import 'dart:collection';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
// import 'package:flutter_money_formatter/flutter_money_formatter.dart';
import 'package:user_pijar/services/api.dart';
import 'package:user_pijar/views/pages/edit_account_page.dart';
import 'package:user_pijar/views/pages/garage_page.dart';
import 'package:user_pijar/views/pages/topup_page.dart';
import 'package:user_pijar/views/pages/webview_page.dart';
import 'package:user_pijar/views/widget/color_library.dart';
import 'package:user_pijar/views/widget/session_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:launch_review/launch_review.dart';

class AccountPage extends StatefulWidget {
  @override
  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  static const String URL = BaseUrl.USER_ACCOUNT + "?user_id=";
  SessionManager _session;
  HashMap<String, String> userData;
  var loading = false;

  String userID;
  String roleID;
  String userName;
  String userEmail;
  String userPhone;
  int userBalance;
  String userPoint;
  String userToken;
  // FlutterMoneyFormatter fmf;
  // MoneyFormatterOutput fo;

  getUserData() async {
    final _prefs = await SharedPreferences.getInstance();
    _session = new SessionManager(_prefs);
    userData = _session.getUserSession();
    userID = userData['USER_ID'];
    roleID = userData['ROLE_ID'];
    userName = userData['USER_FULLNAME'];
    userEmail = userData['USER_EMAIL'];
    userPhone = userData['USER_PHONE'];
    userToken = userData['USER_TOKEN'];

    if (mounted) {
      setState(() {
        loading = true;
      });
    }

    var client = new http.Client();
    try {
      final response = await http.get(URL + userID,
          headers: {HttpHeaders.authorizationHeader: userToken});
      if (response.statusCode == 200) {
        final jsonObject = jsonDecode(response.body);
        var dataList = (jsonObject as Map<String, dynamic>)['data'];
        if (mounted) {
          setState(() {
            userBalance = dataList[0]["user_balance"];
            // fmf = FlutterMoneyFormatter(
            //   amount: (userBalance == null) ? 0.0 : userBalance.toDouble(),
            //   settings: MoneyFormatterSettings(
            //       symbol: 'Rp',
            //       thousandSeparator: '.',
            //       decimalSeparator: ',',
            //       symbolAndNumberSeparator: ' ',
            //       fractionDigits: 0,
            //       compactFormatType: CompactFormatType.long),
            // );
            // fo = fmf.output;
            loading = false;
          });
        }
      }
    } finally {
      client.close();
    }
  }

  @override
  void initState() {
    super.initState();
    getUserData();
  }

  @override
  Widget build(BuildContext context) {
    Widget _topContent = new Align(
      alignment: Alignment.topLeft,
      child: new Row(
        children: <Widget>[
          new Expanded(
            flex: 1,
            child: new Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  (userName != null ? userName : 'No Data'),
                  style: TextStyle(
                    fontFamily: 'Work Sans',
                    fontSize: 24,
                  ),
                  textAlign: TextAlign.left,
                ),
                Text(
                  (userEmail != null ? userEmail : 'No Data'),
                  style: TextStyle(fontFamily: 'Work Sans', fontSize: 14),
                  textAlign: TextAlign.left,
                ),
                Text(
                  (userPhone != null ? '+$userPhone' : 'No Data'),
                  style: TextStyle(fontFamily: 'Work Sans', fontSize: 14),
                  textAlign: TextAlign.left,
                ),
              ],
            ),
          ),
          new Column(
            children: <Widget>[
              new GestureDetector(
                child: new Text(
                  "edit",
                  style: TextStyle(fontFamily: 'Work Sans', fontSize: 12.0),
                  textAlign: TextAlign.right,
                ),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => EditAccountPage()));
                },
              ),
            ],
          ),
        ],
      ),
    );

    Widget _circularProgress() {
      return SizedBox(
        child: CircularProgressIndicator(
          backgroundColor: ColorLibrary.primary,
          valueColor: AlwaysStoppedAnimation<Color>(ColorLibrary.secondary),
          strokeWidth: 2.0,
        ),
        height: 10.0,
        width: 10.0,
      );
    }

    Widget _saldoContent = new Row(
      children: <Widget>[
        new GestureDetector(
          child: loading
              ? Center(child: _circularProgress())
              : new Row(
                  children: <Widget>[
                    Icon(
                      Icons.account_balance_wallet,
                      size: 18,
                    ),
                    Container(width: 5.0),
                    Text(
                      // (userBalance != null ? fo.symbolOnLeft : "No Data"),
                      (userBalance != null ? "Rp $userBalance" : "No Data"),
                      style: TextStyle(fontFamily: 'Work Sans', fontSize: 14),
                    ),
                  ],
                ),
          onTap: () {
            _moveToTopup();
          },
        ),
        new Container(
          width: 15.0,
        ),
        new GestureDetector(
          child: new Row(
            children: <Widget>[
              Icon(
                Icons.confirmation_number,
                size: 18,
              ),
              Container(width: 5.0),
              Text(
                "7 vouchers",
                style: TextStyle(fontFamily: 'Work Sans', fontSize: 14),
              )
            ],
          ),
          onTap: () {
            print("object");
          },
        ),
      ],
    );

    Widget _listContent = new ListView(
      children: <Widget>[
        new Container(
          decoration: new BoxDecoration(
            border: Border(bottom: BorderSide()),
          ),
          child: new ListTile(
            leading: Icon(Icons.inbox),
            title: Text(
              "My Garage",
              style: TextStyle(fontFamily: 'Work Sans'),
            ),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => GaragePage()));
            },
          ),
        ),
        new Container(
          decoration: new BoxDecoration(
            border: Border(bottom: BorderSide()),
          ),
          child: new ListTile(
            leading: Icon(Icons.help),
            title: Text(
              "Help",
              style: TextStyle(fontFamily: 'Work Sans'),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => new WebViewPage(
                      "Help", "https://solarapp.digitalevent.id/pijar_reza"),
                ),
              );
            },
          ),
        ),
        new Container(
          decoration: new BoxDecoration(
            border: Border(bottom: BorderSide()),
          ),
          child: new ListTile(
            leading: Icon(Icons.description),
            title: Text(
              "Terms of Services",
              style: TextStyle(fontFamily: 'Work Sans'),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => new WebViewPage("Terms of Services",
                      "https://solarapp.digitalevent.id/pijar_reza"),
                ),
              );
            },
          ),
        ),
        new Container(
          decoration: new BoxDecoration(
            border: Border(bottom: BorderSide()),
          ),
          child: ListTile(
            leading: Icon(Icons.security),
            title: Text(
              "Privacy Policy",
              style: TextStyle(fontFamily: 'Work Sans'),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => new WebViewPage("Privacy Policy",
                      "https://solarapp.digitalevent.id/pijar_reza"),
                ),
              );
            },
          ),
        ),
        new Container(
          decoration: new BoxDecoration(
            border: Border(bottom: BorderSide()),
          ),
          child: ListTile(
            leading: Icon(Icons.star),
            title: Text(
              "Rate Pijar App",
              style: TextStyle(fontFamily: 'Work Sans'),
            ),
            trailing: Text(
              "v0.00.0",
              style: TextStyle(fontFamily: 'Work Sans', fontSize: 10),
            ),
            onTap: () {
              LaunchReview.launch(
                  androidAppId: "com.mobile.legends", iOSAppId: "585027354");
            },
          ),
        ),
      ],
    );

    Widget _compileWidget = new Scaffold(
      backgroundColor: ColorLibrary.backgroundDark,
      body: new SafeArea(
        child: new Stack(
          children: <Widget>[
            new ClipPath(
              clipper: WaveClipper2(),
              child: Container(
                child: Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Column(
                    children: <Widget>[
                      _topContent,
                      Container(
                        height: 10.0,
                      ),
                      _saldoContent,
                    ],
                  ),
                ),
                width: double.infinity,
                height: 180,
                decoration: BoxDecoration(color: ColorLibrary.secondary),
              ),
            ),
            new Container(
              child: Padding(
                padding: EdgeInsets.only(top: 170),
                child: _listContent,
              ),
            ),
            new Align(
              alignment: Alignment.bottomCenter,
              child: new ButtonTheme(
                minWidth: double.infinity,
                child: new RaisedButton(
                  color: Colors.white,
                  onPressed: () {
                    _dialogLogout();
                  },
                  child: new Text(
                    "Log Out",
                    style: new TextStyle(color: Colors.black),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );

    return _compileWidget;
  }

  void _moveToTopup() {
    Navigator.of(context).push(PageRouteBuilder(
      maintainState: true,
      opaque: true,
      pageBuilder: (context, _, __) => new TopupPage(),
    ));
  }

  void _logout() async {
    final _prefs = await SharedPreferences.getInstance();
    _prefs.remove('ISLOGIN');
    Navigator.of(context).pushNamedAndRemoveUntil(
        '/splash', (Route<dynamic> route) => false);
  }

  void _dialogLogout() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text(
            "Attention !",
            style:
                TextStyle(fontFamily: 'Work Sans', fontWeight: FontWeight.w700),
          ),
          content: new Text(
            "Are you sure want to logout ?",
            style: TextStyle(
                fontFamily: 'Work Sans',
                fontWeight: FontWeight.w300,
                fontSize: 12),
          ),
          actions: <Widget>[
            new FlatButton(
              child: new Text(
                "No",
                style: TextStyle(fontFamily: 'Work Sans'),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            new FlatButton(
              child: new Text(
                "Yes",
                style: TextStyle(fontFamily: 'Work Sans'),
              ),
              onPressed: () {
                _logout();
              },
            ),
          ],
        );
      },
    );
  }
}

class WaveClipper1 extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0.0, size.height - 50);

    var firstEndPoint = Offset(size.width * 0.6, size.height - 29 - 50);
    var firstControlPoint = Offset(size.width * .25, size.height - 60 - 50);
    path.quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy,
        firstEndPoint.dx, firstEndPoint.dy);

    var secondEndPoint = Offset(size.width, size.height - 60);
    var secondControlPoint = Offset(size.width * 0.84, size.height - 50);
    path.quadraticBezierTo(secondControlPoint.dx, secondControlPoint.dy,
        secondEndPoint.dx, secondEndPoint.dy);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}

class WaveClipper2 extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0.0, size.height - 120);

    var firstEndPoint = Offset(size.width / 3, size.height - 60);
    var firstControlPoint = Offset(size.width * 0, size.height - 25);
    path.quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy,
        firstEndPoint.dx, firstEndPoint.dy);

    var secondEndPoint = Offset(size.width * 0.7, size.height - 20);
    var secondControlPoint = Offset(size.width * 0.7, size.height - 100);
    path.quadraticBezierTo(secondControlPoint.dx, secondControlPoint.dy,
        secondEndPoint.dx, secondEndPoint.dy);

    var thirdEndPoint = Offset(size.width, size.height - 90);
    var thirdControlPoint = Offset(size.width, size.height);
    path.quadraticBezierTo(thirdControlPoint.dx, thirdControlPoint.dy,
        thirdEndPoint.dx, thirdEndPoint.dy);

    path.lineTo(size.width, size.height);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}
