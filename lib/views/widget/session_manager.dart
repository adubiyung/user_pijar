import 'dart:collection';

import 'package:shared_preferences/shared_preferences.dart';

class SessionManager {
  final SharedPreferences _preferences;

  SessionManager(this._preferences);

  void setUserSession(String id, String role, String name, String email,
      String phone, String token) {
    _preferences.setBool('ISLOGIN', true);
    _preferences.setString('USER_ID', id);
    _preferences.setString('ROLE_ID', role);
    _preferences.setString('USER_FULLNAME', name);
    _preferences.setString('USER_EMAIL', email);
    _preferences.setString('USER_PHONE', phone);
    _preferences.setString('USER_TOKEN', token);

    _preferences.commit();
  }

  bool isLoggedIn() {
    return _preferences.getBool('ISLOGIN');
  }

  HashMap<String, String> getUserSession() {
    HashMap<String, String> user = new HashMap<String, String>();

    user['USER_ID'] = _preferences.getString('USER_ID');
    user['ROLE_ID'] = _preferences.getString('ROLE_ID');
    user['USER_FULLNAME'] = _preferences.getString('USER_FULLNAME');
    user['USER_EMAIL'] = _preferences.getString('USER_EMAIL');
    user['USER_PHONE'] = _preferences.getString('USER_PHONE');
    user['USER_TOKEN'] = _preferences.getString('USER_TOKEN');

    return user;
  }

  void logoutUser() {
    _preferences.remove('ISLOGIN');
  }
}
