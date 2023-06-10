import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/model/task.dart';
import 'package:todo_app/providers/category_provider.dart';
import 'package:todo_app/providers/task_provider.dart';
import 'package:todo_app/widgets/category_list.dart';
import 'package:todo_app/widgets/task_option.dart';

class TaskDetailScreen extends ConsumerStatefulWidget {
  const TaskDetailScreen({super.key, required this.taskId});

  final String taskId;

  @override
  ConsumerState<TaskDetailScreen> createState() => _TaskDetailScreenState();
}

class _TaskDetailScreenState extends ConsumerState<TaskDetailScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  bool isRemoved = false;

  void _onSelectCategory(TaskData task) {
    showDialog(
      context: context,
      builder: (context) => CategoryList(
        task: task,
      ),
    );
  }

  @override
  void initState() {
    _titleController.text =
        ref.read(tasksProvider).firstWhere((element) => element.id == widget.taskId).title;
    _descriptionController.text =
        ref.read(tasksProvider).firstWhere((element) => element.id == widget.taskId).description;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (isRemoved) {
      return const Scaffold();
    }
    final task = ref.watch(tasksProvider).firstWhere((element) => element.id == widget.taskId);
    final category = task.categoryId == null
        ? null
        : ref.watch(categoriesProvider).firstWhere((element) => element.id == task.categoryId);

    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              ref.read(tasksProvider.notifier).toggleStarTask(task);
            },
            icon: task.isStarred ? const Icon(Icons.star) : const Icon(Icons.star_border),
          ),
          IconButton(
            onPressed: () {
              isRemoved = true;
              ref.read(tasksProvider.notifier).removeTask(task);
              Navigator.pop(context);
            },
            icon: const Icon(Icons.delete),
          ),
        ],
      ),
      body: SingleChildScrollView(
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
                icon: category?.icon ?? Icons.category,
                title: category?.name ?? "No Category",
                color: category?.color,
                isValueSet: false,
                onReset: () {},
              ),
              const SizedBox(
                height: 16,
              ),
              TextField(
                controller: _titleController,
                onChanged: (value) {
                  ref.read(tasksProvider.notifier).updateTask(task.copyWith(title: value));
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
                        ref
                            .read(tasksProvider.notifier)
                            .updateTask(task.copyWith(description: value));
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
                      ref.read(tasksProvider.notifier).updateTask(task.copyWith(date: value));
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
                          task.date != null ? DateFormat.yMMMMd().format(task.date!) : "Add Date",
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
                                  id: task.id,
                                  title: task.title,
                                  description: task.description,
                                  date: null,
                                  time: task.time,
                                  categoryId: category?.id,
                                  isStarred: task.isStarred,
                                  isCompleted: task.isCompleted,
                                );

                                ref.read(tasksProvider.notifier).forceUpdateTask(newTask);
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
                        ref.read(tasksProvider.notifier).updateTask(
                              task.copyWith(
                                time: DateTime(
                                  date.year,
                                  date.month,
                                  date.day,
                                  value.hour,
                                  value.minute,
                                ),
                              ),
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
                            task.time != null ? DateFormat.yMMMMd().format(task.time!) : "Add Time",
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
                                task.time != null ? DateFormat.Hm().format(task.time!) : "Add Time",
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                              const SizedBox(
                                width: 8,
                              ),
                              GestureDetector(
                                onTap: () {
                                  final newTask = TaskData(
                                    id: task.id,
                                    title: task.title,
                                    description: task.description,
                                    date: task.date,
                                    time: null,
                                    categoryId: category?.id,
                                    isStarred: task.isStarred,
                                    isCompleted: task.isCompleted,
                                  );

                                  ref.read(tasksProvider.notifier).forceUpdateTask(newTask);
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
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          ref.read(tasksProvider.notifier).toggleTask(task);
          if (!task.isCompleted) Navigator.pop(context);
        },
        icon: !task.isCompleted ? const Icon(Icons.check) : const Icon(Icons.close),
        label:
            !task.isCompleted ? const Text("Mark as Completed") : const Text("Mark as Uncompleted"),
      ),
    );
  }
}
