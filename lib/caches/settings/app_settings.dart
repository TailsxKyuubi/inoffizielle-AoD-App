/*
 * Copyright 2020-2021 TailsxKyuubi
 * This code is part of inoffizielle-AoD-App and licensed under the AGPL License
 */
import 'package:shared_preferences/shared_preferences.dart';
import 'package:unoffical_aod_app/caches/settings/abstract_settings.dart';

class AppSettings extends AbstractSettings {
  AppSettings(SharedPreferences preferences) : super(preferences){
    bool? keepSession = this.preferences.getBool('app.keepSession');
    if(keepSession != null){
      this.keepSession = keepSession;
    }
  }

  setKeepSession(bool keepSession){
    this.keepSession = keepSession;
    this.save();
  }

  bool keepSession = true;

  @override
  save() {
    this.preferences.setBool('app.keepSession', this.keepSession);
  }

}