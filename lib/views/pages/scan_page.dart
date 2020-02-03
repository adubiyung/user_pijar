import 'dart:collection';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:user_pijar/models/getTransaction.dart' as trans;
import 'package:user_pijar/models/vehicle.dart';
import 'package:user_pijar/services/api.dart';
import 'package:user_pijar/views/pages/detail_ticket_page.dart';
import 'package:user_pijar/views/pages/qrcode_page.dart';
import 'package:user_pijar/views/widget/color_library.dart';
import 'package:user_pijar/views/widget/dialog_select_vehicle.dart';
import 'package:user_pijar/views/widget/session_manager.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:qr_code_scanner/qr_scanner_overlay_shape.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:http/http.dart' as http;

const flash_on = "FLASH ON";
const flash_off = "FLASH OFF";
const front_camera = "FRONT CAMERA";
const back_camera = "BACK CAMERA";

class ScanPage extends StatefulWidget {
  const ScanPage({
    Key key,
  }) : super(key: key);
  @override
  _ScanPageState createState() => _ScanPageState();
}

class _ScanPageState extends State<ScanPage> {
  var qrText = "";
  var flashState = flash_on;
  var cameraState = front_camera;
  QRViewController controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  IconData _iconFlash = Icons.flash_off;
  //
  List<Vehicle> _listVehicle = [];
  static const String URL = BaseUrl.VEHICLE;
  static const String include =
      "&include=vehicle_model_id&include=vehicle_brand_id";
  SessionManager _session;
  HashMap<String, String> userData;
  var loading = false;
  String token;
  String userID;
  //
  String _selectedBrand = "";
  String _selectedModel = "";
  String _selectedBrandModel = "";
  String _selectedLicense = "";
  String _selectedVehicleID = "";
  String _selectedVehicleType = "";
  int millis = new DateTime.now().millisecondsSinceEpoch;
  String methodScan = '1';
  int featureTypeID = 1;
  int featureID;
  int startPrice;
  int nextPrice;
  //
  trans.DataTransaction modelTrans;
  List<trans.DataTransaction> _listTrans = [];

  List<String> splitCode = [];

  Future<Null> _fetchData() async {
    final _prefs = await SharedPreferences.getInstance();
    _session = new SessionManager(_prefs);
    userData = _session.getUserSession();
    token = userData['USER_TOKEN'];
    userID = userData['USER_ID'];

    String whereMine = "?user_id=$userID&vehicle_status=t";

    setState(() {
      loading = true;
    });

    final response = await http.get('$URL$whereMine$include',
        headers: {HttpHeaders.authorizationHeader: token});
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        _listVehicle.clear();
        for (Map i in data['data']) {
          _listVehicle.add(Vehicle.fromJson(i));
        }

        _selectedVehicleID = "${_listVehicle[0].vehicleID}";
        _selectedVehicleType = "${_listVehicle[0].vehicleTypeID}";
        _selectedBrand = "${_listVehicle[0].vehicleBrandID.vehicleBrandName}";
        _selectedModel = "${_listVehicle[0].vehicleModelID.vehicleModelName}";
        _selectedBrandModel = "$_selectedBrand - $_selectedModel";
        _selectedLicense = "${_listVehicle[0].vehicleLicense}";

        loading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  _navigateToQRCode(BuildContext context) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => new QrcodePage(
          methodScan,
          userID,
          _selectedVehicleID,
          _selectedVehicleType,
          featureTypeID.toString()
        ),
      ),
    );
  }

  _navigateToDetailTicket(BuildContext context) async {
    // Navigator.push returns a Future that completes after calling
    // Navigator.pop on the Dialog Screen.
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => new DetailTicketPage(modelTrans: _listTrans[0]),
      ),
    );
  }

  _displayDialogVehicle(BuildContext context) async {
    // Navigator.push returns a Future that completes after calling
    // Navigator.pop on the Dialog Screen.
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => new DialogSelectVehicle(fromPage: 2,),
          fullscreenDialog: true),
    );

    // After the Dialog Screen returns a result
    // and show the new result.
    if (result != null) {
      var hasil = result.split(",");
      if (mounted) {
        setState(() {
          _selectedVehicleType = hasil[0];
          _selectedVehicleID = hasil[1];
          _selectedBrandModel = hasil[2];
          _selectedLicense = hasil[3];
        });
      }
    }
  }

  Future<Null> _sendDataCheckIn() async {
    String url = BaseUrl.TRANSACTION;
    var client = new http.Client();
    String body = '';
    String wardenID = splitCode[0];
    String locationID = splitCode[1];
    String tcode =
        'in-$_selectedVehicleID${splitCode[0]}${splitCode[1]}$millis';
    body =
        '''{"method": "scan-in", "transaction_code": "$tcode", "user_id": $userID, 
        "vehicle_id": $_selectedVehicleID, "vehicle_type_id": $_selectedVehicleType, "feature_id": $featureID, 
        "feature_type_id": $featureTypeID, "location_id": $locationID, "start_price": $startPrice, 
        "next_price": $nextPrice, "warden_checkin_by": $wardenID}''';
    setState(() {
      loading = true;
    });
    final response = await client.post(url,
        headers: {HttpHeaders.authorizationHeader: token}, body: body);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      // if (mounted) {
      //   setState(() {
      //     for (Map item in data['data']) {
      //       _listTrans.add(trans.DataTransaction.fromJson(item));
      //     }
      //   });
      // }
      print(data);
      Fluttertoast.showToast(
        msg: "Success",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );
    }

    controller.resumeCamera();
    // _navigateToDetailTicket(context);
  }

  Future<Null> _checkScanning() async {
    String url = BaseUrl.TRANSACTION;
    var client = new http.Client();
    String body = '''{"method": "scan", "user_id": "$userID", 
        "location_id": "${splitCode[1]}", "vehicle_type_id": "$_selectedVehicleType", 
        "feature_type_id": 1}''';
    setState(() {
      loading = true;
    });
    final response = await client.post(url,
        headers: {HttpHeaders.authorizationHeader: token}, body: body);

    var jsonObject = json.decode(response.body);
    String code = jsonObject['code'];
    if (response.statusCode == 200) {
      // menampilkan dialog konfirmasi
      if (code == "001") {
        _dialogWarning();
      } else {
        _dialogCheckin();
        setState(() {
          featureID = jsonObject['feature_id'];
          startPrice = jsonObject['feature_startprice'];
          nextPrice = jsonObject['feature_nextprice'];
        });
      }
    } else {
      Fluttertoast.showToast(
        msg: "Oops cannot read the code",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
      );
    }
  }

  void _dialogCheckin() {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.INFO,
      animType: AnimType.SCALE,
      body: new Container(
        child: Column(
          children: <Widget>[
            new Center(
              child: new Text(
                "CHECK-IN",
                style: TextStyle(
                  fontFamily: 'Work Sans',
                  fontWeight: FontWeight.w700,
                  fontSize: 25,
                ),
              ),
            ),
            SizedBox(
              height: 10.0,
            ),
            new Container(
              margin: EdgeInsets.only(left: 10.0, right: 10.0),
              child: new Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  new Text(
                    "License Number: $_selectedLicense",
                    style: TextStyle(
                      fontFamily: 'Work Sans',
                    ),
                  ),
                  new Text(
                    "Brand - Model: $_selectedBrandModel",
                    style: TextStyle(fontFamily: 'Work Sans'),
                  ),
                  new Text(
                    (_selectedVehicleType == "1")
                        ? "Vehicle Type: CAR"
                        : "Vehicle Type: BIKE",
                    style: TextStyle(
                      fontFamily: 'Work Sans',
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      btnOkText: "Yes",
      btnOkOnPress: () {
        _sendDataCheckIn();
      },
      btnCancelText: "Cancel",
      btnCancelOnPress: () {
        controller.resumeCamera();
      },
      dismissOnTouchOutside: false,
    ).show();
  }

  void _dialogWarning() {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.ERROR,
      animType: AnimType.SCALE,
      body: new Container(
        child: Column(
          children: <Widget>[
            new Center(
              child: new Text(
                "Warning !",
                style: TextStyle(
                  fontFamily: 'Work Sans',
                  fontWeight: FontWeight.w700,
                  fontSize: 25,
                ),
              ),
            ),
            SizedBox(
              height: 10.0,
            ),
            new Container(
              margin: EdgeInsets.only(left: 10.0, right: 10.0),
              child: Text(
                "Your vehicle is still check-in",
                style: TextStyle(fontFamily: 'Work Sans'),
              ),
            ),
          ],
        ),
      ),
      btnOkText: "OK",
      btnOkOnPress: () {
        controller.resumeCamera();
      },
      dismissOnTouchOutside: false,
    ).show();
  }

  @override
  Widget build(BuildContext context) {
    Widget _buttonContent = new Container(
      margin: EdgeInsets.all(5.0),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: ColorLibrary.primary,
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(5),
      ),
      child: new Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Icon(
                (_selectedVehicleType == "1")
                    ? Icons.directions_car
                    : Icons.directions_bike,
                size: 13,
                color: ColorLibrary.thinFontWhite,
              ),
              SizedBox(
                width: 5.0,
              ),
              Flexible(
                child: Container(
                  child: Text(
                    _selectedBrandModel,
                    style: TextStyle(
                      fontFamily: 'Work Sans',
                      color: ColorLibrary.thinFontWhite,
                      fontSize: 11,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ],
          ),
          Center(
            child: Text(
              _selectedLicense,
              style: TextStyle(
                fontFamily: 'Work Sans',
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: ColorLibrary.thinFontWhite,
              ),
            ),
          ),
        ],
      ),
    );

    Widget _selectionButton = new Container(
      width: 170.0,
      height: 50.0,
      margin: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 10.0),
      child: new Container(
        decoration: BoxDecoration(
          color: ColorLibrary.primary,
          borderRadius: BorderRadius.circular(5),
        ),
        child: _buttonContent,
      ),
    );

    Widget _slideWidget = new Container(
      color: ColorLibrary.backgroundDark,
      child: new Column(
        children: <Widget>[
          //icon strip
          new Center(
            child: Icon(
              Icons.minimize,
            ),
          ),
          new Padding(
            padding: EdgeInsets.fromLTRB(20.0, 10.0, 5.0, 0.0),
            child: new Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                new Column(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(bottom: 10.0),
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: new Text(
                          "another way",
                          style: TextStyle(
                              fontFamily: 'Work Sans',
                              fontSize: 13,
                              fontWeight: FontWeight.w300),
                        ),
                      ),
                    ),
                    ButtonTheme(
                      minWidth: 30.0,
                      height: 50.0,
                      child: FlatButton(
                        child: Icon(
                          Icons.keyboard,
                          size: 35,
                          color: ColorLibrary.thinFontWhite,
                        ),
                        color: ColorLibrary.primary,
                        shape: new RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        onPressed: () {
                          _navigateToQRCode(context);
                        },
                      ),
                    ),
                    Container(
                      height: 5.0,
                    ),
                    Text(
                      "QR Code",
                      style: TextStyle(
                          fontFamily: 'Work Sans',
                          fontSize: 13,
                          fontWeight: FontWeight.w400),
                    ),
                  ],
                ),
                new Column(
                  children: <Widget>[
                    new Container(
                      padding: EdgeInsets.only(left: 12.0, right: 12.0),
                      height: 28.0,
                      width: 30.0,
                      decoration: BoxDecoration(
                        border: Border(
                          right: BorderSide(width: 2.0, color: Colors.black54),
                        ),
                      ),
                    ),
                  ],
                ),
                new SizedBox(
                  width: 25.0,
                ),
                new Column(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(bottom: 10.0),
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: new Text(
                          "select vehicle",
                          style: TextStyle(
                              fontFamily: 'Work Sans',
                              fontSize: 13,
                              fontWeight: FontWeight.w300),
                        ),
                      ),
                    ),
                    GestureDetector(
                      child: _selectionButton,
                      onTap: () {
                        _displayDialogVehicle(context);
                      },
                    ),
                    SizedBox(height: 5),
                    Text(
                      "",
                      style: TextStyle(
                          fontFamily: 'Work Sans',
                          fontSize: 13,
                          fontWeight: FontWeight.w400),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );

    Widget _cameraWidget = new Column(
      children: <Widget>[
        Expanded(
          child: QRView(
            key: qrKey,
            onQRViewCreated: _onQRViewCreated,
            overlay: QrScannerOverlayShape(
              borderColor: ColorLibrary.secondary,
              borderRadius: 10.0,
              borderLength: 40.0,
              borderWidth: 5.0,
              cutOutSize: 300.0,
            ),
          ),
        ),
        Container(
          height: 150.0,
        )
      ],
    );

    Widget _compileWidget = new SlidingUpPanel(
      panel: _slideWidget,
      minHeight: 150.0,
      body: new Stack(
        children: <Widget>[
          _cameraWidget,
          Padding(
            padding: const EdgeInsets.all(23.0),
            child: Align(
              alignment: Alignment.topRight,
              child: new SizedBox(
                width: 40.0,
                height: 40.0,
                child: FloatingActionButton(
                  child: Icon(
                    _iconFlash,
                    size: 20.0,
                  ),
                  backgroundColor: Colors.grey,
                  onPressed: () {
                    if (controller != null) {
                      controller.toggleFlash();
                      if (_isFlashOn(flashState)) {
                        setState(() {
                          flashState = flash_off;
                          _iconFlash = Icons.flash_on;
                        });
                      } else {
                        setState(() {
                          flashState = flash_on;
                          _iconFlash = Icons.flash_off;
                        });
                      }
                    }
                  },
                ),
              ),
            ),
          )
        ],
      ),
    );

    return _compileWidget;
  }

  _isFlashOn(String current) {
    return flash_on == current;
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        qrText = scanData;
        if (scanData.isNotEmpty) {
          splitCode = scanData.split('-');
          _checkScanning();
          controller.pauseCamera();
        }
      });
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
