import 'package:flutter/material.dart';
import 'package:user_pijar/models/topup_model.dart';
import 'package:user_pijar/views/widget/color_library.dart';
import 'package:user_pijar/views/widget/topup_row.dart';

class TopupPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Widget topWidget = new Container(
      width: double.infinity,
      color: Colors.blueGrey,
      child: new Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(top: 15.0),
            child: Text("Your LinkAja! Balance"),
          ),
          Padding(
            padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
            child: Text(
              "Rp 300.000",
              style: TextStyle(fontSize: 42),
            ),
          )
        ],
      ),
    );

    Widget midWidget = new Scaffold(
      body: new CustomScrollView(
      scrollDirection: Axis.vertical,
      shrinkWrap: false,
      slivers: <Widget>[
        new SliverPadding(
          padding: const EdgeInsets.symmetric(vertical: 12.0),
          sliver: new SliverList(
            delegate: new SliverChildBuilderDelegate(
              (context, index) => new TopupRow(topupList[index]),
              childCount: topupList.length,
            ),
          ),
        ),
      ],
    ),
    );

    Widget compileWidget = new Column(
      children: <Widget>[topWidget, Expanded(
        child: midWidget,
      )],
    );

    return new Scaffold(
      appBar: AppBar(
        title: Text("Top Up LinkAja!"),
        backgroundColor: ColorLibrary.primary,
      ),
      body: compileWidget,
    );
  }
}
