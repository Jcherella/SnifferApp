import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:snifferapp/models/ArpEntry.dart';

class Detail extends StatelessWidget {
  final ArpEntry arpEntry;
  Detail({Key key, @required this.arpEntry}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body:Container(
          alignment: Alignment(0.0, 0.0),
          child: Container(
            width: 7/8*MediaQuery.of(context).size.width,
            height: 3/4*MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
                border: Border.all(color: Colors.blue[800], width: 2),
                borderRadius: BorderRadius.circular(4.0)),
            child: Text(arpEntry.toString(),textAlign: TextAlign.justify,),
            padding: EdgeInsets.fromLTRB(10, 40, 10, 40),
          ),
        ),
      ),
    );
  }
}
