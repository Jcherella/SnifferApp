import 'dart:io';

import 'dart:typed_data';

/// Generates a list of IP addresses between start and end exclusive
/// NOTE: both start and end are exclusive as it is designed to work
/// with subnet ranges. This is desired since we are looking to target
/// the hosts in the subnet so we can ignore the network and broadcast
/// addresses
List<InternetAddress> generateIpAddresses(InternetAddress start, InternetAddress end) {
  List<InternetAddress> addresses = [];
  // Exclusive start
  start = nextIpAddress(start);
  // Dart InternetAddress class doesn't offer value equality so
  // we convert them to strings before comparing
  while (start.address != end.address) {
    addresses.add(start);
    start = nextIpAddress(start);
  }

  return addresses;
}

/// Returns a new InternetAddress representing the incremented IP address
/// mainly for the edge case
/// e.g. nextIpAddress(10.0.0.255) -> 10.0.1.0
InternetAddress nextIpAddress(InternetAddress address) {
  Uint8List rawAddress = address.rawAddress;
  int index = 3;
  while (index >= 0) {
    if (rawAddress[index] == 255) {
      rawAddress[index] = 0;
      index -= 1;
    } else {
      rawAddress[index] += 1;
      return new InternetAddress(rawAddress.join("."));
    }
  }
  // Might be better to throw error here but this should
  // be unreachable
  return null;
}

/// Calculates and returns a List containing InternetAddress objects
/// representing the network and broadcast address respectively of
/// the subnet that the given ip resides in
/// The network and broadcast addresses are located at the start and
/// end of a subnet respectively
List<InternetAddress> calculateSubnetIpRange(InternetAddress ip, int cidr) {
  // We need to convert the CIDR notation to a raw subnet mask
  // so we can use it to do binary operations with the ip address
  Uint8List mask = cidrToMask(cidr).rawAddress;
  Uint8List ipAddress = ip.rawAddress;

  Uint8List subnetNetworkAddress = new Uint8List(4),
    subnetBroadcastAddress = new Uint8List(4);

  for (var i = 0; i < 4; i++) {
    // Network address is calculated using a bitwise and
    // between the ip address and the subnet mask
    // This will give us the starting address of the subnet
    // that the ip resides in
    subnetNetworkAddress[i] = ipAddress[i] & mask[i];

    // Broadcast address is calculated using a bitwise or
    // between the ip address and the inverse of the subnet mask
    // This will give us the last address in the subnet
    subnetBroadcastAddress[i] = ipAddress[i] | (255 - mask[i]);
  }

  return [new InternetAddress(subnetNetworkAddress.join(".")),
          new InternetAddress(subnetBroadcastAddress.join("."))];
}

/// Converts CIDR notation to a subnet mask
/// e.g. /24 -> 255.255.255.0
InternetAddress cidrToMask(int cidr) {
  List<int> mask = [];

  // Start generating the subnet mask from the left side
  // First generate as many 255 blocks as possible
  while (cidr >= 8) {
    cidr -= 8;
    mask.add(255);
  }

  // If the subnet mask is not full
  // Default to 0
  while (mask.length < 4) {
    int submask = 0;

    // If there are bits left in the CIDR
    // Use them as the host bits and convert to int
    // Each part of the IP address is 8 bits
    // CIDR represent the number of bits starting from
    // the leftmost bit
    // e.g. CIDR 3 -> 11100000
    while (cidr > 0) {
      submask += 2 << (8 - cidr) >> 1;
      cidr -= 1;
    }

    mask.add(submask);

  }

  return new InternetAddress(mask.join("."));
}