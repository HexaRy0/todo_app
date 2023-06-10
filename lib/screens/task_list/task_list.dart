import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_app/model/category.dart';
import 'package:todo_app/model/task.dart';
import 'package:todo_app/providers/category_provider.dart';
import 'package:todo_app/providers/task_provider.dart';
import 'package:todo_app/widgets/chips.dart';
import 'package:todo_app/widgets/task_slide.dart';

class TaskListScreen extends ConsumerStatefulWidget {
  const TaskListScreen({super.key});

  @override
  ConsumerState<TaskListScreen> createState() => TaskListScreenState();
}

class TaskListScreenState extends ConsumerState<TaskListScreen> {
  bool isPreviousTaskExpanded = true;
  bool isTodayTaskExpanded = true;
  bool isUpcomingTaskExpanded = true;

  @override
  Widget build(BuildContext context) {
    final tasks = ref.watch(tasksProvider);
    final categories = ref.watch(categoriesProvider);
    final selectedCategory = ref.watch(selectedCategoryProvider);
    List<TaskData> filteredTaskList = selectedCategory == null
        ? tasks
        : tasks.where((element) => element.categoryId == selectedCategory.id).toList();
    List<TaskData> previousTaskList = filteredTaskList
        .where((element) => element.date != null ? element.date!.day < DateTime.now().day : false)
        .toList();
    List<TaskData> todayTaskList = filteredTaskList
        .where((element) =>
            element.date != null ? element.date!.day == DateTime.now().day : element.date == null)
        .toList();
    List<TaskData> upcomingTaskList = filteredTaskList.where((element) {
      if (element.date != null) {
        return element.date!.day > DateTime.now().day;
      } else {
        return false;
      }
    }).toList();

    return ListView(
      shrinkWrap: true,
      primary: true,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: SizedBox(
            height: 48,
            child: ListView(
              scrollDirection: Axis.horizontal,
              shrinkWrap: true,
              children: [
                Chips(
                  category: CategoryData(
                    id: "all",
                    name: "All",
                    icon: Icons.category,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  isActive: selectedCategory == null,
                  onPressed: () {
                    setState(() {
                      ref.read(selectedCategoryProvider.notifier).selectCategory(null);
                    });
                  },
                ),
                for (final category in categories)
                  Chips(
                    category: category,
                    isActive: selectedCategory == category,
                    onPressed: () {
                      setState(() {
                        ref.read(selectedCategoryProvider.notifier).selectCategory(category);
                      });
                    },
                  ),
              ],
            ),
          ),
        ),
        if (filteredTaskList.isEmpty)
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.7,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Transform.rotate(
                  angle: 0.05,
                  child: Icon(
                    Icons.check_circle_outline,
                    size: 64,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  "There are no task!",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "You can add new task by clicking\nthe add button below.",
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
          Column(
            children: [
              if (previousTaskList.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ExpansionTile(
                    initiallyExpanded: isPreviousTaskExpanded,
                    shape: ShapeBorder.lerp(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      1,
                    ),
                    title: Text(
                      "Previous",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                    onExpansionChanged: (value) {
                      setState(() {
                        isPreviousTaskExpanded = value;
                      });
                    },
                    children: [
                      ListView.builder(
                        primary: false,
                        itemCount: previousTaskList.length,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          final task = previousTaskList[index];
                          final isTaskFinished = task.isCompleted;
                          final category = task.categoryId == null
                              ? null
                              : categories.firstWhere((element) => element.id == task.categoryId);

                          return Container(
                            margin: const EdgeInsets.symmetric(vertical: 4),
                            child: TaskSlide(
                              task: task,
                              category: category,
                              isTaskFinished: isTaskFinished,
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              if (todayTaskList.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ExpansionTile(
                    initiallyExpanded: isTodayTaskExpanded,
                    shape: ShapeBorder.lerp(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      1,
                    ),
                    title: Text(
                      "Today",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                    onExpansionChanged: (value) {
                      setState(() {
                        isTodayTaskExpanded = value;
                      });
                    },
                    children: [
                      ListView.builder(
                        primary: false,
                        itemCount: todayTaskList.length,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          final task = todayTaskList[index];
                          final isTaskFinished = task.isCompleted;
                          final category = task.categoryId == null
                              ? null
                              : categories.firstWhere((element) => element.id == task.categoryId);

                          return Container(
                            margin: const EdgeInsets.symmetric(vertical: 4),
                            child: TaskSlide(
                              task: task,
                              category: category,
                              isTaskFinished: isTaskFinished,
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              if (upcomingTaskList.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ExpansionTile(
                    initiallyExpanded: isUpcomingTaskExpanded,
                    shape: ShapeBorder.lerp(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      1,
                    ),
                    title: Text(
                      "Upcoming",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                    onExpansionChanged: (value) {
                      setState(() {
                        isUpcomingTaskExpanded = value;
                      });
                    },
                    children: [
                      ListView.builder(
                        primary: false,
                        itemCount: upcomingTaskList.length,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          final task = upcomingTaskList[index];
                          final isTaskFinished = task.isCompleted;
                          final category = task.categoryId == null
                              ? null
                              : categories.firstWhere((element) => element.id == task.categoryId);

                          return Container(
                            margin: const EdgeInsets.symmetric(vertical: 4),
                            child: TaskSlide(
                              task: task,
                              category: category,
                              isTaskFinished: isTaskFinished,
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
            ],
          ),
      ],
    );
  }
}
