

/// Represents a network interface on the device
/// Provides the name (ex. wlan0) and the subnet (IP/mask)
///  that the network interface is in
class NetworkInterface {
  final String name, ipAddress;
  final int subnetMask;

  const NetworkInterface(this.name, this.ipAddress, this.subnetMask);


  @override
  String toString () {
    return '''
    NetworkInterface ${this.name}
    Subnet: ${this.ipAddress}/${this.subnetMask}
    ''';
  }
}