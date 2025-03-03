import 'dart:convert';

import 'package:dass/colortheme/theme_maneger.dart';
import 'package:dass/ui/todolist/todolist.dart';
import 'package:dass/webservices/api.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

class CreateTodoList extends StatefulWidget {
  final String? name;
  final String? email;

  const CreateTodoList({Key? key, required this.email, required this.name})
      : super(key: key);

  @override
  State<CreateTodoList> createState() => _CreateTodoListState();
}

class _CreateTodoListState extends State<CreateTodoList> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController addDiscriptionController = TextEditingController();
  TextEditingController priorityController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController timeController = TextEditingController();
  TextEditingController categoryController = TextEditingController();

  bool isLoader = false;

  Future<void> submitForm() async {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final todosData = {
      'userEmail': widget.email,
      "description": addDiscriptionController.text.trim(),
      "date": dateController.text.trim(),
      "time": timeController.text.trim(),
      "priority": priorityController.text,
      "category": categoryController.text.trim(),
    };

    setState(() {
      isLoader = true;
    });

    try {
      final response = await ApiService.createTodos(todosData, context);

      if (response.statusCode == 201) {
        Fluttertoast.showToast(
          msg: "Created Todos Successfully!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor:
              themeProvider.themeData.brightness == Brightness.light
                  ? Colors.indigo.shade900
                  : Color(0xFF57C9E7),
          textColor: Colors.white,
          fontSize: 16.0,
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => TodoScreen(
                    name: widget.name,
                    email: widget.email,
                  )),
        );
      } else {
        final errorData = jsonDecode(response.body);
        Fluttertoast.showToast(
          msg: "Error: ${errorData['message']}",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      }
    } catch (e) {
      Fluttertoast.showToast(
        msg: "Error: $e",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    } finally {
      setState(() {
        isLoader = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      backgroundColor: themeProvider.themeData.brightness == Brightness.light
          ? const Color.fromARGB(255, 246, 244, 244)
          : Color(0xFF1C1F26),
      appBar: AppBar(
        title: Text('Create TodoList',
            style: TextStyle(
              color: themeProvider.themeData.brightness == Brightness.light
                  ? Colors.white
                  : Color(0xFF57C9E7),
            )),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: themeProvider.themeData.brightness == Brightness.light
                ? LinearGradient(
                    colors: [Colors.indigo.shade900, Colors.indigo.shade900],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  )
                : null,
            color: themeProvider.themeData.brightness == Brightness.dark
                ? Color.fromARGB(255, 24, 28, 37)
                : null,
          ),
        ),
        iconTheme: IconThemeData(
          color: themeProvider.themeData.brightness == Brightness.light
              ? Colors.white
              : Color(0xFF57C9E7),
        ),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                SizedBox(
                  height: 30,
                ),
                TextFormField(
                  style: TextStyle(
                    color:
                        themeProvider.themeData.brightness == Brightness.light
                            ? Colors.black
                            : Colors.white,
                  ),
                  controller: addDiscriptionController,
                  maxLines: 5,
                  decoration: InputDecoration(
                    labelText: 'Add a description...',
                    labelStyle: TextStyle(
                      color:
                          themeProvider.themeData.brightness == Brightness.light
                              ? Colors.black
                              : Colors.white,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide(
                        color: themeProvider.themeData.brightness ==
                                Brightness.light
                            ? Colors.black.withOpacity(0.3)
                            : Colors.white.withOpacity(0.3),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide(
                        color: themeProvider.themeData.brightness ==
                                Brightness.light
                            ? Colors.black
                            : Colors.grey,
                        width: 1,
                      ),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a description';
                    }
                    return null;
                  },
                ),
                SizedBox(
                  height: 20,
                ),
                DropdownButtonFormField<String>(
                  value: priorityController.text.isNotEmpty
                      ? priorityController.text
                      : null,
                  items: ['Low', 'Medium', 'High'].map((String priority) {
                    return DropdownMenuItem<String>(
                      value: priority,
                      child: Text(priority),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    if (newValue != null) {
                      priorityController.text = newValue;
                    }
                  },
                  decoration: InputDecoration(
                    labelText: 'Priority',
                    labelStyle: TextStyle(
                      color:
                          themeProvider.themeData.brightness == Brightness.light
                              ? Colors.black
                              : Colors.white,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide(
                        color: themeProvider.themeData.brightness ==
                                Brightness.light
                            ? Colors.black.withOpacity(0.3)
                            : Colors.white.withOpacity(0.3),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide(
                        color: themeProvider.themeData.brightness ==
                                Brightness.light
                            ? Colors.black
                            : Colors.grey,
                        width: 1,
                      ),
                    ),
                  ),
                  style: TextStyle(
                    color:
                        themeProvider.themeData.brightness == Brightness.light
                            ? Colors.black
                            : Colors.white,
                  ),
                  dropdownColor:
                      themeProvider.themeData.brightness == Brightness.light
                          ? Colors.white
                          : Colors.grey[800],
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select a priority';
                    }
                    return null;
                  },
                ),
                SizedBox(
                  height: 20,
                ),
                GestureDetector(
                  onTap: () async {
                    DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100),
                    );

                    if (pickedDate != null) {
                      dateController.text =
                          "${pickedDate.year}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')}";
                    }
                  },
                  child: AbsorbPointer(
                    child: TextFormField(
                      style: TextStyle(
                        color: themeProvider.themeData.brightness ==
                                Brightness.light
                            ? Colors.black
                            : Colors.white,
                      ),
                      controller: dateController,
                      decoration: InputDecoration(
                        suffixIcon: Icon(Icons.calendar_month),
                        labelText: 'Date',
                        labelStyle: TextStyle(
                          color: themeProvider.themeData.brightness ==
                                  Brightness.light
                              ? Colors.black
                              : Colors.white,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide(
                            color: themeProvider.themeData.brightness ==
                                    Brightness.light
                                ? Colors.black.withOpacity(0.3)
                                : Colors.white.withOpacity(0.3),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide(
                            color: themeProvider.themeData.brightness ==
                                    Brightness.light
                                ? Colors.black
                                : Colors.grey,
                            width: 1,
                          ),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please select a date';
                        }
                        return null;
                      },
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                GestureDetector(
                  onTap: () async {
                    TimeOfDay? pickedTime = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.now(),
                    );

                    if (pickedTime != null) {
                      final hour = pickedTime.hour.toString().padLeft(2, '0');
                      final minute =
                          pickedTime.minute.toString().padLeft(2, '0');
                      final seconds = "00";

                      timeController.text = "$hour:$minute:$seconds";
                    }
                  },
                  child: AbsorbPointer(
                    child: TextFormField(
                      style: TextStyle(
                        color: themeProvider.themeData.brightness ==
                                Brightness.light
                            ? Colors.black
                            : Colors.white,
                      ),
                      controller: timeController,
                      decoration: InputDecoration(
                        suffixIcon: Icon(Icons.timer),
                        labelText: 'Time',
                        labelStyle: TextStyle(
                          color: themeProvider.themeData.brightness ==
                                  Brightness.light
                              ? Colors.black
                              : Colors.white,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide(
                            color: themeProvider.themeData.brightness ==
                                    Brightness.light
                                ? Colors.black.withOpacity(0.3)
                                : Colors.white.withOpacity(0.3),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide(
                            color: themeProvider.themeData.brightness ==
                                    Brightness.light
                                ? Colors.black
                                : Colors.grey,
                            width: 1,
                          ),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please select a time';
                        }
                        return null;
                      },
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                TextFormField(
                  style: TextStyle(
                    color:
                        themeProvider.themeData.brightness == Brightness.light
                            ? Colors.black
                            : Colors.white,
                  ),
                  controller: categoryController,
                  decoration: InputDecoration(
                    labelText: 'Importent',
                    suffixIcon: Icon(Icons.add_box),
                    labelStyle: TextStyle(
                      color:
                          themeProvider.themeData.brightness == Brightness.light
                              ? Colors.black
                              : Colors.white,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide(
                        color: themeProvider.themeData.brightness ==
                                Brightness.light
                            ? Colors.black.withOpacity(0.3)
                            : Colors.white.withOpacity(0.3),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide(
                        color: themeProvider.themeData.brightness ==
                                Brightness.light
                            ? Colors.black
                            : Colors.grey,
                        width: 1,
                      ),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a category';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 50),
                SizedBox(
                  height: 50,
                  width: 120,
                  child: GestureDetector(
                    child: ElevatedButton(
                      onPressed: isLoader ? null : submitForm,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: themeProvider.themeData.brightness ==
                                Brightness.light
                            ? Colors.indigo.shade900
                            : Color(0xFF57C9E7),
                      ),
                      child: Text(
                        "Done",
                        style: TextStyle(fontSize: 20, color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
