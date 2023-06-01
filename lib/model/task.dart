import 'package:todo_app/model/category.dart';

class TaskData {
  final String title;
  final String description;
  final DateTime date;
  final Category category;
  bool isCompleted;

  TaskData({
    required this.title,
    required this.description,
    required this.date,
    required this.category,
    this.isCompleted = false,
  });
}
