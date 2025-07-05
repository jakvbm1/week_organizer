import 'package:floor/floor.dart';
import 'package:week_organizer/model/entities/enums.dart';

@entity
class ArchivedActivity {
  @primaryKey
  final int id;
  final int originalId; // References the original Activity
  final String name;
  final String? description;
  final Weekday weekday;
  final Status finalStatus; // Status when archived
  final DateTime weekStartDate;
  final DateTime archivedAt;
  
  ArchivedActivity(this.id, this.originalId, this.name, this.description, 
    this.weekday, this.finalStatus, this.weekStartDate, this.archivedAt);
}