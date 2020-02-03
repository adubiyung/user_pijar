import 'package:flutter/material.dart';

class ButtonSearch extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 110.0,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: Row(
          children: <Widget>[
            Container(
              width: 5.0,
            ),
            Container(
              child: Icon(Icons.search),
            ),
            Container(
              child: Text(" cari lokasi"),
            ),
            Container(
              width: 5.0,
            ),
          ],
        ),
      ),
    );
  }
}
