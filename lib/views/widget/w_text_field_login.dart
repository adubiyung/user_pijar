import 'package:flutter/material.dart';

class TextFielLogin extends StatefulWidget {
  @override
  _TextFielLoginState createState() => _TextFielLoginState();
}

class _TextFielLoginState extends State<TextFielLogin> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: TextFormField(
        decoration: InputDecoration(
          labelText: "Enter Email",
          fillColor: Colors.amber,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25.0),
            borderSide: BorderSide(),
          )
        ),
      ),
    );
  }
}