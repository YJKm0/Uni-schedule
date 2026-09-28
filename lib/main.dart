import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:uni_schudle_try1/modules/schedule_model.dart';
import 'package:uni_schudle_try1/pages/home_page.dart';
import 'package:uni_schudle_try1/services/processor.dart';
import 'package:uni_schudle_try1/services/sql_service.dart';
import 'package:flutter/foundation.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';
void main()async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    databaseFactory = databaseFactoryFfiWeb;
  }
  DpSqlService dpSqlService = DpSqlService();
  List<Schedule> schedules = await dpSqlService.getSchedules();
  Processor processor  = Processor(schedules);
  runApp( MainApp(processor: processor,));
}

class MainApp extends StatelessWidget {
  final Processor processor;

  const MainApp({super.key, required this.processor});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      localizationsDelegates: const [
        CustomMaterialLocalizationsDelegate(),
        DefaultWidgetsLocalizations.delegate,
      ],  
      home: HomePage(processor: processor)
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