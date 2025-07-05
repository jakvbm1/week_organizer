import 'package:floor/floor.dart';
import 'package:week_organizer/model/entities/enums.dart';

@entity
class Activity 
{
@primaryKey
final int id;
final String name;
final String? description;
final Weekday weekday;
Status status;


Activity(this.id, this.name, this.description, this.status, this.weekday);
}