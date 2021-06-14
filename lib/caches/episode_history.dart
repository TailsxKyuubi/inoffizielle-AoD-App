import 'database.dart';

class EpisodeHistory {
  final int id;
  final int mediaId;
  final String lang;
  Duration position = Duration();
  EpisodeHistory(this.id, this.mediaId, this.lang,{this.position});

  void updateEpisode(Duration position) async {
    await databaseHelper.query('UPDATE history SET progress = \'' + databaseHelper.formatTime(position) + '\' WHERE rowid = ' + id.toString() + ';');
  }
}