import 'package:flutter/material.dart';
import '../models/networkDevice.dart';

class NetworkDevice extends StatefulWidget {
  @override
  _NetworkDeviceState createState() => _NetworkDeviceState();
}

class _NetworkDeviceState extends State<NetworkDevice> {
  @override
  Widget build(BuildContext context) {
    return Card()
      child: Text("I am the card class"),
    );
  }
}
