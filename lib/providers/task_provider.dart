import 'package:riverpod/riverpod.dart';
import 'package:todo_app/model/task.dart';

class Tasks extends StateNotifier<List<TaskData>> {
  Tasks([List<TaskData>? initialTasks]) : super(initialTasks ?? []);

  void addTask(TaskData newTask) {
    state = [...state, newTask];
  }

  void updateTask(TaskData task) {
    state = state.map((element) => element.id == task.id ? task : element).toList();
  }

  void forceUpdateTask(TaskData task) {
    state = state.map((element) => element.id == task.id ? task : element).toList();
  }

  void toggleTask(TaskData task) {
    state = state
        .map((element) =>
            element.id == task.id ? task.copyWith(isCompleted: !task.isCompleted) : element)
        .toList();
  }

  void toggleStarTask(TaskData task) {
    state = state
        .map((element) =>
            element.id == task.id ? task.copyWith(isStarred: !task.isStarred) : element)
        .toList();
  }

  void removeTask(TaskData task) {
    state = state.where((element) => element.id != task.id).toList();
  }
}

final tasksProvider = StateNotifierProvider<Tasks, List<TaskData>>((ref) {
  return Tasks();
});
