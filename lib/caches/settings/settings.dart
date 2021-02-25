/*
 * Copyright 2020 TailsxKyuubi
 * This code is part of inoffizielle-AoD-App and licensed under the AGPL License
 */
import 'package:shared_preferences/shared_preferences.dart';
import 'package:unoffical_aod_app/caches/settings/app_settings.dart';
import 'package:unoffical_aod_app/caches/settings/player_settings.dart';
Settings? settings;
class Settings {
  Settings() {
    SharedPreferences.getInstance().then(( SharedPreferences value ){
      print('init settings');
      playerSettings = PlayerSettings(value);
      appSettings = AppSettings(value);
    });
  }
  PlayerSettings? playerSettings;
  AppSettings? appSettings;
}