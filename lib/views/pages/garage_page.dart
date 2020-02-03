import 'dart:collection';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:user_pijar/models/vehicle.dart';
import 'package:user_pijar/services/api.dart';
import 'package:user_pijar/views/widget/color_library.dart';
import 'package:user_pijar/views/widget/dialog_add_vehicle.dart';
import 'package:user_pijar/views/widget/session_manager.dart';
import 'package:user_pijar/views/widget/vehicle_row.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class GaragePage extends StatefulWidget {
  @override
  _GaragePageState createState() => _GaragePageState();
}

class _GaragePageState extends State<GaragePage>
    with SingleTickerProviderStateMixin {
  static const String URL = BaseUrl.VEHICLE;
  static const String include =
      "&include=vehicle_model_id&include=vehicle_brand_id";
  SessionManager _session;
  HashMap<String, String> userData;
  var loading = false;
  List<Vehicle> _listMotor = [];
  List<Vehicle> _listMobil = [];
  TabController _tabController;

  @override
  void initState() {
    super.initState();
    _fetchData();
    _tabController = TabController(length: 2, vsync: this, initialIndex: 0);
    _tabController.addListener(_handleTabIndex);
  }

  @override
  void dispose() {
    _tabController.removeListener(_handleTabIndex);
    _tabController.dispose();
    super.dispose();
  }

  void _handleTabIndex() {
    setState(() {});
  }

  Future<Null> _fetchData() async {
    final _prefs = await SharedPreferences.getInstance();
    _session = new SessionManager(_prefs);
    userData = _session.getUserSession();
    String token = userData['USER_TOKEN'];
    String userID = userData['USER_ID'];

    String whereCar = "?user_id=$userID&vehicle_status=t&vehicle_type_id=1";
    String whereMotor = "?user_id=$userID&vehicle_status=t&vehicle_type_id=2";

    setState(() {
      loading = true;
    });

    final responseCar = await http.get('$URL$whereCar$include',
        headers: {HttpHeaders.authorizationHeader: token});
    if (responseCar.statusCode == 200) {
      final data = jsonDecode(responseCar.body);
      setState(() {
        _listMobil.clear();
        for (Map i in data['data']) {
          _listMobil.add(Vehicle.fromJson(i));
        }
        loading = false;
      });
    }

    final responseMotor = await http.get('$URL$whereMotor$include',
        headers: {HttpHeaders.authorizationHeader: token});
    if (responseMotor.statusCode == 200) {
      final data = jsonDecode(responseMotor.body);
      if (mounted) {
        setState(() {
          _listMotor.clear();
          for (Map i in data['data']) {
            if (data != null) {
              _listMotor.add(Vehicle.fromJson(i));
            } else {
              _listMotor = null;
            }
          }
          loading = false;
        });
      }
    }
  }

  _navigateAndDisplayDialog(BuildContext context, int typeID) async {
    // Navigator.push returns a Future that completes after calling
    // Navigator.pop on the Dialog Screen.
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => new DialogAddVehicle(
              0, typeID, "Add Vehicle", "", "", null, null, 0, "no"),
          fullscreenDialog: true),
    );

    // After the Dialog Screen returns a result
    // and show the new result.
    print("hasil lemparan $result");
    if (result == 'Update') {
      _fetchData();
    } else {
      _fetchData();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorLibrary.primary,
        title: Text(
          "My Garage",
          style: TextStyle(fontFamily: 'Work Sans'),
        ),
        bottom: TabBar(
          indicator: BoxDecoration(
            border: Border(
                bottom: BorderSide(color: ColorLibrary.secondary, width: 1.0)),
          ),
          controller: _tabController,
          tabs: <Widget>[
            Tab(
              child: Text(
                "MOTORCYCLE",
                style: TextStyle(fontFamily: 'Work Sans'),
              ),
            ),
            Tab(
              child: Text(
                "CAR",
                style: TextStyle(fontFamily: 'Work Sans'),
              ),
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: <Widget>[
          Container(
            color: ColorLibrary.backgroundDark,
            child: loading
                ? Center(child: _circularProgress())
                : (_listMotor.length > 0)
                    ? ListView.builder(
                        itemBuilder: (context, position) {
                          return new VehicleRow(_listMotor[position], 1);
                        },
                        itemCount: _listMotor.length,
                      )
                    : Center(
                        child: Text('Oops.. \n No Data Found'),
                      ),
          ),
          Container(
              color: ColorLibrary.backgroundDark,
              child: loading
                  ? Center(
                      child: CircularProgressIndicator(
                        backgroundColor: ColorLibrary.primary,
                        valueColor: AlwaysStoppedAnimation<Color>(
                            ColorLibrary.secondary),
                      ),
                    )
                  : (_listMobil.length > 0)
                      ? ListView.builder(
                          itemBuilder: (context, position) {
                            return new VehicleRow(_listMobil[position], 1);
                          },
                          itemCount: _listMobil.length,
                        )
                      : Center(
                          child: Text('Oops.. \n No Data Found'),
                        ))
        ],
      ),
      floatingActionButton: _floatingAction(),
    );
  }

  Widget _circularProgress() {
    return SizedBox(
      child: CircularProgressIndicator(
        backgroundColor: ColorLibrary.primary,
          valueColor: AlwaysStoppedAnimation<Color>(ColorLibrary.secondary),
        strokeWidth: 2.0,
      ),
      height: 15.0,
      width: 15.0,
    );
  }

  Widget _floatingAction() {
    return _tabController.index == 0
        ? FloatingActionButton(
            backgroundColor: ColorLibrary.secondary,
            child: Icon(
              Icons.directions_bike,
              color: ColorLibrary.thinFontBlack,
            ),
            onPressed: () {
              _navigateAndDisplayDialog(context, 1);
            },
          )
        : FloatingActionButton(
            backgroundColor: ColorLibrary.secondary,
            child: Icon(
              Icons.directions_car,
              color: ColorLibrary.thinFontBlack,
            ),
            onPressed: () {
              _navigateAndDisplayDialog(context, 2);
            },
          );
  }
}
