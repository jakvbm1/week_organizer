import 'package:flutter/material.dart';
import 'package:week_organizer/model/entities/activity.dart';
import 'package:week_organizer/model/entities/enums.dart';
import 'package:week_organizer/model/repositories/activity_repository.dart';


class ActivityViewModel extends ChangeNotifier {
  final ActivityRepository _repository;

  ActivityViewModel(this._repository);

  List<Activity> _allActivities = [];
  List<Activity> get allActivities => _allActivities;

  // Track expansion state of each weekday section
  final Map<Weekday, bool> _expanded = {
    for (var day in Weekday.values) day: false,
  };
  Map<Weekday, bool> get expanded => _expanded;

  // For generating new IDs locally if needed (you might want a better ID strategy)
  int _nextId = 1;

  Future<void> loadActivities() async {
    _allActivities = await _repository.getAllActivities();
    // Ensure _nextId is ahead of any existing IDs
    if (_allActivities.isNotEmpty) {
      _nextId = _allActivities.map((a) => a.id).reduce((a, b) => a > b ? a : b) + 1;
    }
    notifyListeners();
  }

  Map<Weekday, List<Activity>> get groupedActivities {
    return {
      for (var day in Weekday.values)
        day: _allActivities.where((a) => a.weekday == day).toList(),
    };
  }

  String weekdayToString(Weekday day) {
    return day.name[0] + day.name.substring(1).toLowerCase();
  }

  Color statusColor(Status status, BuildContext context) {
    switch (status) {
      case Status.COMPLETED:
        return Theme.of(context).colorScheme.secondary;
      case Status.TRANSFERED:
        return Theme.of(context).colorScheme.tertiary;
      case Status.UNFINISHED:
      return Theme.of(context).colorScheme.primary;
    }
  }

  void toggleExpanded(Weekday day, bool value) {
    _expanded[day] = value;
    notifyListeners();
  }

  Future<void> addActivity(String name, String? description, Weekday weekday) async {
    if (name.trim().isEmpty) return;
    final activity = Activity(
      _nextId++,
      name,
      description?.trim().isEmpty == true ? null : description,
      Status.UNFINISHED,
      weekday,
    );
    await _repository.insertActivity(activity);
    _allActivities.add(activity);
    notifyListeners();
  }

  Future<void> deleteActivity(Activity activity) async
  {
    await _repository.deleteActivity(activity);
    notifyListeners();
  }

  Future<void> markActivityCompleted(Activity activity) async {
    activity.status = Status.COMPLETED;
    await _repository.updateActivity(activity);
    notifyListeners();
  }
}
