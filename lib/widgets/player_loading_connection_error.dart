/*
 * Copyright 2020 TailsxKyuubi
 * This code is part of inoffizielle-AoD-App and licensed under the AGPL License
 */
import 'package:flutter/material.dart';
import 'package:unoffical_aod_app/transfermodels/player.dart';
import 'package:unoffical_aod_app/caches/playercache.dart' as playerCache;
import 'package:unoffical_aod_app/caches/settings/settings.dart';

class PlayerLoadingConnectionErrorDialog extends StatelessWidget {
  final PlayerTransfer args;
  PlayerLoadingConnectionErrorDialog(this.args){
    if(settings!.playerSettings!.saveEpisodeProgress && playerCache.episodeTracker != null && playerCache.episodeTracker!.isActive){
      playerCache.episodeTracker?.cancel();
      playerCache.episodeTracker = null;
    }
    if(playerCache.updateThread!.isActive){
      playerCache.updateThread?.cancel();
      playerCache.updateThread = null;
    }
    playerCache.timeTrackThread?.cancel();
    playerCache.timeTrackThread = null;
  }

  @override
  Widget build(BuildContext context) {
    const double padding = 16.0;
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      child:
        Container(
            padding: EdgeInsets.only(
              top: padding*2,
              left: padding,
              right: padding,
            ),
            decoration: new BoxDecoration(
                color: Colors.white,
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(padding),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 10.0,
                    offset: const Offset(0.0, 10.0),
                  )
                ]),
            child:
            Column(
                mainAxisSize: MainAxisSize.min, // To make the card compact
                children: <Widget>[
                  Text(
                    'Verbindungsfehler',
                    style: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: 16.0),
                  Text('Fehler beim Laden der Stream Informationen. Bitte überprüfe deine Internetverbindung',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16.0,
                      )),
                  SizedBox(height: 24.0),
                  Align(
                      alignment: Alignment.bottomRight,
                      child: FlatButton(
                        onPressed: () {
                          Navigator.pop(context);
                          Navigator.pushReplacementNamed(
                              context,
                              '/player',
                              arguments: this.args
                          );
                        },
                        child: Text('Stream neustarten'),
                      ))
                ]
            )
        ),
    );
  }
}