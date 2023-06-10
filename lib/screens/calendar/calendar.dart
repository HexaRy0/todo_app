import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/providers/category_provider.dart';
import 'package:todo_app/providers/task_provider.dart';
import 'package:todo_app/widgets/calendar.dart';
import 'package:todo_app/widgets/task_slide.dart';

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

                return TaskSlide(task: task, category: category, isTaskFinished: isTaskFinished);
              },
            )
        ],
      ),
    );
  }
}
