import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter/material.dart';

class WebViewStack extends ConsumerStatefulWidget {
  const WebViewStack({required this.controller, super.key});

  final WebViewController controller;

  @override
  ConsumerState<WebViewStack> createState() => _WebViewStackState();
}

class _WebViewStackState extends ConsumerState<WebViewStack> {
  var loadingPercentage = 0;
  bool showMenu = true;

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  void initState() {
    super.initState();

    widget.controller
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (url) {
            setState(() {
              loadingPercentage = 0;
            });
          },
          onProgress: (progress) {
            setState(() {
              loadingPercentage = progress;
            });
          },
          onPageFinished: (url) async {
            setState(() {
              loadingPercentage = 100;
            });
          },
        ),
      )
      ..enableZoom(true)
      ..setJavaScriptMode(JavaScriptMode.unrestricted);
  }

  @override
  void dispose() {
    widget.controller.removeJavaScriptChannel("parser");
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        WebViewWidget(
          controller: widget.controller,
        ),
        if (loadingPercentage < 100)
          LinearProgressIndicator(
            value: loadingPercentage / 100.0,
            minHeight: 4,
          ),
      ],
    );
  }
}
