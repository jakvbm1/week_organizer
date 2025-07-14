import 'package:flutter/foundation.dart';
import 'package:week_organizer/model/entities/enums.dart';
import 'package:week_organizer/model/entities/archived_activity.dart';
import 'package:week_organizer/model/entities/archived_recurring_activity.dart';
import 'package:week_organizer/model/repositories/archive_repository.dart';
import 'package:week_organizer/model/repositories/activity_repository.dart';
import 'package:week_organizer/model/repositories/reccuring_activity_repository.dart';


class ArchiveViewModel extends ChangeNotifier {
  final ArchiveRepository _archiveRepository;
  final ActivityRepository _activityRepository;
  final RecurringActivityRepository _recurringRepository;

  List<ArchivedActivity> _archivedActivities = [];
  List<ArchivedRecurringActivity> _archivedRecurring = [];
  bool _isLoading = false;

  Map<DateTime, Map<String, List<dynamic>>> groupedByWeek = {};

  ArchiveViewModel(
    this._archiveRepository,
    this._activityRepository,
    this._recurringRepository,
  );

  List<ArchivedActivity> get archivedActivities => _archivedActivities;
  List<ArchivedRecurringActivity> get archivedRecurring => _archivedRecurring;
  bool get isLoading => _isLoading;

  Future<void> loadArchiveData() async {
    _isLoading = true;
    notifyListeners();

    _archivedActivities = await _archiveRepository.getAllArchivedActivities();
    _archivedRecurring = await _archiveRepository.getAllArchivedRecurringActivities();

    _groupByWeek();

    _isLoading = false;
    notifyListeners();
  }

  void _groupByWeek() {
    groupedByWeek = {};
    for (var rec in _archivedRecurring) {
      groupedByWeek[rec.weekStartDate] ??= {'recurring': [], 'activities': []};
      groupedByWeek[rec.weekStartDate]!['recurring']!.add(rec);
    }
    for (var act in _archivedActivities) {
      groupedByWeek[act.weekStartDate] ??= {'recurring': [], 'activities': []};
      groupedByWeek[act.weekStartDate]!['activities']!.add(act);
    }
  }

  Future<void> runWeeklyArchive() async {
  final now = DateTime.now();
  final weekStartDate = now.subtract(Duration(days: now.weekday - 1));

  final activities = await _activityRepository.getAllActivities();
  final recurringActivities = await _recurringRepository.getAllRecurringActivities();

  final completed = activities.where((a) => a.status == Status.COMPLETED).toList();
  final notCompleted = activities.where((a) => a.status != Status.COMPLETED).toList();

  // Archive completed
  await _archiveRepository.archiveActivities(completed, weekStartDate);

  for (var a in notCompleted) {
    a.status = Status.TRANSFERED;
    await _activityRepository.updateActivity(a);
  }

  for (var a in completed)
  {
    await _activityRepository.deleteActivity(a);
  }

  for (var r in recurringActivities) {
    await _archiveRepository.archiveRecurringActivity(r, weekStartDate);
    r.reportedHours = 0;
    await _recurringRepository.updateRecurringActivity(r);
  }
}

  /// The archiving operation you asked for
  Future<void> archiveCurrentWeek(DateTime weekStartDate) async {
    _isLoading = true;
    notifyListeners();

    // 1. Get all current activities and recurring activities for the week
    final activities = await _activityRepository.getAllActivities();
    final recurringActivities = await _recurringRepository.getAllRecurringActivities();

    // 2. Separate completed and uncompleted activities
    final completedActivities = activities.where((a) => a.status == Status.COMPLETED).toList();
    final uncompletedActivities = activities.where((a) => a.status != Status.COMPLETED).toList();

    // 3. Archive completed activities
    await _archiveRepository.archiveActivities(completedActivities, weekStartDate);

    // 4. Mark uncompleted activities as TRANSFERRED in the DB
    for (var act in uncompletedActivities) {
      act.status = Status.TRANSFERED;
      await _activityRepository.updateActivity(act);
    }

      for (var a in completedActivities)
  {
    await _activityRepository.deleteActivity(a);
  }

    // 5. Archive recurring activities and reset reportedHours to 0
    await _archiveRepository.archiveRecurringActivities(recurringActivities, weekStartDate);
    for (var rec in recurringActivities) {
      rec.reportedHours = 0;
      await _recurringRepository.updateRecurringActivity(rec);
    }

    // 6. Reload archive data for UI refresh
    await loadArchiveData();

    _isLoading = false;
    notifyListeners();
  }
}
