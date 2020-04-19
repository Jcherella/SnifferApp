import 'package:flutter/material.dart';

class DetailsText extends StatelessWidget {
  final String _title, _text;

  DetailsText(this._title, this._text);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(0, 30, 0, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Container(
            width: 3 / 12 * MediaQuery.of(context).size.width,
            child: Text(
              this._title,
              textAlign: TextAlign.justify,
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800),
            ),
          ),
          Container(
            width: 6 / 12 * MediaQuery.of(context).size.width,
            child: Text(
              this._text,
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }
}
