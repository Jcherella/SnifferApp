import 'package:flutter/material.dart';
import 'package:snifferapp/screens/loading.dart';
import 'package:snifferapp/screens/scanning.dart';

void main() => runApp(MaterialApp(
      initialRoute: '/scanPage',
      theme: ThemeData(
        brightness: Brightness.dark,
      ),
      //Routes
      routes: {
        '/loadPage': (context) => Loading(), //Loading Screen
        '/scanPage': (context) => Scanning(), //Scanning Screen
      },
    ));
