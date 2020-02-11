import 'package:flutter/material.dart';
import 'package:user_pijar/models/lot_model.dart';

class ListviewLeft extends StatefulWidget {
  final LotModel _lotModel;
  ListviewLeft(this._lotModel);

  @override
  _ListviewLeftState createState() => _ListviewLeftState();
}

class _ListviewLeftState extends State<ListviewLeft> {
  final bool _isSelected = true;

  @override
  Widget build(BuildContext context) {
    Widget _child;
    if (widget._lotModel.sideID == 1) {
      _child = new Row(
        children: <Widget>[
          Checkbox(
            value: (widget._lotModel.isAvailable == 1),
            onChanged: (bool value) {
              setState(() {
                if (value) {
                  widget._lotModel.isAvailable = 3;
                } else{
                  widget._lotModel.isAvailable = 2;
                }
              });
            },
          ),
          Container(
            width: 3.0,
          ),
          Text(widget._lotModel.detailLotID.toString())
        ],
      );
    }
    return _child;
  }
}
