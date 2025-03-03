import 'package:dass/colortheme/theme_maneger.dart';
import 'package:dass/modal/todosmodel.dart';
import 'package:dass/ui/todolist/createtodolist.dart';
import 'package:dass/webservices/api.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TodoScreen extends StatefulWidget {
  final String? name;
  final String? email;

  const TodoScreen({Key? key, required this.email, required this.name})
      : super(key: key);

  @override
  State<TodoScreen> createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> {
  List<TodosModel> todoItems = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchTodos();
  }

  Future<void> fetchTodos() async {
    final response = await ApiService.getTodosList(widget.email!, context);
    if (response != null && response['statusCode'] == 200) {
      List<dynamic> data = response['body'];
      setState(() {
        todoItems = data.map((json) => TodosModel.fromJson(json)).toList();
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
    }
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
                              : const Color(0xFF57C9E7),
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
                              builder: (context) => CreateTodoList(
                                name: widget.name,
                                email: widget.email,
                              ),
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
                  "Your Todos",
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
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : todoItems.isEmpty
                    ? const Center(child: Text("No todos available"))
                    : ListView.builder(
                        itemCount: todoItems.length,
                        itemBuilder: (context, index) {
                          final item = todoItems[index];
                          return TodoItem(
                            title: item.description ?? "No Title",
                            date: "${item.date} at ${item.time}",
                            category: item.category ?? "General",
                            categoryColor: Colors.blue,
                            importance: item.priority ?? "Normal",
                            importanceColor: Colors.red,
                            isChecked: item.isChecked,
                            onCheckboxChanged: (value) {
                              setState(() {
                                todoItems[index].isChecked = value ?? false;
                              });
                            },
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
