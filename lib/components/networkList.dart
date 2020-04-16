import 'package:flutter/material.dart';
import 'package:snifferapp/components/networkCard.dart';
import 'package:snifferapp/models/ArpEntry.dart';

//Creates a list view (gives scrollability) to portray all of the NetworkCards (Devices on the network)
class NetworkList extends StatefulWidget {
  final List<ArpEntry> networkList;
  final String filterAttribute;
  //Initializer
  NetworkList(this.networkList, this.filterAttribute);

  @override
  _NetworkListState createState() => _NetworkListState();
}

class _NetworkListState extends State<NetworkList> {
  //Building the widget
  @override
  Widget build(BuildContext context) {
    return widget.networkList.length == 0
        ? Padding(
            padding: const EdgeInsets.only(top: 20),
            child: Text(
              "Press scan to get started",
              textScaleFactor: 1.5,
            ))
        : ListView.builder(
            itemCount: widget.networkList.length,
            itemBuilder: (BuildContext context, int index) {
              ArpEntry entry = widget.networkList[index];
              return widget.filterAttribute == 'All' ||
                      (entry.isMalicious &&
                          widget.filterAttribute == 'Threats') ||
                      (!entry.isMalicious &&
                          widget.filterAttribute == 'Non-Threats')
                  ? new NetworkCard(entry)
                  : new Container();
            });
  }
}
