// lib/model/database.dart
import 'dart:async';
import 'package:floor/floor.dart';
import 'package:sqflite/sqflite.dart' as sqflite;
import 'package:week_organizer/model/Daos/activity_dao.dart';
import 'package:week_organizer/model/Daos/archived_activity_dao.dart';
import 'package:week_organizer/model/Daos/archived_reccuring_activity_dao.dart';
import 'package:week_organizer/model/Daos/reccuring_activity_dao.dart';
import 'package:week_organizer/model/entities/enums.dart';
import 'package:week_organizer/model/entities/recurring_activity.dart';
import 'package:week_organizer/model/entities/activity.dart';
import 'package:week_organizer/model/entities/archived_activity.dart';
import 'package:week_organizer/model/entities/archived_recurring_activity.dart';
part 'database.g.dart'; // the generated code will be there

// Define type converters directly in this file
class DateTimeConverter extends TypeConverter<DateTime, int> {
  @override
  DateTime decode(int databaseValue) {
    return DateTime.fromMillisecondsSinceEpoch(databaseValue);
  }

  @override
  int encode(DateTime value) {
    return value.millisecondsSinceEpoch;
  }
}

class NullableDateTimeConverter extends TypeConverter<DateTime?, int?> {
  @override
  DateTime? decode(int? databaseValue) {
    return databaseValue == null 
        ? null 
        : DateTime.fromMillisecondsSinceEpoch(databaseValue);
  }

  @override
  int? encode(DateTime? value) {
    return value?.millisecondsSinceEpoch;
  }
}

class StatusConverter extends TypeConverter<Status, int> {
  @override
  Status decode(int databaseValue) {
    return Status.values[databaseValue];
  }

  @override
  int encode(Status value) {
    return value.index;
  }
}

class WeekdayConverter extends TypeConverter<Weekday, int> {
  @override
  Weekday decode(int databaseValue) {
    return Weekday.values[databaseValue];
  }

  @override
  int encode(Weekday value) {
    return value.index;
  }
}

class NullableWeekdayConverter extends TypeConverter<Weekday?, int?> {
  @override
  Weekday? decode(int? databaseValue) {
    return databaseValue == null ? null : Weekday.values[databaseValue];
  }

  @override
  int? encode(Weekday? value) {
    return value?.index;
  }
}

class NullableStatusConverter extends TypeConverter<Status?, int?> {
  @override
  Status? decode(int? databaseValue) {
    return databaseValue == null ? null : Status.values[databaseValue];
  }

  @override
  int? encode(Status? value) {
    return value?.index;
  }
}

@TypeConverters([
  DateTimeConverter, 
  NullableDateTimeConverter,
  StatusConverter,
  WeekdayConverter,
  NullableWeekdayConverter,
  NullableStatusConverter
])
@Database(version: 1, entities: [Activity, RecurringActivity, ArchivedActivity, ArchivedRecurringActivity])
abstract class AppDatabase extends FloorDatabase {
  ActivityDao get activityDao;
  RecurringActivityDao get reccuringActivityDao;
  ArchivedActivityDao get archivedActivityDao;
  ArchivedRecurringActivityDao get archivedRecurringActivityDao;
}