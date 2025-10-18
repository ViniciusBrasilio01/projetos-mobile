import 'package:hive/hive.dart';

part 'task.g.dart';

@HiveType(typeId: 0)
class Task extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String title;

  @HiveField(2)
  String? description;

  @HiveField(3)
  DateTime createdAt;

  @HiveField(4)
  DateTime? dueDate;

  @HiveField(5)
  bool isCompleted;

  @HiveField(6)
  int priority;

  @HiveField(7)
  String? category;

  @HiveField(8)
  List<DateTime>? reminders;

  @HiveField(9)
  String displayMode;

  @HiveField(10)
  int points;

  Task({
    required this.id,
    required this.title,
    this.description,
    required this.createdAt,
    this.dueDate,
    this.isCompleted = false,
    this.priority = 2,
    this.category,
    this.reminders,
    this.displayMode = 'visual',
    this.points = 0,
  });
}