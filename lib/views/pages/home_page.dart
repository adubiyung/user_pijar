import 'dart:async';
import 'dart:collection';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:user_pijar/models/Location.dart';
import 'package:user_pijar/services/api.dart';
import 'package:user_pijar/views/pages/location_search_page.dart';
import 'package:user_pijar/views/widget/color_library.dart';
import 'package:user_pijar/views/widget/location_row.dart';
import 'package:user_pijar/views/widget/session_manager.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with WidgetsBindingObserver {
  DateTime currentBackPressTime;
  List<Location> _listLocation = [];
  GoogleMapController _mapController;
  Geolocator _geolocator;
  LatLng _currentPosition;
  double _currentZoom;
  StreamSubscription<Position> _positionStream;
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  bool _shouldRecenterMap = true;
  Timer _mapDragTimer;
  SessionManager _session;
  HashMap<String, String> userData;
  String kecamatan;
  int districtID;

  // final Firestore _db = Firestore.instance;
  // final FirebaseMessaging _fcm = FirebaseMessaging();

  @override
  void initState() {
    super.initState();
    _currentPosition = LatLng(-6.175048, 106.827127);
    _currentZoom = 17.5;
    _initLocationService();
    // _fetchDataLocation();
    // _fcm.configure(
    //   onMessage: (Map<String, dynamic> message) async {
    //     print("onMessage: $message");
    //     showDialog(
    //       context: context,
    //       builder: (context) => AlertDialog(
    //         content: ListTile(
    //           title: Text(message['notification']['title']),
    //           subtitle: Text(message['notification']['body']),
    //         ),
    //         actions: <Widget>[
    //           FlatButton(
    //             child: Text('Ok'),
    //             onPressed: () => Navigator.of(context).pop(),
    //           ),
    //         ],
    //       ),
    //     );
    //   },
    //   onLaunch: (Map<String, dynamic> message) async {
    //     print("onLaunch: $message");
    //     // TODO optional
    //   },
    //   onResume: (Map<String, dynamic> message) async {
    //     print("onResume: $message");
    //     // TODO optional
    //   },
    // );
  }

  Future<Null> _fetchDataLocation(String district) async {
    final _prefs = await SharedPreferences.getInstance();
    _session = new SessionManager(_prefs);
    userData = _session.getUserSession();
    String token = userData['USER_TOKEN'];
    // String url = BaseUrl.LOCATION;
    // String include = "?include=district_id&include=city_id&include=province_id";
    String url = BaseUrl.NEARBY;
    var client = new http.Client();
    String body = """{
    "district_name": "$district",
    "include": ["district_id", "city_id", "province_id"]
    }""";
    int ang = 0;
    final response = await client.post(url,
        headers: {HttpHeaders.authorizationHeader: token}, body: body);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      print('data $data');

      if (mounted) {
        setState(() {
          districtID = data['district_id'];
          _listLocation.clear();
          int left = 0;
          for (Map i in data['result']) {
            ang++;
            if (ang < 3) {
              _listLocation.add(Location.fromJson(i));
            }
          }
        });
      }
    }
  }

  Future<void> _initLocationService() async {
    _geolocator = Geolocator();
    var locationOptions =
        LocationOptions(accuracy: LocationAccuracy.best, distanceFilter: 50);

    try {
      _positionStream =
          _geolocator.getPositionStream(locationOptions).listen((position) {
        if (position != null) {
          _updateCurrentPosition(position);
        }
      });
    } on Exception catch (_) {
      print("Permission denied");
    }
  }

  @override
  void dispose() {
    _positionStream.cancel();
    super.dispose();
  }

  void _updateCurrentPosition(Position position) {
    if (position != null) {
      _currentPosition = LatLng(position.latitude, position.longitude);

      _moveMarker(position);
      _refreshCameraPosition();
      _geocodeCurrentPosition();
    } else {}
  }

  void _moveMarker(Position position) {
    var markerId = MarkerId("currentPos");
    if (mounted) {
      setState(() {
        markers[markerId] =
            Marker(markerId: markerId, position: _currentPosition);
      });
    }
  }

  void _refreshCameraPosition() {
    if (_mapController != null && _shouldRecenterMap) {
      _mapController.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(target: _currentPosition, zoom: _currentZoom),
      ));
    }
  }

  void _geocodeCurrentPosition() async {
    var resultList = await _geolocator.placemarkFromCoordinates(
        _currentPosition.latitude, _currentPosition.longitude,
        localeIdentifier: "id-ID");

    if (resultList.length > 0) {
      Placemark firstResult = resultList[0];

      if (mounted) {
        setState(() {
          kecamatan = firstResult.locality;
          print("ini adalah region = " + kecamatan);
          _positionStream.cancel();
        });
      }
      var length = kecamatan.length;
      print(kecamatan.substring(9, length));
      _fetchDataLocation(kecamatan.substring(10, length));
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget _topWidget = new Container(
      margin: EdgeInsets.only(top: 15.0),
      child: Column(
        children: <Widget>[
          Align(
            alignment: Alignment.topCenter,
            child: Icon(
              Icons.maximize,
            ),
          ),
          //ButtonSearch(),
        ],
      ),
    );

    Widget _middleWidget = new Container(
      height: MediaQuery.of(context).size.height / 2.5,
      child: Column(
        children: <Widget>[
          Expanded(
            child: (_listLocation.length == 0)
                ? Container(
                    alignment: Alignment.topCenter,
                    child: CircularProgressIndicator(
                      backgroundColor: ColorLibrary.primary,
                      valueColor:
                          AlwaysStoppedAnimation<Color>(ColorLibrary.secondary),
                    ),
                  )
                : ListView.builder(
                    itemBuilder: (context, position) {
                      return new LocationRow(_listLocation[position]);
                    },
                    itemCount: _listLocation.length,
                  ),
          ),
          SizedBox(
            height: 5.0,
          ),
          Center(
              child: GestureDetector(
            child: Text(
              "show more",
              style: TextStyle(color: ColorLibrary.thinFontWhite),
            ),
            onTap: _moveToSearch,
          ))
        ],
      ),
    );

    Widget _slideWidget = new Container(
      color: ColorLibrary.backgroundDark,
      child: Column(
        children: <Widget>[_topWidget, _middleWidget],
      ),
    );

    Widget _compileWidget = new SafeArea(
      child: new SlidingUpPanel(
        panel: _slideWidget,
        minHeight: 150.0,
        maxHeight: MediaQuery.of(context).size.height / 2,
        body: WillPopScope(
          onWillPop: onWillPop,
          child: Stack(
            children: <Widget>[
              GoogleMap(
                mapType: MapType.normal,
                myLocationEnabled: true,
                initialCameraPosition: CameraPosition(
                    target: _currentPosition, zoom: _currentZoom),
                onMapCreated: (controller) {
                  _mapController = controller;
                },
                onCameraMove: (cameraPosition) {
                  _currentZoom = cameraPosition.zoom;
                  _shouldRecenterMap = false;
                  if (_mapDragTimer != null && _mapDragTimer.isActive) {
                    _mapDragTimer.cancel();
                  }
                  _mapDragTimer = Timer(Duration(seconds: 3), () {
                    _shouldRecenterMap = true;
                  });
                },
                markers: Set<Marker>.of(markers.values),
              ),
            ],
          ),
        ),
      ),
    );

    return _compileWidget;
  }

  void _moveToSearch() {
    String districtName = kecamatan.substring(10, kecamatan.length);
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => LocationSearchPage(district: districtName),
        ));
  }

  Future<bool> onWillPop() {
    DateTime now = DateTime.now();
    if (currentBackPressTime == null ||
        now.difference(currentBackPressTime) > Duration(seconds: 2)) {
      currentBackPressTime = now;
      Fluttertoast.showToast(
        msg: "press back again to exit",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );
      return Future.value(false);
    }
    return Future.value(true);
  }
}
