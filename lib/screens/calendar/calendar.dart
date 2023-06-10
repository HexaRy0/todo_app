import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/providers/category_provider.dart';
import 'package:todo_app/providers/task_provider.dart';
import 'package:todo_app/widgets/calendar.dart';

class CalendarScreen extends ConsumerStatefulWidget {
  const CalendarScreen({super.key});

  @override
  ConsumerState<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends ConsumerState<CalendarScreen> {
  DateTime _selectedDay = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final tasks = ref.watch(tasksProvider);
    final filteredTaskList = tasks.where((element) {
      return element.date?.year == _selectedDay.year &&
          element.date?.month == _selectedDay.month &&
          element.date?.day == _selectedDay.day;
    }).toList();

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Calendar(
            tasks: tasks,
            onDaySelected: (day) {
              setState(() {
                _selectedDay = day;
              });
            },
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Task on",
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                Text(
                  DateFormat.MMMd().format(_selectedDay),
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          if (filteredTaskList.isEmpty)
            Container(
              height: 160,
              width: double.infinity,
              margin: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceVariant,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Theme.of(context).colorScheme.onSurface.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  "No task on this day",
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
                      ),
                ),
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
                    : ref
                        .read(categoriesProvider)
                        .firstWhere((element) => element.id == task.categoryId);

                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
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
                              Text(
                                task.title,
                                style: TextStyle(
                                  decoration: isTaskFinished ? TextDecoration.lineThrough : null,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              if (task.description.isNotEmpty)
                                Text(
                                  task.description,
                                  style: TextStyle(
                                    decoration: isTaskFinished ? TextDecoration.lineThrough : null,
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
                );
              },
            )
        ],
      ),
    );
  }
}
