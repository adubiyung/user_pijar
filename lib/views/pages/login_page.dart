import 'dart:convert';

import 'package:country_pickers/country.dart';
import 'package:country_pickers/country_pickers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:user_pijar/services/api.dart';
import 'package:user_pijar/models/user_model.dart';
import 'package:user_pijar/views/pages/otp_page.dart';
import 'package:user_pijar/views/pages/register_page.dart';
import 'package:user_pijar/views/widget/color_library.dart';
import 'package:http/http.dart' as http;

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  UserModel model;

  Country _selectedCountry = CountryPickerUtils.getCountryByPhoneCode('62');
  TextEditingController numberControler = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    Widget _compile = new Scaffold(
        appBar: AppBar(
          title: Text(""),
          backgroundColor: ColorLibrary.primary,
          elevation: 0.0,
          iconTheme: IconThemeData(color: ColorLibrary.regularFontWhite),
        ),
        body: new Container(
          color: ColorLibrary.background,
          padding: EdgeInsets.only(left: 10.0, right: 10.0),
          child: new Column(
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(top: 10.0, bottom: 10.0),
                child: new Text(
                  'Enter your registered phone number to log in',
                  style: TextStyle(
                      fontFamily: 'Work Sans', color: ColorLibrary.primaryDark),
                ),
              ),
              Row(
                children: <Widget>[
                  Expanded(
                    flex: 2,
                    child: new Align(
                      alignment: Alignment.center,
                      child: new GestureDetector(
                        child: _showItem(_selectedCountry),
                        onTap: _openCountryPickerDialog,
                      ),
                    ),
                  ),
                  Container(
                    width: 10.0,
                  ),
                  Expanded(
                    flex: 5,
                    child: TextFormField(
                      key: new Key('phone'),
                      decoration:
                          new InputDecoration(labelText: 'Phone Number'),
                      keyboardType: TextInputType.phone,
                      autocorrect: false,
                      controller: numberControler,
                    ),
                  ),
                ],
              ),
              Expanded(
                child: Align(
                    alignment: Alignment.bottomCenter,
                    child: ButtonTheme(
                      height: 45.0,
                      minWidth: double.infinity,
                      child: RaisedButton(
                        color: ColorLibrary.primary,
                        child: Text(
                          'CONTINUE',
                          style: TextStyle(
                              fontFamily: 'Work Sans',
                              fontWeight: FontWeight.w700,
                              color: ColorLibrary.regularFontWhite),
                        ),
                        onPressed: () {
                          authNumber(_selectedCountry, numberControler.text);
                        },
                      ),
                    )),
              ),
            ],
          ),
        ));
    return _compile;
  }

  void _openCountryPickerDialog() => showDialog(
        context: context,
        builder: (context) => Theme(
            data: Theme.of(context).copyWith(primaryColor: Colors.pink),
            child: CountryPickerDialog(
                titlePadding: EdgeInsets.all(2.0),
                searchCursorColor: Colors.pinkAccent,
                searchInputDecoration:
                    InputDecoration(hintText: 'Type in Country name or code'),
                isSearchable: true,
                title: Text('search country code'),
                onValuePicked: (Country country) =>
                    setState(() => _selectedCountry = country),
                itemBuilder: _buildDialogItem)),
      );

  Widget _showItem(Country country) => new Card(
      color: Colors.white54,
      child: new Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(10.0),
            child: new Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                CountryPickerUtils.getDefaultFlagImage(country),
                SizedBox(width: 8.0),
                Text(
                  "+${country.phoneCode}",
                  style: TextStyle(fontSize: 14),
                ),
              ],
            ),
          )
        ],
      ));

  Widget _buildDialogItem(Country country) => Row(
        children: <Widget>[
          CountryPickerUtils.getDefaultFlagImage(country),
          SizedBox(width: 8.0),
          Text("+${country.phoneCode}"),
          SizedBox(width: 8.0),
          Flexible(child: Text(country.name))
        ],
      );

// fungsi navigasi yang menangani perpindahan ke page OTP
  void moveToOTP(String number, String otp) {
    Navigator.of(context).push(PageRouteBuilder(
      maintainState: true,
      opaque: true,
      pageBuilder: (context, _, __) =>
          new OtpPage(phoneNumber: number, otpNumber: otp),
    ));
  }

// fungsi navigasi yang menangani perpindahan ke page register
  void moveToRegister(String number) {
    Navigator.of(context).push(PageRouteBuilder(
      maintainState: true,
      opaque: true,
      pageBuilder: (context, _, __) => new RegisterPage(number: number),
    ));
  }

  // alert dialog untuk menangani kondisi nomor tidak terdaftar
  void _dialogRegister(String number) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text(
            "You seem to be new",
            style:
                TextStyle(fontFamily: 'Work Sans', fontWeight: FontWeight.w700),
          ),
          content: new Text(
            "This number $number has not been registered on Pijar. Let's create a new account for you",
            style: TextStyle(
                fontFamily: 'Work Sans',
                fontWeight: FontWeight.w300,
                fontSize: 12),
          ),
          actions: <Widget>[
            new FlatButton(
              child: new Text(
                "Not Now",
                style: TextStyle(fontFamily: 'Work Sans'),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            new FlatButton(
              child: new Text(
                "Register",
                style: TextStyle(fontFamily: 'Work Sans'),
              ),
              onPressed: () {
                moveToRegister(number.substring(2, number.length));
              },
            ),
          ],
        );
      },
    );
  }

  authNumber(Country country, String number) async {
    String phoneNumber;
    String nomor;
    if (number[0] == '0') {
      nomor = number;
      number = number.substring(1, number.length);
      phoneNumber = "${country.phoneCode}$number";
    } else if (number[0] == '+') {
      nomor = '0' + number.substring(3, number.length);
    }

    var client = new http.Client();
    // variable request berfungsi untuk mengirimkan data dengan method post
    try {
      var response = await client.post(BaseUrl.LOGIN_AUTH,
          body: '{"user_phone": "$phoneNumber", "method": "auth_number"}');

      var jsonObject = json.decode(response.body);
      dynamic otp = jsonObject['data'];
      String message = jsonObject['message'];
      int status = jsonObject['status'];

      if (status == 200) {
        sendOTP(phoneNumber, nomor, otp.toString());
      } else if (status == 204) {
        _dialogRegister(phoneNumber);
      } else {
        print(message);
      }
    } finally {
      client.close();
    }
  }

  sendOTP(String hpOtp, String number, String otp) async {
    String msg =
        "Pijar - JANGAN MEMBERIKAN KODE INI KE SIAPAPUN. Kode verifikasi (OTP) Anda adalah $otp.";
    String url =
        "https://secure.gosmsgateway.com/api/Send.php?username=sigmatelkom&mobile=$number&message=$msg&password=gosms3e35fg";
    print(url);
    var client = new http.Client();
    var response = await client.get(url);

    if (response.statusCode == 200) {
      moveToOTP(hpOtp, otp.toString());
    } else {
      print("something wrong ${response.statusCode}");
    }
  }
}
