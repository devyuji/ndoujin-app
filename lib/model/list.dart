import 'dart:typed_data';

class Nhentai {
  Nhentai({
    required this.image,
    required this.source,
    required this.code,
    this.id,
  });

  final Uint8List image;
  final String source;
  final String code;
  int? id;

  factory Nhentai.fromJSON(Map<String, dynamic> data) {
    return Nhentai(
      image: data['image'],
      source: data['source'],
      id: data['id'],
      code: data['code'],
    );
  }

  Map<String, dynamic> toJSON() {
    return {
      "image": image,
      "source": source,
      "code": code,
      if (id != null) "id": id
    };
  }
}
