import 'dart:collection';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:user_pijar/models/vehicle.dart';
import 'package:user_pijar/services/api.dart';
import 'package:user_pijar/views/widget/color_library.dart';
import 'package:user_pijar/views/widget/session_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class DialogAddVehicle extends StatefulWidget {
  static const double padding = 16.0;
  static const double avatarRadius = 35.0;
  static const String URL = BaseUrl.BRAND;
  static const String URL_MODEL = BaseUrl.MODEL;
  static const String URL_CRUD = BaseUrl.VEHICLE;
  final String title;
  final int vehicleID;
  final int vehicleTypeID;
  final String nickName;
  final String licenseNumb;
  final VehicleBrand brand;
  final VehicleModel model;
  final int year;
  final String isDefault;

  const DialogAddVehicle(
    this.vehicleID,
    this.vehicleTypeID,
    this.title,
    this.nickName,
    this.licenseNumb,
    this.brand,
    this.model,
    this.year,
    this.isDefault,
  );

  @override
  _DialogAddVehicleState createState() => _DialogAddVehicleState();
}

class _DialogAddVehicleState extends State<DialogAddVehicle> {
  SessionManager _session;
  HashMap<String, String> userData;
  List<VehicleBrand> _listBrand = [];
  List<VehicleModel> _listModel = [];
  List<String> _listYear = [];
  List<DropdownMenuItem<VehicleBrand>> _itemBrand;
  List<DropdownMenuItem<VehicleModel>> _itemModel;
  VehicleBrand _selectedBrand;
  VehicleModel _selectedModel;
  static const String URL = BaseUrl.BRAND;
  int _typeIDValue = 2;
  String _modelIDValue;
  String _brandIDValue;
  int _vehicleID;
  String _nickNameValue;
  String _licenseValue;
  String _yearValue = "1980";
  bool _checked = false;
  var nickCont = new TextEditingController();
  var licenseCont = new TextEditingController();

  Future<Null> _fetchData(String typeID) async {
    final _prefs = await SharedPreferences.getInstance();
    _session = new SessionManager(_prefs);
    userData = _session.getUserSession();
    String token = userData['USER_TOKEN'];

    final response = await http.get(
        '${DialogAddVehicle.URL}?vehicle_type_id=$typeID',
        headers: {HttpHeaders.authorizationHeader: token});
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (mounted) {
        setState(() {
          _listBrand.clear();

          for (Map i in data['data']) {
            _listBrand.add(VehicleBrand.fromJson(i));
          }

          if (_listBrand.length > 0) {
            _itemBrand = buildMenuItemBrand(_listBrand);
            _selectedBrand = _itemBrand[0].value;

            if (widget.brand != null) {
              nickCont.text = widget.nickName;
              licenseCont.text = widget.licenseNumb;

              for (var i = 0; i < _itemBrand.length; i++) {
                if (_itemBrand[i].value.vehicleBrandID ==
                    widget.brand.vehicleBrandID) {
                  _selectedBrand = _itemBrand[i].value;
                }
              }
            }
            _fetchDataModel(_selectedBrand.vehicleBrandID.toString());
          }
        });
      }
    }
  }

  List<DropdownMenuItem<VehicleBrand>> buildMenuItemBrand(List brands) {
    List<DropdownMenuItem<VehicleBrand>> items = List();
    for (VehicleBrand brand in brands) {
      items.add(
        DropdownMenuItem(
          value: brand,
          child: Text(
            brand.vehicleBrandName,
            style: TextStyle(fontFamily: 'Work Sans'),
          ),
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
        '${DialogAddVehicle.URL_MODEL}?vehicle_brand_id=$brandID',
        headers: {HttpHeaders.authorizationHeader: token});

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (mounted) {
        setState(() {
          _listModel.clear();
          for (Map i in data['data']) {
            _listModel.add(VehicleModel.fromJson(i));
          }

          if (_listModel.length > 0) {
            _itemModel = buildMenuItemModel(_listModel);
            _selectedModel = _itemModel[0].value;

            if (widget.model != null) {
              for (var i = 0; i < _itemModel.length; i++) {
                if (_itemModel[i].value.vehicleModelID ==
                    widget.model.vehicleModelID) {
                  _selectedModel = _itemModel[i].value;
                }
              }
            }
          }
        });
      }
    }
  }

  List<DropdownMenuItem<VehicleModel>> buildMenuItemModel(List models) {
    List<DropdownMenuItem<VehicleModel>> items = List();
    for (VehicleModel model in models) {
      items.add(
        DropdownMenuItem(
          value: model,
          child: Text(
            model.vehicleModelName,
            style: TextStyle(fontFamily: 'Work Sans'),
          ),
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

  generateYear() {
    var now = new DateTime.now();
    int years = now.year;

    for (int i = 1980; i <= years; i++) {
      _listYear.add(i.toString());
    }

    if (widget.year != 0) {
      _yearValue = widget.year.toString();
    }
  }

  @override
  void initState() {
    super.initState();
    if (widget.vehicleTypeID == 0) {
      _typeIDValue = 2;
      _vehicleID = 0;
    } else {
      _vehicleID = widget.vehicleID;
      _typeIDValue = widget.vehicleTypeID;
    }
    _fetchData(_typeIDValue.toString());
    generateYear();
  }

  Future<Null> _savingData() async {
    final _prefs = await SharedPreferences.getInstance();
    _session = new SessionManager(_prefs);
    userData = _session.getUserSession();
    String userID = userData['USER_ID'];
    String token = userData['USER_TOKEN'];
    var client = new http.Client();
    _nickNameValue = nickCont.text;
    _licenseValue = licenseCont.text;
    _brandIDValue = _selectedBrand.vehicleBrandID.toString();
    _modelIDValue = _selectedModel.vehicleModelID.toString();
    String body;

    if (widget.vehicleID != 0) {
      print("vID " + widget.vehicleID.toString());
      if (_licenseValue == widget.licenseNumb) {
        body =
            '''{"user_id": "$userID", "vehicle_id": "$_vehicleID", "vehicle_type_id":"$_typeIDValue", "vehicle_model_id":"$_modelIDValue", 
            "vehicle_brand_id":"$_brandIDValue", "vehicle_name": "$_nickNameValue", "vehicle_year": "$_yearValue", 
            "vehicle_license": null, "updated_by": "$userID", "method": "update"}''';
        print("object");
      } else {
        body =
            '''{"user_id": "$userID", "vehicle_id": "$_vehicleID", "vehicle_type_id":"$_typeIDValue", "vehicle_model_id":"$_modelIDValue", 
            "vehicle_brand_id":"$_brandIDValue", "vehicle_name": "$_nickNameValue", "vehicle_year": "$_yearValue", 
            "vehicle_license": "$_licenseValue", "updated_by": "$userID", "method": "update"}''';
        print("object2");
      }
    } else {
      body =
          '''{"user_id": "$userID", "vehicle_type_id": "$_typeIDValue", "vehicle_model_id": "$_modelIDValue",
          "vehicle_brand_id": "$_brandIDValue", "vehicle_name": "$_nickNameValue", "vehicle_year": "$_yearValue", 
          "vehicle_license": "$_licenseValue", "created_by": "$userID", "method": "insert"}''';
    }

    var response = await client.post(DialogAddVehicle.URL_CRUD,
        headers: {HttpHeaders.authorizationHeader: token}, body: body);

    var jsonObject = json.decode(response.body);
    int status = jsonObject['status'];

    if (status == 200) {
      Navigator.of(context).pop('Update');
      print("masuk 1");
    } else {
      Navigator.of(context).pop();
      print("masuk 2");
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        backgroundColor: ColorLibrary.primary,
        title: Text(
          widget.title,
          style: TextStyle(fontFamily: 'Work Sans'),
        ),
        actions: <Widget>[
          new FlatButton(
            onPressed: () {
              _savingData();
            },
            child: new Text(
              'SAVE',
              style: TextStyle(
                  fontFamily: 'Work Sans', color: ColorLibrary.thinFontWhite),
            ),
          ),
        ],
      ),
      body: new Container(
        padding: EdgeInsets.all(15.0),
        child: new Form(
          // key: _formKey,
          autovalidate: false,
          child: new SingleChildScrollView(
            child: new Column(
              mainAxisSize: MainAxisSize.min, // To make the card compact
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _typeIDValue = 2;
                          _fetchData(_typeIDValue.toString());
                        });
                      },
                      child: Container(
                        margin: EdgeInsets.all(5.0),
                        padding: EdgeInsets.all(10.0),
                        decoration: BoxDecoration(
                          border: _typeIDValue == 2
                              ? Border.all(
                                  width: 1.0, color: ColorLibrary.primary)
                              : Border.all(
                                  width: 0.0,
                                  color: ColorLibrary.thinFontWhite),
                          borderRadius: BorderRadius.circular(60.0),
                          color: _typeIDValue == 2
                              ? ColorLibrary.secondary
                              : ColorLibrary.thinFontWhite,
                        ),
                        child: _typeIDValue == 2
                            ? Icon(
                                Icons.motorcycle,
                                size: 40,
                                color: ColorLibrary.thinFontBlack,
                              )
                            : Icon(
                                Icons.motorcycle,
                                size: 40,
                                color: Colors.white,
                              ),
                      ),
                    ),
                    SizedBox(width: 20.0),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _typeIDValue = 1;
                          _fetchData(_typeIDValue.toString());
                        });
                      },
                      child: Container(
                        margin: EdgeInsets.all(5.0),
                        padding: EdgeInsets.all(10.0),
                        decoration: BoxDecoration(
                          border: _typeIDValue == 1
                              ? Border.all(
                                  width: 1.0, color: ColorLibrary.primary)
                              : Border.all(
                                  width: 0.0,
                                  color: ColorLibrary.thinFontWhite),
                          borderRadius: BorderRadius.circular(60.0),
                          color: _typeIDValue == 1
                              ? ColorLibrary.secondary
                              : ColorLibrary.thinFontWhite,
                        ),
                        child: _typeIDValue == 1
                            ? Icon(
                                Icons.directions_car,
                                size: 40,
                                color: ColorLibrary.thinFontBlack,
                              )
                            : Icon(
                                Icons.directions_car,
                                size: 40,
                                color: Colors.white,
                              ),
                      ),
                    ),
                  ],
                ),
                TextField(
                  style: TextStyle(fontFamily: 'Work Sans'),
                  decoration: InputDecoration(
                      labelStyle: TextStyle(fontFamily: 'Work Sans'),
                      labelText: "Nick Name"),
                  controller: nickCont,
                ),
                SizedBox(height: 5.0),
                TextField(
                  style: TextStyle(fontFamily: 'Work Sans'),
                  decoration: InputDecoration(
                    labelStyle: TextStyle(fontFamily: 'Work Sans'),
                    labelText: "License Plate",
                  ),
                  controller: licenseCont,
                ),
                SizedBox(height: DialogAddVehicle.padding),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "Brand Vehicle",
                      style: TextStyle(
                          fontFamily: 'Work Sans',
                          fontSize: 11,
                          color: ColorLibrary.thinFontBlack),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      child: DropdownButtonHideUnderline(
                        child: ButtonTheme(
                          alignedDropdown: true,
                          child: DropdownButton(
                            value: _selectedBrand,
                            items: _itemBrand,
                            onChanged: onChangeDropDownBrand,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: DialogAddVehicle.padding),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "Model Vehicle",
                      style: TextStyle(
                          fontFamily: 'Work Sans',
                          fontSize: 11,
                          color: ColorLibrary.thinFontBlack),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      child: DropdownButtonHideUnderline(
                        child: ButtonTheme(
                          alignedDropdown: true,
                          child: DropdownButton<VehicleModel>(
                            value: _selectedModel,
                            items: _itemModel,
                            onChanged: onChangeDropDownModel,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: DialogAddVehicle.padding),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "Year Vehicle",
                      style: TextStyle(
                          fontFamily: 'Work Sans',
                          fontSize: 11,
                          color: ColorLibrary.thinFontBlack),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      child: DropdownButtonHideUnderline(
                        child: ButtonTheme(
                          alignedDropdown: true,
                          child: DropdownButton<String>(
                            value: _yearValue,
                            items: _listYear
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                            onChanged: (String newValue) {
                              setState(() {
                                _yearValue = newValue;
                              });
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: DialogAddVehicle.padding),
                Row(
                  children: <Widget>[
                    Checkbox(
                      value: _checked,
                      onChanged: (bool value) {
                        setState(() {
                          _checked = value;
                        });
                      },
                    ),
                    SizedBox(
                      width: 16.0,
                    ),
                    Text(
                      "set as default",
                      style: TextStyle(fontFamily: 'Work Sans'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
