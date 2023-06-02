import 'package:todo_app/model/category.dart';

class TaskData {
  final String id;
  final String title;
  final String description;
  final DateTime date;
  final CategoryData? category;
  bool isCompleted;

  TaskData({
    required this.id,
    required this.title,
    required this.description,
    required this.date,
    this.category,
    this.isCompleted = false,
  });

  TaskData copyWith({
    String? id,
    String? title,
    String? description,
    DateTime? date,
    CategoryData? category,
    bool? isCompleted,
  }) {
    return TaskData(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      date: date ?? this.date,
      category: category ?? this.category,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}
