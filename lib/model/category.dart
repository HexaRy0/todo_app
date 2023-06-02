import 'package:flutter/material.dart';

class CategoryData {
  final String id;
  final String name;
  final IconData icon;

  CategoryData({
    required this.id,
    required this.name,
    required this.icon,
  });

  @override
  String toString() {
    return "Category(id: $id, name: $name, icon: $icon)";
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is CategoryData && other.id == id && other.name == name && other.icon == icon;
  }

  @override
  int get hashCode {
    return id.hashCode ^ name.hashCode ^ icon.hashCode;
  }
}
