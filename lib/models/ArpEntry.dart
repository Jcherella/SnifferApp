import 'dart:io';

/// This class holds the necessary information for an ARP entry
/// At its core, an ARP entry must contain an IP address and its
/// corresponding MAC address
class ArpEntry {
  final String macAddress;
  final InternetAddress ip;

  ArpEntry(ipAddress, this.macAddress)
      : this.ip = new InternetAddress(ipAddress);

  @override
  String toString() {
    return '''
    ArpEntry
    IP address: ${this.ip.address}
    HW address: ${this.macAddress}
    ''';
  }

  //Returns the IP Address
  String getIP() {
    return this.ip.address;
  }

  //Returns the MAC Address
  String getMAC() {
    return this.macAddress;
  }
}

/// This class represents the data contained in the ARP table
/// on Android 9 devices
class AndroidArpEntry extends ArpEntry {
  final String hwType, flags, mask, device;

  AndroidArpEntry(
      ipAddress, this.hwType, this.flags, hwAddress, this.mask, this.device)
      : super(ipAddress, hwAddress);

  AndroidArpEntry.spread(List<String> arr)
      : this(arr[0], arr[1], arr[2], arr[3], arr[4], arr[5]);

  AndroidArpEntry.raw(String str) : this.spread(str.split(new RegExp('\\s+')));

  @override
  String toString() {
    return '''
    AndroidArpEntry
    IP address: ${this.ip.address}
    HW type: ${this.hwType}
    Flags: ${this.flags}
    HW address: ${this.macAddress}
    Mask: ${this.mask}
    Device: ${this.device}
    ''';
  }
}
