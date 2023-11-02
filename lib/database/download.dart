import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import 'package:ndoujin/model/download.dart';

class Downloaded {
  static final Downloaded instance = Downloaded();

  static Database? _database;
  final String _tableName = "downloads";

  Future<Database?> get _openDb async {
    if (_database != null) return _database!;

    final path = await getApplicationDocumentsDirectory();

    final dataBasePath = join(path.path, "database", "downloads.db");

    _database =
        await openDatabase(dataBasePath, version: 1, onCreate: _onCreate);

    return _database;
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute(
        "CREATE TABLE $_tableName (id INTEGER PRIMARY KEY, filePath TEXT NOT NULL, coverImage TEXT NOT NULL)");
  }

  Future<List<Downloads>> readAll() async {
    List<Downloads> result = [];
    final db = await instance._openDb;

    final data = await db!.query(_tableName);

    if (data.isEmpty) return result;

    for (var i in data) {
      result.add(Downloads.fromJSON(i));
    }

    return result;
  }

  Future<int> create(Downloads data) async {
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
