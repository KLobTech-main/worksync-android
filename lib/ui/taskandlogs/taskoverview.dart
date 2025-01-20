import 'package:dass/colortheme/theme_maneger.dart';
import 'package:dass/ui/taskandlogs/edittaskpage.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../webservices/api.dart';

class TaskOverviewScreen extends StatefulWidget {
  final String? name;
  final String? email;

  TaskOverviewScreen({Key? key, this.name, this.email}) : super(key: key);

  @override
  State<TaskOverviewScreen> createState() => _TaskOverviewScreenState();
}

class _TaskOverviewScreenState extends State<TaskOverviewScreen> {
  late Future<List<dynamic>> assignedTasks;
  late Future<List<dynamic>> givenTasks;
  String selectedTaskType = "My Tasks";

  @override
  void initState() {
    super.initState();
    assignedTasks = ApiService.getAssignedTasks(context, widget.email!);
    givenTasks = ApiService.getGivenTasks(context, widget.email!);
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return SafeArea(
      child: Scaffold(
        backgroundColor: themeProvider.themeData.brightness == Brightness.light
            ? const Color.fromARGB(255, 246, 244, 244)
            : Color(0xFF1C1F26),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 8),
                              child: InkWell(
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                child: Icon(
                                  Icons.arrow_back_ios,
                                  color: themeProvider.themeData.brightness ==
                                          Brightness.light
                                      ? Colors.black
                                      : Color(0xFF57C9E7),
                                ),
                              ),
                            ),
                            SizedBox(width: 5),
                            Text(
                              'Hi, ${widget.name}',
                              style: GoogleFonts.poppins(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: themeProvider.themeData.brightness ==
                                        Brightness.light
                                    ? Colors.black
                                    : Color(0xFF57C9E7),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    // InkWell(
                    //   onTap: () {
                    //     Navigator.push(
                    //       context,
                    //       MaterialPageRoute(
                    //         builder: (context) => CreateTaskScreen(
                    //           name: widget.name,
                    //           email: widget.email,
                    //         ),
                    //       ),
                    //     );
                    //   },
                    //   child: CircleAvatar(
                    //     radius: 20,
                    //     backgroundColor: themeProvider.themeData.brightness ==
                    //             Brightness.light
                    //         ? Colors.indigo.shade900
                    //         : Color(0xFF57C9E7),
                    //     child: Icon(
                    //       Icons.add,
                    //       size: 24,
                    //       color: Colors.white,
                    //     ),
                    //   ),
                    // ),
                  ],
                ),
                SizedBox(height: 16),
                Text(
                  'My Task',
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                SizedBox(
                  height: 100,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedTaskType = "My Tasks";
                          });
                        },
                        child: TaskCard(
                          color: Colors.red.shade900,
                          title: 'My Tasks',
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedTaskType = "Tasks By Me";
                          });
                        },
                        child: TaskCard(
                          color: Colors.green.shade900,
                          title: 'Tasks By Me',
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  selectedTaskType == "My Tasks"
                      ? 'Assigned Tasks'
                      : 'Tasks Given By Me',
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color:
                        themeProvider.themeData.brightness == Brightness.light
                            ? Colors.black
                            : Colors.white,
                  ),
                ),
                SizedBox(height: 8),
                FutureBuilder<List<dynamic>>(
                  future: selectedTaskType == "My Tasks"
                      ? givenTasks
                      : assignedTasks,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                          child: CircularProgressIndicator(
                        color: themeProvider.themeData.brightness ==
                                Brightness.light
                            ? Colors.indigo.shade900
                            : Color(0xFF57C9E7),
                      ));
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return Center(child: Text('No tasks available.'));
                    } else {
                      return Column(
                        children: snapshot.data!.map<Widget>((task) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 16.0),
                            child: TaskProgressCard(
                              id: task['id'] ?? '',
                              title: task['title'] ?? 'No Title',
                              description:
                                  task['description'] ?? 'No Description',
                              status: task['status'] ?? 'No Status',
                              deadLine: task['deadLine'] ?? 'No Deadline',
                              createdAt: task['createdAt'] ?? "",
                              assignedTo: task['assignedTo'] ?? "",
                              onUpdate: (newStatus) async {
                                try {
                                  await ApiService.updateTaskStatus(
                                      task['id'], newStatus, widget.email!);

                                  setState(() {
                                    assignedTasks = ApiService.getAssignedTasks(
                                        context, widget.email!);
                                    givenTasks = ApiService.getGivenTasks(
                                        context, widget.email!);
                                  });

                                  Fluttertoast.showToast(
                                    msg: 'Task status updated to "$newStatus".',
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.BOTTOM,
                                    timeInSecForIosWeb: 1,
                                    backgroundColor:
                                        themeProvider.themeData.brightness ==
                                                Brightness.light
                                            ? Colors.indigo.shade900
                                            : Color(0xFF57C9E7),
                                    textColor: Colors.white,
                                    fontSize: 16.0,
                                  );
                                } catch (e) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        content: Text(
                                            'Failed to update status: $e')),
                                  );
                                }
                              },
                              email: widget.email!,
                              isTaskByMe: selectedTaskType == "Tasks By Me",
                            ),
                          );
                        }).toList(),
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class TaskProgressCard extends StatefulWidget {
  final String id;
  final String title;
  final String description;
  final String status;
  final String createdAt;
  String? assignedTo;
  final String deadLine;
  final Function(String) onUpdate;
  final bool isTaskByMe;
  final String email;

  TaskProgressCard(
      {required this.id,
      required this.title,
      required this.description,
      required this.status,
      required this.createdAt,
      required this.deadLine,
      required this.assignedTo,
      required this.onUpdate,
      required this.isTaskByMe,
      required this.email});

  @override
  State<TaskProgressCard> createState() => _TaskProgressCardState();
}

class _TaskProgressCardState extends State<TaskProgressCard> {
  void _showFullDescription(BuildContext context, String description) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            "Full Description",
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          content: SingleChildScrollView(
            child: Text(
              description,
              style: GoogleFonts.poppins(
                  fontSize: 16,
                  color: themeProvider.themeData.brightness == Brightness.light
                      ? Colors.grey[800]
                      : Colors.white),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                "Close",
                style: TextStyle(
                  color: Colors.blue,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.title,
              style: GoogleFonts.poppins(
                fontSize: 20,
                color: themeProvider.themeData.brightness == Brightness.light
                    ? Colors.black
                    : Color(0xFF57C9E7),
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text.rich(
              TextSpan(
                text: widget.description
                    .split(' ')
                    .take(30)
                    .join(' '), // Display the first 50 words
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  color: themeProvider.themeData.brightness == Brightness.light
                      ? Colors.grey[800]
                      : Colors.grey,
                ),

                children: [
                  if (widget.description.split(' ').length > 50)
                    TextSpan(
                      text: " ...Read More",
                      style: TextStyle(
                        color: themeProvider.themeData.brightness ==
                                Brightness.light
                            ? Colors.indigo[900]
                            : Colors.red[800],
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          _showFullDescription(context, widget.description);
                        },
                    ),
                ],
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Status: ${widget.status}',
              style: GoogleFonts.poppins(
                fontSize: 16,
                color: themeProvider.themeData.brightness == Brightness.light
                    ? Colors.grey[800]
                    : Colors.grey,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Deadline: ${widget.deadLine}',
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: themeProvider.themeData.brightness == Brightness.light
                    ? Colors.grey[800]
                    : Colors.grey,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Assigned To: ${widget.assignedTo}',
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: themeProvider.themeData.brightness == Brightness.light
                    ? Colors.grey[800]
                    : Colors.grey,
              ),
            ),
            SizedBox(height: 8),
            Align(
                alignment: Alignment.centerRight,
                child: !widget.isTaskByMe
                    ? PopupMenuButton<String>(
                        onSelected: (value) {
                          if (value == 'EXTEND_DEADLINE') {
                            _showExtendDeadlineDialog(context, widget.id);
                          } else if (value == 'EDIT') {
                          } else {
                            widget.onUpdate(value);
                          }
                        },
                        itemBuilder: (BuildContext context) => [
                          PopupMenuItem(
                            value: 'ONHOLD',
                            child: Text('On Hold'),
                          ),
                          PopupMenuItem(
                            value: 'INPROGRESS',
                            child: Text('In Progress'),
                          ),
                          PopupMenuItem(
                            value: 'COMPLETED',
                            child: Text('Completed'),
                          ),
                          PopupMenuItem(
                            value: 'EXTEND_DEADLINE',
                            child: Text('Extend Deadline'),
                          ),
                        ],
                        icon: Icon(
                          Icons.more_horiz,
                          color: Colors.blue.shade800,
                        ),
                      )
                    : InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EditTaskPage(
                                taskId: widget.id,
                                title: widget.title,
                                description: widget.description,
                                deadline: widget.deadLine,
                                assignedTo: widget
                                    .email, // Pass the current assignee's email
                              ),
                            ),
                          );
                        },
                        child: Icon(
                          Icons.edit,
                          color: themeProvider.themeData.brightness ==
                                  Brightness.light
                              ? Colors.indigo.shade900
                              : Color(0xFF57C9E7),
                        ),
                      ))
          ],
        ),
      ),
    );
  }

  void _showExtendDeadlineDialog(BuildContext context, String taskId) {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    final TextEditingController newDeadlineController = TextEditingController();
    final TextEditingController reasonController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
          title: Row(
            children: [
              Icon(
                Icons.date_range,
                color: themeProvider.themeData.brightness == Brightness.light
                    ? Colors.indigo.shade900
                    : const Color(0xFF57C9E7),
              ),
              const SizedBox(width: 8),
              Text(
                "Extend Deadline",
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: themeProvider.themeData.brightness == Brightness.light
                      ? Colors.indigo.shade900
                      : const Color(0xFF57C9E7),
                ),
              ),
            ],
          ),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                GestureDetector(
                  onTap: () async {
                    DateTime? selectedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
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
                                foregroundColor: themeProvider.themeData.brightness ==
                                    Brightness.dark
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
                      newDeadlineController.text =
                          selectedDate.toIso8601String().substring(0, 10);
                    }
                  },
                  child: AbsorbPointer(
                    child: TextField(
                      controller: newDeadlineController,
                      decoration: InputDecoration(
                        labelText: 'New Deadline',
                        prefixIcon: Icon(
                          Icons.calendar_today,
                          color: themeProvider.themeData.brightness == Brightness.light
                              ? Colors.indigo.shade900
                              : const Color(0xFF57C9E7),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  style: TextStyle(
                    color: themeProvider.themeData.brightness == Brightness.light
                        ? Colors.black
                        : Colors.white,
                  ),
                  controller: reasonController,
                  maxLines: 5,
                  decoration: InputDecoration(
                    labelText: 'Reason for Extension',
                    labelStyle: TextStyle(
                      color: themeProvider.themeData.brightness == Brightness.light
                          ? Colors.black
                          : Colors.white,
                    ),
                    alignLabelWithHint: true,
                    prefixIcon: Icon(
                      Icons.edit,
                      color: themeProvider.themeData.brightness == Brightness.light
                          ? Colors.indigo.shade900
                          : const Color(0xFF57C9E7),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                "Cancel",
                style: TextStyle(
                  color: themeProvider.themeData.brightness == Brightness.light
                      ? Colors.indigo.shade900
                      : const Color(0xFF57C9E7),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            ElevatedButton.icon(
              onPressed: () async {
                // Validate inputs
                if (newDeadlineController.text.isEmpty) {
                  Fluttertoast.showToast(
                    msg: "Please select a new deadline",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    backgroundColor: Colors.red.shade700,
                    textColor: Colors.white,
                    fontSize: 16.0,
                  );
                  return;
                }
                if (reasonController.text.isEmpty) {
                  Fluttertoast.showToast(
                    msg: "Please provide a reason for the extension",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    backgroundColor: Colors.red.shade700,
                    textColor: Colors.white,
                    fontSize: 16.0,
                  );
                  return;
                }

                Navigator.of(context).pop();

                // Show a toast message
                Fluttertoast.showToast(
                  timeInSecForIosWeb: 2,
                  msg: "Deadline extension request is sent",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  backgroundColor: themeProvider.themeData.brightness == Brightness.light
                      ? Colors.indigo.shade900
                      : const Color(0xFF57C9E7),
                  textColor: Colors.white,
                  fontSize: 16.0,
                );

                try {
                  await ApiService.extendDeadline(
                    taskId,
                    newDeadlineController.text,
                    reasonController.text,
                    context,
                  );
                  Fluttertoast.showToast(
                    timeInSecForIosWeb: 2,
                    msg: "Deadline extended successfully",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    backgroundColor: themeProvider.themeData.brightness == Brightness.light
                        ? Colors.indigo.shade900
                        : const Color(0xFF57C9E7),
                    textColor: Colors.white,
                    fontSize: 16.0,
                  );
                } catch (e) {
                  Fluttertoast.showToast(
                    msg: "Failed to extend deadline: $e",
                    toastLength: Toast.LENGTH_SHORT,
                    timeInSecForIosWeb: 2,
                    gravity: ToastGravity.BOTTOM,
                    backgroundColor: Colors.red.shade700,
                    textColor: Colors.white,
                    fontSize: 16.0,
                  );
                }
              },
              icon: const Icon(Icons.check, color: Colors.white),
              label: const Text(
                "Submit",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: themeProvider.themeData.brightness == Brightness.light
                    ? Colors.indigo.shade900
                    : const Color(0xFF57C9E7),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

}

class TaskCard extends StatelessWidget {
  final Color color;
  final String title;

  TaskCard({
    required this.color,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: color,
      margin: const EdgeInsets.only(right: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title,
              style: GoogleFonts.poppins(
                fontSize: 18,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}
