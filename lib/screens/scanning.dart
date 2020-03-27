import 'package:flutter/material.dart';
import 'package:snifferapp/components/networkList.dart';
import 'package:snifferapp/models/networkDevice.dart';

class Scanning extends StatefulWidget {
  @override
  _ScanningState createState() => _ScanningState();
}

class _ScanningState extends State<Scanning> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            floatingActionButton: RaisedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/');
              },
              child: Text('SCAN', style: TextStyle(fontSize: 20)),
            ),
            body: NetworkList([
              for (var i = 0; i < 100; i++)
                new NetworkDevice("IP goes here", "MAC goes here")
            ])));
  }
}
