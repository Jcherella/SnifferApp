import 'package:flutter/material.dart';
import 'package:snifferapp/components/networkCard.dart';
import 'package:snifferapp/models/ArpEntry.dart';

//Creates a list view (gives scrollability) to portray all of the NetworkCards (Devices on the network)
class NetworkList extends StatefulWidget {
  final List<ArpEntry> networkList;

  //Initializer
  NetworkList(this.networkList);

  @override
  _NetworkListState createState() => _NetworkListState(networkList);
}

class _NetworkListState extends State<NetworkList> {
  List<ArpEntry> networkList;

  //Initializer
  _NetworkListState(this.networkList);

  //Building the widget
  @override
  Widget build(BuildContext context) {
    return ListView(padding: const EdgeInsets.all(8), children: <Widget>[
      for (ArpEntry device in networkList) NetworkCard(device)
    ]);
  }
}
