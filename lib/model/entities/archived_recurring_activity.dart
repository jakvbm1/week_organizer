import 'package:floor/floor.dart';

@entity

class ArchivedRecurringActivity {
  @primaryKey
  final int id;
  final int originalId; // References the original RecurringActivity
  final String name;
  final String? description;
  final int suggestedHours;
  final double reportedHours;
  final DateTime weekStartDate; // Week this was archived for
  final DateTime archivedAt;
  
  ArchivedRecurringActivity(this.id, this.originalId, this.name, 
    this.description, this.suggestedHours, this.reportedHours, 
    this.weekStartDate, this.archivedAt);
}