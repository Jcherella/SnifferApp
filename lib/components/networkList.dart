import 'package:flutter/material.dart';
import 'package:snifferapp/components/networkCard.dart';
import 'package:snifferapp/models/networkDevice.dart';

class NetworkList extends StatefulWidget {
  final List<NetworkDevice> networkList;

  NetworkList(this.networkList);

  @override
  _NetworkListState createState() => _NetworkListState(networkList);
}

class _NetworkListState extends State<NetworkList> {
  List<NetworkDevice> networkList;
  _NetworkListState(this.networkList);

  @override
  Widget build(BuildContext context) {
    return ListView(padding: const EdgeInsets.all(8), children: <Widget>[
      for (NetworkDevice device in networkList) NetworkCard(device)
    ]);
  }
}
