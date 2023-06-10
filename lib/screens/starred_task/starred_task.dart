import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_app/model/task.dart';
import 'package:todo_app/providers/category_provider.dart';
import 'package:todo_app/providers/task_provider.dart';
import 'package:todo_app/widgets/task_slide.dart';

class StarredTaskScreen extends ConsumerStatefulWidget {
  const StarredTaskScreen({super.key});

  @override
  ConsumerState<StarredTaskScreen> createState() => _StarredTaskScreenState();
}

class _StarredTaskScreenState extends ConsumerState<StarredTaskScreen> {
  @override
  Widget build(BuildContext context) {
    final tasks = ref.watch(tasksProvider);
    final categories = ref.watch(categoriesProvider);
    final selectedCategory = ref.watch(selectedCategoryProvider);
    List<TaskData> filteredTaskList = selectedCategory == null
        ? tasks.where((element) => element.isStarred).toList()
        : tasks
            .where((element) => element.categoryId == selectedCategory.id && element.isStarred)
            .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Starred Tasks'),
      ),
      body: ListView(
        shrinkWrap: true,
        primary: true,
        children: [
          if (filteredTaskList.isEmpty)
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.7,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Transform.rotate(
                    angle: 0.25,
                    child: Icon(
                      Icons.star,
                      size: 64,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    "There are no starred task!",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "You can star a task by long pressing it.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                ],
              ),
            )
          else
            ListView.builder(
              primary: false,
              itemCount: filteredTaskList.length,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                final task = filteredTaskList[index];
                final isTaskFinished = task.isCompleted;
                final category = task.categoryId == null
                    ? null
                    : categories.firstWhere((element) => element.id == task.categoryId);

                return TaskSlide(task: task, category: category, isTaskFinished: isTaskFinished);
              },
            ),
        ],
      ),
    );
  }
}
