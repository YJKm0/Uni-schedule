import 'package:get_it/get_it.dart';
import 'package:uni_schudle_try1/services/defaultsettings_service.dart';
import 'package:uni_schudle_try1/services/sql_service.dart';
import 'package:uni_schudle_try1/view_models/app_view_model.dart';
import 'package:uni_schudle_try1/view_models/schedule_view_model.dart';
import 'package:uni_schudle_try1/view_models/settings_view_model.dart';

final locator = GetIt.instance;

void setupLocator() {
  locator.registerLazySingleton<DpSqlService>(() => DpSqlService());
  locator.registerSingleton<DefaultsettingsService>(DefaultsettingsService());
  locator.registerLazySingleton<SettingsVm>(
    () => SettingsVm(locator<DefaultsettingsService>()),
  );
  locator.registerSingleton<AppVm>(AppVm(locator<DefaultsettingsService>()));
  locator.registerLazySingleton<ScheduleVm>(
    () =>
        ScheduleVm(locator<DpSqlService>(), locator<DefaultsettingsService>()),
  );
}
