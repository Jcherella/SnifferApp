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
  //Setting the time on the screen
  @override
  void initState() {
    super.initState();
//    Timer(
//        Duration(seconds: 5), () => Navigator.pushNamed(context, '/scanPage'));
//    DeviceInfoService().loadArpTable().then((a) => Navigator.pushNamed(context, '/scanPage'));
    DeviceInfoService().loadNetworkInterfaces().then(
        (success) {
          return DeviceInfoService().networkInterfaces[0];
        }
    ).then(
        (NetworkInterface networkInterface) {
          try {
            return DiscoveryService.discoverNetwork(networkInterface);
          } catch (e) {
            return true;
          }
        }
    ).then(
        (success) {
          return DeviceInfoService().loadArpTable();
        }
    ).then(
        (success) {
          return Navigator.pushNamed(context, '/scanPage');
        }
    );
  }

  //Building the screen
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        //Loading Spinner
        child: SpinKitRing(
          color: Colors.blue,
          size: 150.0,
        ),
      ),
    );
  }
}
