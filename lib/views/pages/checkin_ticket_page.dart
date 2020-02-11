import 'dart:collection';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_money_formatter/flutter_money_formatter.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:user_pijar/models/getTransaction.dart';
import 'package:user_pijar/services/api.dart';
import 'package:user_pijar/views/pages/voucher_page.dart';
import 'package:user_pijar/views/widget/color_library.dart';
import 'package:user_pijar/views/widget/dialog_payment_qr.dart';
import 'package:user_pijar/views/widget/session_manager.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:http/http.dart' as http;

class CheckinTicketPage extends StatefulWidget {
  final DataTransaction modelTrans;

  const CheckinTicketPage({Key key, this.modelTrans}) : super(key: key);
  @override
  _CheckinTicketPageState createState() => _CheckinTicketPageState();
}

class _CheckinTicketPageState extends State<CheckinTicketPage> {
  SessionManager _session;
  HashMap<String, String> userData;

  String userID;
  String checkout = '';
  String duration = '';
  int fare = 0;
  int billing = 0;
  String _voucherID = "";
  String _voucherName = "";
  String _voucherPercent = "";
  String _voucherNominal = "";
  double voucherTemp = 0;
  var dateout;
  String datetimeOut = '9999-12-31T00:00:00';
  var loading = false;

  void _showModalQR(context) {
    String transCode = widget.modelTrans.transactionCode;
    int transID = widget.modelTrans.transactionID;
    String methodCode = "2";

    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return DialogPaymentQR(methodCode, userID, transCode, transID);
        });
  }

  Future<Null> _updateStatus() async {
    SharedPreferences _pref = await SharedPreferences.getInstance();
    SessionManager _session = new SessionManager(_pref);
    HashMap<String, String> userData = _session.getUserSession();
    String token = userData['USER_TOKEN'];
    String url = BaseUrl.STATUSQR;
    var client = new http.Client();
    print(url);
    String _body =
        '{"method": "turnON", "transaction_id":"${widget.modelTrans.transactionID}"}';
    print(_body);

    setState(() {
      loading = true;
    });

    final response = await client.post(url,
        headers: {HttpHeaders.authorizationHeader: token}, body: _body);
    print(response.statusCode);
    if (response.statusCode == 200) {
      final jsonObject = jsonDecode(response.body);
      if (jsonObject['status'] == 200) {
        _showModalQR(context);
      } else {
        Fluttertoast.showToast(
            msg: "Opss.. Something wrong",
            gravity: ToastGravity.BOTTOM,
            toastLength: Toast.LENGTH_SHORT);
      }
      setState(() {
        loading = false;
      });
    }
  }

  Future<Null> _fetchData() async {
    String url = BaseUrl.GETTIME;
    final _prefs = await SharedPreferences.getInstance();
    _session = new SessionManager(_prefs);
    userData = _session.getUserSession();
    userID = userData['USER_ID'];
    String token = userData['USER_TOKEN'];

    if (mounted) {
      setState(() {
        loading = true;
      });
    }

    final response = await http
        .get("$url", headers: {HttpHeaders.authorizationHeader: token});

    if (response.statusCode == 200) {
      final jsonObject = jsonDecode(response.body);

      setState(() {
        loading = false;

        DateTime keluarDate = DateTime.parse(datetimeOut);
        DateTime masukDate = DateTime.parse(widget.modelTrans.startTime);
        String timeServer = jsonObject['data'];
        DateTime waktuServer = DateTime.parse(timeServer);

        datetimeOut = widget.modelTrans.endTime;

        int inMinutes = widget.modelTrans.totalDuration;
        String convertJam = (inMinutes / 60).toString();
        String jam = convertJam.split('.')[0];
        String menit = (inMinutes % (60)).toString();
        duration = '${jam}h ${menit}m';
        var min = int.parse(menit);
        if (min > 5) {
          setState(() {
            fare = widget.modelTrans.parkingBilling;
            billing = fare;
          });
        } else {
          setState(() {
            fare = widget.modelTrans.parkingBilling;
            billing = fare;
          });
        }
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
    FlutterMoneyFormatter fmf = FlutterMoneyFormatter(amount: 12345678.9012345);
    MoneyFormatterOutput fo = fmf.output;

    Widget _locationContent = new Container(
      width: MediaQuery.of(context).size.width,
      color: Colors.white,
      padding: EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            widget.modelTrans.location.locationName,
            style: TextStyle(fontFamily: 'Work Sans', fontSize: 18),
          ),
          Text(
            widget.modelTrans.location.locationAddress,
            style: TextStyle(fontFamily: 'Work Sans', fontSize: 12),
          ),
          Text(
            widget.modelTrans.location.locationCity,
            style: TextStyle(fontFamily: 'Work Sans', fontSize: 12),
          ),
        ],
      ),
    );

    List<String> splitIn = [];
    var datein = widget.modelTrans.startTime;

    splitIn = datein.split("T");
    String tglin = splitIn[0];
    String combineIn = splitIn[0] + " " + splitIn[1];
    var parseCombineIn = DateFormat("yyyy-MM-dd hh:mm:ss").parse(combineIn);
    var parseDateIn = DateFormat("yyyy-MM-dd").parse(tglin);
    final formatDateIn = DateFormat("EEE, MMM d").format(parseDateIn);

    String waktuIn = splitIn[1];
    var parseTimeIn = DateFormat("hh:mm:ss").parse(waktuIn);
    var formatTimeIn = DateFormat("hh:mm a").format(parseTimeIn);

    List<String> splitOut = [];
    splitOut = datetimeOut.split("T");
    String tglOut = splitOut[0];
    String combineOut = splitOut[0] + " " + splitOut[1];
    var parseCombineOut = DateFormat("yyyy-MM-dd H:m:s").parse(combineOut);
    var parseDateOut = DateFormat("yyyy-MM-dd").parse(tglOut);
    final formatDateOut = DateFormat("EEE, MMM d").format(parseDateOut);

    String waktuOut = splitOut[1];
    var parseTimeOut = DateFormat("h:m:s").parse(waktuOut);
    var formatTimeOut = DateFormat("hh:mm a").format(parseTimeOut);

    Widget _durationContent = new Container(
      width: MediaQuery.of(context).size.width,
      color: Colors.white,
      padding: EdgeInsets.all(20.0),
      child: new Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          new Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Text(
                formatDateIn.toString(),
                style: TextStyle(fontFamily: 'Work Sans', fontSize: 10),
              ),
              Text(
                formatTimeIn.toString(),
                style: TextStyle(fontFamily: 'Work Sans', fontSize: 15),
              ),
            ],
          ),
          new Center(
            child: Container(
              height: 25.0,
              width: 90.0,
              decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(14.0),
                color: ColorLibrary.background,
                border: Border.all(color: ColorLibrary.backgroundDark),
              ),
              child: Center(
                child: Text(
                  "$duration",
                  style: TextStyle(
                      fontFamily: 'Work Sans',
                      fontSize: 12,
                      fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ),
          new Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Text(
                formatDateOut.toString(),
                style: TextStyle(fontFamily: 'Work Sans', fontSize: 10),
              ),
              Text(
                formatTimeOut.toString(),
                style: TextStyle(fontFamily: 'Work Sans', fontSize: 15),
              ),
            ],
          ),
        ],
      ),
    );

    _navigateVoucherPage(BuildContext context) async {
      final result = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => new VoucherPage(),
          fullscreenDialog: true,
        ),
      );

      if (result != null) {
        var hasil = result.split(",");
        voucherTemp = billing * (int.parse(hasil[1]) / 100);
        if (voucherTemp < int.parse(hasil[2])) {
          setState(() {
            billing = fare - voucherTemp.round();
            //
          });
        } else {
          setState(() {
            billing = fare - int.parse(hasil[2]);
            voucherTemp = double.parse(hasil[2]);
            //
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

    Widget _voucherContent = new Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
      color: Colors.white,
      child: ListTile(
        leading: Icon(
          Icons.local_play,
          color: ColorLibrary.primary,
        ),
        title: Text(
          (_voucherName.isEmpty) ? " - " : _voucherName,
          style:
              TextStyle(fontFamily: 'Work Sans', color: ColorLibrary.primary),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              fmf
                  .copyWith(
                      amount: widget.modelTrans.voucherNominal.toDouble(),
                      symbol: 'Rp',
                      thousandSeparator: '.',
                      decimalSeparator: ',',
                      fractionDigits: 0)
                  .output
                  .symbolOnLeft,
              style: TextStyle(
                  fontFamily: 'Work Sans', color: ColorLibrary.primary),
            ),
          ],
        ),
      ),
    );

    Widget _paymentTypeContent = new Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
      color: Colors.white,
      child: ListTile(
          leading: Icon(
            Icons.account_balance_wallet,
            color: ColorLibrary.primary,
          ),
          title: Text(
            "Link Aja",
            style:
                TextStyle(fontFamily: 'Work Sans', color: ColorLibrary.primary),
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                fmf
                    .copyWith(
                        amount: billing.toDouble(),
                        symbol: 'Rp',
                        thousandSeparator: '.',
                        decimalSeparator: ',',
                        fractionDigits: 0)
                    .output
                    .symbolOnLeft,
                style: TextStyle(
                    fontFamily: 'Work Sans', color: ColorLibrary.primary),
              ),
            ],
          )),
    );

    Widget _paymentDetailContent = new Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.all(20.0),
      color: Colors.white,
      child: Column(
        children: <Widget>[
          Align(
            alignment: Alignment.topLeft,
            child: Text(
              "Detail Payment",
              style: TextStyle(fontFamily: 'Work Sans', fontSize: 10),
            ),
          ),
          SizedBox(
            height: 5.0,
          ),
          Row(
            children: <Widget>[
              SizedBox(
                width: 13.0,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Parking Fare',
                      style: TextStyle(
                        fontFamily: 'Work Sans',
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      height: 5.0,
                    ),
                    Text(
                      'Voucher Discount',
                      style: TextStyle(
                        fontFamily: 'Work Sans',
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      height: 5.0,
                    ),
                    Text(
                      'Total',
                      style: TextStyle(
                        fontFamily: 'Work Sans',
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      height: 5.0,
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    Text(
                      fmf
                          .copyWith(
                              amount: fare.toDouble(),
                              symbol: 'Rp',
                              thousandSeparator: '.',
                              decimalSeparator: ',',
                              fractionDigits: 0)
                          .output
                          .symbolOnLeft,
                      style: TextStyle(
                        fontFamily: 'Work Sans',
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Container(
                      height: 5.0,
                    ),
                    Text(
                      fmf
                          .copyWith(
                              amount: voucherTemp.toDouble(),
                              symbol: '-Rp',
                              thousandSeparator: '.',
                              decimalSeparator: ',',
                              fractionDigits: 0)
                          .output
                          .symbolOnLeft,
                      style: TextStyle(
                        fontFamily: 'Work Sans',
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Container(
                      height: 5.0,
                    ),
                    Text(
                      fmf
                          .copyWith(
                              amount: billing.toDouble(),
                              symbol: 'Rp',
                              thousandSeparator: '.',
                              decimalSeparator: ',',
                              fractionDigits: 0)
                          .output
                          .symbolOnLeft,
                      style: TextStyle(
                        fontFamily: 'Work Sans',
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Container(
                      height: 5.0,
                    ),
                  ],
                ),
              ),
              Container(
                width: 15.0,
              )
            ],
          ),
        ],
      ),
    );

    Widget _checkInContent = new Container(
      color: Colors.white,
      child: Padding(
        padding: EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            new Text(
              fmf
                  .copyWith(
                      amount: billing.toDouble(),
                      symbol: 'Rp',
                      thousandSeparator: '.',
                      decimalSeparator: ',',
                      fractionDigits: 0)
                  .output
                  .symbolOnLeft,
              style: TextStyle(fontFamily: 'Work Sans'),
            ),
            new SizedBox(
              height: 15.0,
            ),
            new Center(
              child: ButtonTheme(
                minWidth: MediaQuery.of(context).size.width / 2,
                child: RaisedButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadiusDirectional.circular(18.0),
                    side: BorderSide(color: ColorLibrary.secondary),
                  ),
                  color: ColorLibrary.secondary,
                  child: Text(
                    "Check in",
                    style: TextStyle(fontFamily: 'Work Sans'),
                  ),
                  onPressed: () {
                    _updateStatus();
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );

    Widget _titleContent = new Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        Text(
          "Detail Ticket",
          style: TextStyle(
              fontFamily: 'Work Sans',
              fontWeight: FontWeight.w600,
              fontSize: 24,
              color: ColorLibrary.thinFontWhite),
        ),
        Text(
          "Ticket NO. ${widget.modelTrans.transactionCode}",
          style: TextStyle(
              fontFamily: 'Work Sans',
              fontWeight: FontWeight.w300,
              fontSize: 16,
              color: ColorLibrary.thinFontWhite),
        ),
      ],
    );

    Widget _circularProgress() {
      return CircularProgressIndicator(
        backgroundColor: ColorLibrary.primary,
        valueColor: AlwaysStoppedAnimation<Color>(ColorLibrary.secondary),
        strokeWidth: 2.0,
      );
    }

    return new Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(70.0),
        child: AppBar(
          title: _titleContent,
          backgroundColor: ColorLibrary.primary,
        ),
      ),
      body: loading
          ? Center(
              child: _circularProgress(),
            )
          : SingleChildScrollView(
              child: new Container(
                color: ColorLibrary.thinFontWhite,
                height: MediaQuery.of(context).size.height,
                child: new Column(
                  children: <Widget>[
                    _locationContent,
                    SizedBox(
                      height: 3.0,
                    ),
                    _durationContent,
                    SizedBox(
                      height: 3.0,
                    ),
                    _voucherContent,
                    SizedBox(
                      height: 3.0,
                    ),
                    _paymentTypeContent,
                    SizedBox(
                      height: 3.0,
                    ),
                    _paymentDetailContent,
                    SizedBox(
                      height: 3.0,
                    ),
                  ],
                ),
              ),
            ),
      bottomSheet: Container(
        child: _checkInContent,
        height: MediaQuery.of(context).size.height / 5,
        decoration: BoxDecoration(boxShadow: [
          BoxShadow(
            color: Colors.black45,
            spreadRadius: 3.0,
            blurRadius: 2.0,
          ),
        ]),
      ),
    );
  }
}
