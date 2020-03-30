import 'package:flutter/material.dart';
import 'package:snifferapp/components/networkList.dart';
import 'package:snifferapp/models/ArpEntry.dart';

//Scanning Screen: portrays the devices on the network by IP and MAC(all the ARP table)
class Scanning extends StatefulWidget {
  @override
  _ScanningState createState() => _ScanningState();
}

class _ScanningState extends State<Scanning> {
  //Building the Screen
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          //Bottom Bar
          bottomNavigationBar: BottomAppBar(
            color: Colors.blue,
            child: Container(height: 50.0),
          ),
          //Button Location
          floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
          //Button Functionality and look
          floatingActionButton: RaisedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/');
              },
              child: Text('SCAN', style: TextStyle(fontSize: 20)),
          ),
          //Display of the list
          body: NetworkList([
              for (var i = 0; i < 100; i++)
                new ArpEntry("IP goes here", "MAC goes here")
          ])

        )
      );
  }
}
