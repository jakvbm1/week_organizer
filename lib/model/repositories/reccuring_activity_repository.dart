
import 'package:week_organizer/model/daos/reccuring_activity_dao.dart';
import 'package:week_organizer/model/entities/recurring_activity.dart';

class RecurringActivityRepository {
  final RecurringActivityDao _recurringActivityDao;

  RecurringActivityRepository(this._recurringActivityDao);

  // Basic CRUD operations
  Future<List<RecurringActivity>> getAllRecurringActivities() async {
    return await _recurringActivityDao.findAllRecurringActivities();
  }

  Future<RecurringActivity?> getRecurringActivityById(int id) async {
    return await _recurringActivityDao.findRecurringActivityById(id);
  }

  Future<int> insertRecurringActivity(RecurringActivity activity) async {
  return await _recurringActivityDao.insertRecurringActivity(activity);
  }

  Future<void> insertRecurringActivities(List<RecurringActivity> activities) async {
    await _recurringActivityDao.insertRecurringActivities(activities);
  }

  Future<void> updateRecurringActivity(RecurringActivity activity) async {
    await _recurringActivityDao.updateRecurringActivity(activity);
  }

  Future<void> deleteRecurringActivity(RecurringActivity activity) async {
    await _recurringActivityDao.deleteRecurringActivity(activity);
  }

  Future<void> deleteRecurringActivityById(int id) async {
    await _recurringActivityDao.deleteRecurringActivityById(id);
  }

  // Time reporting
  Future<void> updateReportedHours(int id, double hours) async {
    await _recurringActivityDao.updateReportedHours(id, hours);
  }

  Future<void> addHours(int id, double hours) async {
    final activity = await getRecurringActivityById(id);
    if (activity != null) {
      final newHours = activity.reportedHours + hours;
      await updateReportedHours(id, newHours);
    }
  }

  Future<void> resetReportedHours(int id) async {
    await updateReportedHours(id, 0.0);
  }

  Future<void> resetAllReportedHours() async {
    await _recurringActivityDao.resetAllReportedHours();
  }

  // Queries
  Future<List<RecurringActivity>> getActivitiesWithReportedHours() async {
    return await _recurringActivityDao.findActivitiesWithReportedHours();
  }

  Future<List<RecurringActivity>> getActivitiesWithoutReportedHours() async {
    final allActivities = await getAllRecurringActivities();
    return allActivities.where((activity) => activity.reportedHours == 0.0).toList();
  }

  // Statistics
  Future<double> getTotalReportedHours() async {
    return await _recurringActivityDao.getTotalReportedHours() ?? 0.0;
  }

  Future<int> getTotalSuggestedHours() async {
    return await _recurringActivityDao.getTotalSuggestedHours() ?? 0;
  }

  Future<double> getHoursProgress() async {
    final suggested = await getTotalSuggestedHours();
    if (suggested == 0) return 0.0;
    
    final reported = await getTotalReportedHours();
    return reported / suggested;
  }

  Future<double> getAverageReportedHours() async {
    final activities = await getAllRecurringActivities();
    if (activities.isEmpty) return 0.0;
    
    final totalReported = await getTotalReportedHours();
    return totalReported / activities.length;
  }

  Future<double> getAverageSuggestedHours() async {
    final activities = await getAllRecurringActivities();
    if (activities.isEmpty) return 0.0;
    
    final totalSuggested = await getTotalSuggestedHours();
    return totalSuggested / activities.length;
  }

  // Goal tracking
  Future<List<RecurringActivity>> getActivitiesUnderGoal() async {
    final activities = await getAllRecurringActivities();
    return activities.where((activity) => 
      activity.reportedHours < activity.suggestedHours
    ).toList();
  }

  Future<List<RecurringActivity>> getActivitiesOverGoal() async {
    final activities = await getAllRecurringActivities();
    return activities.where((activity) => 
      activity.reportedHours > activity.suggestedHours
    ).toList();
  }

  Future<List<RecurringActivity>> getActivitiesAtGoal() async {
    final activities = await getAllRecurringActivities();
    return activities.where((activity) => 
      activity.reportedHours == activity.suggestedHours
    ).toList();
  }

  // Convenience methods
  Future<bool> hasReportedHours(int id) async {
    final activity = await getRecurringActivityById(id);
    return activity?.reportedHours != null && activity!.reportedHours > 0;
  }

  Future<double> getGoalProgress(int id) async {
    final activity = await getRecurringActivityById(id);
    if (activity == null || activity.suggestedHours == 0) return 0.0;
    
    return activity.reportedHours / activity.suggestedHours;
  }

  Future<double> getRemainingHours(int id) async {
    final activity = await getRecurringActivityById(id);
    if (activity == null) return 0.0;
    
    final remaining = activity.suggestedHours - activity.reportedHours;
    return remaining < 0 ? 0.0 : remaining;
  }
}