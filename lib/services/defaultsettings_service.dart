import 'package:shared_preferences/shared_preferences.dart';

import 'package:uni_schudle_try1/modules/defaults_settings.dart';

class DefaultsettingsService {
  Future<DefaultsSettings> loadSavedSettings() async {
    final prefs = await SharedPreferences.getInstance();
    final defaultSec = prefs.getInt('default_section') ?? 1;
    final alwaysToday = prefs.getBool('always_today') ?? true;

    return DefaultsSettings(
      defaultSection: defaultSec,
      isAlwaysToday: alwaysToday,
    );
  }
}
