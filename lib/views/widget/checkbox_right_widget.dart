import 'package:flutter/material.dart';
import 'package:user_pijar/models/lot_model.dart';

class ListviewRight extends StatefulWidget {
  final LotModel _lotModel;
  ListviewRight(this._lotModel);

  @override
  _ListviewRightState createState() => _ListviewRightState();
}

class _ListviewRightState extends State<ListviewRight> {
  final bool _isSelected = false;
  int _radioValue = -1;

  @override
  Widget build(BuildContext context) {
    Widget _child;
    if (widget._lotModel.sideID == 2) {
      _child = new Row(
        children: <Widget>[
          Text(widget._lotModel.detailLotID.toString()),
          Container(
            width: 3.0,
          ),
          Radio(
            value: widget._lotModel.isAvailable,
            groupValue: _radioValue,
            onChanged: (value) {
              setState(() {
                widget._lotModel.isAvailable = value;
              });
            },
          ),
        ],
      );
    }
    return _child;
  }
}
