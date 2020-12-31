import 'package:flutter/material.dart';
import 'package:unoffical_aod_app/transfermodels/player.dart';
import 'package:unoffical_aod_app/caches/playercache.dart' as playerCache;
import 'package:unoffical_aod_app/caches/settings/settings.dart';

class PlayerConnectionErrorDialog extends StatelessWidget {
  final PlayerTransfer args;
  PlayerConnectionErrorDialog(this.args){
    if(settings.playerSettings.saveEpisodeProgress && playerCache.episodeTracker.isActive){
      playerCache.episodeTracker.cancel();
      playerCache.episodeTracker = null;
    }
    if(playerCache.updateThread.isActive){
      playerCache.updateThread.cancel();
      playerCache.updateThread = null;
    }
    playerCache.timeTrackThread.cancel();
    playerCache.timeTrackThread = null;
    if(playerCache.controller.value != null){
      this.args.startTime = playerCache.controller.value.position;
    }else{
      this.args.startTime = Duration.zero;
    }
    playerCache.controller = null;
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
                  Text('Fehler beim laden des Streams. Bitte überprüfe deine Internetverbindung',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16.0,
                      )),
                  SizedBox(height: 24.0),
                  Align(
                      alignment: Alignment.bottomRight,
                      child: FlatButton(
                        onPressed: () {
                          for(int i = 0;this.args.episode.playlistUrl.length > i;i++){
                            Uri oldStreamUrl = Uri.tryParse(this.args.episode.playlistUrl[this.args.languageIndex]);
                            List<String> oldPathList = oldStreamUrl.path.split('/');
                            oldPathList[2] = playerCache.playlist[playerCache.playlistIndex]['mediaid'].toString();
                            this.args.episode.playlistUrl[i] = 'https://'+ oldStreamUrl.host + oldPathList.join('/');
                          }
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