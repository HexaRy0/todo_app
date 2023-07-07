import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:todo_app/model/task.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'async_task_provider.g.dart';

@riverpod
class AsyncTask extends _$AsyncTask {
  Isar? isar = Isar.getInstance('todo_app');

  Future<List<TaskData>> _fetchTasks() async {
    return await isar!.taskDatas.where().findAll();
  }

  @override
  FutureOr<List<TaskData>> build() async {
    return await _fetchTasks();
  }

  Future<void> addTask(TaskData newTask) async {
    state = const AsyncValue.loading();
    final todo = TaskData(
      title: newTask.title,
      description: newTask.description,
      date: newTask.date,
      time: newTask.time,
      categoryId: newTask.categoryId,
    );
    state = await AsyncValue.guard(() async {
      await isar!.writeTxn(() async {
        await isar!.taskDatas.put(todo);
      });
      return _fetchTasks();
    });
  }

  Future<void> updateTask(TaskData task) async {
    state = const AsyncValue.loading();
    final todo = await isar!.taskDatas.get(task.id);
    todo!.title = task.title;
    todo.description = task.description;
    todo.date = task.date;
    todo.time = task.time;
    todo.categoryId = task.categoryId;
    state = await AsyncValue.guard(() async {
      await isar!.writeTxn(() async {
        await isar!.taskDatas.put(todo);
      });
      return _fetchTasks();
    });
  }

  Future<void> toggleTask(TaskData task) async {
    state = const AsyncValue.loading();
    final todo = await isar!.taskDatas.get(task.id);
    todo!.isCompleted = !task.isCompleted;
    state = await AsyncValue.guard(() async {
      await isar!.writeTxn(() async {
        await isar!.taskDatas.put(todo);
      });
      return _fetchTasks();
    });
  }

  Future<void> toggleStarTask(TaskData task) async {
    state = const AsyncValue.loading();
    final todo = await isar!.taskDatas.get(task.id);
    debugPrint("Wow");
    debugPrint(todo.toString());
    todo!.isStarred = !task.isStarred;
    state = await AsyncValue.guard(() async {
      await isar!.writeTxn(() async {
        await isar!.taskDatas.put(todo);
      });
      return _fetchTasks();
    });
  }

  Future<void> removeTask(TaskData task) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await isar!.writeTxn(() async {
        await isar!.taskDatas.delete(task.id);
      });
      return _fetchTasks();
    });
  }
}

// import 'package:riverpod/riverpod.dart';
// import 'package:todo_app/model/task.dart';

// class Tasks extends StateNotifier<List<TaskData>> {
//   Tasks([List<TaskData>? initialTasks]) : super(initialTasks ?? []);

//   void addTask(TaskData newTask) {
//     state = [...state, newTask];
//   }

//   void updateTask(TaskData task) {
//     state = state.map((element) => element.id == task.id ? task : element).toList();
//   }

//   void forceUpdateTask(TaskData task) {
//     state = state.map((element) => element.id == task.id ? task : element).toList();
//   }

//   void toggleTask(TaskData task) {
//     state = state
//         .map((element) =>
//             element.id == task.id ? task.copyWith(isCompleted: !task.isCompleted) : element)
//         .toList();
//   }

//   void toggleStarTask(TaskData task) {
//     state = state
//         .map((element) =>
//             element.id == task.id ? task.copyWith(isStarred: !task.isStarred) : element)
//         .toList();
//   }

//   void removeTask(TaskData task) {
//     state = state.where((element) => element.id != task.id).toList();
//   }
// }

// final tasksProvider = StateNotifierProvider<Tasks, List<TaskData>>((ref) {
//   return Tasks();
// });
