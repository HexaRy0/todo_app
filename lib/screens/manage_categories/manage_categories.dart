import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_app/model/category.dart';
import 'package:todo_app/providers/category_provider.dart';
import 'package:todo_app/providers/task_provider.dart';
import 'package:todo_app/widgets/category_setting_dialog.dart';

class ManageCategoriesScreen extends ConsumerStatefulWidget {
  const ManageCategoriesScreen({super.key});

  @override
  ConsumerState<ManageCategoriesScreen> createState() => _ManageCategoriesScreenState();
}

class _ManageCategoriesScreenState extends ConsumerState<ManageCategoriesScreen> {
  void _openCategorySetting({
    CategoryData? category,
    bool isEdit = false,
  }) {
    showDialog(
      context: context,
      builder: (context) => CategorySettingDialog(
        category: category,
        isEdit: isEdit,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final tasks = ref.watch(tasksProvider);
    final categories = ref.watch(categoriesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Categories'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceVariant,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text(
                "Drag and drop category to reorder",
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            ReorderableListView(
              onReorder: (oldIndex, newIndex) {
                ref.read(categoriesProvider.notifier).reorderCategory(oldIndex, newIndex);
              },
              shrinkWrap: true,
              primary: false,
              children: [
                ...categories
                    .map(
                      (category) => Padding(
                        key: Key(category.id),
                        padding: const EdgeInsets.symmetric(horizontal: 12.0),
                        child: ListTile(
                          onTap: () {},
                          leading: CircleAvatar(
                            backgroundColor: ColorScheme.fromSeed(
                              seedColor: category.color,
                              brightness: Theme.of(context).brightness,
                            ).primaryContainer,
                            child: Icon(category.icon),
                          ),
                          title: Text(category.name),
                          contentPadding: EdgeInsets.zero,
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                tasks
                                    .where((element) => element.id == category.id)
                                    .length
                                    .toString(),
                              ),
                              PopupMenuButton(
                                offset: const Offset(0, 50),
                                itemBuilder: (context) {
                                  return const [
                                    PopupMenuItem(
                                      value: 0,
                                      child: Text("Edit"),
                                    ),
                                    PopupMenuItem(
                                      value: 1,
                                      child: Text("Delete"),
                                    ),
                                  ];
                                },
                                onSelected: (value) {
                                  if (value == 0) {
                                    _openCategorySetting(
                                      category: category,
                                      isEdit: true,
                                    );
                                  } else if (value == 1) {
                                    ref.read(categoriesProvider.notifier).removeCategory(category);
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ],
            ),
            ListTile(
              leading: const Icon(Icons.add),
              title: const Text('Add Category'),
              onTap: _openCategorySetting,
            ),
          ],
        ),
      ),
    );
  }
}
