import 'dart:collection';
import 'dart:convert';
import 'dart:io';

import 'package:user_pijar/models/getTransaction.dart';
import 'package:user_pijar/services/api.dart';
import 'package:user_pijar/views/widget/session_manager.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class TransactionApi {
  static const String url = BaseUrl.TRANSACTION;
  static const String include =
      '&include=vehicle_id&include=location_id&include=feature_type_id&include=payment_type_id&include=voucher_id';
  static SessionManager _session;
  static HashMap<String, String> user;

  static Future getTicket(String idStatus) async {
    final prefs = await SharedPreferences.getInstance();
    _session = new SessionManager(prefs);
    user = _session.getUserSession();
    String token = user['USER_TOKEN'];

    try {
      final response = await http.get('$url$idStatus$include', headers: {
        HttpHeaders.authorizationHeader: token
      });
      
      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        GetTransaction getTransaction = new GetTransaction.fromJson(jsonResponse);
        print('ini response body: ${response.body}');
        print('ini response message: ${getTransaction.message}');
        print('ini response data: ${getTransaction.datas}');
        
      } else {
        print('ini status code: ${response.statusCode}');
        throw Exception('Error');
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  // static List<GetTransaction> parseTrans(String responseBody) {
  //   final Map<String, dynamic> parsed = json.decode(responseBody);
  //   return parsed
  //       .map<GetTransaction>((json) => GetTransaction.fromJson(json))
  //       .toList();
  // }
}
