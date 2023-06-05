import 'package:todo_app/model/category.dart';

class TaskData {
  final String id;
  final String title;
  final String description;
  final DateTime? date;
  final DateTime? time;
  final CategoryData? category;
  final bool isStarred;
  final bool isCompleted;

  TaskData({
    required this.id,
    required this.title,
    required this.description,
    this.date,
    this.time,
    this.category,
    this.isStarred = false,
    this.isCompleted = false,
  });

  TaskData copyWith({
    String? id,
    String? title,
    String? description,
    DateTime? date,
    DateTime? time,
    CategoryData? category,
    bool? isStarred,
    bool? isCompleted,
    bool force = false,
  }) {
    if (force) {
      return TaskData(
        id: id!,
        title: title!,
        description: description!,
        date: date!,
        time: time!,
        category: category!,
        isStarred: isStarred!,
        isCompleted: isCompleted!,
      );
    }

    return TaskData(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      date: date ?? this.date,
      time: time ?? this.time,
      category: category ?? this.category,
      isStarred: isStarred ?? this.isStarred,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}
