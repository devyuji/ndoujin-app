import "dart:io";
import "dart:typed_data";

import "package:archive/archive.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";

part "read_download_file.g.dart";

@riverpod
Future<List<Uint8List>> readFile(ReadFileRef ref,
    {required String path}) async {
  List<Uint8List> images = [];
  final file = File(path);
  final bytes = await file.readAsBytes();

  final zipEncoder = ZipDecoder();
  final zipBytes = zipEncoder.decodeBytes(bytes);

  for (var i in zipBytes.files) {
    images.add(i.content);
  }

  return images;
}
