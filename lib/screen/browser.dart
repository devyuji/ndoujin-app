import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ndoujin/provider/download_queue.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_cookie_manager/webview_cookie_manager.dart';
import "package:html/dom.dart" as dom;

import 'package:ndoujin/model/list.dart';
import 'package:ndoujin/widgets/webview.dart';
import 'package:ndoujin/provider/list_feed.dart';
import 'package:ndoujin/utils/convert_to_memory.dart';
import 'package:ndoujin/utils/show_toast.dart';
import 'package:ndoujin/widgets/snackbar.dart';
import 'package:ndoujin/constraint.dart';
import 'package:ndoujin/provider/ui.dart';

class BrowserScreen extends ConsumerStatefulWidget {
  const BrowserScreen({
    required this.url,
    super.key,
  });

  final String url;

  @override
  ConsumerState<BrowserScreen> createState() => _BrowserScreenState();
}

class _BrowserScreenState extends ConsumerState<BrowserScreen> {
  late final WebViewController _controller;
  final cookieManager = WebviewCookieManager();

  @override
  void initState() {
    super.initState();

    _controller = WebViewController()
      ..loadRequest(
        Uri.parse(widget.url),
      );
  }

  Future<void> _addToFavorite() async {
    ref.read(isAddingProvider.notifier).update(true);

    final url = await _controller.currentUrl();

    final parser = Uri.parse(url!);

    if (parser.path.contains("/g/")) {
      try {
        String cookiesStr = "";
        final gotCookies = await cookieManager.getCookies(url);
        for (var item in gotCookies) {
          cookiesStr += "${item.name}=${item.value}; ";
        }

        Object userAgent = await _controller
            .runJavaScriptReturningResult('navigator.userAgent');
        userAgent = userAgent.toString().replaceAll('"', '');

        String code = "";
        final codeParse = url.split('/');
        if (codeParse.length > 6) {
          code = codeParse[codeParse.length - 3];
        } else {
          code = codeParse[codeParse.length - 2];
        }

        final dio = Dio(
          BaseOptions(
            headers: {
              "Cookie": cookiesStr,
              "User-Agent": userAgent,
              "Connection": "Keep-Alive",
            },
          ),
        );

        final res = await dio.get("https://nhentai.net/g/$code/");

        final doc = dom.Document.html(res.data);

        final coverImage =
            doc.querySelector("#cover img")!.attributes['data-src'];

        final image = await ConvertToMemory(imageurl: coverImage!).convert();

        final send = Nhentai(
          image: image,
          source: "https://nhentai.net/g/$code/1",
          code: code,
        );

        // store to database
        ref.read(listFeedProvider.notifier).add(send);

        if (!mounted) return;
        customSnackbar(context, "Successfully added");
      } catch (err) {
        print(err);
        if (!mounted) return;
        customSnackbar(context, "Unable to add");
      } finally {
        ref.read(isAddingProvider.notifier).update(false);
      }
    }
  }

  Future<void> _copyToClipboard() async {
    final url = await _controller.currentUrl();
    await Clipboard.setData(ClipboardData(text: url!));
    await ShowToast.show("copied!");
  }

  Future<void> _handleClick(String value) async {
    switch (value) {
      case 'Copy url':
        _copyToClipboard();
        break;
      case 'Reload':
        await _controller.reload();
        break;
      case "Download":
        final url = await _controller.currentUrl();

        final uri = Uri.parse(url!);

        if (!uri.path.contains("/g")) {
          ShowToast.show("You cannot download invalid!");
          break;
        }

        Object userAgent = await _controller
            .runJavaScriptReturningResult('navigator.userAgent');
        userAgent = userAgent.toString().replaceAll('"', '');

        ref.read(
            downloadQueueProvider(userAgent: userAgent as String, url: url));

        break;
    }
  }

  Future<bool> _exitApp() async {
    if (await _controller.canGoBack()) {
      await _controller.goBack();

      return Future.value(false);
    }

    return Future.value(true);
  }

  @override
  Widget build(BuildContext context) {
    final isAdding = ref.watch(isAddingProvider);

    return WillPopScope(
      onWillPop: _exitApp,
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.close_outlined),
            tooltip: "close",
          ),
          actions: [
            IconButton(
              onPressed: () async {
                await _controller.loadRequest(Uri.parse("https://nhentai.net"));
              },
              icon: const Icon(Icons.home),
              iconSize: 20,
              tooltip: "Home",
            ),
            isAdding
                ? Container(
                    width: 40,
                    height: 40,
                    padding: const EdgeInsets.all(kDefaultPadding / 2),
                    child: const CircularProgressIndicator(
                      strokeWidth: 2,
                    ),
                  )
                : IconButton(
                    onPressed: _addToFavorite,
                    icon: const Icon(Icons.add_outlined),
                  ),
            PopupMenuButton<String>(
              onSelected: _handleClick,
              itemBuilder: (BuildContext context) {
                return {"Download", 'Copy url', "Reload"}.map((String choice) {
                  return PopupMenuItem<String>(
                    value: choice,
                    child: Text(choice, style: TextStyle(fontWeight: FontWeight.w600,)),
                  );
                }).toList();
              },
            ),
          ],
        ),
        body: WebViewStack(
          controller: _controller,
        ),
      ),
    );
  }
}
