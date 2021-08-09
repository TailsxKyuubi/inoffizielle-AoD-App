import 'dart:typed_data';

import 'package:unoffical_aod_app/caches/episode.dart';

import 'database.dart';

class EpisodeHistory {
  final int id;
  final Episode episode;
  final String lang;
  Duration position = Duration();
  EpisodeHistory(this.id, this.episode, this.lang,{this.position});

  void updateEpisode(Duration position) async {
    await databaseHelper.query('UPDATE history SET progress = \'' + databaseHelper.formatTime(position) + '\' WHERE rowid = ' + id.toString() + ';');
  }
}