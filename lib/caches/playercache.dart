/*
 * Copyright 2020-2021 TailsxKyuubi
 * This code is part of inoffizielle-AoD-App and licensed under the AGPL License
 */

import 'dart:async';

import 'package:flutter_vlc_player/flutter_vlc_player.dart';

List playlist = [];
int playlistIndex = 0;
VlcPlayerController? controller;
Timer? updateThread;
Timer? timeTrackThread;
Timer? episodeTracker;
late String language;