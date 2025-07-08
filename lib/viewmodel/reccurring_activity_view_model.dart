import 'package:flutter/foundation.dart';
import 'package:week_organizer/model/entities/recurring_activity.dart';
import 'package:week_organizer/model/repositories/reccuring_activity_repository.dart';

class RecurringActivityViewModel extends ChangeNotifier {
  final RecurringActivityRepository _repository;

  List<RecurringActivity> _activities = [];
  bool _isLoading = true;

  List<RecurringActivity> get activities => _activities;
  bool get isLoading => _isLoading;

  RecurringActivityViewModel(this._repository) {
    loadActivities();
  }

  Future<void> loadActivities() async {
    _isLoading = true;
    notifyListeners();

    _activities = await _repository.getAllRecurringActivities();

    _isLoading = false;
    notifyListeners();
  }

  Future<void> addActivity(RecurringActivity activity) async {
  final newId = await _repository.insertRecurringActivity(activity);
  //debugPrint("Inserted activity with ID: $newId");
  await loadActivities();
  }

  Future<void> updateActivity(RecurringActivity activity) async {
    await _repository.updateRecurringActivity(activity);
    await loadActivities();
  }

  Future<void> deleteActivity(RecurringActivity activity) async {
    await _repository.deleteRecurringActivity(activity);
    await loadActivities();
  }

  Future<void> addHours(int activityId, double hours) async {
    final activity = _activities.firstWhere((a) => a.id == activityId);
    activity.reportedHours += hours;
    await updateActivity(activity);
    }
}
