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

class DialogSelectVehicle extends StatefulWidget {
  final int fromPage;
  //fromPage == 1 (from booking page)
  //fromPage == 2 (from ots page)

  const DialogSelectVehicle({Key key, this.fromPage}) : super(key: key);
  @override
  _DialogSelectVehicleState createState() => _DialogSelectVehicleState();
}

class _DialogSelectVehicleState extends State<DialogSelectVehicle> {
  SessionManager _session;
  HashMap<String, String> userData;
  var loading = false;
  List<Vehicle> _listData = [];

  Future<Null> _fetchData() async {
    final prefs = await SharedPreferences.getInstance();
    _session = new SessionManager(prefs);
    userData = _session.getUserSession();
    String token = userData['USER_TOKEN'];
    String idUser = userData['USER_ID'];
    String url = BaseUrl.VEHICLE;
    String whereClause;
    if (widget.fromPage == 1) {
      whereClause = "?user_id=$idUser&vehicle_status=t&vehicle_type_id=1";
    } else {
      whereClause = "?user_id=$idUser&vehicle_status=t";
    }
    String include = "&include=vehicle_model_id&include=vehicle_brand_id";

    if (mounted) {
      setState(() {
        loading = true;
      });
    }

    final response = await http.get('$url$whereClause$include',
        headers: {HttpHeaders.authorizationHeader: token});
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        _listData.clear();
        for (Map i in data['data']) {
          _listData.add(Vehicle.fromJson(i));
        }
        loading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        backgroundColor: ColorLibrary.primary,
        title: Text(
          "Select Your Vehicle",
          style: TextStyle(fontFamily: 'Work Sans'),
        ),
      ),
      body: SafeArea(
        child: new Container(
          color: ColorLibrary.backgroundDark,
          child: loading
              ? Center(
                  child: CircularProgressIndicator(
                    backgroundColor: ColorLibrary.primary,
                    valueColor:
                        AlwaysStoppedAnimation<Color>(ColorLibrary.secondary),
                  ),
                )
              : (_listData.length > 0)
                  ? CustomScrollView(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: false,
                      slivers: <Widget>[
                        new SliverPadding(
                          padding: const EdgeInsets.symmetric(vertical: 10.0),
                          sliver: new SliverList(
                            delegate: new SliverChildBuilderDelegate(
                              (context, index) {
                                return ListRow(_listData[index]);
                              },
                              childCount: _listData.length,
                            ),
                          ),
                        )
                      ],
                    )
                  : Center(
                      child: Text("You have no vehicle"),
                    ),
        ),
      ),
    );
  }
}

class ListRow extends StatelessWidget {
  final Vehicle vehicle;
  ListRow(this.vehicle);

  @override
  Widget build(BuildContext context) {
    return new Container(
      height: 55.0,
      margin: EdgeInsets.only(left: 10.0, right: 10.0, top: 10.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          width: 1.0,
          color: ColorLibrary.regularFontWhite,
        ),
      ),
      child: new ListTile(
        leading: Icon(
          (vehicle.vehicleTypeID.toString() == "1")
              ? Icons.directions_car
              : Icons.directions_bike,
          color: ColorLibrary.primary,
        ),
        title: Container(
          child: Column(
            children: <Widget>[
              Text(
                "${vehicle.vehicleBrandID.vehicleBrandName} - ${vehicle.vehicleModelID.vehicleModelName}",
                style: TextStyle(fontFamily: 'Work Sans', fontSize: 13),
              ),
              Text(
                "${vehicle.vehicleLicense}",
                style: TextStyle(fontFamily: 'Work Sans', fontSize: 20),
              ),
            ],
          ),
        ),
        trailing: Icon(
          Icons.arrow_forward_ios,
          color: ColorLibrary.primary,
        ),
        onTap: () {
          Navigator.of(context).pop(
              "${vehicle.vehicleTypeID},${vehicle.vehicleID},${vehicle.vehicleBrandID.vehicleBrandName} - ${vehicle.vehicleModelID.vehicleModelName},${vehicle.vehicleLicense}");
        },
      ),
    );
  }
}
