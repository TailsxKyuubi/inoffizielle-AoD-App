/*
 * Copyright 2020-2021 TailsxKyuubi
 * This code is part of inoffizielle-AoD-App and licensed under the AGPL License
 */
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:unoffical_aod_app/caches/playercache.dart' as playerCache;
import 'package:unoffical_aod_app/caches/settings/settings.dart';
import 'package:unoffical_aod_app/caches/episode_progress.dart';
import 'package:unoffical_aod_app/widgets/player.dart';

class VideoIntel extends StatelessWidget {

  final PlayerState _playerState;
  VideoIntel(this._playerState);

  @override
  Widget build(BuildContext context) {
    return Positioned(
        top: 0,
        child: Container(
          decoration: BoxDecoration(
              color: Color.fromRGBO(53, 54, 56,0.5)
          ),
          width: MediaQuery.of(context).size.width,
          child: Row(
            children: [
              GestureDetector(
                onTap: () async{
                  await playerCache.controller.pause();
                  if(settings.playerSettings.saveEpisodeProgress){
                    if(playerCache.episodeTracker != null){
                      playerCache.episodeTracker.cancel();
                    }
                    episodeProgressCache.addEpisode(
                        playerCache.playlist[playerCache.playlistIndex]['mediaid'],
                        playerCache.controller.value.position,
                        this._playerState.args.episode.languages[this._playerState.args.languageIndex]
                    );
                  }
                  print('video halted');
                  playerCache.updateThread.cancel();
                  playerCache.timeTrackThread.cancel();
                  print('switched orientation');
                  Navigator.pop(context);
                  playerCache.controller = null;
                  playerCache.updateThread = null;
                  print('cleared controller');
                },
                child: Container(
                  padding: EdgeInsets.all(7),
                  child: Icon(
                    Icons.arrow_back,
                    color: Theme.of(context).accentColor
                  ),
                ),
              ),
              Text(
                playerCache.playlist[playerCache.playlistIndex]['title'] + ' ' + playerCache.playlist[playerCache.playlistIndex]['description'],
                style: TextStyle(
                  color: Colors.white
                ),
              ),
            ]
          ),
        )
    );
  }
  
}