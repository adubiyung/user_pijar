import 'dart:collection';
import 'dart:convert';
import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_money_formatter/flutter_money_formatter.dart';
import 'package:user_pijar/models/Location.dart';
import 'package:user_pijar/services/api.dart';
import 'package:user_pijar/views/pages/topup_page.dart';
import 'package:user_pijar/views/pages/voucher_page.dart';
import 'package:user_pijar/views/widget/color_library.dart';
import 'package:user_pijar/views/widget/dialog_select_vehicle.dart';
import 'package:user_pijar/views/widget/pop_result.dart';
import 'package:user_pijar/views/widget/session_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

class BookingPage extends StatefulWidget {
  static final String pageName = "booking";
  final Location model;

  const BookingPage({Key key, this.model}) : super(key: key);

  @override
  _BookingPageState createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  String textLot = "data";
  Duration initialtimer = new Duration();
  static DateFormat _dateFormat = DateFormat("dd-MM-yyyy");
  static DateFormat _serverFormat = DateFormat("yyyy-MM-dd hh:mm:ss");
  String dateSelect = _dateFormat.format(new DateTime.now());
  String dateServer = _serverFormat.format(new DateTime.now());
  String timeSelect = "How Many Hour?";
  String dura = '';
  int duration;
  int billing = 0;
  int finalBilling = 0;
  SessionManager _session;
  HashMap<String, String> userData;
  var loading = false;
  List<LocationFeature> _listFeature = [];
  int millis = new DateTime.now().millisecondsSinceEpoch;
  //
  String _selectedBrandModel = "";
  String _selectedLicense = "";
  String _selectedLot = "";
  String _selectedVehicleID = "";
  String _selectedVehicleType = "";
  String _voucherID = "1";
  String _voucherName = "";
  String _voucherPercent = "";
  String _voucherNominal = "";
  double voucherTemp = 0;
  int startPrice = 0;
  int nextPrice = 0;
  int featureID;
  int lotMobil = 0;
  int lotMotor = 0;
  //
  String detailID = '';
  String detailName = '';
  String lotID = '';

  Future<Null> _fetchData() async {
    final _prefs = await SharedPreferences.getInstance();
    _session = new SessionManager(_prefs);
    userData = _session.getUserSession();
    String token = userData['USER_TOKEN'];
    String url = BaseUrl.FEATURE;
    // String clause = '?location_id=${widget.model.locationID}&feature_type_id=2';
    String clause = '?location_id=2&feature_type_id=2';

    if (mounted) {
      setState(() {
        loading = true;
      });
    }

    final response = await http
        .get('$url$clause', headers: {HttpHeaders.authorizationHeader: token});
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      print(data);
      if (mounted) {
        setState(() {
          for (Map i in data['data']) {
            _listFeature.add(LocationFeature.fromJson(i));
          }
          loading = false;
          if (_listFeature.length != 0) {
            featureID = _listFeature[0].featureID;
            startPrice = _listFeature[0].startPrice;
            nextPrice = _listFeature[0].nextPrice;
          }
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
    FlutterMoneyFormatter fmf = FlutterMoneyFormatter(amount: 12345678.9012345);
    MoneyFormatterOutput fo = fmf.output;

    Widget _locationWidget = new Card(
      child: new Padding(
        padding: EdgeInsets.all(5.0),
        child: new Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text(
              widget.model.locationName,
              style: TextStyle(
                  fontSize: 23,
                  fontFamily: 'Work Sans',
                  fontWeight: FontWeight.w500),
            ),
            Container(
              height: 5.0,
            ),
            Text(
              widget.model.locationAddress +
                  ", " +
                  widget.model.locationDistrict +
                  ", " +
                  widget.model.locationProvince,
              style: TextStyle(
                  fontSize: 14,
                  fontFamily: 'Work Sans',
                  fontWeight: FontWeight.w300),
            ),
            Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Card(
                      child: Column(
                        children: <Widget>[
                          Icon(
                            Icons.drive_eta,
                            size: 40,
                          ),
                          Text(
                            "${widget.model.lotCar} lot",
                            style: TextStyle(fontFamily: 'Work Sans'),
                          )
                        ],
                      ),
                    ),
                    Card(
                      child: Column(
                        children: <Widget>[
                          Icon(
                            Icons.motorcycle,
                            size: 40,
                          ),
                          Text(
                            "${widget.model.lotMotor} lot",
                            style: TextStyle(fontFamily: 'Work Sans'),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );

    Widget _chooseVehicleWidget = new ListTile(
      leading: Container(
        height: 25.0,
        padding: EdgeInsets.only(right: 12.0),
        decoration: BoxDecoration(
          border: Border(
            right: BorderSide(width: 1.0, color: Colors.grey),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              Icons.event_seat,
              color: Colors.grey,
            ),
          ],
        ),
      ),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            (_selectedVehicleID.isEmpty) ? "select vehicle" : _selectedLicense,
            style:
                TextStyle(fontFamily: 'Work Sans', fontWeight: FontWeight.w500),
          ),
          SizedBox(
            height: 3.0,
          ),
          Text(
            (_selectedVehicleID.isEmpty) ? "" : "\t\t$_selectedBrandModel",
            style: TextStyle(fontFamily: 'Work Sans', fontSize: 11),
          ),
        ],
      ),
      trailing: Padding(
        padding: EdgeInsets.only(right: 12.0),
        child: Icon(Icons.arrow_forward_ios),
      ),
      onTap: () {
        _displayDialogVehicle(context);
      },
    );

    Widget _chooseLotWidget = new ListTile(
      leading: Container(
        height: 25.0,
        padding: EdgeInsets.only(right: 12.0),
        decoration: BoxDecoration(
          border: Border(
            right: BorderSide(width: 1.0, color: Colors.grey),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              Icons.compare_arrows,
              color: Colors.grey,
            ),
          ],
        ),
      ),
      title: Text(
        (_selectedLot.isEmpty) ? "select lot" : _selectedLot,
        style: TextStyle(fontFamily: 'Work Sans'),
      ),
      trailing: Padding(
        padding: EdgeInsets.only(right: 12.0),
        child: Icon(Icons.arrow_forward_ios),
      ),
      onTap: () {
        _moveToDetailLoc(context);
      },
    );

    Widget _chooseStartWidget = new ListTile(
      leading: Container(
        height: 25.0,
        padding: EdgeInsets.only(right: 12.0),
        decoration: BoxDecoration(
          border: Border(
            right: BorderSide(width: 1.0, color: Colors.grey),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              Icons.access_time,
              color: Colors.grey,
            ),
          ],
        ),
      ),
      title: Text(
        dateSelect,
        style: TextStyle(fontFamily: 'Work Sans'),
      ),
      trailing: Padding(
        padding: EdgeInsets.only(right: 12.0),
        child: Icon(Icons.arrow_forward_ios),
      ),
    );

    Widget _chooseDurationWidget = new ListTile(
        leading: Container(
          height: 25.0,
          padding: EdgeInsets.only(right: 12.0),
          decoration: BoxDecoration(
            border: Border(
              right: BorderSide(width: 1.0, color: Colors.grey),
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(
                Icons.timelapse,
                color: Colors.grey,
              ),
            ],
          ),
        ),
        title: Text(timeSelect),
        trailing: Padding(
          padding: EdgeInsets.only(right: 12.0),
          child: Icon(Icons.arrow_forward_ios),
        ),
        onTap: () {
          showModalBottomSheet(
            context: context,
            builder: (BuildContext builder) {
              return Container(
                height: MediaQuery.of(context).copyWith().size.height / 3,
                child: CupertinoTimerPicker(
                  mode: CupertinoTimerPickerMode.hm,
                  minuteInterval: 1,
                  secondInterval: 1,
                  initialTimerDuration: initialtimer,
                  onTimerDurationChanged: (Duration changedtimer) {
                    setState(() {
                      initialtimer = changedtimer;
                      String hasil = "$initialtimer".substring(0, 4);
                      if (hasil == "0:00") {
                        duration = 0;
                        timeSelect = "How Many Hours?";
                      } else {
                        timeSelect = hasil;
                        int lamaJam = int.parse(hasil.substring(0, 1));
                        int hour = int.parse(hasil.substring(0, 1)) * 60;
                        int min = int.parse(hasil.substring(2, 4));
                        duration = hour + min;
                        int nextJam = lamaJam - 1;

                        if (min > 5) {
                          setState(() {
                            billing = (1 * startPrice) +
                                (nextJam * nextPrice) +
                                nextPrice;
                            finalBilling = billing;
                          });
                        } else {
                          setState(() {
                            billing = (1 * startPrice) + (nextJam * nextPrice);
                            finalBilling = billing;
                          });
                        }
                      }
                    });
                  },
                ),
              );
            },
          );
        });

    Widget _firstColumnWidget = new Card(
      // margin: EdgeInsets.only(right: 10.0, left: 10.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          _chooseVehicleWidget,
          Divider(
            color: Colors.grey,
            height: 2.0,
          ),
          _chooseLotWidget
        ],
      ),
    );

    Widget _secondColumnWidget = new Card(
      // margin: EdgeInsets.only(right: 10.0, left: 10.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          _chooseStartWidget,
          Divider(
            color: Colors.grey,
            height: 2.0,
          ),
          _chooseDurationWidget
        ],
      ),
    );

    Widget _thirdColumnWidget = new Card(
      // margin: EdgeInsets.only(right: 10.0, left: 10.0),
      child: Container(
        height: 70.0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            GestureDetector(
              child: new Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  new Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Icon(
                        Icons.monetization_on,
                        size: 15,
                      ),
                      Container(
                        width: 3.0,
                      ),
                      Text(
                        "LinkAJa",
                        style: TextStyle(fontFamily: 'Work Sans'),
                      )
                    ],
                  ),
                  new Container(
                    height: 7.0,
                  ),
                  new Text(
                    "Rp 300.000",
                    style: TextStyle(fontFamily: 'Work Sans'),
                  ),
                ],
              ),
              onTap: () {
                _moveToTopup();
              },
            ),
            Container(
              height: 25.0,
              padding: EdgeInsets.only(right: 12.0),
              decoration: BoxDecoration(
                border: Border(
                  right: BorderSide(width: 1.0, color: Colors.grey),
                ),
              ),
            ),
            GestureDetector(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Icon(
                        Icons.local_play,
                        size: 15,
                      ),
                      Container(
                        width: 3.0,
                      ),
                      Text(
                        "Voucher",
                        style: TextStyle(fontFamily: 'Work Sans'),
                      ),
                    ],
                  ),
                  Container(
                    height: 7.0,
                  ),
                  Text(
                    (_voucherName.isEmpty) ? "Select Voucher" : _voucherName,
                    style: TextStyle(fontFamily: 'Work Sans'),
                  ),
                ],
              ),
              onTap: () {
                _displayDialogVoucher(context);
              },
            ),
          ],
        ),
      ),
    );

    Widget _billingWidget = new Card(
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  'Parking Fare',
                  style: TextStyle(fontFamily: 'Work Sans', fontSize: 11),
                ),
                Text(
                  fmf
                      .copyWith(
                        amount: billing.toDouble(),
                        symbol: 'Rp',
                        thousandSeparator: '.',
                        decimalSeparator: ',',
                        fractionDigits: 0,
                      )
                      .output
                      .symbolOnLeft,
                  style: TextStyle(fontFamily: 'Work Sans', fontSize: 11),
                ),
              ],
            ),
            SizedBox(
              height: 8,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  'Voucher Discount',
                  style: TextStyle(fontFamily: 'Work Sans', fontSize: 11),
                ),
                Text(
                  fmf
                      .copyWith(
                        amount: voucherTemp,
                        symbol: '-Rp',
                        thousandSeparator: '.',
                        decimalSeparator: ',',
                        fractionDigits: 0,
                      )
                      .output
                      .symbolOnLeft,
                  style: TextStyle(fontFamily: 'Work Sans', fontSize: 11),
                ),
              ],
            ),
            SizedBox(
              height: 8,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  'Total',
                  style: TextStyle(fontFamily: 'Work Sans', fontSize: 14),
                ),
                Text(
                  fmf
                      .copyWith(
                        amount: finalBilling.toDouble(),
                        symbol: 'Rp',
                        thousandSeparator: '.',
                        decimalSeparator: ',',
                        fractionDigits: 0,
                      )
                      .output
                      .symbolOnLeft,
                  style: TextStyle(fontFamily: 'Work Sans', fontSize: 14),
                ),
              ],
            ),
          ],
        ),
      ),
    );

    Widget _buttonWidget = new Align(
      alignment: Alignment.bottomCenter,
      child: Column(
        children: <Widget>[
          ButtonTheme(
            buttonColor: ColorLibrary.secondary,
            minWidth: double.infinity,
            height: 50.0,
            child: RaisedButton(
              child: Text(
                "booking",
                style: TextStyle(
                    fontFamily: 'Work Sans', color: ColorLibrary.thinFontBlack),
              ),
              onPressed: () {
                _sendData();
              },
            ),
          ),
        ],
      ),
    );

    Widget _compileBottomWidget = new Center(
      child: new SingleChildScrollView(
        child: new Container(
          // margin: EdgeInsets.only(top: 50.0),
          color: ColorLibrary.backgroundDark,
          child: new Column(
            children: <Widget>[
              SizedBox(
                height: 10.0,
              ),
              _locationWidget,
              _firstColumnWidget,
              _secondColumnWidget,
              _thirdColumnWidget,
              _billingWidget,
            ],
          ),
        ),
      ),
    );

    return new NestedScrollView(
      headerSliverBuilder: (BuildContext context, bool isScrolled) {
        return <Widget>[
          SliverAppBar(
            expandedHeight: 200.0,
            floating: false,
            pinned: true,
            backgroundColor: ColorLibrary.primary,
            flexibleSpace: FlexibleSpaceBar(
              centerTitle: false,
              title: Text(
                widget.model.locationName,
                style: TextStyle(fontFamily: 'Work Sans', fontSize: 20),
              ),
              // background: Image.network(
              //   "",
              //   fit: BoxFit.cover,
              // ),
            ),
          ),
        ];
      },
      body: new Container(
        color: ColorLibrary.backgroundDark,
        child: Column(
          children: <Widget>[
            Expanded(
              child: _compileBottomWidget,
            ),
            _buttonWidget,
          ],
        ),
      ),
    );
  }

  Future<Null> _sendData() async {
    final _prefs = await SharedPreferences.getInstance();
    _session = new SessionManager(_prefs);
    userData = _session.getUserSession();
    String token = userData['USER_TOKEN'];
    String userID = userData['USER_ID'];
    String url = BaseUrl.TRANSACTION;
    var client = new http.Client();
    String paymentId = '2';
    String featureTypeId = '2';

    var time = new DateTime.now().add(new Duration(minutes: duration));
    String endTime = _serverFormat.format(time);

    String tcode = '$_selectedVehicleID${widget.model.locationID}$millis';
    String body = '''{
      "method": "booking", "transaction_code": "$tcode", "user_id": "$userID", "vehicle_id": "$_selectedVehicleID",
      "vehicle_type_id": "$_selectedVehicleType", "feature_id": "$featureID", "feature_type_id": "$featureTypeId", "location_id": "${widget.model.locationID}",
      "payment_type_id": "$paymentId", "voucher_id": "$_voucherID", "start_price": "$startPrice", "next_price": "$nextPrice",
      "start_time": "$dateServer", "end_time": "$endTime", "total_duration": "$duration", "parking_billing": "$billing",
      "voucher_nominal": "${voucherTemp.round()}", "total_billing": "$finalBilling", "detail_lot_id": "$lotID"
    }''';

    setState(() {
      loading = true;
    });

    final response = await client.post(url,
        headers: {HttpHeaders.authorizationHeader: token}, body: body);
    if (response.statusCode == 200) {
      var jsonObject = json.decode(response.body);

      int status = jsonObject['status'];
      if (status == 200) {
        Fluttertoast.showToast(
          msg: "Booking Success",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
        );
      } else {
        _dialogInfo();
      }
    }
  }

  void _dialogInfo() {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.ERROR,
      animType: AnimType.SCALE,
      body: new Container(
        child: Column(
          children: <Widget>[
            new Center(
              child: new Text(
                "Oops ..",
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
                "Lot is not available",
                style: TextStyle(fontFamily: 'Work Sans'),
              ),
            ),
          ],
        ),
      ),
      btnOkText: "OK",
      btnOkOnPress: () {},
      dismissOnTouchOutside: false,
    ).show();
  }

  void _moveToDetailLoc(BuildContext context) async {
    await Navigator.of(context).pushNamed('/detailLoc', arguments: {
      'locID': widget.model.locationID.toString()
    }).then((results) {
      PopWithResults popResult = results as PopWithResults;
      if (popResult != null) {
        if (popResult.toPage == 'booking') {
          setState(() {
            lotID = popResult.results.values.toList()[0];
            detailID = popResult.results.values.toList()[1];
            detailName = popResult.results.values.toList()[2];
          });
          _selectedLot = detailName + ' - ' + lotID;
        } else {
          Navigator.of(context).pop(results);
        }
      }
    });
  }

  _displayDialogVehicle(BuildContext context) async {
    // Navigator.push returns a Future that completes after calling
    // Navigator.pop on the Dialog Screen.
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => new DialogSelectVehicle(
                fromPage: 1,
              ),
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

  _displayDialogVoucher(BuildContext context) async {
    // Navigator.push returns a Future that completes after calling
    // Navigator.pop on the Dialog Screen.
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => new VoucherPage(
                locationID: widget.model.locationID.toString(),
              ),
          fullscreenDialog: true),
    );

    // After the Dialog Screen returns a result
    // and show the new result.
    if (result != null) {
      var hasil = result.split(",");
      voucherTemp = billing * (int.parse(hasil[1]) / 100);
      if (voucherTemp < int.parse(hasil[2])) {
        setState(() {
          finalBilling = billing - voucherTemp.round();
        });
      } else {
        setState(() {
          finalBilling = billing - int.parse(hasil[2]);
          voucherTemp = double.parse(hasil[2]);
        });
      }
      if (mounted) {
        setState(() {
          _voucherID = hasil[0];
          _voucherPercent = hasil[1];
          _voucherNominal = hasil[2];
          _voucherName = hasil[3];
        });
      }
    }
  }

  void _moveToTopup() {
    Navigator.of(context).push(PageRouteBuilder(
      maintainState: true,
      opaque: true,
      pageBuilder: (context, _, __) => new TopupPage(),
    ));
  }
}
