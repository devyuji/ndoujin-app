import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:ndoujin/database/favorite.dart';
import 'package:ndoujin/model/list.dart';

part 'list_feed.g.dart';

@riverpod
class ListFeed extends _$ListFeed {
  @override
  Future<List<Nhentai>> build() {
    return _getData();
  }

  Future<List<Nhentai>> _getData() async {
    final data = await FavouriteDB.instance.readAll();

    return data.reversed.toList();
  }

  void add(Nhentai value) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await FavouriteDB.instance.add(value);
      return _getData();
    });
  }

  Future<void> remove(int id) async {
    await FavouriteDB.instance.delete(id);
    state.whenData((value) => value.removeWhere((element) => element.id == id));

    ref.notifyListeners();
  }
}
