import 'package:flutter/material.dart';
import 'dart:async';

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
        child: Text("Loading Page"),
      ),
    );
  }
}
