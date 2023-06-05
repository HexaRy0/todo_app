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
                  color: Colors.green,
                ),
                CategoryData(
                  id: "2",
                  name: "Personal",
                  icon: Icons.person,
                  color: Colors.yellow,
                ),
                CategoryData(
                  id: "3",
                  name: "Shopping",
                  icon: Icons.shopping_bag,
                  color: Colors.red,
                ),
              ],
        );

  void addCategory(CategoryData newCategory) {
    state = [...state, newCategory];
  }

  void reorderCategory(int oldIndex, int newIndex) {
    if (oldIndex < newIndex) {
      newIndex -= 1;
    }

    final tempCategories = state;

    final item = tempCategories.removeAt(oldIndex);
    tempCategories.insert(newIndex, item);

    state = [...tempCategories];
  }

  void updateCategory(CategoryData category) {
    state = state.map((element) => element.id == category.id ? category : element).toList();
  }

  void removeCategory(CategoryData category) {
    state = state.where((element) => element != category).toList();
  }
}

final categoriesProvider = StateNotifierProvider<CategoriesClass, List<CategoryData>>((ref) {
  return CategoriesClass();
});

class SelectedCategory extends StateNotifier<CategoryData?> {
  SelectedCategory([CategoryData? initialCategory]) : super(initialCategory);

  void selectCategory(CategoryData? category) {
    state = category;
  }
}

final selectedCategoryProvider = StateNotifierProvider<SelectedCategory, CategoryData?>((ref) {
  return SelectedCategory();
});
