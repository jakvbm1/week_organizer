import 'package:floor/floor.dart';
import 'package:week_organizer/model/entities/archived_activity.dart';
import 'package:week_organizer/model/entities/enums.dart';

@dao
abstract class ArchivedActivityDao {
  @Query('SELECT * FROM ArchivedActivity ORDER BY archivedAt DESC')
  Future<List<ArchivedActivity>> findAllArchivedActivities();

  @Query('SELECT * FROM ArchivedActivity WHERE weekStartDate = :weekStartDate')
  Future<List<ArchivedActivity>> findByWeekStartDate(DateTime weekStartDate);

  @Query('SELECT * FROM ArchivedActivity WHERE originalId = :originalId ORDER BY archivedAt DESC')
  Future<List<ArchivedActivity>> findByOriginalId(int originalId);

  @Query('SELECT * FROM ArchivedActivity WHERE weekStartDate BETWEEN :startDate AND :endDate')
  Future<List<ArchivedActivity>> findByDateRange(DateTime startDate, DateTime endDate);

  @Query('SELECT * FROM ArchivedActivity WHERE finalStatus = :status')
  Future<List<ArchivedActivity>> findByFinalStatus(Status status);

  @insert
  Future<void> insertArchivedActivity(ArchivedActivity activity);

  @insert
  Future<void> insertArchivedActivities(List<ArchivedActivity> activities);

  @delete
  Future<void> deleteArchivedActivity(ArchivedActivity activity);

  @Query('DELETE FROM ArchivedActivity WHERE weekStartDate < :cutoffDate')
  Future<void> deleteOldArchives(DateTime cutoffDate);

  // Statistics queries
  @Query('SELECT COUNT(*) FROM ArchivedActivity WHERE weekStartDate = :weekStartDate AND finalStatus = :status')
  Future<int?> getCompletionCountForWeek(DateTime weekStartDate, Status status);

  //@Query('SELECT finalStatus, COUNT(*) as count FROM ArchivedActivity WHERE weekStartDate = :weekStartDate GROUP BY finalStatus')
  //Future<List<Map<String, dynamic>>> getStatusCountsForWeek(DateTime weekStartDate);

  //@Query('SELECT weekday, COUNT(*) as count FROM ArchivedActivity WHERE weekStartDate = :weekStartDate AND finalStatus = :status GROUP BY weekday')
  //Future<List<Map<String, dynamic>>> getCompletionCountsByWeekdayForWeek(DateTime weekStartDate, Status status);

  @Query('SELECT DISTINCT weekStartDate FROM ArchivedActivity ORDER BY weekStartDate DESC')
  Future<List<DateTime>> getAvailableWeeks();

  @Query('SELECT AVG(CASE WHEN finalStatus = :completedStatus THEN 1.0 ELSE 0.0 END) FROM ArchivedActivity WHERE originalId = :originalId')
  Future<double?> getCompletionRateForActivity(int originalId, Status completedStatus);
}