import 'package:flutter/material.dart';
import 'package:user_pijar/views/pages/booking_page.dart';
import 'package:user_pijar/views/pages/landing_page.dart';
import 'package:user_pijar/views/pages/location_detail_page.dart';
import 'package:user_pijar/views/pages/lot_select_page.dart';
import 'package:user_pijar/views/pages/splashscreen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Pijar',
      home: new SplashScreen(),
      routes: <String, WidgetBuilder>{
        //app routes
        '/splash': (BuildContext context) => new SplashScreen(),
        '/landing': (BuildContext context) => new LandingPage(),
        '/booking': (BuildContext context) => new BookingPage(),
        '/detailLoc': (BuildContext context) => new LocationDetailPage(),
        '/lotmap': (BuildContext context) => new LotSelectPage(),
      },
    );
  }
}
