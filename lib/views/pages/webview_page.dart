import 'dart:async';

import 'package:flutter/material.dart';
import 'package:user_pijar/views/widget/color_library.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewPage extends StatefulWidget {
  final String title;
  final String linkUrl;

  WebViewPage(
    this.title,
    this.linkUrl,
  );

  @override
  _WebViewPageState createState() => _WebViewPageState();
}

class _WebViewPageState extends State<WebViewPage> {
  final Completer<WebViewController> _completer =
      Completer<WebViewController>();

  bool isLoading = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        backgroundColor: ColorLibrary.primary,
        title: Text(
          widget.title,
          style: TextStyle(fontFamily: 'Work Sans'),
        ),
      ),
      body: new Stack(
        children: <Widget>[
          WebView(
            initialUrl: widget.linkUrl,
            javascriptMode: JavascriptMode.unrestricted,
            onWebViewCreated: (WebViewController webViewController) {
              _completer.complete(webViewController);
            },
            onPageFinished: (_) {
              setState(() {
                isLoading = false;
              });
            },
          ),
          isLoading
              ? Center(
                  child: CircularProgressIndicator(
                                        backgroundColor: ColorLibrary.primary,
                    valueColor:
                        AlwaysStoppedAnimation<Color>(ColorLibrary.secondary),
                  ),
                )
              : Container(),
        ],
      ),
    );
  }
}
