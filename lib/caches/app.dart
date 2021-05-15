/*
 * Copyright 2020-2021 TailsxKyuubi
 * This code is part of inoffizielle-AoD-App and licensed under the AGPL License
 */
import 'dart:isolate';

import 'package:flutter_isolate/flutter_isolate.dart';
import 'package:shared_preferences/shared_preferences.dart';

ReceivePort bootUpReceivePort = ReceivePort();
FlutterIsolate bootUpIsolate;

ReceivePort appCheckReceivePort = ReceivePort();
FlutterIsolate appCheckIsolate;

ReceivePort bootUpPreparationsReceivePort = ReceivePort();

SharedPreferences sharedPreferences;