import 'dart:collection';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:user_pijar/models/lot_model.dart';
import 'package:user_pijar/services/api.dart';
import 'package:user_pijar/views/widget/color_library.dart';
import 'package:user_pijar/views/widget/session_manager.dart';
import 'package:user_pijar/views/widget/pop_result.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class LotSelectPage extends StatefulWidget {
  @override
  _LotSelectPageState createState() => _LotSelectPageState();
}

class _LotSelectPageState extends State<LotSelectPage> {
  LotModel _lotModel;
  static const String url = BaseUrl.LOTMAP;
  List<LotModel> _listModel = [];
  List<LotModel> _listModelLeft = [];
  List<LotModel> _listModelRight = [];
  SessionManager _session;
  HashMap<String, String> user;
  var loading = false;
  List<String> _listLabelLeft = [];
  List<String> _listDisableLeft = [];
  List<String> _checkedLeft = [];
  List<String> _listLabelRight = [];
  List<String> _listDisableRight = [];
  List<String> _checkedRight = [];
  String _selectedID;
  String locID = '';
  String detailID = '';
  String detailName = '';

  Future<Null> _fetchData() async {
    final prefs = await SharedPreferences.getInstance();
    _session = new SessionManager(prefs);
    user = _session.getUserSession();
    String token = user['USER_TOKEN'];
    String include =
        "?is_booking=True&detail_location_id=$detailID&include=detail_location_id";

    if (mounted) {
      setState(() {
        loading = true;
      });
    }

    final response = await http
        .get('$url$include', headers: {HttpHeaders.authorizationHeader: token});
    print('$url$include');
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (mounted) {
        setState(() {
          for (Map i in data['data']) {
            _listModel.add(LotModel.fromJson(i));
            if (LotModel.fromJson(i).sideID == 1) {
              _listModelLeft.add(LotModel.fromJson(i));
              _listLabelLeft.add(LotModel.fromJson(i).detailLotID.toString());
              if (!LotModel.fromJson(i).isAvailable) {
                _listDisableLeft
                    .add(LotModel.fromJson(i).detailLotID.toString());
              }
            } else {
              _listModelRight.add(LotModel.fromJson(i));
              _listLabelRight.add(LotModel.fromJson(i).detailLotID.toString());
              if (!LotModel.fromJson(i).isAvailable) {
                _listDisableRight
                    .add(LotModel.fromJson(i).detailLotID.toString());
              }
            }
          }
          loading = false;
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  @override
  Widget build(BuildContext context) {
    final Map arguments = ModalRoute.of(context).settings.arguments as Map;
    if (arguments != null) {
      setState(() {
        locID = arguments['locID'];
        detailID = arguments['detailLocID'];
        detailName = arguments['detailName'];
      });
    }

    Widget _circularProgress() {
      return SizedBox(
        child: CircularProgressIndicator(
          backgroundColor: ColorLibrary.primary,
          valueColor: AlwaysStoppedAnimation<Color>(ColorLibrary.secondary),
          strokeWidth: 2.0,
        ),
      );
    }

    Widget _info = Container(
      color: ColorLibrary.backgroundDark,
      child: Wrap(
        children: <Widget>[
          Container(
            height: 40,
            margin: EdgeInsets.all(10),
            decoration:
                BoxDecoration(border: Border.all(color: ColorLibrary.primary)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(left: 8, right: 8),
                  child: Container(
                    height: 20,
                    width: 20,
                    decoration: BoxDecoration(
                      border: Border.all(color: ColorLibrary.primary),
                      color: ColorLibrary.primary,
                    ),
                  ),
                ),
                Text(
                  'Not Available',
                  style: TextStyle(
                      fontFamily: 'Work Sans',
                      fontSize: 11,
                      color: ColorLibrary.primary),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 8, right: 8),
                  child: Container(
                    height: 20,
                    width: 20,
                    decoration: BoxDecoration(
                      border: Border.all(color: ColorLibrary.primary),
                    ),
                  ),
                ),
                Text(
                  'Available',
                  style: TextStyle(
                      fontFamily: 'Work Sans',
                      fontSize: 11,
                      color: ColorLibrary.primary),
                ),
              ],
            ),
          ),
        ],
      ),
    );

    Widget _bodyMap = new Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      // mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Container(
          height: 20.0,
          child: Text('jalan atas'),
        ),
        Expanded(
          child: new Container(
            decoration:
                BoxDecoration(border: Border.all(color: ColorLibrary.primary)),
            child: new Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                new Text('Some data here'),
                new Text('More stuff here'),
              ],
            ),
          ),
        ),
        Container(
          height: 20.0,
          child: new Align(
            alignment: Alignment.centerRight,
            child: new Text('Jalan Bawah'),
          ),
        )
      ],
    );

    Widget _content = Column(
      children: <Widget>[
        Expanded(
          child: new Container(
            color: ColorLibrary.backgroundDark,
            child: Row(
              children: <Widget>[
                Expanded(
                  child: ListView.builder(
                    itemCount: _listModelLeft.length,
                    itemBuilder: (context, index) {
                      return new InkWell(
                        splashColor: Colors.blueAccent,
                        onTap: () {
                          setState(() {
                            // _listModelLeft.forEach(
                            //     (element) => element.isAvailable = true);
                            if (_checkedLeft.isNotEmpty) {
                              // set clear
                              _listModelLeft[int.parse(_checkedLeft[0])]
                                  .isAvailable = true;
                              _checkedLeft.clear();
                              // set new
                              _listModelLeft[index].isAvailable = false;
                              _checkedLeft.add(index.toString());
                              _selectedID =
                                  _listModelLeft[index].detailLotID.toString();
                            } else {
                              _listModelLeft[index].isAvailable = false;
                              _checkedLeft.add(index.toString());
                              _selectedID =
                                  _listModelLeft[index].detailLotID.toString();
                            }
                            //set selected other side clear
                            if (_checkedRight.isNotEmpty) {
                              _listModelRight[int.parse(_checkedRight[0])]
                                  .isAvailable = true;
                              _checkedRight.clear();
                            }
                          });
                        },
                        child: new RadioItem(_listModelLeft[index]),
                      );
                    },
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Container(
                    width: double.infinity,
                    child: _bodyMap,
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: _listModelRight.length,
                    itemBuilder: (context, index) {
                      return new InkWell(
                        splashColor: Colors.blueAccent,
                        onTap: () {
                          setState(() {
                            // _listModelRight.forEach(
                            //     (element) => element.isAvailable = true);
                            if (_checkedRight.isNotEmpty) {
                              // set clear
                              _listModelRight[int.parse(_checkedRight[0])]
                                  .isAvailable = true;
                              _checkedRight.clear();
                              // set new
                              _listModelRight[index].isAvailable = false;
                              _checkedRight.add(index.toString());
                              _selectedID =
                                  _listModelRight[index].detailLotID.toString();
                            } else {
                              _listModelRight[index].isAvailable = false;
                              _checkedRight.add(index.toString());
                              _selectedID =
                                  _listModelRight[index].detailLotID.toString();
                            }
                            //set selected other side clear
                            if (_checkedLeft.isNotEmpty) {
                              _listModelLeft[int.parse(_checkedLeft[0])]
                                  .isAvailable = true;
                              _checkedLeft.clear();
                            }
                          });
                        },
                        child: new RadioItem(_listModelRight[index]),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );

    return new Scaffold(
      appBar: AppBar(
        backgroundColor: ColorLibrary.primary,
        title: Text(
          "Select Lot",
          style: TextStyle(fontFamily: 'Work Sans'),
        ),
      ),
      body: new Container(
        child: loading
            ? Center(child: _circularProgress())
            : new Column(
                children: <Widget>[
                  _info,
                  Expanded(
                    child: Container(
                      color: ColorLibrary.backgroundDark,
                      child: _content,
                    ),
                  ),
                  Container(
                    color: ColorLibrary.backgroundDark,
                    child: SizedBox(
                      height: 50,
                      width: double.infinity,
                      child: RaisedButton(
                        color: ColorLibrary.secondary,
                        child: Text(
                          "CHOOSE",
                          style: TextStyle(
                            fontFamily: 'Work Sans',
                          ),
                        ),
                        onPressed: () {
                          Navigator.of(context).pop(
                            PopWithResults(
                              fromPage: 'lotmap',
                              toPage: 'booking',
                              results: {
                                "lotID": _selectedID,
                                "detailLocID": detailID,
                                "detailName": detailName
                              },
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

// Expanded(
//                       child: Row(
//                         children: <Widget>[
//                           Expanded(
//                             flex: 2,
//                             child: ListView(
//                               children: <Widget>[
//                                 CheckboxGroup(
//                                   activeColor: ColorLibrary.secondary,
//                                   labels: _listLabelLeft,
//                                   disabled: _listDisableLeft,
//                                   checked: _checkedLeft,
//                                   onChange: (bool isChecked, String label,
//                                           int index) =>
//                                       print(
//                                           "isChecked: $isChecked   label: $label  index: $index"),
//                                   onSelected: (List selected) => setState(() {
//                                     if (selected.length > 1) {
//                                       selected.removeAt(0);
//                                       _checkedRight.clear();
//                                       print(
//                                           'selected length  ${selected.length}');
//                                     } else {
//                                       print("only one");
//                                       _checkedRight.clear();
//                                     }
//                                     _checkedLeft = selected;
//                                     _selectedID = selected[0].toString();
//                                   }),
//                                 )
//                               ],
//                             ),
//                           ),
//                           Expanded(
//                             flex: 2,
//                             child: ListView(
//                               children: <Widget>[
//                                 CheckboxGroup(
//                                   labels: _listLabelRight,
//                                   disabled: _listDisableRight,
//                                   checked: _checkedRight,
//                                   onChange: (bool isChecked, String label,
//                                           int index) =>
//                                       _selectedID = label,
//                                   onSelected: (List selected) => setState(() {
//                                     if (selected.length > 1) {
//                                       selected.removeAt(0);
//                                       print(
//                                           'selected length  ${selected.length}');
//                                       _checkedLeft.clear();
//                                     } else {
//                                       _checkedLeft.clear();
//                                       print("only one");
//                                     }
//                                     _checkedRight = selected;
//                                     _selectedID = selected[0].toString();
//                                   }),
//                                 )
//                               ],
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                     Expanded(
//                       child: Align(
//                         alignment: Alignment.bottomCenter,
//                         child: RaisedButton(
//                           child: Text("Choose"),
//                           onPressed: () {
//                             Navigator.of(context).pop(
//                               PopWithResults(
//                                 fromPage: 'lotmap',
//                                 toPage: 'booking',
//                                 results: {
//                                   "lotID": _selectedID,
//                                   "detailLocID": detailID,
//                                   "detailName": detailName
//                                 },
//                               ),
//                             );
//                           },
//                         ),
//                       ),
//                     ),
//                   ],
//                 )

class RadioItem extends StatelessWidget {
  final LotModel _item;
  RadioItem(this._item);

  @override
  Widget build(BuildContext context) {
    return new Container(
      margin: new EdgeInsets.all(5.0),
      child: new Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          new Container(
            height: 35.0,
            width: 35.0,
            child: new Center(
              child: new Text(_item.detailLotID.toString(),
                  style: new TextStyle(
                      color: _item.isAvailable
                          ? ColorLibrary.regularFontWhite
                          : ColorLibrary.primaryDark,
                      //fontWeight: FontWeight.bold,
                      fontSize: 12.0,
                      fontFamily: 'Work Sans')),
            ),
            decoration: new BoxDecoration(
              color:
                  _item.isAvailable ? Colors.transparent : ColorLibrary.primary,
              border: new Border.all(width: 1.0, color: ColorLibrary.primary),
              borderRadius: const BorderRadius.all(const Radius.circular(2.0)),
            ),
          ),
        ],
      ),
    );
  }
}
