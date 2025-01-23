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
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
        backgroundColor: themeProvider.themeData.brightness == Brightness.light
            ? const Color.fromARGB(255, 246, 244, 244)
            : Color(0xFF1C1F26),
        // appBar: AppBar(
        //   backgroundColor: Colors.blue,
        //   toolbarHeight: 150,
        //   elevation: 0,
        //   title: Column(
        //     crossAxisAlignment: CrossAxisAlignment.start,
        //     children: [
        //       Row(
        //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //         children: [
        //           Icon(Icons.menu, color: Colors.white),
        //           Icon(Icons.arrow_forward_ios, color: Colors.white),
        //         ],
        //       ),
        //       const SizedBox(height: 20),
        //       const Text(
        //         'Today: 17 October',
        //         style: TextStyle(
        //           color: Colors.white,
        //           fontSize: 24,
        //           fontWeight: FontWeight.bold,
        //         ),
        //       ),
        //       const Text(
        //         '1 of 6 Items',
        //         style: TextStyle(
        //           color: Colors.white,
        //           fontSize: 16,
        //         ),
        //       ),
        //     ],
        //   ),
        // ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Section
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 40),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  // bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(120),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 5,
                    spreadRadius: 2,
                  ),
                ],
                color: themeProvider.themeData.brightness == Brightness.light
                    ? Colors.indigo.shade900
                    : Color.fromARGB(255, 21, 24, 30),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header Row with Avatar, User Name, and Notification Icon
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 20,
                            backgroundColor:
                                themeProvider.themeData.brightness ==
                                        Brightness.light
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

                          // InkWell(
                          //   onTap: () {
                          //     Scaffold.of(context).openDrawer();
                          //   },
                          //   child: CircleAvatar(
                          //     radius: 30,
                          //     backgroundColor:
                          //         themeProvider.themeData.brightness ==
                          //                 Brightness.light
                          //             ? Colors.white
                          //             : Color(0xFF57C9E7),
                          //     child: Icon(Icons.person,
                          //         size: 35,
                          //         color: themeProvider.themeData.brightness ==
                          //                 Brightness.light
                          //             ? Colors.blue.shade900
                          //             : Colors.white),
                          //   ),
                          //),
                          // SizedBox(width: 15),
                          // Column(
                          //   children: [
                          //     Text(
                          //       widget.name ?? "User Name",
                          //       style: TextStyle(
                          //         fontSize: 20,
                          //         fontWeight: FontWeight.bold,
                          //         color: themeProvider.themeData.brightness ==
                          //                 Brightness.light
                          //             ? Colors.white
                          //             : Colors.white,
                          //       ),
                          //     ),
                          //     Text(
                          //       "Softwere Developer",
                          //       style: TextStyle(
                          //         fontSize: 13,
                          //         fontWeight: FontWeight.bold,
                          //         color: themeProvider.themeData.brightness ==
                          //                 Brightness.light
                          //             ? Colors.white
                          //             : Colors.grey,
                          //       ),
                          //     )
                          //   ],
                          // ),
                        ],
                      ),
                      InkWell(
                        child: Icon(
                          Icons.arrow_back_ios,
                          color: themeProvider.themeData.brightness ==
                                  Brightness.light
                              ? Colors.white
                              : Colors.white,
                        ),
                        onTap: () {
                          Navigator.pop(context);
                        },
                      )
                    ],
                  ),

                  const SizedBox(height: 20),

                  // Centered CrewSync Text
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        "Today: 17 Jan ",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: themeProvider.themeData.brightness ==
                                  Brightness.light
                              ? Colors.white
                              : Color(0xFF57C9E7),
                        ),
                        // textAlign: TextAlign.center,
                      ),
                      Text(
                        "1 to 6 item",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: themeProvider.themeData.brightness ==
                                  Brightness.light
                              ? Colors.white
                              : Color(0xFF57C9E7),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
            // SizedBox(
            //   height: 10,
            // ),

            // TextField(
            //   decoration: InputDecoration(
            //     hintText: 'Add a new item...',
            //     hintStyle: TextStyle(color: Colors.grey.shade400),
            //     border: InputBorder.none,
            //   ),
            // ),
            // Divider(),
            Expanded(
              child: ListView(
                children: [
                  TodoItem(
                    isChecked: false,
                    title: 'Careers advice appointment',
                    date: '17/10 at 11:00 - 11:30',
                    category: 'Work',
                    categoryColor: Colors.blue,
                    importance: 'Important',
                    importanceColor: Colors.red,
                  ),
                  TodoItem(
                    title: 'Return library books',
                    date: '17/10 at any time',
                    category: 'Fun',
                    categoryColor: Colors.pink,
                    importance: 'Important',
                    importanceColor: Colors.red,
                    isChecked: false,
                  ),
                  TodoItem(
                    title: 'Finish group presentation slides',
                    date: '17/10 at 13:00 - 15:00',
                    category: 'Work',
                    categoryColor: Colors.blue,
                    isChecked: false,
                  ),
                  TodoItem(
                    title: 'Warhammer Painting',
                    date: '17/10 at 18:00 - 20:00',
                    category: 'Fun',
                    categoryColor: Colors.pink,
                    isChecked: false,
                  ),
                  TodoItem(
                    title: 'Take out the Rubbish',
                    date: '17/10 at any time',
                    category: 'Home',
                    categoryColor: Colors.teal,
                    isChecked: false,
                  ),
                  TodoItem(
                    title: 'Clean the lounge',
                    date: '17/10 at any time',
                    category: 'Home',
                    categoryColor: Colors.green,
                    isChecked: true,
                  ),
                ],
              ),
            ),
          ],
        ));
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

  const TodoItem({
    required this.title,
    required this.date,
    this.category,
    this.categoryColor,
    this.importance,
    this.importanceColor,
    required this.isChecked,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Checkbox(
            value: isChecked,
            onChanged: (value) {},
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
                SizedBox(height: 4),
                Text(
                  date,
                  style: TextStyle(
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
                      SizedBox(width: 8),
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
