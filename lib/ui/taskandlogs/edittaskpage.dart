// Existing imports
import 'package:dass/colortheme/theme_maneger.dart';
import 'package:dass/webservices/api.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:fluttertoast/fluttertoast.dart';

class EditTaskPage extends StatefulWidget {
  final String taskId;
  final String title;
  final String description;
  final String deadline;
  final String assignedTo;

  EditTaskPage({
    required this.taskId,
    required this.title,
    required this.description,
    required this.deadline,
    required this.assignedTo,
  });

  @override
  _EditTaskPageState createState() => _EditTaskPageState();
}

class _EditTaskPageState extends State<EditTaskPage> {
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late TextEditingController _deadlineController;
  String? _assignedToEmail;
  List<Map<String, String>> _users = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.title);
    _descriptionController = TextEditingController(text: widget.description);
    _deadlineController = TextEditingController(text: widget.deadline);
    _fetchUsers();
  }

  Future<void> _fetchUsers() async {
    try {
      List<Map<String, String>> users =
          await ApiService.fetchAllUsers(widget.assignedTo, context);
      setState(() {
        _users = users;
        _isLoading = false;
      });
    } catch (e) {
      print("Failed to fetch users: $e");
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _pickDeadline() async {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.parse(widget.deadline),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: themeProvider.themeData.copyWith(
            dialogBackgroundColor:
                themeProvider.themeData.brightness == Brightness.dark
                    ? Colors.grey.shade900
                    : Colors.white,
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor:
                    themeProvider.themeData.brightness == Brightness.dark
                        ? Colors.white
                        : Colors.indigo.shade900,
              ),
            ),
            colorScheme: themeProvider.themeData.colorScheme.copyWith(
              primary: themeProvider.themeData.brightness == Brightness.dark
                  ? const Color(0xFF57C9E7)
                  : Colors.indigo.shade900,
              surface: themeProvider.themeData.brightness == Brightness.dark
                  ? Colors.grey.shade900
                  : Colors.white,
              onSurface: themeProvider.themeData.brightness == Brightness.dark
                  ? Colors.white
                  : Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );
    if (selectedDate != null) {
      setState(() {
        _deadlineController.text =
            DateFormat('yyyy-MM-dd').format(selectedDate);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final inputBorder = OutlineInputBorder(
      borderSide: BorderSide(
        color: themeProvider.themeData.brightness == Brightness.dark
            ? Colors.white
            : Colors.indigo.shade900,
        width: 1.0,
      ),
    );

    return Scaffold(
      backgroundColor: themeProvider.themeData.brightness == Brightness.light
          ? Colors.white
          : const Color(0xFF1C1F26),
      appBar: AppBar(
        backgroundColor: themeProvider.themeData.brightness == Brightness.light
            ? Colors.indigo.shade900
            : Color(0xFF57C9E7),
        title: Text(
          "Edit Task",
          style: TextStyle(
            color: themeProvider.themeData.brightness == Brightness.light
                ? Colors.white
                : const Color(0xFF57C9E7),
          ),
        ),
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: themeProvider.themeData.brightness == Brightness.light
                ? Colors.white
                : const Color(0xFF57C9E7),
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(
              color: themeProvider.themeData.brightness == Brightness.light
                  ? Colors.indigo.shade900
                  : Color(0xFF57C9E7),
            ))
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    style: TextStyle(
                      color:
                          themeProvider.themeData.brightness == Brightness.light
                              ? Colors.black
                              : Colors.white,
                    ),
                    controller: _titleController,
                    decoration: InputDecoration(
                      labelText: "Title",
                      hintStyle: TextStyle(
                        color: themeProvider.themeData.brightness ==
                                Brightness.light
                            ? Colors.black
                            : Colors.white,
                      ),
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
                          width: 2,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    style: TextStyle(
                      color:
                          themeProvider.themeData.brightness == Brightness.light
                              ? Colors.black
                              : Colors.white,
                    ),
                    controller: _descriptionController,
                    decoration: InputDecoration(
                      labelText: "Description",
                      hintStyle: TextStyle(
                        color: themeProvider.themeData.brightness ==
                                Brightness.light
                            ? Colors.black
                            : Colors.white,
                      ),
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
                          width: 2,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  GestureDetector(
                    onTap: _pickDeadline,
                    child: AbsorbPointer(
                      child: TextField(
                        style: TextStyle(
                          color: themeProvider.themeData.brightness ==
                                  Brightness.light
                              ? Colors.black
                              : Colors.white,
                        ),
                        controller: _deadlineController,
                        decoration: InputDecoration(
                          labelText: "Deadline",
                          hintStyle: TextStyle(
                            color: themeProvider.themeData.brightness ==
                                    Brightness.light
                                ? Colors.black
                                : Colors.white,
                          ),
                          labelStyle: TextStyle(
                            color: themeProvider.themeData.brightness ==
                                    Brightness.light
                                ? Colors.black
                                : Colors.white,
                          ),
                          prefixIcon: const Icon(Icons.calendar_today),
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
                              width: 2,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    value: _assignedToEmail,
                    hint: Text(
                      "Select a user",
                      style: TextStyle(
                        color: themeProvider.themeData.brightness ==
                                Brightness.light
                            ? Colors.black
                            : Colors.white,
                      ),
                    ),
                    items: _users.map((user) {
                      return DropdownMenuItem<String>(
                        value: user['email'],
                        child: Text(
                          user['name'] ?? "Unknown",
                          style: TextStyle(
                            color: themeProvider.themeData.brightness ==
                                    Brightness.light
                                ? Colors.black
                                : Colors.white,
                          ),
                        ),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _assignedToEmail = value;
                      });
                    },
                    dropdownColor:
                        themeProvider.themeData.brightness == Brightness.light
                            ? Colors.white
                            : Colors.black, // Dropdown background color
                    decoration: InputDecoration(
                      labelText: "Reassign To",
                      hintStyle: TextStyle(
                        color: themeProvider.themeData.brightness ==
                                Brightness.light
                            ? Colors.black
                            : Colors.white,
                      ),
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
                      enabledBorder: OutlineInputBorder(
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
                              : Colors.white,
                          width: 2,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Center(
                    child:  ElevatedButton(
                      onPressed: () async {
                        if (_assignedToEmail != null) {
                          try {
                            await ApiService.editTask(
                              widget.taskId,
                              _assignedToEmail!,
                              _titleController.text,
                              _descriptionController.text,
                              _deadlineController.text,
                              context
                            );
                            // Show toast on success
                            Fluttertoast.showToast(
                              msg: "Task reassigned successfully!",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              backgroundColor: Colors.indigo.shade900,
                              textColor: Colors.white,
                              fontSize: 16.0,
                            );
                            Navigator.pop(context); // Navigate back
                          } catch (e) {
                            // Handle any errors during the task update
                            Fluttertoast.showToast(
                              msg: "Failed to reassign task. Please try again.",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              backgroundColor: Colors.red,
                              textColor: Colors.white,
                              fontSize: 16.0,
                            );
                          }
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text("Please select a user to reassign the task."),
                            ),
                          );
                        }
                      },
                      child: Text("Save Changes"),
                    )
                  ),
                ],
              ),
            ),
    );
  }
}
