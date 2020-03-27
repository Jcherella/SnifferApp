import 'package:flutter/material.dart';
import '../models/networkDevice.dart';

class NetworkCard extends StatefulWidget {
  final NetworkDevice networkDevice;

  NetworkCard(this.networkDevice);

  @override
  _NetworkCardState createState() => _NetworkCardState(this.networkDevice);
}

class _NetworkCardState extends State<NetworkCard> {
  NetworkDevice networkDevice;
  _NetworkCardState(this.networkDevice);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Text(
          "IP: " + networkDevice.getIP() + "\nMac: " + networkDevice.getMAC()),
      margin: EdgeInsets.symmetric(vertical: 3.0, horizontal: 5.0),
    );
  }
}
