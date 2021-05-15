/*
 * Copyright 2020-2021 TailsxKyuubi
 * This code is part of inoffizielle-AoD-App and licensed under the AGPL License
 */

import 'package:unoffical_aod_app/caches/anime.dart';
import 'package:unoffical_aod_app/caches/animes.dart';
import 'package:unoffical_aod_app/caches/database.dart';

class WatchListCache {
  List<Anime> _elements = [];

  WatchListCache();

  static Future<WatchListCache> _init() async {
    WatchListCache watchListCache = WatchListCache();
    List<Map> watchListIds = await databaseHelper.query('SELECT * FROM wishlist');
    watchListIds.forEach((Map element) {
      watchListCache._elements.add(animesLocalCache.getSingle(int.parse(element['id'])));
    });
    return watchListCache;
  }

  bool add(Anime anime) {
    if(this._elements.indexOf(anime) == -1){
      this._elements.add(anime);
      databaseHelper.query('INSERT INTO watchlist (int) VALUES ('+anime.id.toString()+')');
      return true;
    }
    return false;
  }

  bool delete(Anime anime){
    if(this._elements.indexOf(anime) == -1){
      this._elements.remove(anime);
      databaseHelper.query('DELETE FROM watchlist WHERE id = '+anime.id.toString()+'');
      return true;
    }
    return false;
  }
}