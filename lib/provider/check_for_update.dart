import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:ndoujin/constraint.dart';
import 'package:ndoujin/utils/version_comparision.dart';
import 'package:ndoujin/model/check_for_update.dart';

part 'check_for_update.g.dart';

@riverpod
Future<AppUpdate> checkForUpdate(CheckForUpdateRef ref) async {
  const url =
      "https://api.github.com/repos/devyuji/ndoujin-app/releases/latest";

  final res = await Dio().get(url);
  final data = res.data;
  final latestVersion = data['tag_name'];

  if (!VersionComparision.isVersionGreaterThan(
      latestVersion.replaceAll('v', ''), appVersion)) {
    return AppUpdate(
      body: "App is up to date",
      versionName: latestVersion,
    );
  }
  const platform = MethodChannel('devyuji.com/ndoujin');

  final supportedABIS = await platform.invokeMethod('SupportedAbis');
  for (var i in data['assets']) {
    String name = i['name'];

    if (name.contains(supportedABIS)) {
      return AppUpdate(
        newVersion: true,
        body: data['body'],
        versionName: latestVersion,
        downloadUrl: i['browser_download_url'],
      );
    }
  }

  return const AppUpdate();
}
