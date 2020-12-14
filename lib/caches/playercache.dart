/*
 * Copyright 2020 TailsxKyuubi
 * This code is part of inoffizielle-AoD-App and licensed under the 4-Clause BSD License
 */

import 'dart:async';

import 'package:video_player/video_player.dart';

List playlist = [];
int playlistIndex = 0;
VideoPlayerController controller;
Timer updateThread;
Timer timeTrackThread;
Timer episodeTracker;
String language;