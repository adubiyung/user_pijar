import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:user_pijar/services/api.dart';
import 'package:user_pijar/views/pages/login_page.dart';
import 'package:user_pijar/views/pages/otp_page.dart';
import 'package:user_pijar/views/widget/circleIcon_button.dart';
import 'package:user_pijar/views/widget/color_library.dart';
import 'package:http/http.dart' as http;

var _nameCon = TextEditingController();
var _emailCon = TextEditingController();
var _phoneCon = TextEditingController();
final FocusNode _nameFocus = FocusNode();
final FocusNode _emailFocus = FocusNode();
final FocusNode _phoneFocus = FocusNode();

class RegisterPage extends StatefulWidget {
  final String number;
  RegisterPage({Key key, @required this.number}) : super(key: key);
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _nameKey = GlobalKey<FormState>();
  final _emailKey = GlobalKey<FormState>();
  final _phoneKey = GlobalKey<FormState>();
  bool _nameValidate = false;
  bool _emailValidate = false;
  bool _phoneValidate = false;

  @override
  void initState() {
    _nameCon.text = '';
    _emailCon.text = '';
    _phoneCon.text = '';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.number != null) {
      _phoneCon.text = widget.number;
    }

    Widget _logoWidget = Container(
      alignment: Alignment.center,
      child: Padding(
        padding: const EdgeInsets.only(top: 35.0, bottom: 35.0),
        child: Icon(Icons.local_parking),
      ),
    );

    Widget _registerCardWidget = Padding(
      padding: const EdgeInsets.only(left: 20.0, right: 20.0),
      child: Card(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        elevation: 10.0,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: <Widget>[
              Container(
                alignment: Alignment.center,
                width: double.infinity,
                child: Text(
                  'Daftar Baru',
                  style: TextStyle(
                      fontSize: 18.0,
                      color: ColorLibrary.regularFontBlack,
                      fontFamily: 'Work Sans'),
                ),
              ),
              Column(
                children: <Widget>[
                  Form(
                    key: _nameKey,
                    autovalidate: _nameValidate,
                    child: TextFormField(
                      onTap: () {
                        _emailFocus.unfocus();
                        _phoneFocus.unfocus();
                        FocusScope.of(context).requestFocus(_nameFocus);
                      },
                      controller: _nameCon,
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.text,
                      validator: (value) => _validateName(value),
                      focusNode: _nameFocus,
                      onFieldSubmitted: (term) {
                        FocusScope.of(context).requestFocus(_emailFocus);
                        setState(() {
                          _nameValidate = true;
                        });
                      },
                      decoration: InputDecoration(
                        labelText: 'Nama Lengkap',
                        icon: Icon(
                          Icons.perm_identity,
                          color: _nameFocus.hasFocus
                              ? ColorLibrary.primary
                              : Colors.grey,
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: ColorLibrary.primary),
                        ),
                        labelStyle: TextStyle(
                            color: _nameFocus.hasFocus
                                ? ColorLibrary.primary
                                : Colors.grey),
                        suffixIcon: CircleIconButton(
                          onHide: _nameFocus.hasFocus ? true : false,
                          onPressed: () {
                            this.setState(() {
                              _nameCon.clear();
                            });
                          },
                        ),
                      ),
                    ),
                  ),
                  Form(
                    key: _emailKey,
                    autovalidate: _emailValidate,
                    child: TextFormField(
                      controller: _emailCon,
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) => _validateEmail(value),
                      focusNode: _emailFocus,
                      onTap: () {
                        _nameFocus.unfocus();
                        _phoneFocus.unfocus();
                        FocusScope.of(context).requestFocus(_emailFocus);
                      },
                      onFieldSubmitted: (term) {
                        _fieldFocusChange(context, _emailFocus, _phoneFocus);
                        setState(() {
                          _emailValidate = true;
                        });
                      },
                      decoration: InputDecoration(
                        labelText: 'Email',
                        labelStyle: TextStyle(
                            color: _emailFocus.hasFocus
                                ? ColorLibrary.primary
                                : Colors.grey),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: ColorLibrary.primary),
                        ),
                        icon: Icon(
                          Icons.email,
                          color: _emailFocus.hasFocus
                              ? ColorLibrary.primary
                              : Colors.grey,
                        ),
                      ),
                    ),
                  ),
                  Form(
                    key: _phoneKey,
                    autovalidate: _phoneValidate,
                    child: TextFormField(
                      controller: _phoneCon,
                      onTap: () {
                        _nameFocus.unfocus();
                        _emailFocus.unfocus();
                        FocusScope.of(context).requestFocus(_phoneFocus);
                      },
                      decoration: InputDecoration(
                        labelText: 'No. HP',
                        icon: Icon(
                          Icons.phone_android,
                          color: _phoneFocus.hasFocus
                              ? ColorLibrary.primary
                              : Colors.grey,
                        ),
                        labelStyle: TextStyle(
                            color: _phoneFocus.hasFocus
                                ? ColorLibrary.primary
                                : Colors.grey),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: ColorLibrary.primary),
                        ),
                      ),
                      textInputAction: TextInputAction.done,
                      keyboardType: TextInputType.phone,
                      validator: (value) => _validatePhone(value),
                      focusNode: _phoneFocus,
                      onFieldSubmitted: (term) {
                        setState(() {
                          _phoneValidate = true;
                        });
                      },
                    ),
                  ),
                ],
              ),
              Container(
                padding: EdgeInsets.only(top: 28.0),
                child: Column(
                  children: <Widget>[
                    ButtonTheme(
                      minWidth: double.infinity,
                      child: RaisedButton(
                        color: ColorLibrary.primary,
                        child: Text(
                          'DAFTAR',
                          style: TextStyle(
                              color: ColorLibrary.regularFontWhite,
                              fontFamily: 'Work Sans',
                              fontWeight: FontWeight.w700),
                        ),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0)),
                        onPressed: () {
                          if (_nameKey.currentState.validate() &&
                              _emailKey.currentState.validate() &&
                              _phoneKey.currentState.validate()) {
                            print(_nameKey.currentState.validate());
                            print(_emailKey.currentState.validate());
                            registerService(
                                _nameCon.text, _emailCon.text, _phoneCon.text);
                          } else {
                            print("masuk else");
                            print(_nameKey.currentState.validate());
                            setState(() {
                              _nameValidate = true;
                              _emailValidate = true;
                              _phoneValidate = true;
                            });
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text('sudah punya akun? '),
                    InkWell(
                      splashColor: ColorLibrary.secondary,
                      onTap: () {
                        _moveToLogin();
                      },
                      child: Text(
                        'Masuk',
                        style: TextStyle(
                            color: ColorLibrary.secondary,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );

    Widget _compileWidget = Scaffold(
      backgroundColor: ColorLibrary.background,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(top: 35.0),
          child: Column(
            children: <Widget>[
              _logoWidget,
              _registerCardWidget,
            ],
          ),
        ),
      ),
    );

    return _compileWidget;
  }

  String _validateName(String value) {
    return value.trim().isEmpty ? "Nama tidak boleh kosong" : null;
  }

  String _validateEmail(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value)) {
      return 'Email tidak sesuai';
    } else {
      return null;
    }
  }

  String _validatePhone(String value) {
    return value.length < 10 ? 'Nomor tidak sesuai' : null;
  }

  void _moveToOTP(String number, String otp) {
    if (number[0] == '0') {
      number = number.substring(1, number.length);
    }
    Navigator.of(context).push(PageRouteBuilder(
      maintainState: true,
      opaque: true,
      pageBuilder: (context, _, __) => new OtpPage(phoneNumber: number, otpNumber: otp),
    ));
  }

  void _moveToLogin() {
    Navigator.of(context).push(PageRouteBuilder(
      maintainState: true,
      opaque: true,
      pageBuilder: (context, _, __) => new LoginPage(),
    ));
  }

  _fieldFocusChange(
      BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }

  registerService(String name, String email, String phone) async {
    var client = new http.Client();

    try {
      var request = await client.post(BaseUrl.REGISTER,
          body:
              '{"method":"register","role_id":"3", "user_fullname":"$name", "user_email":"$email", "user_phone":"$phone", "user_status":"1"}');
      var jsonObject = json.decode(request.body);
      dynamic data = jsonObject['data'];
      String message = jsonObject['message'];
      int status = jsonObject['status'];
      print(request.body.toString());
      print(data);

      if (status == 200) {
        _moveToOTP(phone, data.toString());
      } else if (status == 204) {
        if (data == "email already exist") {
          setState(() {
            _emailValidate = true;
          });
        } else {
          setState(() {
            _phoneValidate = true;
          });
        }
      } else {
        print(message);
      }
    } finally {
      client.close();
    }
  }
}
