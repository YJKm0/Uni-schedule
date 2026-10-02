import 'package:flutter/material.dart';
import 'package:uni_schudle_try1/modules/schedule_model.dart';
import 'package:uni_schudle_try1/services/processor.dart';
import 'package:uni_schudle_try1/services/sql_service.dart';

class ScheduleViewModel extends ChangeNotifier {
  final DpSqlService _sqlService;

  Processor? _processor;
  bool isLoading = true;
  String? errorMessage;
  ScheduleViewModel(this._sqlService);

  Future<void> loadInitialData() async {
    try {
      isLoading = true;
      notifyListeners();

      List<Schedule> schedules = await _sqlService.getSchedules();
      _processor = Processor(schedules);

      isLoading = false;
      notifyListeners();
    } catch (e) {
      errorMessage = e.toString();
      isLoading = false;
      notifyListeners();
    }
  }

  DateTime getSaturdayOfWeek(DateTime date) {
    if (_processor == null) return date;
    return _processor!.getSaturdayOfWeek(date);
  }

  List<Schedule> getSchedule(int sectionNumber, DateTime date) {
    if (_processor == null) return [];
    return _processor!.getScheduleForSection(sectionNumber, date);
  }
}
