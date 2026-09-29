import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uni_schudle_try1/modules/schedule_model.dart';

class DpSqlService {
  Future<Database> loadDb() async {
    String dbPath = await getDatabasesPath();
    String path = join(dbPath, 'UniSchedule__second _year.db');
    const int currentVersion = 1;

    final prefs = await SharedPreferences.getInstance();
    int savedVersion = prefs.getInt('db_version') ?? 0;

    if (!await databaseExists(path) || savedVersion < currentVersion) {
      ByteData data = await rootBundle.load("assets/UniSchedule__second _year.db");
      Uint8List bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);

      if (kIsWeb) {
        await databaseFactory.writeDatabaseBytes(path, bytes);
      } else {
        await File(path).writeAsBytes(bytes, flush: true);
      }
      await prefs.setInt('db_version', currentVersion);
    }

    return await openDatabase(path);
  }

  Future<List<Schedule>> getSchedules() async {
    Database db = await loadDb();
    List<Map<String, dynamic>> result = await db.rawQuery('''
      SELECT 
        s.*, 
        IFNULL(l.TeamsLink, 'Not Available') AS TeamsLink
      FROM Schedules s
      LEFT JOIN OnlineLinks l 
        ON s.Professor = l.Professor
    ''');

    return result.map((row) => Schedule.maping(row)).toList();
  }
}