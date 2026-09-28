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
      
      home: HomePage(processor: processor)
    );
  }
}
