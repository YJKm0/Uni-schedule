import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';
import 'package:uni_schudle_try1/core/locator.dart';
import 'package:uni_schudle_try1/pages/home_page.dart';
import 'package:uni_schudle_try1/theme/app_theme.dart';
import 'package:uni_schudle_try1/view_models/app_view_model.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    databaseFactory = databaseFactoryFfiWeb;
  }
  setupLocator();
  locator<AppVm>().loadtheme();

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: locator<AppVm>(),
      builder: (BuildContext context, _) {
        return MaterialApp(
          title: 'UniSchedule',
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: locator<AppVm>().themeMode,
          debugShowCheckedModeBanner: false,
          localizationsDelegates: const [
            CustomMaterialLocalizationsDelegate(),
            DefaultWidgetsLocalizations.delegate,
          ],
          home: HomePage(),
        );
      },
    );
  }
}

class CustomMaterialLocalizationsDelegate
    extends LocalizationsDelegate<MaterialLocalizations> {
  const CustomMaterialLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => true;

  @override
  Future<MaterialLocalizations> load(Locale locale) async =>
      const _CustomMaterialLocalizations();

  @override
  bool shouldReload(CustomMaterialLocalizationsDelegate old) => false;
}

class _CustomMaterialLocalizations extends DefaultMaterialLocalizations {
  const _CustomMaterialLocalizations();

  @override
  int get firstDayOfWeekIndex => 6; // 6 = السبت (0 = الأحد)
  @override
  List<String> get narrowWeekdays => const <String>[
    'Sun', // 0 = الأحد
    'Mon', // 1 = الإثنين
    'Tue', // 2 = الثلاثاء
    'Wed', // 3 = الأربعاء
    'Thu', // 4 = الخميس
    'Fri', // 5 = الجمعة
    'Sat', // 6 = السبت
  ];
}
