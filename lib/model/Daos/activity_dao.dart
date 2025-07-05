import 'package:floor/floor.dart';
import 'package:week_organizer/model/entities/activity.dart';
import 'package:week_organizer/model/entities/enums.dart';

@dao
abstract class ActivityDao {
  @Query('SELECT * FROM Activity')
  Future<List<Activity>> findAllActivities();

  @Query('SELECT * FROM Activity WHERE id = :id')
  Future<Activity?> findActivityById(int id);

  @Query('SELECT * FROM Activity WHERE weekday = :weekday')
  Future<List<Activity>> findActivitiesByWeekday(Weekday weekday);

  @Query('SELECT * FROM Activity WHERE status = :status')
  Future<List<Activity>> findActivitiesByStatus(Status status);

  @Query('SELECT * FROM Activity WHERE weekday = :weekday AND status = :status')
  Future<List<Activity>> findActivitiesByWeekdayAndStatus(Weekday weekday, Status status);

  @insert
  Future<void> insertActivity(Activity activity);

  @insert
  Future<void> insertActivities(List<Activity> activities);

  @update
  Future<void> updateActivity(Activity activity);

  @Query('UPDATE Activity SET status = :status WHERE id = :id')
  Future<void> updateActivityStatus(int id, Status status);

  @Query('UPDATE Activity SET status = :newStatus WHERE status = :oldStatus')
  Future<void> updateActivitiesStatus(Status oldStatus, Status newStatus);

  @delete
  Future<void> deleteActivity(Activity activity);

  @Query('DELETE FROM Activity WHERE id = :id')
  Future<void> deleteActivityById(int id);

  @Query('DELETE FROM Activity WHERE status = :status')
  Future<void> deleteActivitiesByStatus(Status status);

  @Query('SELECT * FROM Activity WHERE status = :status')
  Future<List<Activity>> findCompletedActivities(Status status);

  @Query('UPDATE Activity SET status = :status WHERE status = :currentStatus')
  Future<void> resetWeeklyActivities(Status status, Status currentStatus);

  // Statistics queries
  @Query('SELECT COUNT(*) FROM Activity WHERE status = :status')
  Future<int?> getCountByStatus(Status status);

  @Query('SELECT COUNT(*) FROM Activity WHERE weekday = :weekday AND status = :status')
  Future<int?> getCountByWeekdayAndStatus(Weekday weekday, Status status);

}