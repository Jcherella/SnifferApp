
import 'dart:async';
import 'package:flutter/services.dart';
import 'dart:developer';

import 'package:snifferapp/models/ArpEntry.dart';

/// This class is designed to interface with the Android 9
/// platform specific code that reads and parses the ARP table
/// located in /proc/net/arp
class ArpService {
  final MethodChannel _androidArpService;

  List<ArpEntry> _arpEntries;
  DateTime _arpEntriesLastUpdated;

  ArpService():
    this._androidArpService = const MethodChannel('services/arp_table');

  /// Loads ARP entries from ARP table
  /// Returns a Future that returns upon loading the ARP table and returns a
  /// boolean indicating the outcome of the ARP table load
  /// Also updates arpEntriesLastUpdated datetime
  /// This method will only work on Android 9
  Future<bool> loadArpTable() async {
    List<String> arpEntryStrings;
    this._arpEntries = new List<AndroidArpEntry>();

    try {
      log("Reading ARP entries from ARP table");

      arpEntryStrings = new List<String>.from(
          await this._androidArpService.invokeMethod('getArpTable'));
      log("ARP entries read: " + arpEntryStrings.toString());

      for (var i = 1; i < arpEntryStrings.length; i++) {
        this._arpEntries.add(new AndroidArpEntry.raw(arpEntryStrings[i]));
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

  /// Get most recently retrieved entries of ARP table
  List<ArpEntry> get arpEntries => this._arpEntries;

  /// Get datetime of last load of ARP table
  DateTime get arpEntriesLastUpdated => this._arpEntriesLastUpdated;
}

/*
EXAMPLE USAGE OF MOCK ARP SERVICE

void <function_name> async {
    ...
    final MockArpService mas = new MockArpService();
    log("Loading ARP entries");
    await mas.loadArpTable();
    log("Got ARP entries:");
    for (var arpEntry in mas.arpEntries) {
      log(arpEntry.toString());
    }
    log("Last updated: ${mas.arpEntriesLastUpdated.toIso8601String()}");
    ...
}


 */

class MockArpService extends ArpService {
  MockArpService();

  @override
  Future<bool> loadArpTable() async {
    await Future.delayed(Duration(seconds: 1));
    this._arpEntriesLastUpdated = DateTime.now();
    return true;
  }

  @override
  List<ArpEntry> get arpEntries => [
    new AndroidArpEntry(
        '129.161.49.254',
        '0x1',
        '0x2',
        '00:de:fb:35:c0:c1',
        '*',
        'wlan0'
    )
  ];
}


