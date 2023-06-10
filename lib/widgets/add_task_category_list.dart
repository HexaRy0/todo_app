import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_app/model/category.dart';
import 'package:todo_app/providers/category_provider.dart';
import 'package:todo_app/widgets/category_setting_dialog.dart';
import 'package:todo_app/widgets/chips.dart';

class AddTaskCategoryList extends ConsumerStatefulWidget {
  const AddTaskCategoryList({super.key, required this.onSelectCategory});

  final Function(CategoryData) onSelectCategory;

  @override
  ConsumerState<AddTaskCategoryList> createState() => _AddTaskCategoryListState();
}

class _AddTaskCategoryListState extends ConsumerState<AddTaskCategoryList> {
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
                        id: "new",
                        name: "Add Category",
                        icon: Icons.add,
                        color: Theme.of(context).colorScheme.primaryContainer,
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
        );
      },
    );
  }
}
