import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_app/providers/category_provider.dart';
import 'package:todo_app/providers/task_provider.dart';
import 'package:todo_app/screens/add_task/add_task.dart';
import 'package:todo_app/screens/calendar/calendar.dart';
import 'package:todo_app/screens/task_list/task_list.dart';
import 'package:todo_app/widgets/menu_button.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
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
    final tasks = ref.watch(tasksProvider);
    final categories = ref.watch(categoriesProvider);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
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
      drawer: Drawer(
        child: Column(
          children: [
            UserAccountsDrawerHeader(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer,
              ),
              accountName: const Text('Merza Bolivar'),
              accountEmail: const Text('Merza.bolivar@Gmail.com'),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Theme.of(context).colorScheme.primary,
                child: Text(
                  'A',
                  style: TextStyle(
                    fontSize: 32,
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                ),
              ),
            ),
            ListTile(
              onTap: () {},
              leading: const Icon(Icons.star),
              title: const Text('Starred Tasks'),
            ),
            ExpansionTile(
              initiallyExpanded: true,
              shape: ShapeBorder.lerp(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                1,
              ),
              leading: const Icon(Icons.category),
              title: const Text('Categories'),
              children: [
                ...categories.map(
                  (category) => Padding(
                    padding: const EdgeInsets.only(left: 16),
                    child: ListTile(
                      onTap: () {},
                      leading: Icon(category.icon),
                      title: Text(category.name),
                      trailing: Text(
                        tasks.where((element) => element.category == category).length.toString(),
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 16),
                  child: ListTile(
                    onTap: () {},
                    leading: const Icon(Icons.add),
                    title: const Text('Add Category'),
                  ),
                ),
              ],
            ),
            ListTile(
              onTap: () {},
              leading: const Icon(Icons.favorite),
              title: const Text('Donate'),
            ),
            ListTile(
              onTap: () {},
              leading: const Icon(Icons.question_mark),
              title: const Text('FAQ'),
            ),
            ListTile(
              onTap: () {},
              leading: const Icon(Icons.settings),
              title: const Text('Settings'),
            ),
          ],
        ),
      ),
      body: _pages[index],
      floatingActionButton: index == 0
          ? FloatingActionButton.extended(
              onPressed: _showAddTaskBottomSheet,
              icon: const Icon(Icons.add),
              label: const Text('Add Task'),
            )
          : null,
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
