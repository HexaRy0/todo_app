import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/model/category.dart';
import 'package:todo_app/model/task.dart';
import 'package:todo_app/providers/category_provider.dart';
import 'package:todo_app/providers/task_provider.dart';
import 'package:todo_app/screens/task_detail/task_detail.dart';
import 'package:todo_app/widgets/chips.dart';

class TaskListScreen extends ConsumerStatefulWidget {
  const TaskListScreen({super.key});

  @override
  ConsumerState<TaskListScreen> createState() => TaskListScreenState();
}

class TaskListScreenState extends ConsumerState<TaskListScreen> {
  @override
  Widget build(BuildContext context) {
    final tasks = ref.watch(tasksProvider);
    final categories = ref.watch(categoriesProvider);
    final selectedCategory = ref.watch(selectedCategoryProvider);
    List<TaskData> filteredTaskList = selectedCategory == null
        ? tasks
        : tasks.where((element) => element.categoryId == selectedCategory.id).toList();

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

              return Container(
                margin: const EdgeInsets.symmetric(vertical: 4),
                child: Slidable(
                  key: Key(task.id),
                  groupTag: "task",
                  startActionPane: ActionPane(
                    motion: const ScrollMotion(),
                    extentRatio: 0.25,
                    children: [
                      SlidableAction(
                        borderRadius: BorderRadius.circular(8),
                        onPressed: (context) {
                          ref.read(tasksProvider.notifier).toggleTask(task);
                        },
                        backgroundColor: ColorScheme.fromSeed(
                          seedColor: !isTaskFinished ? Colors.green : Colors.red,
                          brightness: Theme.of(context).brightness,
                        ).primaryContainer,
                        foregroundColor: ColorScheme.fromSeed(
                          seedColor: !isTaskFinished ? Colors.green : Colors.red,
                          brightness: Theme.of(context).brightness,
                        ).onPrimaryContainer,
                        icon: !isTaskFinished ? Icons.check_circle_outline : Icons.close,
                        label: !isTaskFinished ? 'Finish' : 'Unfinish',
                      ),
                    ],
                  ),
                  endActionPane: ActionPane(
                    motion: const ScrollMotion(),
                    extentRatio: 0.5,
                    dismissible: DismissiblePane(onDismissed: () {
                      ref.read(tasksProvider.notifier).removeTask(task);
                    }),
                    children: [
                      SlidableAction(
                        flex: 5,
                        borderRadius: BorderRadius.circular(8),
                        onPressed: (context) {},
                        backgroundColor: ColorScheme.fromSeed(
                          seedColor: Colors.orange,
                          brightness: Theme.of(context).brightness,
                        ).primaryContainer,
                        foregroundColor: ColorScheme.fromSeed(
                          seedColor: Colors.orange,
                          brightness: Theme.of(context).brightness,
                        ).onPrimaryContainer,
                        icon: Icons.edit_outlined,
                        label: 'Edit',
                      ),
                      const Flexible(
                        flex: 1,
                        child: SizedBox(
                          width: 8,
                        ),
                      ),
                      SlidableAction(
                        flex: 5,
                        borderRadius: BorderRadius.circular(8),
                        onPressed: (context) {
                          ref.read(tasksProvider.notifier).removeTask(task);
                        },
                        backgroundColor: ColorScheme.fromSeed(
                          seedColor: Colors.red,
                          brightness: Theme.of(context).brightness,
                        ).primaryContainer,
                        foregroundColor: ColorScheme.fromSeed(
                          seedColor: Colors.red,
                          brightness: Theme.of(context).brightness,
                        ).onPrimaryContainer,
                        icon: Icons.delete_outline,
                        label: 'Delete',
                      ),
                    ],
                  ),
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => TaskDetailScreen(
                              taskId: task.id,
                            ),
                          ),
                        );
                      });
                    },
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 8),
                      decoration: BoxDecoration(
                        color: category != null
                            ? ColorScheme.fromSeed(
                                seedColor: category.color,
                                brightness: Theme.of(context).brightness,
                              ).primaryContainer
                            : Theme.of(context).colorScheme.primaryContainer,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.1),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Transform.scale(
                              scale: 1.25,
                              child: Checkbox(
                                shape: const CircleBorder(),
                                value: isTaskFinished,
                                onChanged: (value) {
                                  setState(() {
                                    ref.read(tasksProvider.notifier).toggleTask(task);
                                  });
                                },
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        task.title,
                                        style: TextStyle(
                                          decoration:
                                              isTaskFinished ? TextDecoration.lineThrough : null,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 8,
                                      ),
                                    ],
                                  ),
                                  if (task.description.isNotEmpty)
                                    Text(
                                      task.description,
                                      style: TextStyle(
                                        decoration:
                                            isTaskFinished ? TextDecoration.lineThrough : null,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  const SizedBox(height: 4),
                                  Wrap(
                                    direction: Axis.horizontal,
                                    spacing: 5.0,
                                    children: [
                                      if (task.date != null)
                                        Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Icon(
                                              Icons.calendar_today,
                                              size: 16,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .onSurface
                                                  .withOpacity(0.5),
                                            ),
                                            const SizedBox(width: 4),
                                            Text(
                                              DateFormat.yMd().format(task.date!),
                                              style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w400,
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .onSurface
                                                    .withOpacity(0.5),
                                              ),
                                            ),
                                          ],
                                        ),
                                      if (task.time != null)
                                        Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Icon(
                                              Icons.access_time,
                                              size: 16,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .onSurface
                                                  .withOpacity(0.5),
                                            ),
                                            const SizedBox(width: 4),
                                            Text(
                                              DateFormat.Hm().format(task.time!),
                                              style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w400,
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .onSurface
                                                    .withOpacity(0.5),
                                              ),
                                            ),
                                          ],
                                        ),
                                      Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(
                                            category?.icon ?? Icons.category,
                                            size: 16,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onSurface
                                                .withOpacity(0.5),
                                          ),
                                          const SizedBox(width: 4),
                                          Text(
                                            category?.name ?? "No Category",
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w400,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .onSurface
                                                  .withOpacity(0.5),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                setState(() {
                                  ref.read(tasksProvider.notifier).toggleStarTask(task);
                                });
                              },
                              icon: Icon(
                                task.isStarred ? Icons.star : Icons.star_outline,
                                color: task.isStarred
                                    ? ColorScheme.fromSeed(
                                        seedColor: Colors.yellow,
                                        brightness: Theme.of(context).brightness,
                                      ).primary
                                    : Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
      ],
    );
  }
}
