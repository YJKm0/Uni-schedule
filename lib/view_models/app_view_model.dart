import 'package:flutter/material.dart';
import 'package:uni_schudle_try1/modules/defaults_settings.dart';
import 'package:uni_schudle_try1/services/defaultsettings_service.dart';

class AppVm extends ChangeNotifier {
  ThemeMode themeMode = ThemeMode.system;

  final DefaultsettingsService defaultsettingsService;
  AppVm(this.defaultsettingsService);
  Future<void> loadtheme() async {
    DefaultsSettings defaults = await defaultsettingsService
        .loadSavedSettings();
    themeMode = defaults.appTheme;
    notifyListeners();
  }
}
