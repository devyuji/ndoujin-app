import "dart:io";
import "dart:isolate";
import "dart:math";
import 'dart:async';

import "package:archive/archive.dart";
import "package:dio/dio.dart";
import "package:flutter/services.dart";
import "package:ndoujin/model/download.dart";
import "package:ndoujin/provider/download_list.dart";
import "package:ndoujin/utils/convert_to_memory.dart";
import "package:ndoujin/utils/notification_service.dart";
import "package:ndoujin/utils/show_toast.dart";
import "package:path_provider/path_provider.dart";
import "package:permission_handler/permission_handler.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";
import "package:webview_cookie_manager/webview_cookie_manager.dart";
import "package:html/dom.dart" as dom;
import 'package:path/path.dart' as pa;
import 'package:async/async.dart';

part 'download_queue.g.dart';

Future<Map<String, Object>> _download(SendPort p) async {
  final commandPort = ReceivePort();
  p.send(commandPort.sendPort);

  final notificationService = NotificationService();
  final cookieManager = WebviewCookieManager();

  await for (final message in commandPort) {
    final url = message['url'];
    BackgroundIsolateBinaryMessenger.ensureInitialized(message['rootToken']);
    String code = "";
    final codeParse = url.split('/');
    if (codeParse.length > 6) {
      code = codeParse[codeParse.length - 3];
    } else {
      code = codeParse[codeParse.length - 2];
    }

    try {
      final path = await getExternalStorageDirectory();
      final downloadPath = pa.join(path!.path, "download");

      final archive = Archive();

      String cookiesStr = "";
      final gotCookies = await cookieManager.getCookies(url);
      for (var item in gotCookies) {
        cookiesStr += "${item.name}=${item.value}; ";
      }

      final dio = Dio(
        BaseOptions(
          headers: {
            "Cookie": cookiesStr,
            "User-Agent": message['userAgent'],
            "Connection": "Keep-Alive",
          },
        ),
      );

      final res = await dio.get("https://nhentai.net/g/$code/");

      ShowToast.show("Download Started");

      final doc = dom.Document.html(res.data);

      final images = doc.querySelectorAll(".thumb-container");

      List<String> l = [];

      for (var image in images) {
        var s = image.querySelector('img')!.attributes['data-src'];
        Uri uri = Uri.parse(s!);
        uri = uri.replace(host: "i3.nhentai.net");

        String convertedUrl = uri.toString().replaceFirstMapped(
            RegExp(r'/(\d+)t\.'), (match) => '/${match.group(1)}.');

        l.add(convertedUrl);
      }

      for (var i = 0; i < l.length; i++) {
        final response = await Dio(
          BaseOptions(
            responseType: ResponseType.bytes,
          ),
        ).get(l[i]);
        final zipFile = ArchiveFile.noCompress(
            '${i + 1}', response.data.length, response.data);
        archive.addFile(zipFile);

        notificationService.showProgressNotification(
            int.parse(code), l.length, i + 1);
      }
      final zipEncoder = ZipEncoder();
      final zipBytes = zipEncoder.encode(archive);

      Directory(downloadPath).create();
      final filePath = pa.join(downloadPath, "$code.cbz");

      File(filePath).writeAsBytesSync(zipBytes!);

      // save to database record
      final coverDir = pa.join(path.path, 'covers');
      Directory(coverDir).create();
      final coverImage = await ConvertToMemory(imageurl: l[0]).convert();

      final coverPath = pa.join(coverDir, _generateRandomString());
      File(coverPath).writeAsBytesSync(coverImage);

      notificationService.showNotifications(
          "Download complete", int.parse(code));

      p.send({"status": "ok", "filePath": filePath, "coverImage": coverPath});
    } catch (err) {
      print(err);
      notificationService.showNotifications("Download Failed", int.parse(code));

      p.send({"status": "fail"});
    }
  }

  Isolate.exit();
}

String _generateRandomString() {
  final random = Random(DateTime.now().millisecondsSinceEpoch);
  const charset =
      'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
  String result = '';

  for (int i = 0; i < 10; i++) {
    result += charset[random.nextInt(charset.length)];
  }

  return result;
}

@riverpod
Future<void> downloadQueue(DownloadQueueRef ref,
    {required String url, required String userAgent}) async {
  ref.keepAlive();

  await Permission.notification.request();

  final receivePort = ReceivePort();

  await Isolate.spawn(_download, receivePort.sendPort);

  final events = StreamQueue<dynamic>(receivePort);

  SendPort sendPort = await events.next;

  final rootToken = ServicesBinding.rootIsolateToken;

  sendPort.send({"url": url, "userAgent": userAgent, "rootToken": rootToken});

  final res = await events.next;

  final v = Downloads.fromJSON(res);

  ref.read(downloadListProvider.notifier).create(v);
}
