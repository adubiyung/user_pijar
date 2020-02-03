import 'dart:collection';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:user_pijar/models/Location.dart';
import 'package:user_pijar/services/api.dart';
import 'package:user_pijar/views/widget/color_library.dart';
import 'package:user_pijar/views/widget/location_row.dart';
import 'package:user_pijar/views/widget/session_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class LocationSearchPage extends StatefulWidget {
  // final int districtID;
  final String district;

  const LocationSearchPage({Key key, this.district}) : super(key: key);
  @override
  _LocationSearchPageState createState() => _LocationSearchPageState();
}

class _LocationSearchPageState extends State<LocationSearchPage>
    with TickerProviderStateMixin {
  TabController _tabController;
  final TextEditingController _filter = new TextEditingController();
  Icon _searchIcon = new Icon(
    Icons.search,
    color: ColorLibrary.thinFontWhite,
  );
  List filteredNames = new List();
  List names = new List();
  int typeID = 0;
  SessionManager _session;
  HashMap<String, String> userData;
  var loading = false;
  List<Location> _listAll = [];
  List<Location> _listFav = [];
  Widget _appbarTitle = new Text(
    "Location",
    style: TextStyle(fontFamily: 'Work Sans'),
  );

  Future<Null> _fetchDataLocation() async {
    final _prefs = await SharedPreferences.getInstance();
    _session = new SessionManager(_prefs);
    userData = _session.getUserSession();
    String token = userData['USER_TOKEN'];
    // String url = BaseUrl.LOCATION;
    // String clause = '?district_id=${widget.districtID}';
    // String include = '&include=city_id&include=province_id';
    String url = BaseUrl.NEARBY;
    var client = new http.Client();
    String body = """{
    "district_name": "${widget.district}",
    "include": ["district_id", "city_id", "province_id"]
    }""";
    // final response = await http
    //     .get(url + clause + include, headers: {HttpHeaders.authorizationHeader: token});

    final response = await client.post(url,
        headers: {HttpHeaders.authorizationHeader: token}, body: body);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      print('iniii $data');
      setState(() {
        _listFav.clear();
        _listAll.clear();
        for (Map i in data['result']) {
          _listAll.add(Location.fromJson(i));
          _listFav.add(Location.fromJson(i));
        }
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this, initialIndex: 0);
    _tabController.addListener(_handleTabIndex);
    _fetchDataLocation();
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

  @override
  Widget build(BuildContext context) {
    Widget _bodyTabFirst = new Container(
      color: ColorLibrary.backgroundDark,
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              GestureDetector(
                onTap: () {
                  setState(() {
                    typeID = 0;
                  });
                },
                child: Container(
                  padding: EdgeInsets.fromLTRB(20.0, 7.0, 20.0, 7.0),
                  margin: EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30.0),
                    border: typeID == 0
                        ? Border.all(width: 0.0, color: ColorLibrary.primary)
                        : Border.all(
                            width: 1.0, color: ColorLibrary.thinFontWhite),
                    color: typeID == 0
                        ? ColorLibrary.primary
                        : ColorLibrary.backgroundDark,
                  ),
                  child: Center(
                    child: Text(
                      "all",
                      style: TextStyle(
                          fontFamily: 'Work Sans',
                          color: typeID == 0
                              ? ColorLibrary.secondaryAccent
                              : ColorLibrary.thinFontWhite),
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 15.0,
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    typeID = 1;
                  });
                },
                child: Container(
                  padding: EdgeInsets.fromLTRB(20.0, 7.0, 20.0, 7.0),
                  margin: EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30.0),
                    border: typeID == 1
                        ? Border.all(width: 0.0, color: ColorLibrary.primary)
                        : Border.all(
                            width: 1.0, color: ColorLibrary.thinFontWhite),
                    color: typeID == 1
                        ? ColorLibrary.primary
                        : ColorLibrary.backgroundDark,
                  ),
                  child: Center(
                    child: Text(
                      "motor",
                      style: TextStyle(
                          fontFamily: 'Work Sans',
                          color: typeID == 1
                              ? ColorLibrary.secondaryAccent
                              : ColorLibrary.thinFontWhite),
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 15.0,
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    typeID = 2;
                  });
                },
                child: Container(
                  padding: EdgeInsets.fromLTRB(20.0, 7.0, 20.0, 7.0),
                  margin: EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30.0),
                    border: typeID == 2
                        ? Border.all(width: 0.0, color: ColorLibrary.primary)
                        : Border.all(
                            width: 1.0, color: ColorLibrary.thinFontWhite),
                    color: typeID == 2
                        ? ColorLibrary.primary
                        : ColorLibrary.backgroundDark,
                  ),
                  child: Center(
                    child: Text(
                      "car",
                      style: TextStyle(
                          fontFamily: 'Work Sans',
                          color: typeID == 2
                              ? ColorLibrary.secondaryAccent
                              : ColorLibrary.thinFontWhite),
                    ),
                  ),
                ),
              ),
            ],
          ),
          Expanded(
            child: (_listAll.length == 0)
                ? Center(
                    child: CircularProgressIndicator(
                      backgroundColor: ColorLibrary.primary,
                      valueColor:
                          AlwaysStoppedAnimation<Color>(ColorLibrary.secondary),
                    ),
                  )
                : ListView.builder(
                    itemBuilder: (context, position) {
                      return new LocationRow(_listAll[position]);
                    },
                    itemCount: _listAll.length,
                  ),
          ),
        ],
      ),
    );

    Widget _bodyTabSecond = new Container(
      child: (_listFav.length == 0)
          ? Center(
              child: CircularProgressIndicator(
                backgroundColor: ColorLibrary.primary,
                valueColor:
                    AlwaysStoppedAnimation<Color>(ColorLibrary.secondary),
              ),
            )
          : ListView.builder(
              itemBuilder: (context, position) {
                return new LocationRow(_listFav[position]);
              },
              itemCount: _listFav.length,
            ),
    );

    Widget _compileWidget = new Scaffold(
      appBar: new AppBar(
        backgroundColor: ColorLibrary.primary,
        title: _appbarTitle,
        actions: <Widget>[
          new IconButton(
            icon: _searchIcon,
            onPressed: () {
              _searchPressed();
            },
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: <Widget>[
            Tab(
              child: Text(
                "Nearby",
                style: TextStyle(fontFamily: 'Work Sans'),
              ),
            ),
            Tab(
              child: Text(
                "Favourite",
                style: TextStyle(fontFamily: 'Work Sans'),
              ),
            ),
          ],
        ),
      ),
      body: new TabBarView(
        controller: _tabController,
        children: <Widget>[_bodyTabFirst, _bodyTabSecond],
      ),
    );

    return _compileWidget;
  }

  void _searchPressed() {
    setState(() {
      if (_searchIcon.icon == Icons.search) {
        _searchIcon = new Icon(
          Icons.close,
          color: ColorLibrary.thinFontWhite,
        );
        _appbarTitle = new TextField(
          controller: _filter,
          decoration: new InputDecoration(
            hintText: 'Search...',
            hintStyle: TextStyle(
              fontFamily: 'Work Sans',
              color: ColorLibrary.thinFontWhite,
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: const BorderSide(color: ColorLibrary.thinFontWhite),
            ),
          ),
        );
      } else {
        _searchIcon = new Icon(
          Icons.search,
          color: ColorLibrary.thinFontWhite,
        );
        _appbarTitle = new Text(
          'Location',
          style: TextStyle(fontFamily: 'Work Sans'),
        );
        filteredNames = names;
        _filter.clear();
      }
    });
  }
}
