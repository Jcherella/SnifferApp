import 'dart:io';

/// Represents a network interface on the device
/// Provides the name (ex. wlan0) and the subnet (IP/mask)
///  that the network interface is in
class NetworkInterface {
  final String name;
  final InternetAddress ip;
  final int cidr;

  NetworkInterface(this.name, ipAddress, this.cidr):
    this.ip = new InternetAddress(ipAddress);


  @override
  String toString () {
    return '''
    NetworkInterface ${this.name}
    IP Address: ${this.ip.address}
    CIDR block: ${this.cidr}
    ''';
  }
}