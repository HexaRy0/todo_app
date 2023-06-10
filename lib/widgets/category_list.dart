import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_app/model/category.dart';
import 'package:todo_app/model/task.dart';
import 'package:todo_app/providers/category_provider.dart';
import 'package:todo_app/providers/task_provider.dart';
import 'package:todo_app/widgets/category_setting_dialog.dart';
import 'package:todo_app/widgets/chips.dart';

class CategoryList extends ConsumerStatefulWidget {
  const CategoryList({super.key, required this.task});

  final TaskData task;

  @override
  ConsumerState<CategoryList> createState() => _CategoryListState();
}

class _CategoryListState extends ConsumerState<CategoryList> {
  void _openCategorySetting({
    CategoryData? category,
    bool isEdit = false,
    void Function(void Function())? setState,
  }) {
    showDialog(
      context: context,
      builder: (context) => CategorySettingDialog(
        category: category,
        isEdit: isEdit,
        setState: setState,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final categories = ref.watch(categoriesProvider);

    return StatefulBuilder(
      builder: (context, setDialogState) {
        return AlertDialog(
          title: const Text("Select Category"),
          content: SizedBox(
            width: 300,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    height: 48,
                    width: double.infinity,
                    child: Chips(
                      category: CategoryData(
                        id: "na",
                        name: "No Category",
                        icon: Icons.category,
                        color: Theme.of(context).colorScheme.primaryContainer,
                      ),
                      isActive: true,
                      onPressed: () {
                        setState(() {
                          final newTask = TaskData(
                            id: widget.task.id,
                            title: widget.task.title,
                            description: widget.task.description,
                            date: widget.task.date,
                            time: widget.task.time,
                            categoryId: null,
                            isStarred: widget.task.isStarred,
                            isCompleted: widget.task.isCompleted,
                          );

                          ref.read(tasksProvider.notifier).forceUpdateTask(newTask);
                        });
                        Navigator.pop(context);
                      },
                    ),
                  ),
                  ...categories.map((category) {
                    return Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      height: 48,
                      width: double.infinity,
                      child: Chips(
                        category: category,
                        isActive: true,
                        onPressed: () {
                          setState(() {
                            ref
                                .read(tasksProvider.notifier)
                                .updateTask(widget.task.copyWith(categoryId: category.id));
                          });
                          Navigator.pop(context);
                        },
                      ),
                    );
                  }),
                  SizedBox(
                    height: 48,
                    width: double.infinity,
                    child: Chips(
                      category: CategoryData(
                        id: "new",
                        name: "Add Category",
                        icon: Icons.add,
                        color: Theme.of(context).colorScheme.primaryContainer,
                      ),
                      isActive: true,
                      onPressed: () {
                        _openCategorySetting(setState: setState);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
