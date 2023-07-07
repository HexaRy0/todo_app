import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/model/category.dart';
import 'package:todo_app/model/task.dart';
import 'package:todo_app/providers/async_category_provider.dart';
import 'package:todo_app/providers/async_task_provider.dart';
import 'package:todo_app/widgets/add_task_category_list.dart';
import 'package:todo_app/widgets/task_option.dart';
import 'package:uuid/uuid.dart';

class AddTaskScreen extends ConsumerStatefulWidget {
  const AddTaskScreen({super.key});

  @override
  ConsumerState<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends ConsumerState<AddTaskScreen> {
  final GlobalKey<FormBuilderState> _addTaskFormKey = GlobalKey<FormBuilderState>();
  final uuid = const Uuid();
  CategoryData? _selectedCategory;
  DateTime? _pickedDate;
  DateTime? _pickedTime;
  DateTime? _pickedReminder;
  bool isTitleValid = false;

  void _onSelectCategory(List<CategoryData> categories) {
    showDialog(
      context: context,
      builder: (context) => AddTaskCategoryList(onSelectCategory: (category) {
        _selectedCategory = category;
      }),
    );
  }

  void _onSelectDueReminder() {
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) {
          return SimpleDialog(
            title: const Text("Due & Reminder"),
            children: [
              ListTile(
                leading: const Icon(Icons.calendar_today_outlined),
                title: const Text("Due Date"),
                subtitle: _pickedDate == null
                    ? const Text("No Due Date")
                    : Text(DateFormat.yMMMMd().format(_pickedDate!)),
                onTap: () {
                  _onSelectDate(setDialogState);
                },
                trailing: _pickedDate == null
                    ? null
                    : IconButton(
                        onPressed: () {
                          setDialogState(() {
                            _pickedDate = null;
                          });
                        },
                        icon: const Icon(Icons.clear),
                      ),
              ),
              ListTile(
                enabled: _pickedDate != null,
                leading: const Icon(Icons.access_time_outlined),
                title: const Text("Due Time"),
                subtitle: _pickedTime == null
                    ? const Text("No Due Time")
                    : Text(DateFormat.jm().format(_pickedTime!)),
                onTap: () {
                  _onSelectTime(setDialogState);
                },
                trailing: _pickedTime == null
                    ? null
                    : IconButton(
                        onPressed: () {
                          setDialogState(() {
                            _pickedTime = null;
                          });
                        },
                        icon: const Icon(Icons.clear),
                      ),
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.notifications),
                title: const Text("Reminder"),
                subtitle: _pickedReminder == null
                    ? const Text("No Reminder")
                    : Text(DateFormat.yMMMMd().add_jm().format(_pickedReminder!)),
                onTap: () {
                  // _onSelectReminder(setDialogState);
                },
                trailing: _pickedReminder == null
                    ? null
                    : IconButton(
                        onPressed: () {
                          setDialogState(() {
                            _pickedReminder = null;
                          });
                        },
                        icon: const Icon(Icons.clear),
                      ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text("Done"),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }

  void _onSelectDate(void Function(void Function() fn) setDialogState) async {
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

    setDialogState(() {
      if (pickedDate == null) return;
      _pickedDate = pickedDate;
    });

    setState(() {
      _pickedDate = pickedDate;
    });
  }

  void _onSelectTime(void Function(void Function() fn) setDialogState) async {
    final pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: DateTime.now().hour, minute: DateTime.now().minute),
    );

    setDialogState(() {
      if (pickedTime == null) return;
      _pickedTime = DateTime(
        DateTime.now().year,
        DateTime.now().month,
        DateTime.now().day,
        pickedTime.hour,
        pickedTime.minute,
      );
    });

    setState(() {
      if (pickedTime == null) return;
      _pickedTime = DateTime(
        DateTime.now().year,
        DateTime.now().month,
        DateTime.now().day,
        pickedTime.hour,
        pickedTime.minute,
      );
    });
  }

  // void _onSelectReminder(void Function(void Function() fn) setDialogState) async {
  //   final pickedReminder = await showDatePicker(
  //     context: context,
  //     initialDate: DateTime.now(),
  //     firstDate: DateTime.now().subtract(
  //       const Duration(days: 365),
  //     ),
  //     lastDate: DateTime.now().add(
  //       const Duration(days: 365),
  //     ),
  //   );

  //   if (pickedReminder == null) return;

  //   final pickedTime = await showTimePicker(
  //     context: context,
  //     initialTime: TimeOfDay(hour: DateTime.now().hour, minute: DateTime.now().minute),
  //   );

  //   setDialogState(() {
  //     if (pickedTime == null) return;
  //     _pickedReminder = DateTime(
  //       pickedReminder.year,
  //       pickedReminder.month,
  //       pickedReminder.day,
  //       pickedTime.hour,
  //       pickedTime.minute,
  //     );
  //   });

  //   setState(() {
  //     if (pickedTime == null) return;
  //     _pickedReminder = DateTime(
  //       pickedReminder.year,
  //       pickedReminder.month,
  //       pickedReminder.day,
  //       pickedTime.hour,
  //       pickedTime.minute,
  //     );
  //   });
  // }

  void _addNewTask() {
    if (_addTaskFormKey.currentState!.saveAndValidate()) {
      final formData = _addTaskFormKey.currentState!.value;
      final newTask = TaskData(
        title: formData['title'],
        description: formData['description'] ?? "",
        date: _pickedDate,
        time: _pickedTime,
        categoryId: _selectedCategory?.catId,
      );

      ref.read(asyncTaskProvider.notifier).addTask(newTask);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final asyncCategories = ref.watch(asyncCategoryProvider);
    final mediaQuery = MediaQuery.of(context);

    return asyncCategories.when(
      data: (categories) => FormBuilder(
        key: _addTaskFormKey,
        child: Padding(
          padding: EdgeInsets.only(
            top: 16,
            right: 16,
            bottom: mediaQuery.viewInsets.bottom + 16,
            left: 16,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
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
                onChanged: (value) {
                  setState(() {
                    if (value != null) isTitleValid = true;
                  });
                },
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
                  hintText: "Enter Task Description (Optional)",
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
              ),
              const SizedBox(height: 16),
              Wrap(
                runSpacing: 8,
                direction: Axis.horizontal,
                children: [
                  TaskOption(
                    onPressed: () {
                      _onSelectCategory(categories);
                    },
                    icon: _selectedCategory?.icon == null
                        ? Icons.category
                        : IconData(_selectedCategory!.icon, fontFamily: 'MaterialIcons'),
                    title: _selectedCategory?.name ?? "No Category",
                    color: _selectedCategory?.color == null
                        ? Theme.of(context).colorScheme.primaryContainer
                        : Color(_selectedCategory!.color),
                    isValueSet: _selectedCategory != null,
                    onReset: () {
                      setState(() {
                        _selectedCategory = null;
                      });
                    },
                  ),
                  TaskOption(
                    onPressed: _onSelectDueReminder,
                    icon: Icons.calendar_month_outlined,
                    title: "Due & Reminder",
                    isValueSet: false,
                    onReset: () {},
                  ),
                ],
              ),
              const SizedBox(
                height: 16,
              ),
              Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(999),
                    ),
                  ),
                  onPressed: isTitleValid ? _addNewTask : null,
                  icon: Icon(
                    Icons.add,
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                  ),
                  label: Text(
                    "Add Task",
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      error: (error, trace) => Center(
        child: Text(error.toString()),
      ),
      loading: () => const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
