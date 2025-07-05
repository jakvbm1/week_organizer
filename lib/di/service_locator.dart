
import 'package:get_it/get_it.dart';
import 'package:week_organizer/model/database.dart';
import 'package:week_organizer/model/daos/archived_activity_dao.dart';
import 'package:week_organizer/model/daos/archived_reccuring_activity_dao.dart';
import 'package:week_organizer/model/repositories/activity_repository.dart';
import 'package:week_organizer/model/repositories/archive_repository.dart';
import 'package:week_organizer/model/repositories/reccuring_activity_repository.dart';


final GetIt sl = GetIt.instance;

Future<void> setupServiceLocator() async {
  // Database
  final database = await $FloorAppDatabase.databaseBuilder('app_database.db').build();
  sl.registerSingleton<AppDatabase>(database);
  // Repositories
  sl.registerLazySingleton<ActivityRepository>(() => ActivityRepository(sl()));
  sl.registerLazySingleton<RecurringActivityRepository>(() => RecurringActivityRepository(sl()));
  sl.registerLazySingleton<ArchiveRepository>(
  () => ArchiveRepository(
    sl<ArchivedActivityDao>(),
    sl<ArchivedRecurringActivityDao>(),
  ),
);
}