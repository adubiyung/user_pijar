import 'dart:collection';

import 'package:fancy_bottom_navigation/fancy_bottom_navigation.dart';
import 'package:flutter/material.dart';
import 'package:user_pijar/views/pages/account_page.dart';
import 'package:user_pijar/views/pages/home_page.dart';
import 'package:user_pijar/views/pages/order_page.dart';
import 'package:user_pijar/views/pages/scan_page.dart';
import 'package:user_pijar/views/widget/color_library.dart';
import 'package:user_pijar/views/widget/session_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LandingPage extends StatefulWidget {
  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  SessionManager _session;
  HashMap<String, String> user;
  int _page = 0;

  final _pageOption = [
    HomePage(),
    ScanPage(),
    OrderPage(),
    AccountPage(),
  ];

  Future<String> getNameUser() async {
    final prefs = await SharedPreferences.getInstance();
    _session = new SessionManager(prefs);
    user = _session.getUserSession();
    String name = user['USER_FULLNAME'];
    return name;
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      bottomNavigationBar: FancyBottomNavigation(
        tabs: [
          TabData(iconData: Icons.location_searching, title: "booking"),
          TabData(iconData: Icons.list, title: "OTS"),
          TabData(iconData: Icons.line_style, title: "orders"),
          TabData(iconData: Icons.person, title: "account"),
        ],
        textColor: ColorLibrary.regularFontWhite,
        barBackgroundColor: ColorLibrary.primary,
        circleColor: ColorLibrary.secondary,
        inactiveIconColor: ColorLibrary.secondary,
        onTabChangedListener: (position) {
          if (mounted) {
            setState(() {
              _page = position;
            });
          }
        },
      ),
      body: _pageOption[_page],
    );
  }
}
