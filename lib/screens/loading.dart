import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter_spinkit/flutter_spinkit.dart';

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
    Timer(
        Duration(seconds: 5), () => Navigator.pushNamed(context, '/scanPage'));
  }

  //Building the screen
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
      child: SpinKitRing(
        color: Colors.blue,
        size: 50.0,
        ),
      ),
    );
  }
}
