import 'package:isar/isar.dart';
import 'package:todo_app/helper/available_color.dart';
import 'package:todo_app/helper/available_icon.dart';

part 'category.g.dart';

@Collection()
class CategoryData {
  Id id = Isar.autoIncrement;

  String name;

  @Enumerated(EnumType.name)
  AvailableIcon? icon;

  @Enumerated(EnumType.name)
  AvailableColor? color;

  CategoryData({
    required this.name,
    required this.icon,
    required this.color,
  });
}

// import 'package:flutter/material.dart';

// class CategoryData {
//   final String id;
//   final String name;
//   final IconData icon;
//   final Color color;

//   CategoryData({
//     required this.id,
//     required this.name,
//     required this.icon,
//     required this.color,
//   });

//   CategoryData copyWith({
//     String? id,
//     String? name,
//     IconData? icon,
//     Color? color,
//     bool force = false,
//   }) {
//     if (force) {
//       return CategoryData(
//         id: id!,
//         name: name!,
//         icon: icon!,
//         color: color!,
//       );
//     }

//     return CategoryData(
//       id: id ?? this.id,
//       name: name ?? this.name,
//       icon: icon ?? this.icon,
//       color: color ?? this.color,
//     );
//   }

//   @override
//   String toString() {
//     return "Category(id: $id, name: $name, icon: $icon, color: $color)";
//   }

//   @override
//   bool operator ==(Object other) {
//     if (identical(this, other)) return true;

//     return other is CategoryData &&
//         other.id == id &&
//         other.name == name &&
//         other.icon == icon &&
//         other.color == color;
//   }

//   @override
//   int get hashCode {
//     return id.hashCode ^ name.hashCode ^ icon.hashCode ^ color.hashCode;
//   }
// }
