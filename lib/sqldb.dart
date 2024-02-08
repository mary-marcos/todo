import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class SqlDb {
  //static DatabaseFactory? databaseFactory;
  static Database? _db;

  Future<Database?> get db async {
    if (_db == null) {
      // Check if databaseFactory is already initialized

      _db = await initialDb();
      return _db;
    } else {
      return _db;
    }
  }

  initialDb() async {
    String databasepath = await getDatabasesPath();
    String path = join(databasepath, 'note.db');
    //databaseFactory = databaseFactoryFfi;
    Database mydb = await openDatabase(path,
        onCreate: _onCreate, version: 2, onUpgrade: _onUpgrade);
    return mydb;
  }

  _onUpgrade(Database db, int oldversion, int newversion) {
    print("onupgrade ======================");
  }

  _onCreate(Database db, int version) async {
    await db.execute('''
CREATE TABLE "notes"(
  "id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
  "note" TEXT NOT NULL,
  "date" TEXT NOT NULL,
  "time" TEXT NOT NULL,
  "description" TEXT ,
  "done" BOOLEAN NOT NULL DEFAULT 0
)


''');
    print("created ============");
  }

  readData(String sql) async {
    Database? mydb = await db;
    List<Map<String, Object?>> response = await mydb!.rawQuery(sql);
    return response;
  }

  insertData(String sql) async {
    Database? mydb = await db;
    int response = await mydb!.rawInsert(sql);
    return response;
  }

  updateData(String sql) async {
    Database? mydb = await db;
    int response = await mydb!.rawUpdate(sql);
    return response;
  }

  deleteData(String sql) async {
    Database? mydb = await db;
    int response = await mydb!.rawDelete(sql);
    return response;
  }

  deleteAllDatabase() async {
    String databasepath = await getDatabasesPath();
    String path = join(databasepath, 'note.db');
    await deleteDatabase(path);
    print("deleted");
  }
}
