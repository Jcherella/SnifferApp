import 'package:flutter/material.dart';
import 'package:snifferapp/screens/loading.dart';
import 'package:snifferapp/screens/scanning.dart';

void main() => runApp(MaterialApp(initialRoute: '/', routes: {
      '/': (context) => Loading(),
      '/scanPage': (context) => Scanning()
    }));
