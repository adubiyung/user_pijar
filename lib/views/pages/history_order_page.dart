import 'dart:collection';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:user_pijar/models/getTransaction.dart';
import 'package:user_pijar/services/api.dart';
import 'package:user_pijar/views/widget/color_library.dart';
import 'package:user_pijar/views/widget/session_manager.dart';
import 'package:user_pijar/views/widget/ticket_row.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class HistoryOrderPage extends StatefulWidget {
  @override
  _HistoryOrderPageState createState() => _HistoryOrderPageState();
}

class _HistoryOrderPageState extends State<HistoryOrderPage> {
  static const String url = BaseUrl.TRANSACTION;
  static const String include =
      '&include=vehicle_id&include=location_id&include=feature_type_id&include=payment_type_id&include=voucher_id';
  static SessionManager _session;
  static HashMap<String, String> user;
  var loading = false;
  List<DataTransaction> _listData = [];

  Future<Null> _fetchData() async {
    final prefs = await SharedPreferences.getInstance();
    _session = new SessionManager(prefs);
    user = _session.getUserSession();
    String token = user['USER_TOKEN'];
    String idUser = user['USER_ID'];

    String whereClause = '?user_id=$idUser&transaction_status=4&transaction_status=5';

    setState(() {
      loading = true;
    });

    final response = await http.get('$url$whereClause$include',
        headers: {HttpHeaders.authorizationHeader: token});
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        for (Map i in data['data']) {
          _listData.add(DataTransaction.fromJson(i));
        }
        loading = false;
      });
    }
    print(response.statusCode);
    print('$url$whereClause$include');
  }

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorLibrary.backgroundDark,
        title: Text("History Orders"),
      ),
      body: new Column(
        children: <Widget>[
          new Expanded(
            child: new Container(
              color: ColorLibrary.backgroundDark,
              child: loading
                  ? Center(
                      child: CircularProgressIndicator(
                      backgroundColor: ColorLibrary.primary,
                      valueColor:
                          AlwaysStoppedAnimation<Color>(ColorLibrary.secondary),
                    ))
                  : CustomScrollView(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: false,
                      slivers: <Widget>[
                        new SliverPadding(
                          padding: const EdgeInsets.symmetric(vertical: 12.0),
                          sliver: new SliverList(
                            delegate: new SliverChildBuilderDelegate(
                              (context, index) =>
                                  new TicketRow(_listData[index], 3),
                              childCount: _listData.length,
                            ),
                          ),
                        ),
                      ],
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
