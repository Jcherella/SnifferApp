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
  _NetworkListState createState() => _NetworkListState(networkList, filterAttribute);
}

class _NetworkListState extends State<NetworkList> {
  List<ArpEntry> networkList;
  String filterAttribute;
  var _listItems = <Widget>[];
  final GlobalKey<AnimatedListState> _listKey = GlobalKey();

  //Initializer
  _NetworkListState(this.networkList, this.filterAttribute);

  @override
  void initState() {
    super.initState();

    _loadItems(filterAttribute);
  }

//  https://stackoverflow.com/questions/57100219/how-to-animate-the-items-rendered-initially-using-animated-list-in-flutter
  void _loadItems(String filterAttribute) {
    // fetching data from web api, db...
    // this loads the items onto the list for display
    // Input param: String filterAttribute = {Threat, Non-Threat, All}
    // if filterAttribute equals "Threat": display threats
    //
    final fetchedList = <Widget>[];
    for (ArpEntry device in networkList) fetchedList.add(NetworkCard(device));

    if (fetchedList.length == 0) {
      fetchedList.add(ListTile(title: Text('Press SCAN to get started')));
    }

    var future = Future(() {});
    for (var i = 0; i < fetchedList.length; i++) {
      future = future.then((_) {
        return Future.delayed(Duration(milliseconds: 200), () {
          _listItems.add(fetchedList[i]);
          _listKey.currentState.insertItem(_listItems.length - 1);
        });
      });
    }
  }

  void _unloadItems() {
    //Unloads all items from the list
    var future = Future(() {});
    for (var i = _listItems.length - 1; i >= 0; i--) {
      future = future.then((_) {
        return Future.delayed(Duration(milliseconds: 200), () {
          final deletedItem = _listItems.removeAt(i);
          _listKey.currentState.removeItem(i,
              (BuildContext context, Animation<double> animation) {
            return SlideTransition(
              position: CurvedAnimation(
                curve: Curves.easeOut,
                parent: animation,
              ).drive((Tween<Offset>(
                begin: Offset(1, 0),
                end: Offset(0, 0),
              ))),
              child: deletedItem,
            );
          });
        });
      });
    }
  }

  //Building the widget
  @override
  Widget build(BuildContext context) {
    return AnimatedList(
      key: _listKey,
      padding: EdgeInsets.only(top: 10),
      initialItemCount: _listItems.length,
      itemBuilder: (context, index, animation) {
        return SlideTransition(
          position: CurvedAnimation(
            curve: Curves.easeOut,
            parent: animation,
          ).drive((Tween<Offset>(
            begin: Offset(1, 0),
            end: Offset(0, 0),
          ))),
          child: _listItems[index],
        );
      },
    );
//      ListView(padding: const EdgeInsets.all(8), children: <Widget>[
//      for (ArpEntry device in networkList) NetworkCard(device)
//    ]);
  }
}
