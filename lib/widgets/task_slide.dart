import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:todo_app/model/category.dart';
import 'package:todo_app/model/task.dart';
import 'package:todo_app/providers/async_task_provider.dart';
import 'package:todo_app/widgets/task_tile.dart';

class TaskSlide extends ConsumerStatefulWidget {
  const TaskSlide({super.key, required this.task, this.category, this.isTaskFinished = false});

  final TaskData task;
  final CategoryData? category;
  final bool isTaskFinished;

  @override
  ConsumerState<TaskSlide> createState() => _TaskSlideState();
}

class _TaskSlideState extends ConsumerState<TaskSlide> {
  @override
  Widget build(BuildContext context) {
    return Slidable(
        key: Key(widget.task.id.toString()),
        groupTag: "task",
        startActionPane: ActionPane(
          motion: const ScrollMotion(),
          extentRatio: 0.25,
          children: [
            SlidableAction(
              borderRadius: BorderRadius.circular(8),
              onPressed: (context) {
                ref.read(asyncTaskProvider.notifier).toggleTask(widget.task);
              },
              backgroundColor: ColorScheme.fromSeed(
                seedColor: !widget.isTaskFinished ? Colors.green : Colors.red,
                brightness: Theme.of(context).brightness,
              ).primaryContainer,
              foregroundColor: ColorScheme.fromSeed(
                seedColor: !widget.isTaskFinished ? Colors.green : Colors.red,
                brightness: Theme.of(context).brightness,
              ).onPrimaryContainer,
              icon: !widget.isTaskFinished ? Icons.check_circle_outline : Icons.close,
              label: !widget.isTaskFinished ? 'Finish' : 'Unfinish',
            ),
          ],
        ),
        endActionPane: ActionPane(
          extentRatio: 0.25,
          motion: const ScrollMotion(),
          dismissible: DismissiblePane(onDismissed: () {
            ref.read(asyncTaskProvider.notifier).removeTask(widget.task);
          }),
          children: [
            SlidableAction(
              borderRadius: BorderRadius.circular(8),
              onPressed: (context) {
                ref.read(asyncTaskProvider.notifier).removeTask(widget.task);
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
        child: TaskTile(
          task: widget.task,
          category: widget.category,
          isTaskFinished: widget.isTaskFinished,
        ));
  }
}
