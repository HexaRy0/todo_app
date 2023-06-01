import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/model/category.dart';
import 'package:todo_app/model/task.dart';
import 'package:todo_app/widgets/chips.dart';

class TaskListScreen extends StatefulWidget {
  const TaskListScreen({super.key});

  @override
  State<TaskListScreen> createState() => TaskListScreenState();
}

class TaskListScreenState extends State<TaskListScreen> {
  Category selectedCategory = Category.getCategoryById("1");
  List<TaskData> taskList = [
    TaskData(
      title: "Test",
      description: "description",
      date: DateTime.now(),
      category: Category.getCategoryById("2"),
    ),
    TaskData(
      title: "Test",
      description: "description",
      date: DateTime.now(),
      category: Category.getCategoryById("2"),
    ),
    TaskData(
      title: "Test",
      description: "description",
      date: DateTime.now(),
      category: Category.getCategoryById("3"),
    ),
    TaskData(
      title: "Test",
      description: "description",
      date: DateTime.now(),
      category: Category.getCategoryById("4"),
    ),
    TaskData(
      title: "Test",
      description: "description",
      date: DateTime.now(),
      category: Category.getCategoryById("5"),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    List<TaskData> filteredTaskList = selectedCategory == Category.getCategoryById("1")
        ? taskList
        : taskList.where((element) => element.category == selectedCategory).toList();

    return ListView(
      primary: true,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 48,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: Category.categoryList.length,
                  itemBuilder: (context, index) {
                    return Chips(
                      icon: Category.categoryList[index].icon,
                      text: Category.categoryList[index].name,
                      isActive: selectedCategory == Category.categoryList[index],
                      onPressed: () {
                        setState(() {
                          selectedCategory = Category.categoryList[index];
                        });
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        ListView.builder(
          primary: false,
          itemCount: filteredTaskList.length,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                setState(() {
                  print("tapped");
                });
              },
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Theme.of(context).colorScheme.onSurface.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Transform.scale(
                        scale: 1.25,
                        child: Checkbox(
                          shape: const CircleBorder(),
                          value: filteredTaskList[index].isCompleted,
                          onChanged: (value) {
                            setState(() {
                              filteredTaskList[index].isCompleted = value!;
                            });
                          },
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              filteredTaskList[index].title,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              filteredTaskList[index].description,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Wrap(
                              direction: Axis.horizontal,
                              spacing: 5.0,
                              children: [
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.calendar_today,
                                      size: 16,
                                      color:
                                          Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      DateFormat.yMd().format(filteredTaskList[index].date),
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSurface
                                            .withOpacity(0.5),
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      filteredTaskList[index].category.icon,
                                      size: 16,
                                      color:
                                          Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      filteredTaskList[index].category.name,
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSurface
                                            .withOpacity(0.5),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
