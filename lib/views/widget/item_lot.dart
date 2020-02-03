import 'package:flutter/material.dart';
import 'package:user_pijar/views/widget/color_library.dart';
import 'package:user_pijar/models/location.dart';

class RadioItem extends StatelessWidget {
  final LocationLot _item;
  RadioItem(this._item);

  @override
  Widget build(BuildContext context) {
    return new Container(
      margin: new EdgeInsets.all(5.0),
      child: new Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          new Container(
            height: 35.0,
            width: 35.0,
            child: new Center(
              child: new Text(_item.detailLotID.toString(),
                  style: new TextStyle(
                      color: _item.isAvailable
                          ? ColorLibrary.regularFontWhite
                          : ColorLibrary.primaryDark,
                      //fontWeight: FontWeight.bold,
                      fontSize: 12.0,
                      fontFamily: 'Work Sans')),
            ),
            decoration: new BoxDecoration(
              color:
                  _item.isAvailable ? Colors.transparent : ColorLibrary.primary,
              border: new Border.all(width: 1.0, color: ColorLibrary.primary),
              borderRadius: const BorderRadius.all(const Radius.circular(2.0)),
            ),
          ),
        ],
      ),
    );
  }
}