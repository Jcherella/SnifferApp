import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:snifferapp/services/DeviceInfoService.dart';
import 'package:snifferapp/models/NetworkInterface.dart';
import 'package:snifferapp/services/PingService.dart';

//Loading Screen: First Screen to see
class Loading extends StatefulWidget {
  @override
  _LoadingState createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {
  var scanStage = "";
  //Setting the time on the screen
  @override
  void initState() {
    super.initState();
//    Timer(
//        Duration(seconds: 5), () => Navigator.pushNamed(context, '/scanPage'));
//    DeviceInfoService().loadArpTable().then((a) => Navigator.pushNamed(context, '/scanPage'));
    this.setState(() => scanStage = "Loading network interfaces...");
    Future.wait([
      DeviceInfoService().loadNetworkInterfaces(),
      Future.delayed(Duration(seconds: 5))
    ]).then((success) {
      return DeviceInfoService().networkInterfaces[0];
    }).then((NetworkInterface networkInterface) {
      this.setState(
          () => scanStage = "Discovering devices on local network...");
//      return DiscoveryService.discoverNetwork(networkInterface);
      return Future.wait(<Future>[
        DiscoveryService.discoverNetwork(networkInterface),
        Future.delayed(Duration(seconds: 5))
      ]);
    }).then((success) {
      this.setState(() => scanStage = "Loading ARP table...");
//      return DeviceInfoService().loadArpTable();
      return Future.wait([
        DeviceInfoService().loadArpTable(),
        Future.delayed(Duration(seconds: 5))
      ]);
    }).then((success) {
      return Navigator.pushNamed(context, '/scanPage');
    }).catchError((exception) {
      this.setState(() => scanStage = "Loading ARP table...");
      Future.wait([
        DeviceInfoService().loadArpTable(),
        Future.delayed(Duration(seconds: 5))
      ])
//          DeviceInfoService().loadArpTable()
          .then((success) {
        return Navigator.pushNamed(context, '/scanPage');
      });
    });
  }

  //Building the screen
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        //Loading Spinner
        children: [
          SpinKitRing(
            color: Colors.blue,
            size: 150.0,
          ),
          Text('$scanStage')
        ],
      ),
    );
  }
}
