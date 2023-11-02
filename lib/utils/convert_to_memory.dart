import "dart:typed_data";

import "package:dio/dio.dart";

class ConvertToMemory {
  const ConvertToMemory({required this.imageurl});

  final String imageurl;

  Future<Uint8List> convert() async {
    if (imageurl.isEmpty) {
      return Uint8List.fromList([]);
    }

    final dio = Dio(
      BaseOptions(
        responseType: ResponseType.bytes,
      ),
    );

    try {
      final res = await dio.get(imageurl);
      return Uint8List.fromList(res.data);
    } catch (err) {
      return Uint8List.fromList([]);
    }
  }
}
