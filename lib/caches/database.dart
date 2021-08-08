import 'package:sqflite/sqflite.dart';
import 'package:unoffical_aod_app/caches/animes.dart';
import 'package:unoffical_aod_app/caches/episode_progress.dart';
import 'package:unoffical_aod_app/caches/watchlist.dart';

DatabaseHelper databaseHelper;

class DatabaseHelper {
  final Database _db;
  DatabaseHelper(this._db);

  String formatTime(Duration timestamp) {
    int durationSeconds = timestamp.inSeconds;
    return (durationSeconds/3600).floor().toString().padLeft(2,'0')+':'+
        ((durationSeconds%3600)/60).floor().toString().padLeft(2,'0')+':'+
        (durationSeconds%60).toString().padLeft(2,'0');
  }

  Future<List<Map<String,dynamic>>> query(String sql) async => await this._db.rawQuery(sql);

  Future<int> update(String table, Map<String, dynamic> values,[String where]) async
    => await this._db.update(table, values, where: where);

  static create(Database _db, int version) async {
    print('Datenbank tabellen werden erstellt');
    switch(version){
      case 1:
        await _db.execute('CREATE TABLE IF NOT EXISTS animes (' +
            'anime_id int NOT NULL,' +
            'name varchar(255) NOT NULL,' +
            'description text,' +
            'image blob);');
        await _db.execute('CREATE TABLE IF NOT EXISTS watchlist (anime_id int NOT NULL PRIMARY KEY, created_at timestamp DEFAULT CURRENT_TIMESTAMP);');
        await _db.execute('CREATE TABLE IF NOT EXISTS history (media_id int NOT NULL, language varchar(3) NOT NULL, progress time NOT NULL, created_at timestamp DEFAULT CURRENT_TIMESTAMP);');
        await _db.execute('CREATE TABLE IF NOT EXISTS episodes (media_id int NOT NULL PRIMARY KEY, anime_id int NOT NULL, title varchar(255) NOT NULL,image blob NOT NULL, duration time DEFAULT \'99:99:99\');');
        await _db.execute('CREATE TABLE IF NOT EXISTS watchlist (anime_id int NOT NULL PRIMARY KEY, created_at timestamp DEFAULT CURRENT_TIMESTAMP);');
        break;
    }
  }
  insert(String table, Map<String, dynamic> values) => _db.insert(table, values);

  static init(Database _db) async {
    databaseHelper = DatabaseHelper(_db);
    episodeProgressCache = await EpisodeProgressCache.init();
    animesLocalCache = await AnimesLocalCache.init();
    watchListCache = await WatchListCache.init();
  }
}