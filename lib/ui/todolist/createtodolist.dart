import 'package:dass/colortheme/theme_maneger.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CreateTodoList extends StatefulWidget {
  const CreateTodoList({super.key});

  @override
  State<CreateTodoList> createState() => _CreateTodoListState();
}

class _CreateTodoListState extends State<CreateTodoList> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController addDiscriptionController = TextEditingController();
  TextEditingController priorityController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController timeController = TextEditingController();
  TextEditingController importentController = TextEditingController();
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
                TextField(
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
                          : Colors.grey[800], // Matches theme
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
                          "${pickedDate.year}-${pickedDate.month}-${pickedDate.day}";
                    }
                  },
                  child: AbsorbPointer(
                    child: TextField(
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
                      initialTime: TimeOfDay.now(), // Default time
                    );
                    if (pickedTime != null) {
                      // Format the selected time and set it to the controller
                      final hour = pickedTime.hour.toString().padLeft(2, '0');
                      final minute =
                          pickedTime.minute.toString().padLeft(2, '0');
                      timeController.text = "$hour:$minute";
                    }
                  },
                  child: AbsorbPointer(
                    child: TextField(
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
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                TextField(
                  style: TextStyle(
                    color:
                        themeProvider.themeData.brightness == Brightness.light
                            ? Colors.black
                            : Colors.white,
                  ),
                  controller: importentController,
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
                    ), // Added
                  ),
                ),
                SizedBox(height: 50),
                SizedBox(
                  height: 50,
                  width: 120,
                  child: GestureDetector(
                    child: ElevatedButton(
                      onPressed: () {},
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
