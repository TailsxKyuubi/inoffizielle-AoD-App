import 'package:unoffical_aod_app/caches/anime.dart';
import 'package:unoffical_aod_app/caches/episode.dart';

class PlayerTransfer {
  Episode episode;
  Anime anime;
  int languageIndex;
  String csrf;
  int positionEpisodes;
  int countEpisodes;
  PlayerTransfer(this.episode,this.languageIndex,this.csrf,this.anime,this.positionEpisodes,this.countEpisodes);
}