import 'package:flutter/material.dart';

import 'package:uni_schudle_try1/modules/defaults_settings.dart';
import 'package:uni_schudle_try1/services/defaultsettings_service.dart';

class SettingsVm extends ChangeNotifier {
  int defaultSection = 1;
  bool alwaysToday = true;
  bool isLoading = true;
  ThemeMode appTheme = ThemeMode.system;
  final DefaultsettingsService defaultsettingsService;
  SettingsVm(this.defaultsettingsService);
  void loadInitialSettings() async {
    isLoading = true;
    notifyListeners();
    DefaultsSettings defaults = await defaultsettingsService
        .loadSavedSettings();
    defaultSection = defaults.defaultSection;
    alwaysToday = defaults.isAlwaysToday;
    appTheme = defaults.appTheme;
    isLoading = false;
    notifyListeners();
  }

  void updateDefaultSection(int newSection) {
    defaultSection = newSection;
    notifyListeners();
    defaultsettingsService.saveDefaultSection(newSection);
  }

  void updateAlwaysToday(bool value) {
    alwaysToday = value;
    notifyListeners();
    defaultsettingsService.saveAlwaysToday(value);
  }

  void updateApptheme(ThemeMode value) {
    appTheme = value;
    notifyListeners();
    defaultsettingsService.saveThemeMOde(appTheme.name);
  }
}
