import 'package:isar/isar.dart';

part 'task.g.dart';

@Collection()
class TaskData {
  Id id = Isar.autoIncrement;

  String title;
  String description;
  DateTime? date;
  DateTime? time;
  String? categoryId;
  bool isStarred;
  bool isCompleted;

  TaskData({
    required this.title,
    required this.description,
    this.date,
    this.time,
    this.categoryId,
    this.isStarred = false,
    this.isCompleted = false,
  });

  @override
  String toString() {
    return 'TaskData(title: $title, description: $description, date: $date, time: $time, categoryId: $categoryId, isStarred: $isStarred, isCompleted: $isCompleted)';
  }
}
