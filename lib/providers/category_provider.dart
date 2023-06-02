import 'package:flutter/material.dart';
import 'package:riverpod/riverpod.dart';
import 'package:todo_app/model/category.dart';

class CategoriesClass extends StateNotifier<List<CategoryData>> {
  CategoriesClass([List<CategoryData>? initialCategories])
      : super(
          initialCategories ??
              [
                CategoryData(
                  id: "1",
                  name: "Work",
                  icon: Icons.work,
                ),
                CategoryData(
                  id: "2",
                  name: "Personal",
                  icon: Icons.person,
                ),
                CategoryData(
                  id: "3",
                  name: "Shopping",
                  icon: Icons.shopping_bag,
                ),
              ],
        );

  void addTask(CategoryData newCategory) {
    state = [...state, newCategory];
  }

  void removeTask(CategoryData category) {
    state = state.where((element) => element != category).toList();
  }
}

final categoriesProvider = StateNotifierProvider<CategoriesClass, List<CategoryData>>((ref) {
  return CategoriesClass();
});
