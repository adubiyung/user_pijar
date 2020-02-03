import 'dart:collection';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:user_pijar/models/vehicle.dart';
import 'package:user_pijar/services/api.dart';
import 'package:user_pijar/views/widget/color_library.dart';
import 'package:user_pijar/views/widget/dialog_add_vehicle.dart';
import 'package:user_pijar/views/widget/session_manager.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class VehicleRow extends StatelessWidget {
  SessionManager _session;
  HashMap<String, String> userData;
  final Vehicle _vehicle;
  final int type; // 1 adalah garage_page - 2 adalah dialog (scan page)
  VehicleRow(this._vehicle, this.type);

  @override
  Widget build(BuildContext context) {
    Future<Null> deleteData() async {
      final _prefs = await SharedPreferences.getInstance();
      _session = new SessionManager(_prefs);
      userData = _session.getUserSession();
      String token = userData['USER_TOKEN'];
      String userID = userData['USER_ID'];
      var client = new http.Client();
      String body =
          '{"vehicle_id": "${_vehicle.vehicleID}", "updated_by": "$userID", "method": "delete"}';
      var response = await client.post(BaseUrl.VEHICLE,
          headers: {HttpHeaders.authorizationHeader: token}, body: body);

      if (response.statusCode == 200) {
        print("kesini");
        Navigator.of(context).pop('Update');
      }
    }

    void _showDialog() {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: new Text(
                "Warning",
                style: TextStyle(fontFamily: 'Work Sans'),
              ),
              content: new Text(
                "Are you sure want to delete this data ?",
                style: TextStyle(
                  fontFamily: 'Work Sans',
                ),
              ),
              actions: <Widget>[
                new FlatButton(
                  child: Text("Yes"),
                  onPressed: () {
                    deleteData();
                  },
                ),
                new FlatButton(
                  child: Text("Cancel"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                )
              ],
            );
          });
    }

    Widget _actionItem = new Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
        border: Border(
          left: BorderSide(
            width: 1.0,
            color: ColorLibrary.thinFontWhite,
          ),
        ),
      ),
      child: new Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          new GestureDetector(
            child: Center(
              child: Icon(
                Icons.edit,
                color: ColorLibrary.thinFontWhite,
              ),
            ),
            onTap: () {
              Navigator.of(context).push(new MaterialPageRoute<Null>(
                  builder: (BuildContext context) {
                    return new DialogAddVehicle(
                        _vehicle.vehicleID,
                        _vehicle.vehicleTypeID,
                        "Edit Vehicle",
                        _vehicle.vehicleName,
                        _vehicle.vehicleLicense,
                        _vehicle.vehicleBrandID,
                        _vehicle.vehicleModelID,
                        _vehicle.vehicleYear,
                        "yes");
                  },
                  fullscreenDialog: true));
            },
          ),
          new Container(
            margin: EdgeInsets.symmetric(vertical: 14.0),
            height: 1.0,
            width: 20.0,
            color: ColorLibrary.thinFontWhite,
          ),
          new GestureDetector(
            child: Center(
              child: Icon(
                Icons.delete,
                color: ColorLibrary.thinFontWhite,
              ),
            ),
            onTap: () {
              _showDialog();
            },
          )
        ],
      ),
    );

    Widget _iconItem = new Container(
      margin: EdgeInsets.only(left: 10.0, right: 10.0),
      width: 60.0,
      height: 60.0,
      decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          color: ColorLibrary.secondary,
          borderRadius: BorderRadius.circular(10)),
      child: (_vehicle.vehicleTypeID == 1)
          ? Icon(
              Icons.directions_car,
              size: 30,
              color: ColorLibrary.thinFontBlack,
            )
          : Icon(
              Icons.directions_bike,
              size: 30,
              color: ColorLibrary.thinFontBlack,
            ),
    );

    Widget _licenseItem = new Container(
      width: 125.0,
      height: 35.0,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5.0),
        border: Border.all(color: ColorLibrary.thinFontWhite),
      ),
      child: Center(
        child: Text(
          _vehicle.vehicleLicense,
          style: TextStyle(
              fontFamily: 'Work Sans',
              fontSize: 17,
              fontWeight: FontWeight.w600,
              color: ColorLibrary.secondary),
        ),
      ),
    );

    Widget _dataLicense = new Container(
      margin: EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _licenseItem,
          new SizedBox(
            height: 5.0,
          ),
          Text(
            _vehicle.vehicleName,
            style: TextStyle(
              fontFamily: 'Work Sans',
              color: ColorLibrary.thinFontWhite,
            ),
          ),
          new SizedBox(
            height: 5.0,
          ),
          Text(
            _vehicle.vehicleModelID.vehicleModelName +
                " - " +
                _vehicle.vehicleYear.toString(),
            style: TextStyle(
              fontFamily: 'Work Sans',
              color: ColorLibrary.thinFontWhite,
            ),
          ),
        ],
      ),
    );

    Widget _firstLayout = new Container(
      margin: EdgeInsets.fromLTRB(5.0, 10.0, 0.0, 10.0),
      constraints: BoxConstraints.expand(),
      decoration: BoxDecoration(
        color: ColorLibrary.primary,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(15),
          bottomLeft: Radius.circular(15),
        ),
      ),
      child: new Row(
        children: <Widget>[
          _iconItem,
          _dataLicense,
        ],
      ),
    );

    Widget _secondLayout = new Container(
      margin: EdgeInsets.only(top: 10.0, bottom: 10.0, right: 5.0),
      decoration: BoxDecoration(
        color: ColorLibrary.primary,
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(15),
          bottomRight: Radius.circular(15),
        ),
      ),
      child: _actionItem,
    );

    Widget _listLayout = new Container(
      child: new Row(
        children: <Widget>[
          Expanded(
            flex: 8,
            child: _firstLayout,
          ),
          Expanded(
            flex: 2,
            child: _secondLayout,
          ),
        ],
      ),
    );

    return new Container(
      height: 120.0,
      margin: const EdgeInsets.symmetric(
        vertical: 0.0,
        horizontal: 14.0,
      ),
      child: new Stack(
        children: <Widget>[
          _listLayout,
        ],
      ),
    );
  }
}
