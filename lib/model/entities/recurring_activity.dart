import 'package:floor/floor.dart';

@entity
class RecurringActivity
{
@primaryKey
final int id;
final String name;
final String? description;
final int suggestedHours;
double reportedHours;

RecurringActivity(this.id, this.name, this.description, this.suggestedHours, this.reportedHours);
}