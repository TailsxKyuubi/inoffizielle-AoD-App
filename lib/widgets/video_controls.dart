/*
 * Copyright 2020-2021 TailsxKyuubi
 * This code is part of inoffizielle-AoD-App and licensed under the AGPL License
 */
import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:unoffical_aod_app/widgets/player.dart';
import 'package:unoffical_aod_app/caches/playercache.dart' as playerCache;


class VideoControls extends StatefulWidget {
  final PlayerState playerState;
  VideoControls(this.playerState);

  @override
  State<StatefulWidget> createState() => _VideoControlsState();
}

class _VideoControlsState extends State<VideoControls> {

  bool playTap = false;
  bool nextTap = false;
  bool tenSecondsForwardTap = false;
  bool thirtySecondsForwardTap = false;
  bool tenSecondsBackwardTap = false;
  bool thirtySecondsBackwardTap = false;
  Duration videoPosition = Duration();

  void jumpTo(details){
    print('seek triggered');
    widget.playerState.initDelayedControlsHide();
    int seconds = ((details.localPosition.dx+8)*1.1) ~/ ((MediaQuery.of(context).size.width-100)/100)*(playerCache.controller!.value.duration.inSeconds/100).floor();
    playerCache.controller!.seekTo(Duration(seconds: seconds));
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    videoPosition = playerCache.controller!.value.position;
    int positionSeconds = videoPosition.inSeconds;
    int durationSeconds = playerCache.controller!.value.duration.inSeconds;
    TextStyle timeStyle = TextStyle(
      color: Colors.white,
    );
    if(!widget.playerState.showControls){
      return Positioned(child: Container());
    }
    double baseWidth = (MediaQuery.of(context).size.width-142)/100;
    double positionWidth = (positionSeconds / (durationSeconds/100))*baseWidth;
    double bufferedWidth = playerCache.controller!.value.buffered.isNotEmpty && playerCache.controller!.value.buffered.last.end.inSeconds > positionSeconds
        ? ((playerCache.controller!.value.buffered.last.end.inSeconds-positionSeconds) / (durationSeconds/100))*baseWidth
        : 0;
    double placeholderWidth = baseWidth*100-positionWidth-bufferedWidth;
    //placeholderWidth -= ((MediaQuery.of(context).size.width-142)-placeholderWidth-positionWidth-bufferedWidth);
    Color accentColor = Theme.of(context).accentColor;
    return Positioned(
        bottom: 0,
        width: MediaQuery.of(context).size.width,
        child: Container(
            padding: EdgeInsets.only(top: 5),
            decoration: BoxDecoration(
              color: Color.fromRGBO(53, 54, 56,0.5),
            ),
            child:  Column(
                children: [
                  Row (
                    children: [
                      Container(
                          width: 70,
                          child: positionSeconds >= 3600?
                          Text(
                            (positionSeconds/3600).floor().toString()+':'+((positionSeconds%3600)/60).floor().toString().padLeft(2,'0')+':'+(positionSeconds%60).toString().padLeft(2,'0'),
                            style: timeStyle,
                            textAlign: TextAlign.center,
                          ):
                          Text(
                            (positionSeconds/60).floor().toString().padLeft(2,'0')+':'+((positionSeconds%60).toString().padLeft(2,'0')),
                            style: timeStyle,
                            textAlign: TextAlign.center,
                          )
                      ),

                      //width: MediaQuery.of(context).size.width - 102,
                      GestureDetector(
                        onTapDown: jumpTo,
                        onHorizontalDragUpdate: jumpTo,
                        child: Row(
                            children: [
                              Container(
                                transform: Matrix4.skewX(-0.5),
                                width: positionWidth,
                                height: 20,
                                decoration: BoxDecoration(
                                  color: Color.fromRGBO(171, 191, 57, 1),
                                ),
                              ),
                              Container(
                                width: bufferedWidth,
                                height: 20,
                                transform: Matrix4.skewX(-0.5),
                                decoration: BoxDecoration(
                                    color: Color.fromRGBO(171, 191, 57, 0.5)
                                ),
                              ),
                              Container(
                                width: placeholderWidth,
                                height: 20,
                                decoration: BoxDecoration(
                                    color: Color.fromRGBO(53, 54, 56,0)
                                ),
                              ),
                            ]
                        ),
                      ),
                      Container(
                          width: 70,
                          child: durationSeconds >= 3600?
                          Text(
                              (durationSeconds/3600).floor().toString()+':'+((durationSeconds%3600)/60).floor().toString().padLeft(2,'0')+':'+(durationSeconds%60).toString().padLeft(2,'0'),
                              style: timeStyle,
                              textAlign: TextAlign.center
                          ):
                          Text(
                              (durationSeconds/60).floor().toString().padLeft(2,'0')+':'+(durationSeconds%60).toString().padLeft(2,'0'),
                              style: timeStyle,
                              textAlign: TextAlign.center
                          )
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      GestureDetector(
                        onTapDown: (TapDownDetails event){
                          widget.playerState.showControls = true;
                          setState(() {
                            this.thirtySecondsBackwardTap = true;
                          });
                        },
                        onTap: (){
                          setState(() {
                            playerCache.updateThread!.cancel();
                            playerCache.updateThread = null;
                            videoPosition = Duration(seconds: playerCache.controller!.value.position.inSeconds-30);
                            playerCache.controller!.seekTo(videoPosition).then((_){
                              widget.playerState.initUpdateThread();
                            });
                          });
                          setState(() {
                            widget.playerState.initDelayedControlsHide();
                            this.thirtySecondsBackwardTap = false;
                          });
                        },
                        child: Container(
                          height: 40,
                          width: MediaQuery.of(context).size.width*0.15,
                          decoration: BoxDecoration(
                            color: this.thirtySecondsBackwardTap
                                ? Color.fromRGBO(accentColor.red, accentColor.green, accentColor.blue,0.5)
                                : Color.fromRGBO(53, 54, 56, 0),
                          ),
                          child: Icon(
                              Icons.replay_30,
                              color: Colors.white
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTapDown: (TapDownDetails event){
                          setState(() {
                            widget.playerState.showControls = true;
                            this.tenSecondsBackwardTap = true;
                          });
                        },
                        onTap: (){
                          setState(() {
                            playerCache.updateThread!.cancel();
                            playerCache.updateThread = null;
                            videoPosition = Duration(seconds: playerCache.controller!.value.position.inSeconds-10);
                            playerCache.controller!.seekTo(videoPosition).then((_){
                              widget.playerState.initUpdateThread();
                            });
                          });
                          setState(() {
                            widget.playerState.initDelayedControlsHide();
                            this.tenSecondsBackwardTap = false;
                          });
                        },
                        child: Container(
                          height: 40,
                          width: MediaQuery.of(context).size.width*0.15,
                          decoration: BoxDecoration(
                            color: this.tenSecondsBackwardTap
                                ? Color.fromRGBO(accentColor.red, accentColor.green, accentColor.blue,0.5)
                                : Color.fromRGBO(53, 54, 56, 0),
                          ),
                          child: Icon(
                              Icons.replay_10,
                              color: Colors.white
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTapDown: (TapDownDetails event){
                          setState(() {
                            this.playTap = true;
                            this.widget.playerState.showControls = true;
                          });
                        },
                        onTap: (){
                          playerCache.controller!.value.isPlaying && playerCache.timeTrackThread!.isActive
                              ? playerCache.timeTrackThread!.cancel()
                              : Timer(Duration(seconds: ((playerCache.controller!.value.position.inSeconds % 30)-30)*-1),(){
                                playerCache.timeTrackThread = Timer.periodic(
                                    Duration(seconds: 30), widget.playerState.sendAodTrackingRequest
                                );
                              });
                          playerCache.controller!.value.isPlaying?playerCache.controller!.pause():playerCache.controller!.play();
                          setState(() {
                            this.playTap = false;
                            widget.playerState.initDelayedControlsHide();
                            widget.playerState.saveEpisodeProgress();
                          });
                        },
                        child: Container(
                          height: 40,
                          width: MediaQuery.of(context).size.width*0.3,
                          decoration: BoxDecoration(
                            color: this.playTap
                                ? Color.fromRGBO(accentColor.red, accentColor.green, accentColor.blue,0.5)
                                : Color.fromRGBO(53, 54, 56, 0),
                          ),
                          child: Icon(
                              playerCache.controller!.value.isPlaying?Icons.pause:Icons.play_arrow,
                              color: Colors.white
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTapDown: (TapDownDetails event){
                          setState(() {
                            this.tenSecondsForwardTap = true;
                            this.widget.playerState.showControls = true;
                          });
                        },
                        onTap: (){
                          if(playerCache.controller!.value.duration.inSeconds <= playerCache.controller!.value.position.inSeconds+10){
                            this.widget.playerState.jumpToNextEpisode();
                          }else {
                            setState(() {
                              playerCache.updateThread!.cancel();
                              playerCache.updateThread = null;
                              videoPosition = Duration(seconds: playerCache.controller!.value.position.inSeconds+10);
                              playerCache.controller!.seekTo(videoPosition).then((_){
                                widget.playerState.initUpdateThread();
                              });
                            });
                            setState(() {
                              widget.playerState.initDelayedControlsHide();
                              this.tenSecondsForwardTap = false;
                            });
                          }
                        },
                        child: Container(
                          height: 40,
                          width: MediaQuery.of(context).size.width*0.15,
                          decoration: BoxDecoration(
                            color: this.tenSecondsForwardTap
                                ? Color.fromRGBO(accentColor.red, accentColor.green, accentColor.blue,0.5)
                                : Color.fromRGBO(53, 54, 56, 0),
                          ),
                          child: Icon(
                              Icons.forward_10,
                              color: Colors.white
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTapDown: (TapDownDetails event){
                          setState(() {
                            this.thirtySecondsForwardTap = true;
                            this.widget.playerState.showControls = true;
                          });
                        },
                        onTap: (){
                          if(playerCache.controller!.value.duration.inSeconds <= playerCache.controller!.value.position.inSeconds+30){
                            this.widget.playerState.jumpToNextEpisode();
                          }else{
                            setState(() {
                              playerCache.updateThread!.cancel();
                              playerCache.updateThread = null;
                              videoPosition = Duration(seconds: playerCache.controller!.value.position.inSeconds+30);
                              playerCache.controller!.seekTo(videoPosition).then((_){
                                widget.playerState.initUpdateThread();
                              });
                            });
                            setState(() {
                              widget.playerState.initDelayedControlsHide();
                              this.thirtySecondsForwardTap = false;
                            });
                          }
                        },
                        child: Container(
                          height: 40,
                          width: MediaQuery.of(context).size.width*0.15,
                          decoration: BoxDecoration(
                            color: this.thirtySecondsForwardTap
                                ? Color.fromRGBO(accentColor.red, accentColor.green, accentColor.blue,0.5)
                                : Color.fromRGBO(53, 54, 56, 0),
                          ),
                          child: Icon(
                              Icons.forward_30,
                              color: Colors.white
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: (){
                          widget.playerState.jumpToNextEpisode();
                        },
                        onTapDown: (TapDownDetails event){
                          widget.playerState.showControls = true;
                        },
                        child: Container(
                          height: 40,
                          width: MediaQuery.of(context).size.width*0.1,
                          decoration: BoxDecoration(
                            color: this.nextTap
                                ? Color.fromRGBO(accentColor.red, accentColor.green, accentColor.blue,0.5)
                                : Color.fromRGBO(53, 54, 56, 0),
                          ),
                          child: Icon(
                              Icons.skip_next,
                              color: Colors.white
                          ),
                        ),
                      )
                    ],
                  )
                ]
            )
        )
    );
  }

}