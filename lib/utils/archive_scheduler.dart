import 'package:shared_preferences/shared_preferences.dart';

Future<bool> shouldRunWeeklyArchive() async {
  final prefs = await SharedPreferences.getInstance();
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);

  final lastRunMillis = prefs.getInt('last_archive_date');
  if (lastRunMillis != null) {
    final lastRun = DateTime.fromMillisecondsSinceEpoch(lastRunMillis);
    if (lastRun == today) return false; // Already ran today
  }

  if (now.weekday == DateTime.monday) {
    await prefs.setInt('last_archive_date', today.millisecondsSinceEpoch);
    return true;
  }

  return false;
}
