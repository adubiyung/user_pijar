import 'package:flutter/material.dart';

class FirstBackground extends StatefulWidget {
  @override
  _FirstBackgroundState createState() => _FirstBackgroundState();
}

class _FirstBackgroundState extends State<FirstBackground> {
  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/splash_img.png'),
            fit: BoxFit.cover
          ),
        ),
    );
  }
}