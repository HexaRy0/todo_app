import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/model/category.dart';
import 'package:todo_app/model/task.dart';
import 'package:todo_app/providers/category_provider.dart';
import 'package:todo_app/providers/task_provider.dart';
import 'package:todo_app/widgets/chips.dart';
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
  bool isTitleValid = false;

  void _onSelectCategory(List<CategoryData> categories) {
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
  }

  void _onSelectDate() async {
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
  }

  void _onSelectTime() async {
    final pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: DateTime.now().hour, minute: DateTime.now().minute),
    );

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

  void _addNewTask() {
    if (_addTaskFormKey.currentState!.saveAndValidate()) {
      final formData = _addTaskFormKey.currentState!.value;
      final newTask = TaskData(
        id: uuid.v4(),
        title: formData['title'],
        description: formData['description'] ?? "",
        date: _pickedDate,
        time: _pickedTime,
        category: _selectedCategory,
      );

      ref.read(tasksProvider.notifier).addTask(newTask);
      Navigator.pop(context);
    }
  }

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
                  icon: _selectedCategory?.icon ?? Icons.category,
                  title: _selectedCategory?.name ?? "No Category",
                  isValueSet: _selectedCategory != null,
                  onReset: () {
                    setState(() {
                      _selectedCategory = null;
                    });
                  },
                ),
                TaskOption(
                  onPressed: _onSelectDate,
                  icon: Icons.calendar_month_outlined,
                  title: _pickedDate == null ? "No Date" : DateFormat.MMMd().format(_pickedDate!),
                  isValueSet: _pickedDate != null,
                  onReset: () {
                    setState(() {
                      _pickedDate = null;
                    });
                  },
                ),
                if (_pickedDate != null)
                  TaskOption(
                    onPressed: _onSelectTime,
                    icon: Icons.access_time,
                    title: _pickedTime != null ? DateFormat.Hm().format(_pickedTime!) : "No Time",
                    isValueSet: _pickedTime != null,
                    onReset: () {
                      setState(() {
                        _pickedTime = null;
                      });
                    },
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
    );
  }
}
