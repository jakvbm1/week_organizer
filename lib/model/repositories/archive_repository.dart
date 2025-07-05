// lib/repositories/archive_repository.dart
import 'package:week_organizer/model/entities/archived_activity.dart';
import 'package:week_organizer/model/entities/archived_recurring_activity.dart';
import 'package:week_organizer/model/entities/activity.dart';
import 'package:week_organizer/model/entities/enums.dart';
import 'package:week_organizer/model/daos/archived_activity_dao.dart';
import 'package:week_organizer/model/daos/archived_reccuring_activity_dao.dart';
import 'package:week_organizer/model/entities/recurring_activity.dart';

class ArchiveRepository {
  final ArchivedActivityDao _archivedActivityDao;
  final ArchivedRecurringActivityDao _archivedRecurringActivityDao;

  ArchiveRepository(this._archivedActivityDao, this._archivedRecurringActivityDao);

  // Archived Activities
  Future<List<ArchivedActivity>> getAllArchivedActivities() async {
    return await _archivedActivityDao.findAllArchivedActivities();
  }

  Future<List<ArchivedActivity>> getArchivedActivitiesByWeek(DateTime weekStartDate) async {
    return await _archivedActivityDao.findByWeekStartDate(weekStartDate);
  }

  Future<List<ArchivedActivity>> getArchivedActivitiesByDateRange(DateTime startDate, DateTime endDate) async {
    return await _archivedActivityDao.findByDateRange(startDate, endDate);
  }

  Future<List<ArchivedActivity>> getArchivedActivitiesByOriginalId(int originalId) async {
    return await _archivedActivityDao.findByOriginalId(originalId);
  }

  Future<List<ArchivedActivity>> getArchivedActivitiesByStatus(Status status) async {
    return await _archivedActivityDao.findByFinalStatus(status);
  }

  Future<void> insertArchivedActivity(ArchivedActivity activity) async {
    await _archivedActivityDao.insertArchivedActivity(activity);
  }

  Future<void> insertArchivedActivities(List<ArchivedActivity> activities) async {
    await _archivedActivityDao.insertArchivedActivities(activities);
  }

  // Archived Recurring Activities
  Future<List<ArchivedRecurringActivity>> getAllArchivedRecurringActivities() async {
    return await _archivedRecurringActivityDao.findAllArchivedRecurringActivities();
  }

  Future<List<ArchivedRecurringActivity>> getArchivedRecurringActivitiesByWeek(DateTime weekStartDate) async {
    return await _archivedRecurringActivityDao.findByWeekStartDate(weekStartDate);
  }

  Future<List<ArchivedRecurringActivity>> getArchivedRecurringActivitiesByDateRange(DateTime startDate, DateTime endDate) async {
    return await _archivedRecurringActivityDao.findByDateRange(startDate, endDate);
  }

  Future<List<ArchivedRecurringActivity>> getArchivedRecurringActivitiesByOriginalId(int originalId) async {
    return await _archivedRecurringActivityDao.findByOriginalId(originalId);
  }

  Future<void> insertArchivedRecurringActivity(ArchivedRecurringActivity activity) async {
    await _archivedRecurringActivityDao.insertArchivedRecurringActivity(activity);
  }

  Future<void> insertArchivedRecurringActivities(List<ArchivedRecurringActivity> activities) async {
    await _archivedRecurringActivityDao.insertArchivedRecurringActivities(activities);
  }

  // Archiving operations
  Future<void> archiveActivity(Activity activity, DateTime weekStartDate) async {
    final archivedActivity = ArchivedActivity(
      0, // Will be auto-generated
      activity.id,
      activity.name,
      activity.description,
      activity.weekday,
      activity.status,
      weekStartDate,
      DateTime.now(),
    );
    
    await insertArchivedActivity(archivedActivity);
  }

  Future<void> archiveRecurringActivity(RecurringActivity activity, DateTime weekStartDate) async {
    final archivedActivity = ArchivedRecurringActivity(
      0, // Will be auto-generated
      activity.id,
      activity.name,
      activity.description,
      activity.suggestedHours,
      activity.reportedHours,
      weekStartDate,
      DateTime.now(),
    );
    
    await insertArchivedRecurringActivity(archivedActivity);
  }

  Future<void> archiveActivities(List<Activity> activities, DateTime weekStartDate) async {
    final archivedActivities = activities.map((activity) => ArchivedActivity(
      0,
      activity.id,
      activity.name,
      activity.description,
      activity.weekday,
      activity.status,
      weekStartDate,
      DateTime.now(),
    )).toList();
    
    await insertArchivedActivities(archivedActivities);
  }

  Future<void> archiveRecurringActivities(List<RecurringActivity> activities, DateTime weekStartDate) async {
    final archivedActivities = activities.map((activity) => ArchivedRecurringActivity(
      0,
      activity.id,
      activity.name,
      activity.description,
      activity.suggestedHours,
      activity.reportedHours,
      weekStartDate,
      DateTime.now(),
    )).toList();
    
    await insertArchivedRecurringActivities(archivedActivities);
  }

  // Week navigation
  Future<List<DateTime>> getAvailableWeeks() async {
    final activityWeeks = await _archivedActivityDao.getAvailableWeeks();
    final recurringWeeks = await _archivedRecurringActivityDao.getAvailableWeeks();
    
    // Combine and deduplicate weeks
    final allWeeks = <DateTime>{...activityWeeks, ...recurringWeeks};
    final sortedWeeks = allWeeks.toList()..sort((a, b) => b.compareTo(a));
    
    return sortedWeeks;
  }

  Future<DateTime?> getLatestWeek() async {
    final weeks = await getAvailableWeeks();
    return weeks.isNotEmpty ? weeks.first : null;
  }

  Future<DateTime?> getEarliestWeek() async {
    final weeks = await getAvailableWeeks();
    return weeks.isNotEmpty ? weeks.last : null;
  }

  // Statistics
  Future<int> getCompletionCountForWeek(DateTime weekStartDate) async {
    return await _archivedActivityDao.getCompletionCountForWeek(weekStartDate, Status.COMPLETED) ?? 0;
  }

  Future<double> getTotalReportedHoursForWeek(DateTime weekStartDate) async {
    return await _archivedRecurringActivityDao.getTotalReportedHoursForWeek(weekStartDate) ?? 0.0;
  }



  Future<double> getAverageReportedHoursForActivity(int originalId) async {
    return await _archivedRecurringActivityDao.getAverageReportedHoursForActivity(originalId) ?? 0.0;
  }

  Future<double> getCompletionRateForActivity(int originalId) async {
    return await _archivedActivityDao.getCompletionRateForActivity(originalId, Status.COMPLETED) ?? 0.0;
  }

  // Cleanup
  Future<void> deleteOldArchives(DateTime cutoffDate) async {
    await _archivedActivityDao.deleteOldArchives(cutoffDate);
    await _archivedRecurringActivityDao.deleteOldArchives(cutoffDate);
  }

  Future<void> deleteArchivesOlderThan(int months) async {
    final cutoffDate = DateTime.now().subtract(Duration(days: months * 30));
    await deleteOldArchives(cutoffDate);
  }

}