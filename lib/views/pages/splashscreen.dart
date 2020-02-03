/**
 * 
 */

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:user_pijar/views/pages/landing_page.dart';
import 'package:user_pijar/views/pages/welcome_page.dart';
import 'package:user_pijar/views/widget/session_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  SessionManager _session;

  void checkLogin() async {
    final _prefs = await SharedPreferences.getInstance();
    _session = new SessionManager(_prefs);
    if (_session.isLoggedIn() != null && _session.isLoggedIn()) {
      _moveToLanding();
    } else {
      _moveToWelcome();
    }
  }

  @override
  void initState() {
    super.initState();

    new Timer(const Duration(seconds: 3), checkLogin);
  }

  @override
  Widget build(BuildContext context) {
    Widget _background = new Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/splash_img.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ],
      ),
    );

    Widget _compile = new Scaffold(
      body: Stack(
        children: <Widget>[_background],
      ),
    );

    return _compile;
  }

  void _moveToWelcome() {
    Navigator.of(context).pushReplacement(PageRouteBuilder(
        maintainState: true,
        opaque: true,
        pageBuilder: (context, _, __) => new WelcomePage(),
        transitionDuration: const Duration(seconds: 2),
        transitionsBuilder: (context, anim1, anim2, child) {
          return new FadeTransition(
            child: child,
            opacity: anim1,
          );
        }));
  }

  void _moveToLanding() {
    Navigator.of(context).pushReplacement(PageRouteBuilder(
        maintainState: true,
        opaque: true,
        pageBuilder: (context, _, __) => new LandingPage(),
        transitionDuration: const Duration(seconds: 2),
        transitionsBuilder: (context, anim1, anim2, child) {
          return new FadeTransition(
            child: child,
            opacity: anim1,
          );
        }));
  }
}
