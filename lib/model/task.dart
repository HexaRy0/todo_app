import 'package:todo_app/model/category.dart';

class TaskData {
  final String title;
  final String description;
  final DateTime date;
  final CategoryData category;
  bool isCompleted;

  TaskData({
    required this.title,
    required this.description,
    required this.date,
    required this.category,
    this.isCompleted = false,
  });

  TaskData copyWith({
    String? title,
    String? description,
    DateTime? date,
    CategoryData? category,
    bool? isCompleted,
  }) {
    return TaskData(
      title: title ?? this.title,
      description: description ?? this.description,
      date: date ?? this.date,
      category: category ?? this.category,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}
