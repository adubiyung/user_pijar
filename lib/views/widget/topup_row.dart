import 'package:flutter/material.dart';
import 'package:user_pijar/models/topup_model.dart';
import 'package:user_pijar/views/pages/webview_page.dart';

class TopupRow extends StatelessWidget {
  final TopupModel _topup;
  TopupRow(this._topup);

  @override
  Widget build(BuildContext context) {
    return new Card(
      margin: EdgeInsets.only(bottom: 10.0),
      child: ListTile(
        leading: Container(
          height: 50.0,
          padding: EdgeInsets.only(right: 13.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Card(
                child: Icon(Icons.atm),
              ),
            ],
          ),
        ),
        title: Padding(
          padding: EdgeInsets.only(top: 3.0, bottom: 3.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(_topup.nameTopup, style: TextStyle(fontSize: 12),),
              Container(
                height: 5.0,
              ),
              Text(_topup.descTopup, style: TextStyle(fontSize: 12),),
            ],
          ),
        ),
        onTap: () {
          Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => new WebViewPage("Top Up Link Aja",
                      "https://www.linkaja.id/topup"),
                ),
              );
        },
      ),
    );
  }
}
