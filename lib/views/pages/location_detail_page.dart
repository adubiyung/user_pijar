import 'dart:collection';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:user_pijar/models/Location.dart';
import 'package:user_pijar/services/api.dart';
import 'package:user_pijar/views/widget/color_library.dart';
import 'package:user_pijar/views/widget/loc_detail_row.dart';
import 'package:user_pijar/views/widget/session_manager.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class LocationDetailPage extends StatefulWidget {
  // final String locID;

  // const LocationDetailPage({Key key, this.locID}) : super(key: key);
  @override
  _LocationDetailPageState createState() => _LocationDetailPageState();
}

class _LocationDetailPageState extends State<LocationDetailPage> {
  SessionManager _session;
  HashMap<String, String> user;
  var loading = false;
  List<LocationDetail> _listData = [];
  String id = '';

  Future<Null> _fetchData() async {
    final prefs = await SharedPreferences.getInstance();
    _session = new SessionManager(prefs);
    user = _session.getUserSession();
    String token = user['USER_TOKEN'];
    String url = BaseUrl.LOCDETAIL;
    String clause = '?vehicle_type_id=1&location_id=$id';
    print('$url$clause');

    final response = await http
        .get('$url$clause', headers: {HttpHeaders.authorizationHeader: token});
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (mounted) {
        setState(() {
          for (Map i in data['data']) {
            _listData.add(LocationDetail.fromJson(i));
          }
          loading = false;
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();

    _fetchData();
  }

  @override
  Widget build(BuildContext context) {
    final Map arguments = ModalRoute.of(context).settings.arguments as Map;
    if (arguments != null) print('eaa ${arguments['locID']}');
    setState(() {
      id = arguments['locID'];
    });
    return new Scaffold(
      appBar: AppBar(
        title: Text("Location Side"),
        backgroundColor: ColorLibrary.primary,
      ),
      body: new Column(
        children: <Widget>[
          new Expanded(
            child: new Container(
              color: ColorLibrary.backgroundDark,
              child: loading
                  ? Center(
                      child: CircularProgressIndicator(
                      backgroundColor: ColorLibrary.primary,
                      valueColor:
                          AlwaysStoppedAnimation<Color>(ColorLibrary.secondary),
                    ))
                  : (_listData.length > 0)
                      ? CustomScrollView(
                          scrollDirection: Axis.vertical,
                          shrinkWrap: false,
                          slivers: <Widget>[
                            new SliverPadding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 12.0),
                              sliver: new SliverList(
                                delegate: new SliverChildBuilderDelegate(
                                  (context, index) {
                                    return LocDetailRow(_listData[index]);
                                  },
                                  childCount: _listData.length,
                                ),
                              ),
                            ),
                          ],
                        )
                      : Center(
                          child: Text(
                              "Oops.. No Data Found. \n Please select another location."),
                        ),
            ),
          ),
        ],
      ),
    );
  }
}
