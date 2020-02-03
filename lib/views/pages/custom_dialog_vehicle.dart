import 'dart:collection';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:user_pijar/models/vehicle.dart';
import 'package:user_pijar/services/api.dart';
import 'package:user_pijar/views/widget/session_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class CustomDialogVehicle extends StatefulWidget {
  static const double padding = 16.0;
  static const double avatarRadius = 35.0;
  final String title;
  final Icon icon;
  static const String URL = BaseUrl.BRAND;
  static const String URL_MODEL = BaseUrl.MODEL;
  final String vehicleTypeID;

  CustomDialogVehicle({
    @required this.vehicleTypeID,
    @required this.title,
    @required this.icon,
  });

  @override
  _CustomDialogVehicleState createState() => _CustomDialogVehicleState();
}

class _CustomDialogVehicleState extends State<CustomDialogVehicle> {
  SessionManager _session;
  HashMap<String, String> userData;
  List<VehicleBrand> _listBrand = [];
  List<VehicleModel> _listModel = [];
  List<DropdownMenuItem<VehicleBrand>> _itemBrand;
  List<DropdownMenuItem<VehicleModel>> _itemModel;
  VehicleBrand _selectedBrand;
  VehicleModel _selectedModel;

  Future<Null> _fetchData() async {
    final _prefs = await SharedPreferences.getInstance();
    _session = new SessionManager(_prefs);
    userData = _session.getUserSession();
    String token = userData['USER_TOKEN'];

    final response = await http.get(
        '${CustomDialogVehicle.URL}?vehicle_type_id=2',
        headers: {HttpHeaders.authorizationHeader: token});
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        _listBrand.clear();
        for (Map i in data['data']) {
          _listBrand.add(VehicleBrand.fromJson(i));
        }
        _itemBrand = buildMenuItemBrand(_listBrand);
        _selectedBrand = _itemBrand[0].value;
      });
    }
  }

  List<DropdownMenuItem<VehicleBrand>> buildMenuItemBrand(List brands) {
    List<DropdownMenuItem<VehicleBrand>> items = List();
    for (VehicleBrand brand in brands) {
      items.add(
        DropdownMenuItem(
          value: brand,
          child: Text(brand.vehicleBrandName, style: TextStyle(fontFamily: 'Work Sans'),),
        ),
      );
    }
    return items;
  }

  onChangeDropDownBrand(VehicleBrand selected) {
    setState(() {
      _selectedBrand = selected;
      _fetchDataModel(selected.vehicleBrandID.toString());
    });
  }

    Future<Null> _fetchDataModel(String brandID) async {
    final _prefs = await SharedPreferences.getInstance();
    _session = new SessionManager(_prefs);
    userData = _session.getUserSession();
    String token = userData['USER_TOKEN'];

    final response = await http.get(
        '${CustomDialogVehicle.URL_MODEL}?vehicle_brand_id=$brandID',
        headers: {HttpHeaders.authorizationHeader: token});
        print('brandID: $brandID');
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        _listModel.clear();
        for (Map i in data['data']) {
          _listModel.add(VehicleModel.fromJson(i));
        }
        _itemModel = buildMenuItemModel(_listModel);
        _selectedModel = _itemModel[0].value;
      });
    }
  }

    List<DropdownMenuItem<VehicleModel>> buildMenuItemModel(List models) {
    List<DropdownMenuItem<VehicleModel>> items = List();
    for (VehicleModel model in models) {
      items.add(
        DropdownMenuItem(
          value: model,
          child: Text(model.vehicleModelName, style: TextStyle(fontFamily: 'Work Sans'),),
        ),
      );
    }
    return items;
  }

  onChangeDropDownModel(VehicleModel selected) {
    setState(() {
      _selectedModel = selected;
    });
  }

  @override
  void initState() {
    _fetchData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      child: dialogContent(context),
    );
  }

  Widget dialogContent(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(
            top: CustomDialogVehicle.avatarRadius + CustomDialogVehicle.padding,
            bottom: CustomDialogVehicle.padding,
            left: CustomDialogVehicle.padding,
            right: CustomDialogVehicle.padding,
          ),
          margin: EdgeInsets.only(top: CustomDialogVehicle.avatarRadius),
          decoration: new BoxDecoration(
            color: Colors.white,
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(CustomDialogVehicle.padding),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 10.0,
                offset: const Offset(0.0, 10.0),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min, // To make the card compact
            children: <Widget>[
              TextField(
                style: TextStyle(fontFamily: 'Work Sans'),
                decoration: InputDecoration(
                    labelStyle: TextStyle(fontFamily: 'Work Sans'),
                    labelText: "Nick Name"),
              ),
              SizedBox(height: CustomDialogVehicle.padding),
              DropdownButton(
                value: _selectedBrand,
                items: _itemBrand,
                onChanged: onChangeDropDownBrand,
              ),
              SizedBox(height: CustomDialogVehicle.padding),
              DropdownButton(
                value: _selectedModel,
                items: _itemModel,
                onChanged: onChangeDropDownModel,
              ),
              SizedBox(height: 24.0),
              Align(
                alignment: Alignment.bottomRight,
                child: FlatButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // To close the dialog
                    print("selected : ${_selectedBrand.vehicleBrandID}");
                    print("selected : ${_selectedModel.vehicleModelID}");
                  },
                  child: Text("add"),
                ),
              ),
            ],
          ),
        ),
        Positioned(
          left: CustomDialogVehicle.padding,
          right: CustomDialogVehicle.padding,
          child: CircleAvatar(
            backgroundColor: Colors.blueAccent,
            radius: 35.0,
            child: widget.icon,
          ),
        ),
      ],
    );
  }
}
