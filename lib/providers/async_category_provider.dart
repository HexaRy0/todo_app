import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:todo_app/model/category.dart';
import 'package:uuid/uuid.dart';

part 'async_category_provider.g.dart';

const uuid = Uuid();

@riverpod
class AsyncCategory extends _$AsyncCategory {
  Isar? isar = Isar.getInstance('todo_app');

  Future<List<CategoryData>> _fetchCategories() async {
    final categories = await isar!.categoryDatas.where().sortByOrder().findAll();

    if (categories.isEmpty) {
      await isar!.writeTxn(() async {
        await isar!.categoryDatas.putAll([
          CategoryData(
            catId: uuid.v4(),
            order: 0,
            name: "Work",
            icon: Icons.work.codePoint,
            color: Colors.green.value,
          ),
          CategoryData(
            catId: uuid.v4(),
            order: 1,
            name: "Personal",
            icon: Icons.person.codePoint,
            color: Colors.yellow.value,
          ),
          CategoryData(
            catId: uuid.v4(),
            order: 2,
            name: "Shopping",
            icon: Icons.shopping_bag.codePoint,
            color: Colors.red.value,
          ),
          CategoryData(
            catId: uuid.v4(),
            order: 3,
            name: "Others",
            icon: Icons.other_houses.codePoint,
            color: Colors.blue.value,
          ),
        ]);
      });

      return await isar!.categoryDatas.where().sortByOrder().findAll();
    }

    return categories;
  }

  @override
  FutureOr<List<CategoryData>> build() async {
    return await _fetchCategories();
  }

  Future<void> addCategory(CategoryData newCategory) async {
    state = const AsyncValue.loading();
    final categories = await _fetchCategories();

    final category = CategoryData(
      catId: uuid.v4(),
      order: categories.length,
      name: newCategory.name,
      icon: newCategory.icon,
      color: newCategory.color,
    );
    state = await AsyncValue.guard(() async {
      await isar!.writeTxn(() async {
        await isar!.categoryDatas.put(category);
      });
      return _fetchCategories();
    });
  }

  Future<void> reorderCategories(int oldIndex, int newIndex) async {
    state = const AsyncValue.loading();
    final categories = await _fetchCategories();

    if (newIndex > oldIndex) {
      newIndex -= 1;
    }

    final category = categories.removeAt(oldIndex);
    categories.insert(newIndex, category);

    for (var i = 0; i < categories.length; i++) {
      categories[i].order = i;
    }

    state = await AsyncValue.guard(() async {
      await isar!.writeTxn(() async {
        await isar!.categoryDatas.putAll(categories);
      });
      return _fetchCategories();
    });
  }

  Future<void> updateCategory(CategoryData newCategory) async {
    state = const AsyncValue.loading();
    final category = await isar!.categoryDatas.get(newCategory.id);
    category!.name = newCategory.name;
    category.icon = newCategory.icon;
    category.color = newCategory.color;
    state = await AsyncValue.guard(() async {
      await isar!.writeTxn(() async {
        await isar!.categoryDatas.put(category);
      });
      return _fetchCategories();
    });
  }

  Future<void> removeCategory(CategoryData category) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await isar!.writeTxn(() async {
        await isar!.categoryDatas.delete(category.id);
      });
      return _fetchCategories();
    });
  }
}

@riverpod
class SelectedCategory extends _$SelectedCategory {
  @override
  CategoryData? build() {
    return null;
  }

  void selectCategory(CategoryData? newCategory) {
    state = newCategory;
  }
}
