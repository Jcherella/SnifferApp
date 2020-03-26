import 'package:flutter/material.dart';
import 'dart:async';

class Loading extends StatefulWidget {
  @override
  _LoadingState createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 5), () => Navigator.pushNamed(context, '/scanPage'));
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Text("Loading Page"),
      ),
    );
  }
}
