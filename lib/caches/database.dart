import 'package:sqflite/sqflite.dart';

DatabaseHelper databaseHelper;

class DatabaseHelper {
  final Database _db;
  DatabaseHelper(this._db);

  static Future<DatabaseHelper> init(Database db) async {
    DatabaseHelper dbh = DatabaseHelper(db);
    bool check = await dbh._dbCheck();
    if(!check){
      await dbh._create();
    }
    return dbh;
  }

  Future<bool> _dbCheck() async {
    List<Map<String,dynamic>> animeListCheck = await _db.rawQuery('SELECT * FROM animes LIMIT 1;');
    if (animeListCheck.length > 0) {
      return true;
    } else {
      return false;
    }
  }

  Future<List<Map<String,dynamic>>> query(String sql) async => await this._db.rawQuery(sql);

  _create() async {
    await _db.execute('CREATE TABLE animes ('
        'id int NOT NULL PRIMARY KEY,'
        'name varchar(255) NOT NULL'
        'description text,'
        'image blob);');
    await _db.execute('CREATE TABLE watchlist (anime_id int NOT NULL PRIMARY KEY);');
    //_db.execute('history');
  }
}