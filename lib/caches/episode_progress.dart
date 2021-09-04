/*
 * Copyright 2020-2021 TailsxKyuubi
 * This code is part of inoffizielle-AoD-App and licensed under the AGPL License
 */

import 'package:shared_preferences/shared_preferences.dart';
import 'package:unoffical_aod_app/caches/database.dart';
import 'package:unoffical_aod_app/caches/episode_history.dart';

late EpisodeProgressCache episodeProgressCache;
class EpisodeProgressCache {

  final SharedPreferences _sharedPreferences;
  Map<int,Map<String,Duration>> _cache = {};
  List<EpisodeHistory> _history = [];

  EpisodeProgressCache(this._sharedPreferences);

  @Deprecated('Will be removed in 0.10')
  _bootUp(){
    List<String>? ids = _sharedPreferences.getStringList('tracking.mediaIds');
    if(ids != null) {
      ids.forEach((String element) {
        List<String> idArray = element.split('-');
        int mediaId = int.parse(idArray[0]);
        String lang;
        if (idArray.length == 1) {
          return;
        } else {
          lang = idArray[1];
        }
        Duration? duration = this._initEpisode(mediaId, lang);
        if(duration != null) {
          this._cache.addAll({
            mediaId: {
              lang: duration
            }
          });
        }
      });
      this._convertHistory();
      this._sharedPreferences.remove('tracking.mediaIds');
    }
  }

  static init() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    EpisodeProgressCache episodeProgressCache = EpisodeProgressCache(sharedPreferences);
    print('Daten aus Datenbank werden geladen');
    episodeProgressCache._bootUp();
    return episodeProgressCache;
  }

  List<EpisodeHistory> getAll() => this._history;

  void _convertHistory() {
    this._cache.forEach((int mediaId, Map<String,Duration> language) {
      language.forEach((languageCode, timeCode) {
        this.addEpisode(mediaId, timeCode, languageCode);
        this._sharedPreferences.remove('tracking.' +  mediaId.toString() + '-' + languageCode);
      });
      this._cache.remove(mediaId);
    });
  }

  void addEpisode(int mediaId, Duration timeCode, String lang) async {
    await databaseHelper.query('INSERT INTO history (media_id, language, progress) VALUES (' + mediaId.toString() + ', \''+lang+'\', \'' + databaseHelper.formatTime(timeCode) + '\');');

  }

  void updateEpisode(int rowId, Duration timeCode) async {
    await databaseHelper.update('history', {
      'progress':  databaseHelper.formatTime(timeCode)
    }, 'ROWID = ' + rowId.toString());
  }

  Duration getEpisodeDuration(int mediaId, String lang){
    if(this._cache.containsKey(mediaId) && this._cache[mediaId]!.containsKey(lang)){
      return this._cache[mediaId]![lang]!;
    }
    return Duration(hours: 0,minutes: 0, seconds: 0);
  }

  @Deprecated('will be removed in 0.10')
  Duration? _initEpisode(int mediaId, String lang){
    String? durationString = _sharedPreferences
        .getString('tracking.'+mediaId.toString()+'-'+lang);
    if(durationString != null){
      List<String> durationList = durationString.split(':');
      return Duration(
          hours: int.parse(durationList[0]),
          minutes: int.parse(durationList[1]),
          seconds: int.parse(durationList[2])
      );
    }
    return null;
  }
}