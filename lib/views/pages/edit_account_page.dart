import 'dart:collection';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:user_pijar/services/api.dart';
import 'package:user_pijar/views/widget/color_library.dart';
import 'package:user_pijar/views/widget/session_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class EditAccountPage extends StatefulWidget {
  @override
  _EditAccountPageState createState() => _EditAccountPageState();
}

class _EditAccountPageState extends State<EditAccountPage> {
  SessionManager _session;
  HashMap<String, String> userData;
  String userID;
  String userName;
  String userEmail;
  String userPhone;
  String userToken;
  String userRole;
  var loading = true;

  var txtName = TextEditingController();
  var txtEmail = TextEditingController();
  var txtPhone = TextEditingController();

  getUserData() async {
    final _prefs = await SharedPreferences.getInstance();
    _session = new SessionManager(_prefs);
    userData = _session.getUserSession();
    userID = userData['USER_ID'];
    userRole = userData['USER_ROLE'];
    userName = userData['USER_FULLNAME'];
    userEmail = userData['USER_EMAIL'];
    userPhone = userData['USER_PHONE'];
    userToken = userData['USER_TOKEN'];

    if (userPhone != null) {
      setState(() {
        txtName.text = userName;
        txtEmail.text = userEmail;
        txtPhone.text = userPhone;
        loading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getUserData();
  }

  @override
  Widget build(BuildContext context) {
    Widget _compileWidget = new Scaffold(
      appBar: AppBar(
        backgroundColor: ColorLibrary.backgroundDark,
        title: Text(
          "Edit Profile",
          style: TextStyle(fontFamily: 'Work Sans'),
        ),
      ),
      body: new Column(
        children: <Widget>[
          new TextField(
            style: TextStyle(fontFamily: 'Work Sans'),
            decoration: InputDecoration(
              labelText: "Full Name",
              labelStyle: TextStyle(fontFamily: 'Work Sans'),
            ),
            controller: txtName,
          ),
          new TextField(
            style: TextStyle(fontFamily: 'Work Sans'),
            decoration: InputDecoration(
              labelText: "Email",
              labelStyle: TextStyle(fontFamily: 'Work Sans'),
            ),
            controller: txtEmail,
          ),
          new TextField(
            style: TextStyle(fontFamily: 'Work Sans'),
            decoration: InputDecoration(
                labelText: "Phone No",
                labelStyle: TextStyle(fontFamily: 'Work Sans')),
            controller: txtPhone,
          ),
          new Container(
            padding: EdgeInsets.only(top: 20),
            width: double.infinity,
            child: RaisedButton(
              child: Text(
                "Save",
                style: TextStyle(fontFamily: 'Work Sans'),
              ),
              color: ColorLibrary.secondary,
              onPressed: () {
                editingService(
                    txtName.text, txtEmail.text, txtPhone.text, userID);
              },
            ),
          ),
        ],
      ),
    );

    return _compileWidget;
  }

  void editingService(
      String name, String email, String phone, String idUser) async {
    var client = new http.Client();
    String body =
        '{"method":"update", "user_fullname":"$name", "user_email":"$email", "user_phone":"$phone", "updated_by":"$idUser", "user_id":"$idUser"}';

    try {
      var response = await client.post(BaseUrl.USER_ACCOUNT,
          headers: {HttpHeaders.authorizationHeader: userToken}, body: body);
      if (response.statusCode == 200) {
        var jsonObject = json.decode(response.body);
        int status = jsonObject['status'];

        print(status.toString());
        if (status == 200) {
          _session.setUserSession(
              idUser, userRole, name, email, phone, userToken);
        }
      }
    } finally {
      client.close();
    }
  }
}
