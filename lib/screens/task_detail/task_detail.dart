import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/helper/generate_color.dart';
import 'package:todo_app/helper/generate_icon.dart';
import 'package:todo_app/model/task.dart';
import 'package:todo_app/providers/async_category_provider.dart';
import 'package:todo_app/providers/async_task_provider.dart';
import 'package:todo_app/widgets/category_list.dart';
import 'package:todo_app/widgets/errorr_widget.dart';
import 'package:todo_app/widgets/loading_widget.dart';
import 'package:todo_app/widgets/task_option.dart';

class TaskDetailScreen extends ConsumerStatefulWidget {
  const TaskDetailScreen({super.key, required this.task});

  final TaskData task;

  @override
  ConsumerState<TaskDetailScreen> createState() => _TaskDetailScreenState();
}

class _TaskDetailScreenState extends ConsumerState<TaskDetailScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  bool isRemoved = false;

  Widget _renderError(Object error, StackTrace stackTrace) {
    return Scaffold(
      appBar: AppBar(),
      body: const ErrorrWidget(),
    );
  }

  Widget _renderLoading() {
    return Scaffold(
      appBar: AppBar(),
      body: const LoadingWidget(),
    );
  }

  void _onSelectCategory(TaskData task) {
    showDialog(
      context: context,
      builder: (context) => CategoryList(
        task: task,
      ),
    );
  }

  Function debounce(void Function() function, Duration duration) {
    Timer? timer;

    return () {
      if (timer != null) {
        timer!.cancel();
      }

      timer = Timer(duration, () {
        function();
        timer = null;
      });
    };
  }

  @override
  void initState() {
    _titleController.text = widget.task.title;
    _descriptionController.text = widget.task.description;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (isRemoved) {
      return const Scaffold();
    }

    final asyncTasks = ref.watch(asyncTaskProvider);
    final asyncCategories = ref.watch(asyncCategoryProvider);

    return asyncTasks.when(
      skipLoadingOnRefresh: true,
      skipLoadingOnReload: true,
      data: (tasks) {
        final task = tasks.firstWhere((element) => element.id == widget.task.id);

        return asyncCategories.when(
          skipLoadingOnRefresh: true,
          skipLoadingOnReload: true,
          data: (categories) {
            final category = task.categoryId != null
                ? categories.firstWhere((element) => element.id == task.categoryId)
                : null;

            return Scaffold(
              appBar: AppBar(
                title: Text(
                  task.title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                actions: [
                  IconButton(
                    onPressed: () {
                      ref.read(asyncTaskProvider.notifier).toggleStarTask(task);
                    },
                    icon: task.isStarred ? const Icon(Icons.star) : const Icon(Icons.star_border),
                  ),
                  IconButton(
                    onPressed: () {
                      isRemoved = true;
                      ref.read(asyncTaskProvider.notifier).removeTask(task);
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.delete),
                  ),
                ],
              ),
              body: WillPopScope(
                onWillPop: () async {
                  return true;
                },
                child: SingleChildScrollView(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    width: double.infinity,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TaskOption(
                          onPressed: () {
                            _onSelectCategory(task);
                          },
                          icon: generateIcon(category?.icon),
                          title: category?.name ?? "No Category",
                          color: generateColor(category?.color, context),
                          isValueSet: false,
                          onReset: () {},
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        TextField(
                          controller: _titleController,
                          onChanged: (value) {
                            task.title = value;
                            ref.read(asyncTaskProvider.notifier).updateTask(task);
                            debugPrint(task.toString());
                          },
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: "Title",
                          ),
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                        Row(
                          children: [
                            const Icon(Icons.subject),
                            const SizedBox(
                              width: 8,
                            ),
                            Expanded(
                              child: TextField(
                                controller: _descriptionController,
                                onChanged: (value) {
                                  task.description = value;
                                  ref.read(asyncTaskProvider.notifier).updateTask(task);
                                },
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  hintText: "Add Description",
                                ),
                              ),
                            ),
                          ],
                        ),
                        InkWell(
                          onTap: () {
                            showDatePicker(
                              context: context,
                              initialDate: task.date ?? DateTime.now(),
                              firstDate: DateTime.now().subtract(const Duration(days: 365)),
                              lastDate: DateTime.now().add(const Duration(days: 365)),
                            ).then((value) {
                              if (value != null) {
                                task.date = value;
                                ref.read(asyncTaskProvider.notifier).updateTask(task);
                              }
                            });
                          },
                          child: Row(
                            children: [
                              const Icon(Icons.calendar_today),
                              const SizedBox(
                                width: 8,
                              ),
                              if (task.date == null)
                                Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                                  child: Text(
                                    task.date != null
                                        ? DateFormat.yMMMMd().format(task.date!)
                                        : "Add Date",
                                    style: Theme.of(context).textTheme.bodyLarge,
                                  ),
                                ),
                              if (task.date != null)
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.grey.shade400),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Row(
                                    children: [
                                      Text(
                                        task.date != null
                                            ? DateFormat.yMMMMd().format(task.date!)
                                            : "Add Date",
                                        style: Theme.of(context).textTheme.bodyLarge,
                                      ),
                                      const SizedBox(
                                        width: 8,
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          final newTask = TaskData(
                                            title: task.title,
                                            description: task.description,
                                            date: null,
                                            time: task.time,
                                            categoryId: category?.id,
                                            isStarred: task.isStarred,
                                            isCompleted: task.isCompleted,
                                          );

                                          ref.read(asyncTaskProvider.notifier).updateTask(newTask);
                                        },
                                        child: const Icon(
                                          Icons.close,
                                          size: 16,
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        if (task.date != null)
                          InkWell(
                            onTap: () {
                              showTimePicker(
                                context: context,
                                initialTime: TimeOfDay.fromDateTime(task.time ?? DateTime.now()),
                              ).then((value) {
                                final date = task.date ?? DateTime.now();
                                if (value != null) {
                                  task.time = DateTime(
                                    date.year,
                                    date.month,
                                    date.day,
                                    value.hour,
                                    value.minute,
                                  );
                                  ref.read(asyncTaskProvider.notifier).updateTask(
                                        task,
                                      );
                                }
                              });
                            },
                            child: Row(
                              children: [
                                const Icon(Icons.access_time),
                                const SizedBox(
                                  width: 8,
                                ),
                                if (task.time == null)
                                  Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                                    child: Text(
                                      task.time != null
                                          ? DateFormat.yMMMMd().format(task.time!)
                                          : "Add Time",
                                      style: Theme.of(context).textTheme.bodyLarge,
                                    ),
                                  ),
                                if (task.time != null)
                                  Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      border: Border.all(color: Colors.grey.shade400),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Row(
                                      children: [
                                        Text(
                                          task.time != null
                                              ? DateFormat.Hm().format(task.time!)
                                              : "Add Time",
                                          style: Theme.of(context).textTheme.bodyLarge,
                                        ),
                                        const SizedBox(
                                          width: 8,
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            final newTask = TaskData(
                                              title: task.title,
                                              description: task.description,
                                              date: task.date,
                                              time: null,
                                              categoryId: category?.id,
                                              isStarred: task.isStarred,
                                              isCompleted: task.isCompleted,
                                            );

                                            ref
                                                .read(asyncTaskProvider.notifier)
                                                .updateTask(newTask);
                                          },
                                          child: const Padding(
                                            padding: EdgeInsets.symmetric(horizontal: 8.0),
                                            child: Icon(
                                              Icons.close,
                                              size: 16,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                              ],
                            ),
                          ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Icon(Icons.check),
                            const SizedBox(
                              width: 8,
                            ),
                            Text(task.isCompleted ? "Completed" : "Not Completed"),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              floatingActionButton: FloatingActionButton.extended(
                onPressed: () {
                  ref.read(asyncTaskProvider.notifier).toggleTask(task);
                  if (!task.isCompleted) Navigator.pop(context);
                },
                icon: !task.isCompleted ? const Icon(Icons.check) : const Icon(Icons.close),
                label: !task.isCompleted
                    ? const Text("Mark as Completed")
                    : const Text("Mark as Uncompleted"),
              ),
            );
          },
          error: _renderError,
          loading: _renderLoading,
        );
      },
      error: _renderError,
      loading: _renderLoading,
    );
  }
}
