class Downloads {
  Downloads({
    required this.filePath,
    required this.coverImage,
    this.id,
  });

  final String filePath;
  final String coverImage;
  int? id;

  factory Downloads.fromJSON(Map<String, dynamic> data) {
    return Downloads(
      coverImage: data['coverImage'],
      filePath: data['filePath'],
      id: data["id"],
    );
  }

  Map<String, dynamic> toJSON() {
    return {
      "coverImage": coverImage,
      "filePath": filePath,
      if (id != null) "id": id
    };
  }
}
