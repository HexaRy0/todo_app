import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_app/model/category.dart';
import 'package:todo_app/providers/async_category_provider.dart';
import 'package:todo_app/widgets/category_setting_dialog.dart';
import 'package:todo_app/widgets/chips.dart';
import 'package:todo_app/widgets/errorr_widget.dart';
import 'package:todo_app/widgets/loading_widget.dart';

class AddTaskCategoryList extends ConsumerStatefulWidget {
  const AddTaskCategoryList({super.key, required this.onSelectCategory});

  final Function(CategoryData) onSelectCategory;

  @override
  ConsumerState<AddTaskCategoryList> createState() => _AddTaskCategoryListState();
}

class _AddTaskCategoryListState extends ConsumerState<AddTaskCategoryList> {
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
                              widget.onSelectCategory(category);
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
                          showDialog(
                            context: context,
                            builder: (context) => CategorySettingDialog(
                              setState: setDialogState,
                            ),
                          );
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
