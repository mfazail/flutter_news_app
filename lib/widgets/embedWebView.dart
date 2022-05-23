import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:webview_flutter/webview_flutter.dart';

class EmbedWebView extends StatefulWidget {
  final RenderContext child;
  const EmbedWebView({Key? key, required this.child}) : super(key: key);

  @override
  _EmbedWebViewState createState() => _EmbedWebViewState();
}

class _EmbedWebViewState extends State<EmbedWebView> {
  double? webViewHieght;
  WebViewController? _webViewController;
  @override
  void dispose() {
    _webViewController = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: webViewHieght != null ? webViewHieght : 500,
      child: WebView(
        initialUrl: Uri.dataFromString(
          """
            <!DOCTYPE html>
            <html lang="en">
            <head>
              <meta charset="UTF-8">
              <meta http-equiv="X-UA-Compatible" content="IE=edge">
              <meta name="viewport" content="width=device-width, initial-scale=1.0">
            </head>
            <body style="overflow:auto;">
                ${widget.child.tree.element!.outerHtml}
              <script async src="https://www.instagram.com/embed.js"></script>
              <script async src="https://platform.twitter.com/widgets.js" charset="utf-8"></script>
            </body>
          </html>
          """,
          mimeType: 'text/html',
          encoding: Encoding.getByName('utf-8'),
        ).toString(),
        javascriptMode: JavascriptMode.unrestricted,
        onWebViewCreated: (controller) {
          _webViewController = controller;
        },
        onPageFinished: (s) async {
          if (_webViewController != null) {
            webViewHieght = double.tryParse(await _webViewController!
                    .evaluateJavascript(
                        'document.documentElement.offsetHeight'))! *
                2.5;
            setState(() {});
            print("String - $webViewHieght");
          }
        },
      ),
    );
  }
}
