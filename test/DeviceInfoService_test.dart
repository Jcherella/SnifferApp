import 'package:flutter_test/flutter_test.dart';

import 'package:flutter/services.dart';

import 'package:snifferapp/services/DeviceInfoService.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  MethodChannel channel = const MethodChannel('services/networkinfo');

  channel.setMockMethodCallHandler((MethodCall methodCall) async {
    if (methodCall.method == 'getArpTable') {
      return [
        "IP address       HW type     Flags       HW address            Mask     Device",
        "10.1.0.5         0x1         0x0         00:00:00:00:00:00     *        wlan0",
        "10.1.0.2         0x1         0x2         18:b4:30:8f:2e:90     *        wlan0"
      ];
    } else if (methodCall.method == 'getNetworkInterfaceInfo') {
      return [
        "|", "rmnet_data2", "2607:fc20:2781:64ab:8bb:6279:33e9:674c/64",
        "|", "wlan0", "fe80::424e:36ff:fe60:254c/64", "10.1.0.27/24"
      ];
    } else {
      return null;
    }
  });
  
  group('loadArpTable', () {
    test('values should start empty', () {
      final dis = DeviceInfoService();

      expect(dis.arpEntries.length, 0);
      expect(dis.arpEntriesLastUpdated, null);

      expect(dis.networkInterfaces.length, 0);
      expect(dis.arpEntriesLastUpdated, null);
    });

    test('loadArpTable should fill arpEntries', () async {
      final dis = DeviceInfoService();

      final datetime = DateTime.now();

      await dis.loadArpTable();

      expect(dis.arpEntries.length, 1);
      expect(dis.arpEntries[0].ip.address, '10.1.0.2');
      expect(dis.arpEntries[0].macAddress, '18:b4:30:8f:2e:90');
      expect(dis.arpEntriesLastUpdated, isNotNull);
      expect(dis.arpEntriesLastUpdated.compareTo(datetime), greaterThanOrEqualTo(0));
    });

    test('loadNetworkInterfaces should fill networkInterfaces', () async {
      final dis = DeviceInfoService();

      final datetime = DateTime.now();

      await dis.loadNetworkInterfaces();

      expect(dis.arpEntries.length, 1);
      expect(dis.networkInterfaces[0].ip.address, '10.1.0.27');
      expect(dis.networkInterfaces[0].cidr, 24);
      expect(dis.networkInterfaces[0].name, 'wlan0');
      expect(dis.networkInterfacesLastUpdated, isNotNull);
      expect(dis.networkInterfacesLastUpdated.compareTo(datetime), greaterThanOrEqualTo(0));
    });
  });
}