import 'dart:collection';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:user_pijar/models/voucher.dart';
import 'package:user_pijar/services/api.dart';
import 'package:user_pijar/views/widget/color_library.dart';
import 'package:user_pijar/views/widget/session_manager.dart';
import 'package:user_pijar/views/widget/voucher_row.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class VoucherPage extends StatefulWidget {
  final String locationID;

  const VoucherPage({Key key, this.locationID}) : super(key: key);
  @override
  _VoucherPageState createState() => _VoucherPageState();
}

class _VoucherPageState extends State<VoucherPage> {
  List<Voucher> _listVoucher = [];
  SessionManager _session;
  HashMap<String, String> user;
  var loading = false;

  Future<Null> _getVoucher() async {
    final prefs = await SharedPreferences.getInstance();
    _session = new SessionManager(prefs);
    user = _session.getUserSession();
    String token = user['USER_TOKEN'];
    // String locid = widget.locationID;
    String locid = '2';
    String url = BaseUrl.VOUCHER;
    String clause = '?location_id=$locid&vehicle_type_id=1&payment_type_id=2';

    setState(() {
      loading = true;
    });

    final response = await http
        .get('$url$clause', headers: {HttpHeaders.authorizationHeader: token});
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        for (Map i in data['data']) {
          _listVoucher.add(Voucher.fromJson(i));
        }
        loading = false;
      });
    }
    print('$url$clause');
  }

  @override
  void initState() {
    super.initState();
    _getVoucher();
  }

  @override
  Widget build(BuildContext context) {
    Widget _selectionContent = new Container(
      padding: EdgeInsets.all(10),
      child: Card(
          child: Padding(
        padding: EdgeInsets.all(15.0),
        child: Row(
          children: <Widget>[
            Expanded(
              child: TextField(
                style: TextStyle(fontFamily: 'Work Sans'),
                decoration: InputDecoration(
                  hintText: 'Input Voucher Code',
                  hintStyle: TextStyle(fontFamily: 'Work Sans'),
                ),
              ),
            ),
            SizedBox(
              width: 20.0,
            ),
            RaisedButton(
              color: ColorLibrary.secondary,
              child: Text(
                "use now",
                style: TextStyle(fontFamily: 'Work Sans'),
              ),
              onPressed: () {},
            ),
          ],
        ),
      )),
    );

    Widget _listContent = new Container(
      child: loading
          ? Center(
              child: CircularProgressIndicator(
                    backgroundColor: ColorLibrary.primary,
                    valueColor:
                        AlwaysStoppedAnimation<Color>(ColorLibrary.secondary),
              ),
            )
          : CustomScrollView(
              scrollDirection: Axis.vertical,
              shrinkWrap: false,
              slivers: <Widget>[
                SliverPadding(
                  padding: const EdgeInsets.symmetric(vertical: 12.0),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        return new VoucherRow(_listVoucher[index]);
                      },
                      childCount: _listVoucher.length,
                    ),
                  ),
                )
              ],
            ),
    );

    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorLibrary.primary,
        title: Text(
          "Voucher",
          style: TextStyle(
            fontFamily: 'Work Sans',
          ),
        ),
      ),
      body: new Column(
        children: <Widget>[
          _selectionContent,
          SizedBox(
            height: 30,
          ),
          Expanded(
            child: _listContent,
          ),
        ],
      ),
    );
  }
}
