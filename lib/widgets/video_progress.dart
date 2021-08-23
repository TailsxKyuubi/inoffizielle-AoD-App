/*
 * Copyright 2020-2021 TailsxKyuubi
 * This code is part of inoffizielle-AoD-App and licensed under the AGPL License
 */
import 'package:flutter/material.dart';
import 'package:unoffical_aod_app/caches/playercache.dart' as playerCache;

class VideoProgress extends StatefulWidget {

  @override
  State<StatefulWidget> createState() => _VideoProgressState();
}
class _VideoProgressState extends State<VideoProgress> {
  @override
  Widget build(BuildContext context) {
    return playerCache.controller!.value.isInitialized ? AnimatedPositioned(
        duration: playerCache.controller!.value.duration,
        bottom: 0,
        left: 0,
        child: Container(
            height: 5,
            width: MediaQuery.of(context).size.width / 100 * ( playerCache.controller!.value.position.inSeconds / (playerCache.controller!.value.duration.inSeconds / 100)),
            color: Color.fromRGBO(171, 191, 57, 1)
        )
    ):Container(height:0 );
  }
}