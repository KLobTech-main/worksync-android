import 'package:dass/colortheme/theme_maneger.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../webservices/api.dart';

class CreateTaskScreen extends StatefulWidget {
  final String? name;
  final String? email;
  CreateTaskScreen({Key? key, this.name, this.email}) : super(key: key);
  @override
  State<CreateTaskScreen> createState() => _CreateTaskScreenState();
}

class _CreateTaskScreenState extends State<CreateTaskScreen> {
  late Future<List<dynamic>> allUsersFuture;
  String? selectedUserEmail;
  List<dynamic> allUsers = [];
  List<dynamic> userNames = []; // To store user names
  String? selectedUser; // Holds the selected user
  TextEditingController taskNameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController deadlineController = TextEditingController();
  TextEditingController startDateController = TextEditingController();

  @override
  void initState() {
    super.initState();
    allUsersFuture = _fetchUsers();
    debugPrint("name");
    debugPrint(widget.name);
  }

  Future<List<dynamic>> _fetchUsers() async {
    try {
      final users = await ApiService.getAllUsers(widget.email!, context);
      setState(() {
        allUsers = users;
        userNames = users.map((user) => user['name'] ?? "Unnamed").toList();
      });
      return users;
    } catch (e) {
      print("Error fetching users: $e");
      return [];
    }
  }

  Future<void> _createTask() async {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    final taskName = taskNameController.text.trim();
    final description = descriptionController.text.trim();
    //final deadline = deadlineController.text.trim();
    final startDate = startDateController.text.trim();
    final assignedBy = widget.email;
    final assignedTo = allUsers.firstWhere(
      (user) => user['name'] == selectedUser,
      orElse: () => {},
    )['email'];

    if (taskName.isEmpty ||
        description.isEmpty ||
        //deadline.isEmpty ||
        startDate.isEmpty ||
        assignedTo == null) {
      Fluttertoast.showToast(
        msg: "All fields are required",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
      return;
    }

    try {
      await ApiService.createTask(
          name:widget.name,
          assignedBy: assignedBy,
          assignedTo: assignedTo,
          title: taskName,
          description: description,
          deadLine: startDate,
          status: "On Going",
          createdAt: startDate,
          context);

      Fluttertoast.showToast(
        msg: "Task created successfully!",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: themeProvider.themeData.brightness == Brightness.light
            ? Colors.indigo.shade900
            : Color(0xFF57C9E7),
        textColor: Colors.white,
        fontSize: 16.0,
      );
      Navigator.pop(context);
    } catch (e) {
      print("Error creating task: $e");

      Fluttertoast.showToast(
        msg: "Failed to create task",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
  }

  void _pickStartDate(
      BuildContext context,
      TextEditingController startDateController,
      ThemeProvider themeProvider) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: themeProvider.themeData.brightness == Brightness.light
                ? ColorScheme.light(
                    primary: Colors.indigo.shade900, // Header background color
                    onPrimary: Colors.white, // Header text color
                    onSurface: Colors.black, // Body text color
                  )
                : ColorScheme.dark(
                    primary: Color(0xFF57C9E7), // Header background color
                    onPrimary: Colors.white, // Header text color
                    surface: Color(0xFF1C1F26), // Background color
                    onSurface: Colors.white, // Body text color
                  ),
            dialogBackgroundColor:
                themeProvider.themeData.brightness == Brightness.light
                    ? Colors.white
                    : Color(0xFF1C1F26),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate != null) {
      startDateController.text = "${pickedDate.toLocal()}".split(' ')[0];
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
        title: Text('Create New Task',
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
                : null, // You can use null for no gradient in dark mode
            color: themeProvider.themeData.brightness == Brightness.dark
                ? Color.fromARGB(255, 24, 28, 37)
                : null, // This is used when brightness is dark for a solid color
          ),
        ),
        iconTheme: IconThemeData(
          color: themeProvider.themeData.brightness == Brightness.light
              ? Colors.white
              : Color(0xFF57C9E7),
        ), // Adjust icon color for dark theme

        elevation: 0,
      ),
      body: Column(
        children: [
          SizedBox(
            height: 30,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Task name",
                    style: TextStyle(
                        color: themeProvider.themeData.brightness ==
                                Brightness.light
                            ? Colors.indigo.shade900
                            : Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  TextField(
                    style: TextStyle(
                      color:
                          themeProvider.themeData.brightness == Brightness.light
                              ? Colors.black
                              : Colors.white,
                    ),
                    controller: taskNameController,
                    decoration: InputDecoration(
                      labelText: 'Task Name',
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
                      ), // Added
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    "Description",
                    style: TextStyle(
                        color: themeProvider.themeData.brightness ==
                                Brightness.light
                            ? Colors.indigo.shade900
                            : Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  TextField(
                    style: TextStyle(
                      color:
                          themeProvider.themeData.brightness == Brightness.light
                              ? Colors.black
                              : Colors.white,
                    ),
                    controller: descriptionController,
                    maxLines: 3,
                    decoration: InputDecoration(
                      labelText: 'Description',
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
                      ), // Added
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    "Deadline",
                    style: TextStyle(
                        color: themeProvider.themeData.brightness ==
                                Brightness.light
                            ? Colors.indigo.shade900
                            : Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  TextField(
                    style: TextStyle(
                      color:
                          themeProvider.themeData.brightness == Brightness.light
                              ? Colors.black
                              : Colors.white,
                    ),
                    controller: startDateController,
                    readOnly: true,
                    onTap: () => _pickStartDate(
                        context, startDateController, themeProvider),
                    decoration: InputDecoration(
                      labelText: 'Select Start Date',
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
                      ), // Added
                    ),
                  ),
                  // SizedBox(height: 16),
                  // Text(
                  //   "Deadline",
                  //   style: TextStyle(
                  //       color: themeProvider.themeData.brightness ==
                  //               Brightness.light
                  //           ? Colors.indigo.shade900
                  //           : Colors.white,
                  //       fontSize: 18,
                  //       fontWeight: FontWeight.bold),
                  // ),
                  // SizedBox(height: 10),
                  // Row(
                  //   children: [
                  //     Expanded(
                  //       child: TextField(
                  //         style: TextStyle(
                  //           color: themeProvider.themeData.brightness ==
                  //                   Brightness.light
                  //               ? Colors.black
                  //               : Colors.white,
                  //         ),
                  //         controller: deadlineController,
                  //         decoration: InputDecoration(
                  //           labelText: 'Deadline (In Days)',
                  //           labelStyle: TextStyle(
                  //             color:
                  //                 themeProvider.themeData.brightness ==
                  //                         Brightness.light
                  //                     ? Colors.black
                  //                     : Colors.white,
                  //           ),
                  //           border: OutlineInputBorder(
                  //             borderRadius: BorderRadius.circular(10.0),
                  //             borderSide: BorderSide(
                  //               color: themeProvider
                  //                           .themeData.brightness ==
                  //                       Brightness.light
                  //                   ? Colors.black.withOpacity(0.3)
                  //                   : Colors.white.withOpacity(0.3),
                  //             ),
                  //           ),
                  //           focusedBorder: OutlineInputBorder(
                  //             borderRadius: BorderRadius.circular(10.0),
                  //             borderSide: BorderSide(
                  //               color: themeProvider
                  //                           .themeData.brightness ==
                  //                       Brightness.light
                  //                   ? Colors.black
                  //                   : Colors.grey,
                  //               width: 2,
                  //             ),
                  //           ), // Added
                  //         ),
                  //       ),
                  //     ),
                  //   ],
                  // ),
                  SizedBox(height: 16),
                  Text(
                    "Participants",
                    style: TextStyle(
                      color:
                          themeProvider.themeData.brightness == Brightness.light
                              ? Colors.indigo.shade900
                              : Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: themeProvider.themeData.brightness ==
                                Brightness.light
                            ? Colors.black
                            : Colors.grey,
                        width: 1.0,
                      ),
                      borderRadius: BorderRadius.circular(8.0),
                      color: themeProvider.themeData.brightness ==
                              Brightness.light
                          ? const Color.fromARGB(255, 246, 244, 244)
                          : Color(
                              0xFF1C1F26), // Dark background for dropdown in dark mode
                    ),
                    child: DropdownButton<String>(
                      isExpanded: true,
                      underline: SizedBox(),
                      hint: Text(
                        "Select Participant",
                        style: TextStyle(
                          color: themeProvider.themeData.brightness ==
                                  Brightness.light
                              ? Colors.black
                              : Colors.white, // Light/dark hint text color
                        ),
                      ),
                      value: selectedUser,
                      onChanged: (String? value) {
                        setState(() {
                          selectedUser = value;
                        });
                      },
                      items: userNames.isEmpty
                          ? [
                              DropdownMenuItem(
                                value: null,
                                child: Row(
                                  children: [
                                    SizedBox(width: 8),
                                    Text(
                                      "Loading...",
                                      style: TextStyle(
                                        color: themeProvider
                                                    .themeData.brightness ==
                                                Brightness.light
                                            ? Colors.black
                                            : Colors
                                                .white, // Loading text color
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ]
                          : userNames.map((name) {
                              return DropdownMenuItem<String>(
                                value: name,
                                child: Text(
                                  name,
                                  style: TextStyle(
                                    color: themeProvider.themeData.brightness ==
                                            Brightness.light
                                        ? Colors.black
                                        : Colors
                                            .white, // Dropdown item text color
                                  ),
                                ),
                              );
                            }).toList(),
                    ),
                  ),
                  if (selectedUser != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 16.0),
                      child: Text(
                        "Selected User: $selectedUser",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: themeProvider.themeData.brightness ==
                                  Brightness.light
                              ? Colors.black
                              : Colors.white, // Text color for selected user
                        ),
                      ),
                    ),
                  SizedBox(height: 16),
                ],
              ),
            ),
          ),
          Spacer(),
          Container(
            width: double.infinity,
            height: 50,
            margin: EdgeInsets.all(16),
            child: ElevatedButton(
              onPressed: _createTask,
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    themeProvider.themeData.brightness == Brightness.light
                        ? Colors.indigo.shade900
                        : Color(0xFF57C9E7),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.0),
                ),
              ),
              child: Text(
                'Create Task',
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
