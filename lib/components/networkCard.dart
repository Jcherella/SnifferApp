import 'package:flutter/material.dart';
import 'package:snifferapp/models/ArpEntry.dart';
import 'package:snifferapp/services/DatabaseService.dart';

//Portrays each entry or device in the ARP data as a card with the IP and MAC
class NetworkCard extends StatefulWidget {
  final ArpEntry networkDevice;

  //Initializer
  NetworkCard(this.networkDevice);

  @override
  _NetworkCardState createState() => _NetworkCardState(this.networkDevice);
}

class _NetworkCardState extends State<NetworkCard> {
  ArpEntry networkDevice;
  DatabaseService db = DatabaseService();

  //Initializer
  _NetworkCardState(this.networkDevice);

  //Building the widget
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Text("IP: " +
          networkDevice.getIP() +
          "\nMac: " +
          networkDevice.getMAC() +
          "\nVendor: " +
          this.networkDevice.getVendor()),
      margin: EdgeInsets.symmetric(vertical: 3.0, horizontal: 5.0),
    );
  }
}
