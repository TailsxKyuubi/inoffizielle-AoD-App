import 'package:shared_preferences/shared_preferences.dart';
import 'package:unoffical_aod_app/caches/settings/abstract_settings.dart';

class AppSettings extends AbstractSettings {
  AppSettings(SharedPreferences preferences) : super(preferences){
    this.keepSession = this.preferences.getBool('app.keepSession');
    if(keepSession == null){
      this.keepSession = false;
    }
  }

  setKeepSession(bool keepSession){
    this.keepSession = keepSession;
    this.save();
  }

  bool keepSession;

  @override
  save() {
    this.preferences.setBool('app.keepSession', this.keepSession);
  }

}