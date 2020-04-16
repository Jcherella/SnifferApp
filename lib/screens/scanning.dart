import 'package:flutter/material.dart';
import 'package:snifferapp/components/networkList.dart';
import 'package:snifferapp/models/ArpEntry.dart';
import 'package:snifferapp/services/DeviceInfoService.dart';
import 'dart:developer';

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
        //Main Body
        child: Scaffold(
            //List of objects in a column
            body: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                //Color Coded Key
                Container(
                  height: (MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top)* 0.1,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      //Greeen Safe Box
                      Container(
                        width: MediaQuery.of(context).size.width / 2,
                        height: (MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top)* 0.1,
                        color: Color(0xFF228b1b),
                        child: Center(child:Text(
                          "Safe",
                          textAlign: TextAlign.center,
                          textScaleFactor: 1.5,
                        ))
                      ),
                      //Red Sus. Box
                      Container(
                        width: MediaQuery.of(context).size.width / 2,
                        height: (MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top)* 0.1,
                        color: Color(0xFFee2d00),
                        child: Center(child: Text(
                          "Suspicious",
                          textAlign: TextAlign.center,
                          textScaleFactor: 1.5,
                        ))
                      )
                    ],
                  )
                ),
                //Network List
                SizedBox(
                  height: (MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top)* 0.8,
                  child: NetworkList(DeviceInfoService().arpEntries),
                ),
                //App bar
                Container(
                  height: (MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top) * 0.1,
                  color: Color(0xFF003776),
                  //The row of buttons on app bar
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      FloatingActionButton(
                        backgroundColor: Color(0xFF2d8bf6),
                        onPressed: () {
                          Navigator.pushNamed(context, '/loadPage');
                        },
                        child: Icon(Icons.wifi),
                      ),
                    ],
                  )
                )
              ],
            )
           ));
  }
}
