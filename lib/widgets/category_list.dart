import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_app/model/category.dart';
import 'package:todo_app/model/task.dart';
import 'package:todo_app/providers/async_category_provider.dart';
import 'package:todo_app/providers/async_task_provider.dart';
import 'package:todo_app/widgets/category_setting_dialog.dart';
import 'package:todo_app/widgets/chips.dart';
import 'package:todo_app/widgets/errorr_widget.dart';
import 'package:todo_app/widgets/loading_widget.dart';

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
    final asyncCategories = ref.watch(asyncCategoryProvider);

    return StatefulBuilder(
      builder: (context, setDialogState) {
        return asyncCategories.when(
          data: (categories) => AlertDialog(
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
                          catId: "None",
                          order: 0,
                          name: "No Category",
                          icon: Icons.category.codePoint,
                          color: Theme.of(context).colorScheme.primaryContainer.value,
                        ),
                        isActive: true,
                        onPressed: () {
                          setState(() {
                            final newTask = TaskData(
                              title: widget.task.title,
                              description: widget.task.description,
                              date: widget.task.date,
                              time: widget.task.time,
                              categoryId: null,
                              isStarred: widget.task.isStarred,
                              isCompleted: widget.task.isCompleted,
                            );

                            ref.read(asyncTaskProvider.notifier).updateTask(newTask);
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
                              widget.task.categoryId = category.catId;
                              ref.read(asyncTaskProvider.notifier).updateTask(widget.task);
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
                          catId: "Add",
                          order: 0,
                          name: "Add Category",
                          icon: Icons.add.codePoint,
                          color: Theme.of(context).colorScheme.primaryContainer.value,
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
          ),
          error: (error, stackTrace) => const ErrorrWidget(),
          loading: () => const LoadingWidget(),
        );
      },
    );
  }
}
