import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import 'package:ndoujin/model/list.dart';

class FavouriteDB {
  static final FavouriteDB instance = FavouriteDB();

  static Database? _database;
  final String _tableName = "favourite";

  static Future<String> getDbPath() async {
    final path = await getApplicationDocumentsDirectory();

    return join(path.path, "database", "favourite.db");
  }

  Future<Database?> get _openDb async {
    if (_database != null) return _database!;

    final dataBasePath = await getDbPath();

    _database =
        await openDatabase(dataBasePath, version: 1, onCreate: _onCreate);

    return _database;
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute(
        "CREATE TABLE $_tableName (id INTEGER PRIMARY KEY, source TEXT NOT NULL, image BLOB NOT NULL, code TEXT NOT NULL)");
  }

  Future<List<Nhentai>> readAll() async {
    List<Nhentai> result = [];
    final db = await instance._openDb;

    final data = await db!.query(_tableName);

    if (data.isEmpty) return result;

    for (var i in data) {
      result.add(Nhentai.fromJSON(i));
    }

    return result;
  }

  Future<int> add(Nhentai data) async {
    final db = await instance._openDb;
    final id = await db!.insert(_tableName, data.toJSON());
    return id;
  }

  Future deleteAll() async {
    final db = await instance._openDb;
    await db!.delete(_tableName);
  }

  Future<void> delete(int id) async {
    final db = await instance._openDb;

    await db!.delete(_tableName, where: "id = ?", whereArgs: [id]);
  }
}
