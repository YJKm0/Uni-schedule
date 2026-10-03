import 'package:flutter/material.dart';
import 'package:uni_schudle_try1/core/constants.dart';
import 'package:uni_schudle_try1/modules/defaults_settings.dart';

import 'package:uni_schudle_try1/modules/schedule_model.dart';
import 'package:uni_schudle_try1/services/defaultsettings_service.dart';
import 'package:uni_schudle_try1/services/processor.dart';
import 'package:uni_schudle_try1/services/sql_service.dart';

class ScheduleVm extends ChangeNotifier {
  final DpSqlService _sqlService;
  final DefaultsettingsService defaultsettingsService;
  Processor? _processor;
  bool isLoading = true;
  String? errorMessage;
  int? defaultSectionNumber;
  int? currentSectionNumber;
  DateTime? selectedDate;
  bool? isAlwaysToday;
  bool isWeekView = false;

  ScheduleVm(this._sqlService, this.defaultsettingsService);

  //view methods
  Future<void> loadInitialData() async {
    try {
      if (_processor != null) return;
      isLoading = true;
      notifyListeners();

      List<Schedule> schedules = await _sqlService.getSchedules();
      await loadDefualts();
      _processor = Processor(schedules);
      isLoading = false;
      notifyListeners();
    } catch (e) {
      errorMessage = e.toString();
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadDefualts() async {
    DefaultsSettings defaults = await defaultsettingsService
        .loadSavedSettings();
    defaultSectionNumber = defaults.defaultSection;
    currentSectionNumber = defaultSectionNumber;
    isAlwaysToday = defaults.isAlwaysToday;
    valedateTodayDay();
    notifyListeners();
  }

  void valedateTodayDay() {
    if (isAlwaysToday == null) {
      selectedDate = AcademicConstants.minDate;
    }
    if (isAlwaysToday!) {
      final now = DateUtils.dateOnly(DateTime.now());
      if (!now.isBefore(AcademicConstants.minDate) &&
          !now.isAfter(AcademicConstants.maxDate)) {
        selectedDate = now;
      } else {
        selectedDate = AcademicConstants.minDate;
      }
    } else {
      selectedDate = AcademicConstants.minDate;
    }
  }

  void updateSection(String secNum) {
    final parsedSection = int.tryParse(secNum.trim());
    if (parsedSection != null) {
      currentSectionNumber = parsedSection;
      notifyListeners();
    } else {
      return;
    }
  }

  void updateSelectedDate(DateTime v) {
    selectedDate = v;
    notifyListeners();
  }

  void toggleViewMode() {
    isWeekView = !isWeekView;
    notifyListeners();
  }

  //processor methods
  DateTime getSaturdayOfWeek(DateTime date) {
    if (_processor == null) return date;
    return _processor!.getSaturdayOfWeek(date);
  }

  List<Schedule> getSchedule() {
    if (_processor == null) return [];
    return _processor!.getScheduleForSection(
      currentSectionNumber!,
      selectedDate!,
    );
  }
}
