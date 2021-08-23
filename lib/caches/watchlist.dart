/*
 * Copyright 2020-2021 TailsxKyuubi
 * This code is part of inoffizielle-AoD-App and licensed under the AGPL License
 */

import 'package:unoffical_aod_app/caches/anime.dart';
import 'package:unoffical_aod_app/caches/animes.dart';
import 'package:unoffical_aod_app/caches/database.dart';

late WatchListCache watchListCache;

class WatchListCache {
  List<Anime> _elements = [];

  static Future<WatchListCache> init() async {
    WatchListCache watchListCache = WatchListCache();
    List<Map> watchListIds = await databaseHelper.query('SELECT * FROM watchlist');
    watchListIds.forEach((Map element) {
      watchListCache._elements.add(animesLocalCache!.getSingle(element['anime_id'])!);
    });
    return watchListCache;
  }

  List<Anime> getAll() => _elements;

  bool add(Anime anime) {
    if(this._elements.indexOf(anime) == -1){
      this._elements.add(anime);
      databaseHelper.query('INSERT INTO watchlist (anime_id) VALUES ('+anime.id.toString()+')');
      return true;
    }
    return false;
  }

  Anime? searchByAnimeId(int id){
    try {
      return this._elements.firstWhere((element) => element.id == id);
    }catch(exception){
      return null;
    }
  }

  bool delete(Anime anime){
    if(this._elements.indexOf(anime) != -1){
      this._elements.remove(anime);
      databaseHelper.query('DELETE FROM watchlist WHERE anime_id = '+anime.id.toString()+'');
      return true;
    }
    return false;
  }
}