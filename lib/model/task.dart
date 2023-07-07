import 'package:isar/isar.dart';

part 'task.g.dart';

@Collection()
class TaskData {
  Id id = Isar.autoIncrement;

  String title;
  String description;
  DateTime? date;
  DateTime? time;
  int? categoryId;
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

// class TaskData {
//   final String id;
//   final String title;
//   final String description;
//   final DateTime? date;
//   final DateTime? time;
//   final String? categoryId;
//   final bool isStarred;
//   final bool isCompleted;

//   TaskData({
//     required this.id,
//     required this.title,
//     required this.description,
//     this.date,
//     this.time,
//     this.categoryId,
//     this.isStarred = false,
//     this.isCompleted = false,
//   });

//   TaskData copyWith({
//     String? id,
//     String? title,
//     String? description,
//     DateTime? date,
//     DateTime? time,
//     String? categoryId,
//     bool? isStarred,
//     bool? isCompleted,
//     bool force = false,
//   }) {
//     if (force) {
//       return TaskData(
//         id: id!,
//         title: title!,
//         description: description!,
//         date: date!,
//         time: time!,
//         categoryId: categoryId!,
//         isStarred: isStarred!,
//         isCompleted: isCompleted!,
//       );
//     }

//     return TaskData(
//       id: id ?? this.id,
//       title: title ?? this.title,
//       description: description ?? this.description,
//       date: date ?? this.date,
//       time: time ?? this.time,
//       categoryId: categoryId ?? this.categoryId,
//       isStarred: isStarred ?? this.isStarred,
//       isCompleted: isCompleted ?? this.isCompleted,
//     );
//   }
// }
