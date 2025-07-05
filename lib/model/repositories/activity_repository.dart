// lib/repositories/activity_repository.dart
import 'package:week_organizer/model/entities/activity.dart';
import 'package:week_organizer/model/entities/enums.dart';
import 'package:week_organizer/model/daos/activity_dao.dart';

class ActivityRepository {
  final ActivityDao _activityDao;

  ActivityRepository(this._activityDao);

  // Basic CRUD operations
  Future<List<Activity>> getAllActivities() async {
    return await _activityDao.findAllActivities();
  }

  Future<Activity?> getActivityById(int id) async {
    return await _activityDao.findActivityById(id);
  }

  Future<void> insertActivity(Activity activity) async {
    await _activityDao.insertActivity(activity);
  }

  Future<void> insertActivities(List<Activity> activities) async {
    await _activityDao.insertActivities(activities);
  }

  Future<void> updateActivity(Activity activity) async {
    await _activityDao.updateActivity(activity);
  }

  Future<void> deleteActivity(Activity activity) async {
    await _activityDao.deleteActivity(activity);
  }

  Future<void> deleteActivityById(int id) async {
    await _activityDao.deleteActivityById(id);
  }

  // Filtered queries
  Future<List<Activity>> getActivitiesByWeekday(Weekday weekday) async {
    return await _activityDao.findActivitiesByWeekday(weekday);
  }

  Future<List<Activity>> getActivitiesByStatus(Status status) async {
    return await _activityDao.findActivitiesByStatus(status);
  }

  Future<List<Activity>> getActivitiesByWeekdayAndStatus(Weekday weekday, Status status) async {
    return await _activityDao.findActivitiesByWeekdayAndStatus(weekday, status);
  }

  // Status management
  Future<void> updateActivityStatus(int id, Status status) async {
    await _activityDao.updateActivityStatus(id, status);
  }

  Future<void> markAsCompleted(int id) async {
    await updateActivityStatus(id, Status.COMPLETED);
  }

  Future<void> markAsUnfinished(int id) async {
    await updateActivityStatus(id, Status.UNFINISHED);
  }

  Future<void> markAsTransferred(int id) async {
    await updateActivityStatus(id, Status.TRANSFERED);
  }

  // Batch operations
  Future<void> updateActivitiesStatus(Status oldStatus, Status newStatus) async {
    await _activityDao.updateActivitiesStatus(oldStatus, newStatus);
  }

  Future<void> deleteActivitiesByStatus(Status status) async {
    await _activityDao.deleteActivitiesByStatus(status);
  }

  // Weekly management
  Future<List<Activity>> getCompletedActivities() async {
    return await _activityDao.findCompletedActivities(Status.COMPLETED);
  }

  Future<void> resetWeeklyActivities() async {
    // Reset completed activities to unfinished for new week
    await _activityDao.resetWeeklyActivities(Status.UNFINISHED, Status.COMPLETED);
  }

  Future<void> transferUnfinishedActivities() async {
    // Transfer unfinished activities to next week
    await _activityDao.updateActivitiesStatus(Status.UNFINISHED, Status.TRANSFERED);
  }

  // Statistics
  Future<int> getCountByStatus(Status status) async {
    return await _activityDao.getCountByStatus(status) ?? 0;
  }

  Future<int> getCountByWeekdayAndStatus(Weekday weekday, Status status) async {
    return await _activityDao.getCountByWeekdayAndStatus(weekday, status) ?? 0;
  }

  // Convenience methods
  Future<int> getCompletedCount() async {
    return await getCountByStatus(Status.COMPLETED);
  }

  Future<int> getUnfinishedCount() async {
    return await getCountByStatus(Status.UNFINISHED);
  }

  Future<int> getTransferredCount() async {
    return await getCountByStatus(Status.TRANSFERED);
  }

  Future<double> getCompletionRate() async {
    final total = await getAllActivities();
    if (total.isEmpty) return 0.0;
    
    final completed = await getCompletedCount();
    return completed / total.length;
  }
}