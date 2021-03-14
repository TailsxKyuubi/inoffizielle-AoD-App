/*
 * Copyright 2020-2021 TailsxKyuubi
 * This code is part of inoffizielle-AoD-App and licensed under the AGPL License
 */
import 'dart:isolate';

import 'package:flutter_isolate/flutter_isolate.dart';

ReceivePort bootUpReceivePort;
FlutterIsolate bootUpIsolate;