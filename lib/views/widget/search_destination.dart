import 'package:flutter/material.dart';

class SearchDestination extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    Widget _cardWidget = new Container(
      width: double.infinity,
      height: 150.0,
      child: Text("data"),
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(8.0)
      ),
    );

    Widget _compileWidget = new Container(
      child: _cardWidget,
    );
    return _compileWidget;
  }
}
