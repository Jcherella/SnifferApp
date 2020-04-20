import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:snifferapp/models/ArpEntry.dart';
import 'package:snifferapp/components/detailsText.dart';

class Detail extends StatelessWidget {
  final ArpEntry arpEntry;
  Detail({Key key, @required this.arpEntry}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          alignment: Alignment(0.0, 0.0),
          child: Container(
            width: 10 / 12 * MediaQuery.of(context).size.width,
            height: 3 / 4 * MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
                border: Border.all(color: Colors.blue[800], width: 2),
                borderRadius: BorderRadius.circular(4.0)),
            padding: EdgeInsets.fromLTRB(10, 40, 10, 40),
            child: ListView(
              physics: NeverScrollableScrollPhysics(),
              children: [
                Container(
                  width: 10 / 12 * MediaQuery.of(context).size.width,
                  padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
                  child: Text(
                    "Device Info",
                    style: TextStyle(
                      fontSize: 20,
                      decoration: TextDecoration.underline,
                      fontWeight: FontWeight.w800,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                DetailsText("IP Address:", arpEntry.getIP),
                DetailsText("MAC Address:", arpEntry.getMAC),
                DetailsText("Vendor:", arpEntry.getVendor()),
                DetailsText("HW Type:", arpEntry.getHwType),
                DetailsText("Flags:", arpEntry.getFlags),
                DetailsText("Mask:", arpEntry.getMask),
                DetailsText("Device:", arpEntry.getDevice)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
