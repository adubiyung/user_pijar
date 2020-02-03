import 'package:flutter/material.dart';
import 'package:user_pijar/models/Location.dart';
import 'package:user_pijar/views/widget/color_library.dart';
import 'package:user_pijar/views/widget/pop_result.dart';

class LocDetailRow extends StatelessWidget {
  final LocationDetail _model;
  LocDetailRow(this._model);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: new ListTile(
        leading: Container(
          height: 25.0,
          padding: EdgeInsets.only(right: 12.0),
          decoration: BoxDecoration(
            border: Border(
              right: BorderSide(width: 1.0, color: ColorLibrary.primary),
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(
                Icons.compare_arrows,
                color: ColorLibrary.primary,
              ),
            ],
          ),
        ),
        title: Text(
          _model.detailLocName,
          style:
              TextStyle(fontFamily: 'Work Sans', fontWeight: FontWeight.w500),
        ),
        trailing: Padding(
          padding: EdgeInsets.only(right: 12.0),
          child: Icon(Icons.arrow_forward_ios),
        ),
        onTap: () {
          _moveToSelectLot(context, _model.locationID, _model.detailLocID,
              _model.detailLocName);
        },
      ),
    );
  }
}

void _moveToSelectLot(
    BuildContext context, int locid, int detailID, String name) async {
  Navigator.of(context).pushNamed('/lotmap', arguments: {
    'locID': locid.toString(),
    'detailLocID': detailID.toString(),
    'detailName': name
  }).then((results) {
    PopWithResults popResult = results as PopWithResults;
    if (popResult != null) {
      if (popResult.toPage == 'detail') {
        // print(popResult.results.values.toList()[0]);
      } else {
        Navigator.of(context).pop(results);
      }
    }
  });
}
