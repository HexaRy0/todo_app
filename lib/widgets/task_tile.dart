import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/model/category.dart';
import 'package:todo_app/model/task.dart';
import 'package:todo_app/providers/task_provider.dart';
import 'package:todo_app/screens/task_detail/task_detail.dart';

class TaskTile extends ConsumerStatefulWidget {
  const TaskTile({super.key, required this.task, this.category, this.isTaskFinished = false});

  final TaskData task;
  final CategoryData? category;
  final bool isTaskFinished;

  @override
  ConsumerState<TaskTile> createState() => _TaskTileState();
}

class _TaskTileState extends ConsumerState<TaskTile> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => TaskDetailScreen(
                taskId: widget.task.id,
              ),
            ),
          );
        });
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          color: widget.category != null
              ? ColorScheme.fromSeed(
                  seedColor: widget.category!.color,
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
                  value: widget.isTaskFinished,
                  onChanged: (value) {
                    setState(() {
                      ref.read(tasksProvider.notifier).toggleTask(widget.task);
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
                          widget.task.title,
                          style: TextStyle(
                            decoration: widget.isTaskFinished ? TextDecoration.lineThrough : null,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(
                          width: 8,
                        ),
                      ],
                    ),
                    if (widget.task.description.isNotEmpty)
                      Text(
                        widget.task.description,
                        style: TextStyle(
                          decoration: widget.isTaskFinished ? TextDecoration.lineThrough : null,
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    const SizedBox(height: 4),
                    Wrap(
                      direction: Axis.horizontal,
                      spacing: 5.0,
                      children: [
                        if (widget.task.date != null)
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.calendar_today,
                                size: 16,
                                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                DateFormat.yMd().format(widget.task.date!),
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
                                ),
                              ),
                            ],
                          ),
                        if (widget.task.time != null)
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.access_time,
                                size: 16,
                                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                DateFormat.Hm().format(widget.task.time!),
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
                                ),
                              ),
                            ],
                          ),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              widget.category?.icon ?? Icons.category,
                              size: 16,
                              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              widget.category?.name ?? "No Category",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
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
                    ref.read(tasksProvider.notifier).toggleStarTask(widget.task);
                  });
                },
                icon: Icon(
                  widget.task.isStarred ? Icons.star : Icons.star_outline,
                  color: widget.task.isStarred
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
    );
  }
}
