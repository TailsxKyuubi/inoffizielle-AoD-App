/*
 * Copyright 2020-2021 TailsxKyuubi
 * This code is part of inoffizielle-AoD-App and licensed under the AGPL License
 */
import 'dart:typed_data';

import 'package:unoffical_aod_app/caches/database.dart';

class Episode {
  String name;
  String number = '';
  Uri imageUrl;
  Uint8List image;
  int mediaId;
  Duration duration;
  List<String> playlistUrl = [];
  List<String> languages = [];
  String noteText = '';

  static getByAnime(int animeId) async {
    List<Map<String, dynamic>> episodesRaw = await databaseHelper.query('SELECT rowid, media_id, title, episode_number, image, duration FROM episodes WHERE anime_id = ' + animeId.toString() + ' ORDER BY rowid ASC');

    return episodesRaw.map(_initRaw).toList();
  }

  static _initRaw(Map<String, dynamic> element){
    List<String> durationList = element['duration'].split(':');
    Episode episode = Episode();
    episode.name = element['title'];
    episode.number = element['episode_number'];
    episode.image = element['image'];
    episode.mediaId = element['media_id'];
    episode.duration = Duration(
        hours: int.parse(durationList[0]),
        minutes: int.parse(durationList[1]),
        seconds: int.parse(durationList[2])
    );
    return episode;
  }

  static getByMediaId(int mediaId) async {
    List<Map<String, dynamic>> query = await databaseHelper.query('SELECT rowid, media_id, title, episode_number, image, duration FROM episodes WHERE media_id = ' + mediaId.toString());
    if(query.isEmpty){
      return null;
    } else {
      return _initRaw(query.first);
    }
  }
}