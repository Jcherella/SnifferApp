import 'dart:async';
import 'dart:io';
import 'dart:developer';

import 'package:snifferapp/services/IpUtils.dart';
import 'package:snifferapp/models/NetworkInterface.dart';

// Discovers local devices through IP and MAC address by sending out
// socket requests
class DiscoveryService {
  // Sets up class to be singleton
  DiscoveryService._privateConstructor();
  static final DiscoveryService _instance =
      DiscoveryService._privateConstructor();
  factory DiscoveryService() {
    return _instance;
  }

  static discoverNetwork(NetworkInterface networkInterface) {
    List<InternetAddress> range =
        calculateSubnetIpRange(networkInterface.ip, networkInterface.cidr);
    List<InternetAddress> localAddresses =
        generateIpAddresses(range[0], range[1]);
    return DiscoveryService.discoverIPAddresses(localAddresses, 80);
  }

  // Pings a given list of subnets on a given port.
  static discoverIPAddresses(
    List<InternetAddress> ipAdresses,
    int port, {
    Duration timeout = const Duration(seconds: 5),
  }) {
    if (port < 1 || port > 65535) {
      throw 'Invalid port';
    }
    final futures = <Future<Socket>>[];

    for (InternetAddress ipAddr in ipAdresses) {
      final Future<Socket> f = _ping(ipAddr, port, timeout);
      futures.add(f);
      f.then((socket) {
        socket.destroy();
      }).catchError((dynamic e) {
        if (!(e is SocketException)) {
          throw e;
        }

        // Check if connection timed out or we got one of predefined errors
        if (e.osError == null || _errorCodes.contains(e.osError.errorCode)) {
          log("Connection: $e");
        } else {
          // Error 23,24: Too many open files in system
          throw e;
        }
      });
    }

    return Future.wait<Socket>(futures);
  }

  static Future<Socket> _ping(
      InternetAddress host, int port, Duration timeout) {
    return Socket.connect(host, port, timeout: timeout).then((socket) {
      return socket;
    });
  }

  /*
    EXAMPLE USAGE

    DiscoveryService.discoverIPAddresses(['129.161.136.98', '192.168.0.1'], 80);

  */

  static final _errorCodes = [13, 49, 61, 64, 65, 101, 111, 113];
}
