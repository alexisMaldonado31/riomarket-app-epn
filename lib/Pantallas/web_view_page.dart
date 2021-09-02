import 'dart:async';

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewPage extends StatefulWidget {
  
  final String _url;
  final String _title;
  WebViewPage(this._url, this._title);

  @override
  _WebViewPageState createState() => _WebViewPageState();
}

class _WebViewPageState extends State<WebViewPage> {
  Completer<WebViewController> _controller = Completer<WebViewController>();

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(
        title: Text(widget._title, textScaleFactor: 1.0),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10.0),
        child: WebView(
          initialUrl: widget._url,
          onWebViewCreated: (WebViewController controller){
            _controller.complete(controller);
          },

        ),
      )
    );
  }
}