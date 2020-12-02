
import 'package:shared_preferences/shared_preferences.dart';

abstract class AbstractSettings {
   AbstractSettings(this.preferences);
   String prefix = 'app';
   SharedPreferences preferences;
   Map fields;
   save();
}