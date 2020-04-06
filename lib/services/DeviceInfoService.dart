import 'dart:async';

import 'package:flutter/services.dart';

import 'dart:developer';

import 'package:snifferapp/models/ArpEntry.dart';
import 'package:snifferapp/models/NetworkInterface.dart';

/// This class is designed to retrieve device information
class DeviceInfoService {
  final MethodChannel _networkInfoChannel;

  List<ArpEntry> _arpEntries = new List();
  DateTime _arpEntriesLastUpdated;

  List<NetworkInterface> _networkInterfaces = new List();
  DateTime _networkInterfacesLastUpdated;

  // Sets up class to be singleton
  DeviceInfoService._privateConstructor()
      : this._networkInfoChannel = const MethodChannel('services/networkinfo');
//  {
//    this.loadArpTable();
//    this.loadNetworkInterfaces();
//  }
  static final DeviceInfoService _instance =
      DeviceInfoService._privateConstructor();
  factory DeviceInfoService() {
    return _instance;
  }

  /// Loads ARP entries from ARP table
  /// Returns a Future that returns upon loading the ARP table and returns a
  /// boolean indicating the outcome of the ARP table load
  /// Also updates arpEntriesLastUpdated datetime
  /// This has only been tested on Android 9
  Future<bool> loadArpTable() async {
    List<String> arpEntryStrings;

    try {
      log("Reading ARP entries from ARP table");

      arpEntryStrings = new List<String>.from(
          await this._networkInfoChannel.invokeMethod('getArpTable'));
      log("ARP entries read: " + arpEntryStrings.toString());

      this._arpEntries = new List<AndroidArpEntry>();
      List<String> entryParts;
      for (var i = 1; i < arpEntryStrings.length; i++) {
        entryParts = arpEntryStrings[i].split(new RegExp('\\s+'));
        // Ignore unresolved ARP entries
        if (entryParts[3] != "00:00:00:00:00:00") {
          this._arpEntries.add(new AndroidArpEntry.spread(entryParts));
        }
      }
      log("Created ARP entry instances: " + this._arpEntries.toString());

      this._arpEntriesLastUpdated = DateTime.now();
      return true;
    } on PlatformException catch (e) {
      log("Failed to read ARP entries: " + e.toString());

      this._arpEntries = null;

      return false;
    }
  }

  /// Loads network interfaces from Android devices
  /// Only loads interface names containing 'lan'
  /// Returns a Future that returns after loading and parsing and returns
  /// a boolean indicating the outcome
  /// Also updates networkInterfacesLastUpdated
  /// This method has only been tested on Android 9
  Future<bool> loadNetworkInterfaces() async {
    List<String> networkInfo;
    RegExp ipv4Addr = new RegExp(r"\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}\/\d{1,2}",
        caseSensitive: false);

    try {
      log("Loading network information");

      networkInfo = new List<String>.from(await this
          ._networkInfoChannel
          .invokeMethod('getNetworkInterfaceInfo'));
      log("Network information retrieved: " + networkInfo.toString());

      this._networkInterfaces = new List<NetworkInterface>();
      NetworkInterface networkInterface;
      String name;
      for (var i = 0; i < networkInfo.length; i++) {
        if (networkInfo[i] == "|") {
          i += 1;

          if (networkInfo[i] != null && networkInfo[i].contains('lan')) {
            name = networkInfo[i];
          }
        }

        if (name != null &&
            networkInterface == null &&
            ipv4Addr.hasMatch(networkInfo[i])) {
          var info = networkInfo[i].split("/");
          this
              ._networkInterfaces
              .add(new NetworkInterface(name, info[0], int.parse(info[1])));
          name = null;
        }
      }

      log("Created NetworkInterface instances: " +
          this._networkInterfaces.toString());
      this._networkInterfacesLastUpdated = DateTime.now();
      return true;
    } on PlatformException catch (e) {
      log("Failed to load network info: " + e.toString());
      return false;
    }
  }

  /// Get most recently retrieved entries of ARP table
  List<ArpEntry> get arpEntries => this._arpEntries;

  /// Get datetime of last load of ARP table
  DateTime get arpEntriesLastUpdated => this._arpEntriesLastUpdated;

  /// Get most recently updated network interface list
  List<NetworkInterface> get networkInterfaces => this._networkInterfaces;

  /// Get datetime of last load of network interfaces
  DateTime get networkInterfacesLastUpdated =>
      this._networkInterfacesLastUpdated;
}

/*
EXAMPLE USAGE OF MOCK DEVICE INFO SERVICE

void <function_name> async {
    ...
    final MockDeviceInfoService mdis = new MockDeviceInfoService();
    ...
    // Load ARP table
    log("Loading ARP entries");
    await mdis.loadArpTable();
    log("Got ARP entries:");
    for (var arpEntry in mdis.arpEntries) {
      log(arpEntry.toString());
    }
    log("Last updated: ${mdis.arpEntriesLastUpdated.toIso8601String()}");
    ...
    // Load network interfaces
    log("Loading network interfaces");
    await mdis.loadNetworkInterfaces();
    log("Got network interfaces:");
    for (var networkInterface in mdis.networkInterfaces) {
      log(networkInterface.toString());
    }
    log("Last updated: ${mdis.networkInterfacesLastUpdated.toIso8601String()}");
    ...
}


 */

class MockDeviceInfoService {
  final _inst;
  MockDeviceInfoService() : this._inst = new DeviceInfoService();

  Future<bool> loadArpTable() async {
    await Future.delayed(Duration(seconds: 1));
    this._inst._arpEntriesLastUpdated = DateTime.now();
    return true;
  }

  List<ArpEntry> get arpEntries => [
        new AndroidArpEntry(
            '129.161.49.254', '0x1', '0x2', '00:de:fb:35:c0:c1', '*', 'wlan0')
      ];
  DateTime get arpEntriesLastUpdated => this._inst._arpEntriesLastUpdated;

  Future<bool> loadNetworkInterfaces() async {
    await Future.delayed(Duration(seconds: 1));
    this._inst._networkInterfacesLastUpdated = DateTime.now();
    return true;
  }

  List<NetworkInterface> get networkInterfaces =>
      [new NetworkInterface('wlan0', '129.161.138.238', 22)];

  DateTime get networkInterfacesLastUpdated =>
      this._inst._networkInterfacesLastUpdated;
}
