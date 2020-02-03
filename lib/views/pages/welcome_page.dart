import 'package:flutter/material.dart';
import 'package:user_pijar/views/pages/login_page.dart';
import 'package:user_pijar/views/pages/register_page.dart';
import 'package:user_pijar/views/widget/color_library.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WelcomePage extends StatefulWidget {
  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  bool checkStatus = false;

  SharedPreferences preferences;
  DateTime currentBackPressTime;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Widget _compile = new Scaffold(
      body: WillPopScope(
        onWillPop: onWillPop,
        child: new Stack(
          fit: StackFit.expand,
          children: <Widget>[
            Container(
              color: ColorLibrary.primary,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  flex: 2,
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.all(20.0),
                      ),
                      Text(
                        'Pijar',
                        style: TextStyle(
                          color: ColorLibrary.regularFontWhite,
                          fontFamily: 'Work Sans',
                          fontSize: 24,
                        ),
                      ),
                      Text(
                        'Jangan Sampai Kamu Salah Parkir',
                        style: TextStyle(
                            color: ColorLibrary.regularFontWhite,
                            fontFamily: 'Work Sans',
                            fontWeight: FontWeight.w200),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.all(15.00),
                        child: Column(
                          children: <Widget>[
                            ButtonTheme(
                              minWidth: 250.0,
                              child: RaisedButton(
                                child: Text(
                                  'MASUK',
                                  style: TextStyle(
                                      fontFamily: 'Work Sans',
                                      fontWeight: FontWeight.w700,
                                      color: ColorLibrary.regularFontBlack),
                                ),
                                color: ColorLibrary.secondary,
                                shape: RoundedRectangleBorder(
                                  side:
                                      BorderSide(color: ColorLibrary.secondary),
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                                onPressed: _moveToLogin,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Column(
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Expanded(
                                child: Container(
                                  margin: const EdgeInsets.only(
                                      left: 30.0, right: 20.0),
                                  child: Divider(
                                      color: ColorLibrary.regularFontWhite),
                                ),
                              ),
                              Text(
                                'ATAU',
                                style: TextStyle(
                                    color: ColorLibrary.regularFontWhite,
                                    fontFamily: 'Work Sans',
                                    fontWeight: FontWeight.w200),
                              ),
                              Expanded(
                                child: Container(
                                  margin: const EdgeInsets.only(
                                      left: 20.0, right: 30.0),
                                  child: Divider(
                                    color: ColorLibrary.regularFontWhite,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.all(15.00),
                        child: Column(
                          children: <Widget>[
                            ButtonTheme(
                              minWidth: 250.0,
                              child: RaisedButton(
                                child: Text(
                                  'DAFTAR',
                                  style: TextStyle(
                                      fontFamily: 'Work Sans',
                                      fontWeight: FontWeight.w700,
                                      color: ColorLibrary.regularFontWhite),
                                ),
                                color: ColorLibrary.primaryDark,
                                shape: RoundedRectangleBorder(
                                  side: BorderSide(
                                      color: ColorLibrary.primaryDark),
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                                onPressed: _moveToRegister,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
    return _compile;
  }

  void _moveToLogin() {
    Navigator.of(context).push(PageRouteBuilder(
      maintainState: true,
      opaque: true,
      pageBuilder: (context, _, __) => new LoginPage(),
    ));
  }

  void _moveToRegister() {
    Navigator.of(context).push(PageRouteBuilder(
      maintainState: true,
      opaque: true,
      pageBuilder: (context, _, __) => new RegisterPage(),
    ));
  }

  Future<bool> onWillPop() {
    DateTime now = DateTime.now();
    if (currentBackPressTime == null ||
        now.difference(currentBackPressTime) > Duration(seconds: 2)) {
      currentBackPressTime = now;
      Fluttertoast.showToast(msg: "tap again to exit");
      return Future.value(false);
    }
    return Future.value(true);
  }
}
