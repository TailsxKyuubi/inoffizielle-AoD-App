/*
 * Copyright 2020 TailsxKyuubi
 * This code is part of inoffizielle-AoD-App and licensed under the 4-Clause BSD License
 */
import 'package:shared_preferences/shared_preferences.dart';

abstract class AbstractSettings {
   AbstractSettings(this.preferences);
   String prefix = 'app';
   SharedPreferences preferences;
   Map fields;
   save();
}