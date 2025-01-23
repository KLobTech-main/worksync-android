import 'package:dass/colortheme/theme_maneger.dart';
import 'package:dass/ui/todolist/createtodolist.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TodoScreen extends StatefulWidget {
  final String? name;
  final String? email;

  TodoScreen({
    Key? key,
    this.name,
    this.email,
  }) : super(key: key);
  @override
  State<TodoScreen> createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> {
  List<TodoItemData> todoItems = [
    TodoItemData(
      title: 'Careers advice appointment',
      date: '17/10 at 11:00 - 11:30',
      category: 'Work',
      categoryColor: Colors.blue,
      importance: 'Important',
      importanceColor: Colors.red,
      isChecked: false,
    ),
    TodoItemData(
      title: 'Return library books',
      date: '17/10 at any time',
      category: 'Fun',
      categoryColor: Colors.pink,
      importance: 'Important',
      importanceColor: Colors.red,
      isChecked: false,
    ),
    TodoItemData(
      title: 'Finish group presentation slides',
      date: '17/10 at 13:00 - 15:00',
      category: 'Work',
      categoryColor: Colors.blue,
      isChecked: false,
    ),
  ];

  void toggleCheckbox(int index, bool? value) {
    setState(() {
      todoItems[index].isChecked = value ?? false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      backgroundColor: themeProvider.themeData.brightness == Brightness.light
          ? const Color.fromARGB(255, 246, 244, 244)
          : const Color(0xFF1C1F26),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Section
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                bottomRight: Radius.circular(120),
              ),
              color: themeProvider.themeData.brightness == Brightness.light
                  ? Colors.indigo.shade900
                  : const Color.fromARGB(255, 21, 24, 30),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CircleAvatar(
                      radius: 20,
                      backgroundColor:
                          themeProvider.themeData.brightness == Brightness.light
                              ? Colors.white
                              : Color(0xFF57C9E7),
                      child: InkWell(
                        child: Icon(Icons.add,
                            size: 25,
                            color: themeProvider.themeData.brightness ==
                                    Brightness.light
                                ? Colors.blue.shade900
                                : Colors.white),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CreateTodoList(),
                            ),
                          );
                        },
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.arrow_back_ios),
                      color: Colors.white,
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Text(
                  "Today: 17 Jan",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const Text(
                  "1 to 6 items",
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            child: ListView.builder(
              itemCount: todoItems.length,
              itemBuilder: (context, index) {
                final item = todoItems[index];
                return TodoItem(
                  title: item.title,
                  date: item.date,
                  category: item.category,
                  categoryColor: item.categoryColor,
                  importance: item.importance,
                  importanceColor: item.importanceColor,
                  isChecked: item.isChecked,
                  onCheckboxChanged: (value) => toggleCheckbox(index, value),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class TodoItem extends StatelessWidget {
  final String title;
  final String date;
  final String? category;
  final Color? categoryColor;
  final String? importance;
  final Color? importanceColor;
  final bool isChecked;
  final ValueChanged<bool?> onCheckboxChanged;

  const TodoItem({
    required this.title,
    required this.date,
    this.category,
    this.categoryColor,
    this.importance,
    this.importanceColor,
    required this.isChecked,
    required this.onCheckboxChanged,
  });

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Checkbox(
            value: isChecked,
            onChanged: onCheckboxChanged,
            activeColor: themeProvider.themeData.brightness == Brightness.light
                ? Colors.blue.shade900
                : Color(0xFF57C9E7),
            checkColor: Colors.white,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    decoration: isChecked ? TextDecoration.lineThrough : null,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  date,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
                Row(
                  children: [
                    if (category != null)
                      Text(
                        category!,
                        style: TextStyle(
                          fontSize: 14,
                          color: categoryColor,
                        ),
                      ),
                    if (importance != null) ...[
                      const SizedBox(width: 8),
                      Text(
                        importance!,
                        style: TextStyle(
                          fontSize: 14,
                          color: importanceColor,
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class TodoItemData {
  String title;
  String date;
  String? category;
  Color? categoryColor;
  String? importance;
  Color? importanceColor;
  bool isChecked;

  TodoItemData({
    required this.title,
    required this.date,
    this.category,
    this.categoryColor,
    this.importance,
    this.importanceColor,
    this.isChecked = false,
  });
}
