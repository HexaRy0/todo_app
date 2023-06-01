import 'package:flutter/material.dart';

class Category {
  final String id;
  final String name;
  final IconData icon;

  Category({
    required this.id,
    required this.name,
    required this.icon,
  });

  static List<Category> categoryList = [
    Category(
      id: "1",
      name: "All",
      icon: Icons.task_alt,
    ),
    Category(
      id: "2",
      name: "Work",
      icon: Icons.work,
    ),
    Category(
      id: "3",
      name: "Personal",
      icon: Icons.person,
    ),
    Category(
      id: "4",
      name: "Shopping",
      icon: Icons.shopping_bag,
    ),
    Category(
      id: "5",
      name: "Others",
      icon: Icons.category,
    ),
  ];

  static Category getCategoryById(String id) {
    return categoryList.firstWhere((category) => category.id == id);
  }

  @override
  String toString() {
    return "Category(id: $id, name: $name, icon: $icon)";
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Category && other.id == id && other.name == name && other.icon == icon;
  }

  @override
  int get hashCode {
    return id.hashCode ^ name.hashCode ^ icon.hashCode;
  }
}
