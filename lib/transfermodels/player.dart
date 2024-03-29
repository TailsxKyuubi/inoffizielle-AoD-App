/*
 * Copyright 2020-2021 TailsxKyuubi
 * This code is part of inoffizielle-AoD-App and licensed under the AGPL License
 */
import 'package:unoffical_aod_app/caches/anime.dart';
import 'package:unoffical_aod_app/caches/episode.dart';

class PlayerTransfer {
  Episode episode;
  Anime anime;
  int languageIndex;
  String csrf;
  int positionEpisodes;
  int countEpisodes;
  Duration startTime = Duration.zero;
  bool continueSeries;
  PlayerTransfer(this.episode,this.languageIndex,this.csrf,this.anime,this.positionEpisodes,this.countEpisodes,this.continueSeries);
}