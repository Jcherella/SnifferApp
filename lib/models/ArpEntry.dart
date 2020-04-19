import 'dart:developer';
import 'dart:io';

import 'package:snifferapp/services/DatabaseService.dart';

/// This class holds the necessary information for an ARP entry
/// At its core, an ARP entry must contain an IP address and its
/// corresponding MAC address
class ArpEntry {
  final String macAddress;
  final InternetAddress ip;
  String _vendor;
  bool _isMalicious = false;

  ArpEntry(ipAddress, this.macAddress)
      : this.ip = new InternetAddress(ipAddress);

  @override
  String toString() {
    return '''
    Arp Entry
    IP address: ${this.ip.address}
    HW address: ${this.macAddress}
    Vendor: ${this.getVendor()}
    ''';
  }

  //Gets all the necessary details for the Arp Entry
  Future<void> getDetails() async {
    if (this.macAddress == null) {
      return;
    } else {
      try {
        this._vendor = await DatabaseService().lookupVendor(this.macAddress);
        this._isMalicious = await DatabaseService().isVendorRisky(this._vendor);
      } catch (NoSuchMethodError) {
        log("${this.macAddress} is not in the database");
      }
    }
  }

  //Returns the IP Address
  String get getIP => this.ip.address;

  //Returns the Mac Address
  String get getMAC => this.macAddress;

  //Returns _isMalicious
  bool get isMalicious => this._isMalicious;

  String get getHwType => "Unknown";
  String get getFlags => "Unknown";
  String get getMask => "Unknown";
  String get getDevice => "Unknown";

  //Returns Vendor
  String getVendor() {
    if (_vendor == null || _vendor == 'null') {
      return "Unknown Device";
    } else {
      return _vendor;
    }
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
    Android Arp Entry
    IP address: ${this.ip.address}
    MAC address: ${this.macAddress}
    Vendor: ${this.getVendor()}
    HW type: ${this.hwType}
    Flags: ${this.flags}r
    Mask: ${this.mask}
    Device: ${this.device}
    ''';
  }

  //Getter Methods
  @override
  String get getHwType => this.hwType;
  @override
  String get getFlags => this.flags;
  @override
  String get getMask => this.mask;
  @override
  String get getDevice => this.device;
}
