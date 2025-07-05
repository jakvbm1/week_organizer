import 'package:floor/floor.dart';
import 'package:week_organizer/model/entities/archived_recurring_activity.dart';

@dao
abstract class ArchivedRecurringActivityDao {
  @Query('SELECT * FROM ArchivedRecurringActivity ORDER BY archivedAt DESC')
  Future<List<ArchivedRecurringActivity>> findAllArchivedRecurringActivities();

  @Query('SELECT * FROM ArchivedRecurringActivity WHERE weekStartDate = :weekStartDate')
  Future<List<ArchivedRecurringActivity>> findByWeekStartDate(DateTime weekStartDate);

  @Query('SELECT * FROM ArchivedRecurringActivity WHERE originalId = :originalId ORDER BY archivedAt DESC')
  Future<List<ArchivedRecurringActivity>> findByOriginalId(int originalId);

  @Query('SELECT * FROM ArchivedRecurringActivity WHERE weekStartDate BETWEEN :startDate AND :endDate')
  Future<List<ArchivedRecurringActivity>> findByDateRange(DateTime startDate, DateTime endDate);

  @insert
  Future<void> insertArchivedRecurringActivity(ArchivedRecurringActivity activity);

  @insert
  Future<void> insertArchivedRecurringActivities(List<ArchivedRecurringActivity> activities);

  @delete
  Future<void> deleteArchivedRecurringActivity(ArchivedRecurringActivity activity);

  @Query('DELETE FROM ArchivedRecurringActivity WHERE weekStartDate < :cutoffDate')
  Future<void> deleteOldArchives(DateTime cutoffDate);

  // Statistics queries
  @Query('SELECT SUM(reportedHours) FROM ArchivedRecurringActivity WHERE weekStartDate = :weekStartDate')
  Future<double?> getTotalReportedHoursForWeek(DateTime weekStartDate);

  @Query('SELECT AVG(reportedHours) FROM ArchivedRecurringActivity WHERE originalId = :originalId')
  Future<double?> getAverageReportedHoursForActivity(int originalId);

  @Query('SELECT DISTINCT weekStartDate FROM ArchivedRecurringActivity ORDER BY weekStartDate DESC')
  Future<List<DateTime>> getAvailableWeeks();
}