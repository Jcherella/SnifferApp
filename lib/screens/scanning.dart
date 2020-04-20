import 'package:flutter/material.dart';
import 'package:snifferapp/components/networkList.dart';
import 'package:snifferapp/services/DeviceInfoService.dart';

//Scanning Screen: portrays the devices on the network by IP and MAC(all the ARP table)
class Scanning extends StatefulWidget {
  @override
  _ScanningState createState() => _ScanningState();
}

class _ScanningState extends State<Scanning> {
  //Building the Screen
  String filterAttribute = 'All';
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        //Main Body
        child: Scaffold(
            appBar: AppBar(
                title: Text("Sniffer App"),
                automaticallyImplyLeading: false,
                backgroundColor: Color(0xFF003776),
                //Filter
                actions: <Widget>[
                  Container(
                    child: DropdownButton<String>(
                      underline: SizedBox(),
                      iconSize: 50,
                      value: filterAttribute,
                      //Filter Items
                      items: <String>['All', 'Threats', 'Non-Threats']
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(
                            value,
                          ),
                        );
                      }).toList(),
                      onChanged: (String newAttribute) {
                        setState(() {
                          filterAttribute = newAttribute;
                          print(filterAttribute);
                        });
                      },
                    ),
                  ),
                ]),
            //List of objects in a column
            body: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                //Color Coded Key
                Container(
                    height: (MediaQuery.of(context).size.height -
                            MediaQuery.of(context).padding.top) *
                        0.1,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        //Green Safe Key
                        Container(
                          width: 20,
                          height: 20,
                          color: Color(0xFF228b1b),
                        ),
                        Container(
                            margin: EdgeInsets.fromLTRB(0, 0, 40, 0),
                            child: Center(
                              child: Text(
                                "Safe",
                                textAlign: TextAlign.center,
                                textScaleFactor: 1.5,
                              ),
                            )),
                        //Red Suspicious Key
                        Container(
                          width: 20,
                          height: 20,
                          color: Color(0xFFee2d00),
                        ),
                        Container(
                            child: Center(
                                child: Text(
                          "Suspicious",
                          textAlign: TextAlign.center,
                          textScaleFactor: 1.5,
                        )))
                      ],
                    )),
                //Network List
                SizedBox(
                    height: (MediaQuery.of(context).size.height -
                            MediaQuery.of(context).padding.top) *
                        0.7,
                    child: NetworkList(
                        DeviceInfoService().arpEntries, filterAttribute)),
                //Lower Button Bar
                Container(
                    height: 77,
                    /* (MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top) *0.1 */
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
                    ))
              ],
            )));
  }
}
