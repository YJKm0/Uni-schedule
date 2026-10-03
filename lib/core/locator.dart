import 'package:get_it/get_it.dart';
import 'package:uni_schudle_try1/services/defaultsettings_service.dart';
import 'package:uni_schudle_try1/services/sql_service.dart';
import 'package:uni_schudle_try1/view_models/schedule_view_model.dart';

final locator = GetIt.instance;

void setupLocator() {
  locator.registerLazySingleton<DpSqlService>(() => DpSqlService());
  locator.registerLazySingleton<DefaultsettingsService>(
    () => DefaultsettingsService(),
  );
  locator.registerLazySingleton<ScheduleViewModel>(
    () => ScheduleViewModel(
      locator<DpSqlService>(),
      locator<DefaultsettingsService>(),
    ),
  );
}
