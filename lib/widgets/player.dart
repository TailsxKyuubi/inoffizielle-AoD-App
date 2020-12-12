import 'dart:async';
import 'dart:convert';
import 'dart:isolate';

import 'package:flutter/services.dart';
import 'package:unoffical_aod_app/caches/episode_progress.dart';
import 'package:unoffical_aod_app/caches/login.dart';
import 'package:unoffical_aod_app/caches/settings/settings.dart';
import 'package:unoffical_aod_app/transfermodels/player.dart';
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
  DateTime showControlStart;
  PlayerTransfer args;
  bool bootUp = true;

  initUpdateThread() async {
    playerCache.updateThread = Timer.periodic(Duration(milliseconds: 500), (timer) {
      setState(() {});
    });
    playerCache.timeTrackThread = Timer.periodic(
        Duration(seconds: 30), this.sendAodTrackingRequest
    );
  }

  sendAodTrackingRequest([timer]) async{
      await http.get(
          'https://anime-on-demand.de/interfaces/startedstream/'
              +playerCache.playlist[playerCache.playlistIndex]['mediaid'].toString()
              +'/'+playerCache.controller.value.position.inSeconds.toString()
              +'/30/'+playerCache.language+'/'
              +(settings.playerSettings.defaultQuality == 0
              ? '720' : settings.playerSettings.defaultQuality.toString()),
          headers: headerHandler.getHeaders());
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
    http.Response value = await http.get(args.episode.playlistUrl[args.languageIndex], headers: headers);
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
                playerCache.controller.seekTo(episodeTimeCode);
              }else{
                episodeProgressCache.addEpisode(playerCache.playlist[0]['mediaid'], Duration(), this.args.episode.languages[this.args.languageIndex]);
              }
              playerCache.episodeTracker = Timer.periodic(Duration(seconds: 10), this.saveEpisodeProgress);
            }
            playerCache.controller.play();
          });
        });
      widget.receivePort.listen((message) {
        if(playerCache.controller != null){
          setState(() {});
          if(playerCache.controller.value.hasError){
            print("error");
            print(playerCache.controller.value.errorDescription);
          }
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
          onWillPop: () async{
            print('exit player');
            widget.receivePort.close();
            print('closed port');
            await playerCache.controller.pause();
            this.saveEpisodeProgress();
            print('paused video');
            playerCache.updateThread.cancel();
            playerCache.timeTrackThread.cancel();
            if(settings.playerSettings.saveEpisodeProgress){
              playerCache.episodeTracker.cancel();
            }
            await SystemChrome.setPreferredOrientations([
              DeviceOrientation.portraitDown,
              DeviceOrientation.portraitUp
            ]);
            print('set orientation');

            Navigator.pop(context);
            playerCache.updateThread = null;
            print('killed thread');
            playerCache.controller = null;
            print('unlinked object');
            return false;
          },
          child: _playlistLoaded && playerCache.controller != null?Stack (
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
                settings.playerSettings.alwaysShowProgress&&!showControls?Positioned(
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