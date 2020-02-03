import 'package:flutter/material.dart';
import 'package:user_pijar/models/lot_model.dart';

class LotRow extends StatelessWidget {
  final LotModel _lotModel;
  LotRow(this._lotModel);
  final bool _isSelected = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: <Widget>[
          Text(_lotModel.detailLotID.toString()),
          Container(
            width: 6.0,
          ),
          Checkbox(
            value: _isSelected,
            onChanged: (bool value) {
                _lotModel.onChange(value);
            },
          ),
        ],
      ),
    );
  }
}
