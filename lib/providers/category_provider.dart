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
                  name: "All",
                  icon: Icons.task_alt,
                ),
                CategoryData(
                  id: "2",
                  name: "Work",
                  icon: Icons.work,
                ),
                CategoryData(
                  id: "3",
                  name: "Personal",
                  icon: Icons.person,
                ),
                CategoryData(
                  id: "4",
                  name: "Shopping",
                  icon: Icons.shopping_bag,
                ),
                CategoryData(
                  id: "5",
                  name: "Happy",
                  icon: Icons.mood,
                ),
                CategoryData(
                  id: "6",
                  name: "Sad",
                  icon: Icons.mood_bad,
                ),
                CategoryData(
                  id: "7",
                  name: "Angry",
                  icon: Icons.mode_edit_outline,
                ),
                CategoryData(
                  id: "8",
                  name: "Others",
                  icon: Icons.category,
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
