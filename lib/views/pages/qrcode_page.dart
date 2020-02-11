import 'package:flutter/material.dart';
import 'package:user_pijar/views/widget/color_library.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QrcodePage extends StatelessWidget {
  final String methodScan;
  final String userID;
  final String vehicleID;
  final String vehicleTypeID;
  final String featureTypeID;

  const QrcodePage(this.methodScan, this.userID, this.vehicleID,
      this.vehicleTypeID, this.featureTypeID);

  @override
  Widget build(BuildContext context) {
    int nol = 0;
    String nolUser = '';
    String nolVehicle = '';

    for (var i = userID.length; i < 7; i++) {
      nolUser += nol.toString();
    }

    for (var i = vehicleID.length; i < 7; i++) {
      nolVehicle += nol.toString();
    }

    Widget _qrcode = new Container(
      width: 230.0,
      height: 230.0,
      child: QrImage(
        data:
            "$methodScan${nolUser + userID}${nolVehicle + vehicleID}$vehicleTypeID$featureTypeID",
        version: 1,
      ),
    );

    Widget _compile = new Container(
      padding: EdgeInsets.fromLTRB(10.0, 20.0, 10.0, 10.0),
      child: new Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          new Text(
            "Your Check-In Code",
            style: TextStyle(
                fontFamily: 'Work Sans',
                fontSize: 14,
                fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          new Text(
            "Show this code to the warden for check-in",
            style: TextStyle(fontFamily: 'Work Sans', fontSize: 11),
            textAlign: TextAlign.center,
          ),
          SizedBox(
            height: 20.0,
          ),
          _qrcode,
          new Text(
            "$methodScan${nolUser + userID}${nolVehicle + vehicleID}$vehicleTypeID$featureTypeID",
            style: TextStyle(fontFamily: 'Work Sans', fontSize: 20),
          ),
          Container(
            height: 5.0,
          ),
        ],
      ),
    );

    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorLibrary.primary,
        iconTheme: IconThemeData(color: ColorLibrary.regularFontWhite),
        title: Text(
          "Check-In",
          style: TextStyle(
              fontFamily: 'Work Sans', color: ColorLibrary.regularFontWhite),
        ),
      ),
      body: _compile,
    );
  }
}
