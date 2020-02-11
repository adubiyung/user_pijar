import 'dart:async';
import 'dart:collection';
import 'dart:convert';
import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:user_pijar/services/api.dart';
import 'package:user_pijar/views/widget/color_library.dart';
import 'package:user_pijar/views/widget/session_manager.dart';
import 'package:http/http.dart' as http;

class DialogPaymentQR extends StatefulWidget {
  final String methodCode;
  final String userID;
  final String transCode;
  final int transID;

  const DialogPaymentQR(
      this.methodCode, this.userID, this.transCode, this.transID);

  @override
  _DialogPaymentQRState createState() => _DialogPaymentQRState();
}

class _DialogPaymentQRState extends State<DialogPaymentQR>
    with SingleTickerProviderStateMixin {
  Timer _timer;
  int _start = 120;
  bool _hideResendButton;
  bool _hideErrorLabel = true;
  final int time = 120;
  var loading = false;

  void startTimer() {
    const oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(
      oneSec,
      (Timer timer) => setState(
        () {
          if (_start < 1) {
            timer.cancel();
          } else {
            _start = _start - 1;
          }
        },
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  Future<Null> _updateStatus() async {
    SharedPreferences _pref = await SharedPreferences.getInstance();
    SessionManager _session = new SessionManager(_pref);
    HashMap<String, String> userData = _session.getUserSession();
    String token = userData['USER_TOKEN'];
    String url = BaseUrl.STATUSQR;
    var client = new http.Client();
    String _body =
        '{"method": "turnOFF", "transaction_id":"${widget.transID}"}';

    setState(() {
      loading = true;
    });

    final response = await client.post(url,
        headers: {HttpHeaders.authorizationHeader: token}, body: _body);

    if (response.statusCode == 200) {
      print("response turnOFF" + response.body);
      setState(() {
        loading = false;
      });
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
                "Time Out ..",
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
                "Please generate new QR Code",
                style: TextStyle(fontFamily: 'Work Sans'),
              ),
            ),
          ],
        ),
      ),
      btnOkText: "OK",
      btnOkOnPress: () {
        Navigator.pop(context);
      },
      dismissOnTouchOutside: false,
    ).show();
  }

  @override
  Widget build(BuildContext context) {
    int nol = 0;
    String nolUser = '';
    String nolTrans = '';

    for (var i = widget.userID.length; i < 7; i++) {
      nolUser += nol.toString();
    }

    for (var i = widget.transCode.length; i < 7; i++) {
      nolTrans += nol.toString();
    }

    Widget _getTimerText = new Container(
      height: 32,
      child: new Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          new Icon(Icons.access_time),
          new SizedBox(
            width: 5.0,
          ),
          new Text(
            "$_start",
            style: TextStyle(fontFamily: 'Work Sans'),
          ),
        ],
      ),
    );

    Widget _qrcode = new Container(
      width: 230.0,
      height: 230.0,
      child: Padding(
        padding: EdgeInsets.all(10.0),
        child: QrImage(
          data:
              "${widget.methodCode}${nolUser + widget.userID}${nolTrans + widget.transCode}",
          version: QrVersions.auto,
        ),
      ),
    );

    return Container(
      padding: EdgeInsets.all(10.0),
      child: new Column(
        children: <Widget>[
          _qrcode,
          _getTimerText,
          SizedBox(
            height: 30.0,
          ),
          Text(
            (widget.methodCode == '2')
                ? "Your Check-In Ticket"
                : "Your Check-Out Ticket",
            style:
                TextStyle(fontFamily: 'Work Sans', fontWeight: FontWeight.w500),
          ),
          SizedBox(height: 10.0),
          Text(
            (widget.methodCode == '2')
                ? "Show this code to the Warden to make payment and check in"
                : "Show this code to the Warden to make payment and check out",
            style: TextStyle(fontFamily: 'Work Sans', fontSize: 10),
          )
        ],
      ),
    );
  }
}
