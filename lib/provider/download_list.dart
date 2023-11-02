import "package:ndoujin/database/download.dart";
import "package:ndoujin/model/download.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";

part 'download_list.g.dart';

@riverpod
class DownloadList extends _$DownloadList {
  Future<List<Downloads>> _getData() async {
    final data = await Downloaded.instance.readAll();

    return data.reversed.toList();
  }

  @override
  Future<List<Downloads>> build() => _getData();

  Future<void> create(Downloads data) async {
    state = const AsyncValue.loading();

    state = await AsyncValue.guard(() async {
      await Downloaded.instance.create(data);
      return _getData();
    });
  }

  Future<void> delete(int id) async {
    await Downloaded.instance.delete(id);
    state.whenData((value) => value.removeWhere((element) => element.id == id));

    ref.notifyListeners();
  }
}
