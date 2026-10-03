import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:uni_schudle_try1/modules/defaults_settings.dart';

class DefaultsettingsService {
  Future<DefaultsSettings> loadSavedSettings() async {
    final prefs = await SharedPreferences.getInstance();
    final defaultSec = prefs.getInt('default_section') ?? 1;
    final alwaysToday = prefs.getBool('always_today') ?? true;
    var themeName = prefs.getString('theme_mode') ?? 'dark';
    final thememode = ThemeMode.values.byName(themeName);
    return DefaultsSettings(
      defaultSection: defaultSec,
      isAlwaysToday: alwaysToday,
      appTheme: thememode,
    );
  }

  Future<void> saveDefaultSection(int section) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('default_section', section);
  }

  Future<void> saveAlwaysToday(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('always_today', value);
  }

  Future<void> saveThemeMOde(String value) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString('theme_mode', value);
  }
}
