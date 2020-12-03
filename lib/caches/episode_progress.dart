import 'package:shared_preferences/shared_preferences.dart';

EpisodeProgressCache episodeProgressCache;
class EpisodeProgressCache {

  SharedPreferences _sharedPreferences;
  bool isReady;
  Map<int,Duration> _cache = {};

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
        int mediaId = int.parse(element);
        this._cache.addAll({
          mediaId: this._initEpisode(mediaId)
        });
      });
    }else{
      _saveMediaList();
    }
  }

  addEpisode(int mediaId, Duration timeCode){
    if( ! this._cache.containsKey(mediaId) ){
      this._cache.addAll( { mediaId: timeCode } );
      this._saveMediaList();
    }else{
      this._cache[mediaId] = timeCode;
    }
    this._saveEpisodeDuration(mediaId, timeCode);
  }

  Duration getEpisodeDuration(int mediaId){
    if(this._cache.containsKey(mediaId)){
      return this._cache[mediaId];
    }
    return Duration(hours: 0,minutes: 0, seconds: 0);
  }

  _saveEpisodeDuration(int mediaId, Duration timeCode){
    this._sharedPreferences.remove('tracking.'+mediaId.toString());
    this._sharedPreferences.setString('tracking.'+mediaId.toString(), _durationToString(timeCode) );
  }

  String _durationToString(Duration timeCode){
    return (timeCode.inSeconds / 3600).floor().toString() + ':'
        + ((timeCode.inSeconds % 3600)/60).floor().toString()+ ':'
        + (timeCode.inSeconds % 60).toString();
  }

  _saveMediaList(){
    _sharedPreferences.setStringList('tracking.mediaIds', _cache.keys.map((e) => e.toString()).toList(growable: false));
  }

  Duration _initEpisode(int mediaId){
    List<String> durationList = _sharedPreferences
        .getString('tracking.'+mediaId.toString())
        .split(':');
    return Duration(
      hours: int.parse(durationList[0]),
      minutes: int.parse(durationList[1]),
      seconds: int.parse(durationList[2])
    );
  }
}