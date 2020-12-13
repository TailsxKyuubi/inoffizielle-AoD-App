import 'package:shared_preferences/shared_preferences.dart';

EpisodeProgressCache episodeProgressCache;
class EpisodeProgressCache {

  SharedPreferences _sharedPreferences;
  bool isReady;
  Map<int,Map<String,Duration>> _cache = {};

  EpisodeProgressCache(){
    SharedPreferences.getInstance().then((value){
      _sharedPreferences = value;
      _bootUp();
      isReady = true;
    });
  }

  _bootUp(){
    List<String> ids = _sharedPreferences.getStringList('tracking.mediaIds');
    if(ids != null){
      ids.forEach((String element) {
        List<String> idArray = element.split('-');
        int mediaId = int.parse(idArray[0]);
        String lang;
        if(idArray.length == 1){
          lang = 'jap';
        }else{
          lang = idArray[1];
        }
        this._cache.addAll({
          mediaId: {
            lang: this._initEpisode( mediaId, lang )
          }
        });
      });
    }else{
      _saveMediaList();
    }
  }

  addEpisode(int mediaId, Duration timeCode,String lang){
    if( ! this._cache.containsKey(mediaId) ){
      this._cache.addAll( { mediaId: { lang: timeCode } } );
      this._saveMediaList();
    }else{
      this._cache[mediaId][lang] = timeCode;
    }
    this._saveEpisodeDuration(mediaId, timeCode, lang);
  }

  Duration getEpisodeDuration(int mediaId, String lang){
    if(this._cache.containsKey(mediaId) && this._cache[mediaId].containsKey(lang)){
      return this._cache[mediaId][lang];
    }
    return Duration(hours: 0,minutes: 0, seconds: 0);
  }

  _saveEpisodeDuration(int mediaId, Duration timeCode, String lang){
    this._sharedPreferences.remove('tracking.'+mediaId.toString());
    this._sharedPreferences.setString('tracking.'+mediaId.toString()+'-'+lang, _durationToString(timeCode) );
  }

  String _durationToString(Duration timeCode){
    return (timeCode.inSeconds / 3600).floor().toString() + ':'
        + ((timeCode.inSeconds % 3600)/60).floor().toString()+ ':'
        + (timeCode.inSeconds % 60).toString();
  }

  _saveMediaList(){
    _sharedPreferences.setStringList('tracking.mediaIds', _cache.keys.map((e) => e.toString()).toList(growable: false));
  }

  Duration _initEpisode(int mediaId, String lang){
    List<String> durationList = _sharedPreferences
        .getString('tracking.'+mediaId.toString()+'-'+lang)
        .split(':');
    return Duration(
      hours: int.parse(durationList[0]),
      minutes: int.parse(durationList[1]),
      seconds: int.parse(durationList[2])
    );
  }
}