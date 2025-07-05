import 'package:floor/floor.dart';
import 'package:week_organizer/model/entities/recurring_activity.dart';

@dao
abstract class RecurringActivityDao {
  @Query('SELECT * FROM RecurringActivity')
  Future<List<RecurringActivity>> findAllRecurringActivities();

  @Query('SELECT * FROM RecurringActivity WHERE id = :id')
  Future<RecurringActivity?> findRecurringActivityById(int id);

  @insert
  Future<void> insertRecurringActivity(RecurringActivity activity);

  @insert
  Future<void> insertRecurringActivities(List<RecurringActivity> activities);

  @update
  Future<void> updateRecurringActivity(RecurringActivity activity);

  @Query('UPDATE RecurringActivity SET reportedHours = :hours WHERE id = :id')
  Future<void> updateReportedHours(int id, double hours);

  @Query('UPDATE RecurringActivity SET reportedHours = 0')
  Future<void> resetAllReportedHours();

  @delete
  Future<void> deleteRecurringActivity(RecurringActivity activity);

  @Query('DELETE FROM RecurringActivity WHERE id = :id')
  Future<void> deleteRecurringActivityById(int id);

  @Query('SELECT * FROM RecurringActivity WHERE reportedHours > 0')
  Future<List<RecurringActivity>> findActivitiesWithReportedHours();

  @Query('SELECT SUM(reportedHours) FROM RecurringActivity')
  Future<double?> getTotalReportedHours();

  @Query('SELECT SUM(suggestedHours) FROM RecurringActivity')
  Future<int?> getTotalSuggestedHours();
}