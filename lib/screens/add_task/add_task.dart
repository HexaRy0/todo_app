import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/model/category.dart';
import 'package:todo_app/providers/category_provider.dart';
import 'package:todo_app/widgets/chips.dart';

class AddTaskScreen extends ConsumerStatefulWidget {
  const AddTaskScreen({super.key});

  @override
  ConsumerState<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends ConsumerState<AddTaskScreen> {
  final GlobalKey<FormBuilderState> _addTaskFormKey = GlobalKey<FormBuilderState>();
  CategoryData? _selectedCategory;
  DateTime? _pickedDate;

  @override
  Widget build(BuildContext context) {
    final categories = ref.watch(categoriesProvider);
    final mediaQuery = MediaQuery.of(context);

    return FormBuilder(
      key: _addTaskFormKey,
      child: Padding(
        padding: EdgeInsets.only(
          top: 16,
          right: 16,
          bottom: mediaQuery.viewInsets.bottom + 16,
          left: 16,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            FormBuilderTextField(
              name: 'title',
              autofocus: true,
              decoration: const InputDecoration(
                hintText: "Enter Task Name",
                filled: true,
                contentPadding: EdgeInsets.symmetric(
                  vertical: 4,
                  horizontal: 12,
                ),
                border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter title';
                }
                return null;
              },
            ),
            FormBuilderTextField(
              name: 'description',
              style: const TextStyle(
                fontSize: 14,
                height: 1.5,
              ),
              decoration: const InputDecoration(
                filled: true,
                hintText: "Enter Task Description",
                contentPadding: EdgeInsets.symmetric(
                  vertical: 4,
                  horizontal: 12,
                ),
                border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(16),
                    bottomRight: Radius.circular(16),
                  ),
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter title';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                SizedBox(
                  height: 48,
                  child: GestureDetector(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
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
                                        icon: category.icon,
                                        text: category.name,
                                        isActive: true,
                                        onPressed: () {
                                          setState(() {
                                            _selectedCategory = category;
                                          });
                                          Navigator.pop(context);
                                        },
                                      ),
                                    );
                                  }),
                                  const SizedBox(
                                    height: 48,
                                    width: double.infinity,
                                    child: Chips(
                                      icon: Icons.add,
                                      text: "Add New Category",
                                      isActive: true,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      margin: const EdgeInsets.only(right: 8),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primaryContainer,
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            _selectedCategory?.icon ?? Icons.category,
                            size: 24,
                            color: Theme.of(context).colorScheme.onPrimaryContainer,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            _selectedCategory?.name ?? "No Category",
                            style: TextStyle(
                              fontSize: 16,
                              color: Theme.of(context).colorScheme.onPrimaryContainer,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 48,
                  child: GestureDetector(
                    onTap: () async {
                      final pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime.now().subtract(
                          const Duration(days: 365),
                        ),
                        lastDate: DateTime.now().add(
                          const Duration(days: 365),
                        ),
                      );

                      setState(() {
                        _pickedDate = pickedDate;
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      margin: const EdgeInsets.only(right: 8),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primaryContainer,
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.calendar_month_outlined,
                            size: 24,
                            color: Theme.of(context).colorScheme.onPrimaryContainer,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            DateFormat.MMMd().format(_pickedDate ?? DateTime.now()),
                            style: TextStyle(
                              fontSize: 16,
                              color: Theme.of(context).colorScheme.onPrimaryContainer,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
