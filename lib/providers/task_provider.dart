import 'package:flutter/material.dart';
import 'package:riverpod/riverpod.dart';
import 'package:todo_app/model/category.dart';
import 'package:todo_app/model/task.dart';

class Tasks extends StateNotifier<List<TaskData>> {
  Tasks([List<TaskData>? initialTasks])
      : super(initialTasks ??
            [
              TaskData(
                title: "Test",
                description: "description",
                date: DateTime.now(),
                category: CategoryData(
                  id: "8",
                  name: "Others",
                  icon: Icons.category,
                ),
              ),
              TaskData(
                title: "Test",
                description: "description",
                date: DateTime.now(),
                category: CategoryData(
                  id: "2",
                  name: "Work",
                  icon: Icons.work,
                ),
              ),
              TaskData(
                title: "Test",
                description: "description",
                date: DateTime.now(),
                category: CategoryData(
                  id: "3",
                  name: "Personal",
                  icon: Icons.person,
                ),
              ),
              TaskData(
                title: "Test",
                description: "description",
                date: DateTime.now(),
                category: CategoryData(
                  id: "4",
                  name: "Shopping",
                  icon: Icons.shopping_bag,
                ),
              ),
              TaskData(
                title: "Test",
                description: "description",
                date: DateTime.now(),
                category: CategoryData(
                  id: "5",
                  name: "Happy",
                  icon: Icons.mood,
                ),
              )
            ]);

  void addTask(TaskData newTask) {
    state = [...state, newTask];
  }

  void updateTask(TaskData task) {
    state = state.map((element) => element == task ? task : element).toList();
  }

  void toggleTask(TaskData task) {
    state = state
        .map((element) => element == task ? task.copyWith(isCompleted: !task.isCompleted) : element)
        .toList();
  }

  void removeTask(TaskData task) {
    state = state.where((element) => element != task).toList();
  }
}

final tasksProvider = StateNotifierProvider<Tasks, List<TaskData>>((ref) {
  return Tasks();
});
