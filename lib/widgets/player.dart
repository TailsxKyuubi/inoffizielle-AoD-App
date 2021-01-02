/*
 * Copyright 2020 TailsxKyuubi
 * This code is part of inoffizielle-AoD-App and licensed under the AGPL License
 */
import 'dart:async';
import 'dart:convert';
import 'dart:isolate';

import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:unoffical_aod_app/caches/episode_progress.dart';
import 'package:unoffical_aod_app/caches/login.dart';
import 'package:unoffical_aod_app/caches/settings/settings.dart';
import 'package:unoffical_aod_app/transfermodels/player.dart';
import 'package:unoffical_aod_app/widgets/player_connection_error.dart';
import 'package:unoffical_aod_app/widgets/player_loading_connection_error.dart';
import 'package:unoffical_aod_app/widgets/video_controls.dart';
import 'package:unoffical_aod_app/widgets/video_intel.dart';
import 'package:unoffical_aod_app/widgets/video_progress.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:wakelock/wakelock.dart';
import 'package:unoffical_aod_app/caches/playercache.dart' as playerCache;

import 'package:flutter_spinkit/flutter_spinkit.dart';

class PlayerWidget extends StatefulWidget {
  final ReceivePort receivePort = ReceivePort();

  PlayerWidget(){
    Wakelock.enable();
  }
  @override
  State<StatefulWidget> createState() => PlayerState();
}

class PlayerState extends State<PlayerWidget> {
  bool _playlistLoaded = false;
  bool showControls = false;
  bool showVolume = false;
  DateTime showControlStart;
  DateTime showVolumeStart;
  PlayerTransfer args;
  bool bootUp = true;
  double basicVolume;

  initUpdateThread() async {
    playerCache.updateThread = Timer.periodic(Duration(milliseconds: 500), (timer) {
      setState(() {});
    });
    playerCache.timeTrackThread = Timer.periodic(
        Duration(seconds: 30), this.sendAodTrackingRequest
    );
  }

  sendAodTrackingRequest([timer]) async{
    try {
      await http.get(
          'https://anime-on-demand.de/interfaces/startedstream/'
              + playerCache.playlist[playerCache.playlistIndex]['mediaid']
              .toString()
              + '/' + playerCache.controller.value.position.inSeconds.toString()
              + '/30/' + playerCache.language + '/'
              + (settings.playerSettings.defaultQuality == 0
              ? '720' : settings.playerSettings.defaultQuality.toString()),
          headers: headerHandler.getHeaders());
    }catch(exception){
      showDialog(
        context: context,
        child: PlayerConnectionErrorDialog(args),
        barrierDismissible: false,
      );
    }
  }

  initDelayedControlsHide(){
    this.showControlStart = DateTime.now();
    Future.delayed(
        Duration(seconds: 5),
            () {
          if (DateTime.now().difference(showControlStart).inSeconds >= 5) {
            setState(() {
              showControls = false;
            });
          }
        }
    );
  }

  saveEpisodeProgress([timer]){
    if(settings.playerSettings.saveEpisodeProgress){
      Duration duration = (playerCache.controller.value.position.inSeconds > (playerCache.controller.value.duration.inSeconds - 120))
          ? Duration()
          : playerCache.controller.value.position;

      episodeProgressCache.addEpisode(
          playerCache.playlist[playerCache.playlistIndex]['mediaid'],
          duration,
          this.args.episode.languages[this.args.languageIndex]
      );
    }
  }

  jumpToNextEpisode() async{
    this.saveEpisodeProgress();
    if(playerCache.playlist.length <= (playerCache.playlistIndex+1)){
      await playerCache.controller.pause();
      print('video halted');
      playerCache.updateThread.cancel();
      playerCache.timeTrackThread.cancel();
      await SystemChrome.setPreferredOrientations(
          [
            DeviceOrientation.portraitUp,
            DeviceOrientation.portraitDown
          ]
      );
      print('switched orientation');
      Navigator.pop(context);
      playerCache.controller = null;
      playerCache.updateThread = null;
      print('cleared controller');
      return false;
    }
    await playerCache.controller.pause();
    this._playlistLoaded = false;
    showControls = false;
    setState(() {});
    //playerCache.controller.dispose();
    playerCache.controller = null;
    playerCache.playlistIndex++;
    String m3u8 = playerCache.playlist[playerCache.playlistIndex]['sources'][0]['file'];
    m3u8 = await this.checkVideoQuality(m3u8);
    playerCache.controller = VideoPlayerController.network(m3u8);
    await playerCache.controller.initialize();
    setState(() {
      _playlistLoaded = true;
      playerCache.controller.play();
    });
  }

  Future<String> checkVideoQuality(String m3u8) async{
    if(settings.playerSettings.defaultQuality != 0){
      http.Response res = await http.get(m3u8,headers: headerHandler.getHeaders());
      List<String> lines = res.body.split('\n');
      for(int i = 0;i<lines.length;i++){
        if(lines[i].split(':')[0] == '#EXT-X-STREAM-INF' && lines[i].split('x').last == settings.playerSettings.defaultQuality.toString()){
          List<String> oldLinkArray = m3u8.split('/');
          oldLinkArray.removeLast();
          oldLinkArray.add(lines[i+1].trim());
          m3u8 = oldLinkArray.join('/');
        }
      }
    }
    return m3u8;
  }

  initPlayer() async{
    this.bootUp = false;
    playerCache.playlistIndex = 0;
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight
    ]);
    print('building headers');
    Map headers = headerHandler.getHeaders();
    headers['Accept'] = 'application/json, text/javascript, */*; q=0.01';
    headers['X-CSRF-Token'] = args.csrf;
    headers['Referrer'] = 'https://anime-on-demand.de/anime/'+args.anime.id.toString();
    headers['X-Requested-With'] = 'XMLHttpRequest';
    print('headers build');
    print('starting request');
    playerCache.language = Uri.parse(args.episode.playlistUrl[args.languageIndex]).path.split('/')[3] == 'OmU' ? 'jap' : 'ger';
    http.Response value;
    try{
      value = await http.get(args.episode.playlistUrl[args.languageIndex], headers: headers);
    }catch(exception){
      showDialog(
        context: context,
        child: PlayerLoadingConnectionErrorDialog(args),
        barrierDismissible: false,
      );
      return;
    }

    print('request finished');
    try{
      playerCache.playlist = jsonDecode(value.body)['playlist'];

      if(playerCache.playlist.length > 1 && args.countEpisodes != args.positionEpisodes){
        playerCache.playlist.removeRange(((playerCache.playlist.length - args.positionEpisodes)), playerCache.playlist.length);
      }else if(playerCache.playlist.length > 1 && args.countEpisodes == args.positionEpisodes){
        playerCache.playlist.removeRange(1, playerCache.playlist.length);
      }

      String m3u8 = playerCache.playlist[0]['sources'][0]['file'];
      m3u8 = await this.checkVideoQuality(m3u8);
      this._playlistLoaded = true;
      playerCache.controller = VideoPlayerController.network(m3u8)
        ..initialize().then((_) {
          // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
          setState(() {
            if(settings.playerSettings.saveEpisodeProgress){
              Duration episodeTimeCode = episodeProgressCache
                  .getEpisodeDuration(playerCache.playlist[0]['mediaid'],this.args.episode.languages[this.args.languageIndex]);
              int difference = playerCache.controller.value.duration.inSeconds - episodeTimeCode.inSeconds;
              if(difference > 120){
                this.args.startTime = episodeTimeCode;
              }else{
                episodeProgressCache.addEpisode(playerCache.playlist[0]['mediaid'], Duration.zero, this.args.episode.languages[this.args.languageIndex]);
              }
              playerCache.episodeTracker = Timer.periodic(Duration(seconds: 10), this.saveEpisodeProgress);
            }
            playerCache.controller.seekTo(this.args.startTime);
            playerCache.controller.play();
          });
        })
        ..addListener(() {
          if(playerCache.controller.value.hasError){
            showDialog(
              context: context,
              child: PlayerConnectionErrorDialog(this.args),
              barrierDismissible: false,
            );
          }
        });
    }catch(exception){
      print('error occurred');
      print(args.episode.playlistUrl[args.languageIndex]);
      print(value.body);
      print(exception);
    }
  }

  @override
  Widget build(BuildContext context) {
    Color primaryColor = Color(Theme.of(context).primaryColor.value);
    if( playerCache.updateThread == null && this.bootUp ){
      print('init update thread');
      initUpdateThread();
    }
    if( playerCache.controller == null && this.bootUp ){
      this.args = ModalRoute.of(context).settings.arguments;
      initPlayer();
    }
    if( playerCache.controller != null && playerCache.controller.value != null ){
      if( playerCache.controller.value.isBuffering && playerCache.timeTrackThread.isActive ){
        playerCache.timeTrackThread.cancel();
      }else if( ! playerCache.controller.value.isBuffering && ! playerCache.timeTrackThread.isActive ){
        playerCache.timeTrackThread = Timer(Duration(seconds: ((playerCache.controller.value.position.inSeconds % 30)-30)*-1),() {
          playerCache.timeTrackThread = Timer.periodic(
              Duration(seconds: 30), this.sendAodTrackingRequest
          );
        });
      }
    }
    SystemChrome.setEnabledSystemUIOverlays([]);
    if(playerCache.controller != null && playerCache.controller.value != null && playerCache.controller.value.position != null && playerCache.controller.value.duration != null &&
        playerCache.controller.value.duration.inSeconds == playerCache.controller.value.position.inSeconds) {
      jumpToNextEpisode();
      if(settings.playerSettings.saveEpisodeProgress){
        this.saveEpisodeProgress();
      }
    }
    return Scaffold(
        body: WillPopScope(
          onWillPop: () async {
            print('exit player');
            widget.receivePort.close();
            print('closed port');
            await playerCache.controller.pause();
            print('paused video');
            playerCache.updateThread.cancel();
            playerCache.timeTrackThread.cancel();
            if(settings.playerSettings.saveEpisodeProgress){
              playerCache.episodeTracker.cancel();
              this.saveEpisodeProgress();
            }
            print('set orientation');

            Navigator.pop(context);
            playerCache.updateThread = null;
            print('killed thread');
            playerCache.controller = null;
            print('unlinked object');
            return false;
          },
          child: _playlistLoaded && playerCache.controller != null ? Stack (
              children: [
                GestureDetector(
                  onTap: (){
                    showControls = showControls?false:true;
                    showControlStart = DateTime.now();
                    if(showControls){
                      //SystemChrome.setEnabledSystemUIOverlays([
                      /*SystemUiOverlay.top,
                        SystemUiOverlay.bottom*/
                      //]);
                      initDelayedControlsHide();
                    }else{
                      //SystemChrome.setEnabledSystemUIOverlays([]);
                    }
                    setState(() {});
                  },
                  onVerticalDragStart: (DragStartDetails value){
                    this.showVolume = true;
                    this.showVolumeStart = DateTime.now();
                  },
                  onVerticalDragUpdate: (DragUpdateDetails update){
                    if(update.globalPosition.dx > MediaQuery.of(context).size.width * 0.5){
                      playerCache.controller.setVolume(
                          playerCache.controller.value.volume+((update.delta.dy/(MediaQuery.of(context).size.height/100*0.8))/100)*-1
                      );
                      setState(() {});
                    }
                  },
                  onVerticalDragEnd: (DragEndDetails value){
                    Timer(Duration(seconds: 5),(){
                      if(DateTime.now().difference(showVolumeStart).inSeconds >= 5){
                        showVolume = false;
                      }
                    });
                  },
                  child: Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          color: Colors.black
                      ),
                      child: _playlistLoaded && playerCache.controller != null && playerCache.controller.value != null && playerCache.controller.value.initialized
                          ? AspectRatio(
                        aspectRatio: playerCache.controller.value.aspectRatio,
                        child: VideoPlayer(playerCache.controller),
                      )
                          : Container()
                  ),
                ),
                settings.playerSettings.alwaysShowProgress && !showControls ? Positioned(
                    width: MediaQuery.of(context).size.width,
                    bottom: 0,
                    right: 0,
                    child: Container(
                      height: 5,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        color: Color.fromRGBO(53, 54, 56, 1),
                      ),
                    )
                ):Container(),
                showVolume && playerCache.controller.value != null
                    ? Positioned(
                  right: MediaQuery.of(context).size.width * 0.05,
                  top: MediaQuery.of(context).size.height *0.15,
                  child: Container(
                    height: MediaQuery.of(context).size.height *0.7,
                    width: 30,
                    decoration: BoxDecoration(
                      border: Border.all(
                          color: primaryColor,
                          width: 3
                      ),
                    ),
                    child: Column(
                        children: [
                          Container(
                            height: ((MediaQuery.of(context).size.height * 0.7)-6) * (playerCache.controller.value.volume*-1+1),
                            decoration: BoxDecoration(

                            ),
                          ),
                          Container(
                            height: ((MediaQuery.of(context).size.height * 0.7)-6) * playerCache.controller.value.volume,
                            decoration: BoxDecoration(
                                color: Theme.of(context).accentColor
                            ),
                          ),
                        ]
                    ),
                  ),
                )
                    :Container(),
                showControls && _playlistLoaded
                    ? VideoControls(this)
                    : _playlistLoaded && settings.playerSettings.alwaysShowProgress ? VideoProgress(): Container(height: 0),
                showControls && _playlistLoaded
                    ? VideoIntel(this)
                    : Container(),
                playerCache.controller.value.isBuffering
                    ? Positioned.fill(
                    child: Align(
                      alignment: Alignment.center,
                      child: SpinKitFadingCircle(
                        size: 80,
                        duration: Duration( seconds: 2 ),
                        //color: Colors.white,
                        itemBuilder: (BuildContext context, int index) {
                          return DecoratedBox(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Theme.of(context).accentColor,
                            ),
                          );
                        },
                      ),
                    )
                )
                    : Container()
              ]
          ):Container(
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
            ),
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Stack (
              alignment: Alignment.center,
              children: [
                SpinKitFadingCircle(
                  size: 80,
                  duration: Duration( seconds: 2 ),
                  //color: Colors.white,
                  itemBuilder: (BuildContext context, int index) {
                    return DecoratedBox(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Theme.of(context).accentColor,
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        )
    );
  }

  @override
  void dispose() {
    //playerCache.updateThread.kill(priority: 0);
    widget.receivePort.close();
    super.dispose();
  }
}