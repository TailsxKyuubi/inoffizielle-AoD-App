/*
 * Copyright 2020-2021 TailsxKyuubi
 * This code is part of inoffizielle-AoD-App and licensed under the AGPL License
 */
import 'package:shared_preferences/shared_preferences.dart';
import 'package:unoffical_aod_app/caches/settings/abstract_settings.dart';

class PlayerSettings extends AbstractSettings {
  PlayerSettings(SharedPreferences preferences) : super(preferences){
    this.alwaysShowProgress = preferences.getBool('player.alwaysShowProgress');
    if(this.alwaysShowProgress == null){
      this.alwaysShowProgress = false;
    }
    this.defaultQuality = preferences.getInt('player.defaultQuality');
    if(this.defaultQuality == null){
      this.defaultQuality = 720;
    }
    this.saveEpisodeProgress = preferences.getBool('player.saveEpisodeProgress');
    if(this.saveEpisodeProgress == null){
      this.saveEpisodeProgress = true;
    }

    this.volumeControls = preferences.getBool('player.volumeControls');
    if(this.volumeControls == null){
      this.volumeControls = true;
    }
  }

  bool alwaysShowProgress;
  int defaultQuality;
  bool saveEpisodeProgress;
  bool volumeControls;

  setAlwaysShowProgress(bool alwaysShowProgress){
    this.alwaysShowProgress = alwaysShowProgress;
    this.save();
  }

  setDefaultQuality(int defaultQuality){
    this.defaultQuality = defaultQuality;
    this.save();
  }

  setSaveEpisodeProgress(bool saveEpisodeProgress){
    this.saveEpisodeProgress = saveEpisodeProgress;
    this.save();
  }

  setVolumeControls(bool volumeControls){
    this.volumeControls = volumeControls;
    this.save();
  }

  @override
  save() {
    this.preferences.setBool('player.alwaysShowProgress',this.alwaysShowProgress);
    this.preferences.setInt('player.defaultQuality', this.defaultQuality);
    this.preferences.setBool('player.saveEpisodeProgress', this.saveEpisodeProgress);
    this.preferences.setBool('player.volumeControls', this.volumeControls);
  }
}