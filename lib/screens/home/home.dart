import 'package:flutter/material.dart';
import 'package:todo_app/screens/add_task/add_task.dart';
import 'package:todo_app/screens/calendar/calendar.dart';
import 'package:todo_app/screens/task_list/task_list.dart';
import 'package:todo_app/widgets/menu_button.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int index = 0;

  final List<Widget> _pages = [
    const TaskListScreen(),
    const CalendarScreen(),
  ];

  void _showAddTaskBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(16),
        ),
      ),
      builder: (context) {
        return const AddTaskScreen();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Todo App'),
        actions: const [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: CircleAvatar(
              child: Text('A'),
            ),
          ),
        ],
      ),
      body: _pages[index],
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showAddTaskBottomSheet,
        icon: const Icon(Icons.add),
        label: const Text('Add Task'),
      ),
      bottomNavigationBar: BottomAppBar(
        height: 96,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            DrawerButton(
              style: ButtonStyle(
                iconColor: MaterialStateProperty.all<Color>(
                  Theme.of(context).colorScheme.onSurface,
                ),
                padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                  const EdgeInsets.all(16),
                ),
                shape: MaterialStateProperty.all<OutlinedBorder>(
                  const CircleBorder(),
                ),
              ),
            ),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  MenuButton(
                    icon: Icons.task_alt,
                    text: "Tasks",
                    isActive: index == 0,
                    onPressed: () {
                      setState(() {
                        index = 0;
                      });
                    },
                  ),
                  MenuButton(
                    icon: Icons.calendar_month_outlined,
                    text: "Calendar",
                    isActive: index == 1,
                    onPressed: () {
                      setState(() {
                        index = 1;
                      });
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
