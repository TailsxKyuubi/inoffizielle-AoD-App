

import 'dart:async';

import 'package:video_player/video_player.dart';

List playlist = [];
int playlistIndex = 0;
VideoPlayerController controller;
Timer updateThread;
Timer timeTrackThread;
String language;