import 'dart:convert';

import 'package:dass/colortheme/theme_maneger.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../webservices/api.dart';

class CreateMeetingScreen extends StatefulWidget {
  final String? name;
  final String? email;
  CreateMeetingScreen({Key? key, this.name, this.email}) : super(key: key);
  @override
  _CreateMeetingScreenState createState() => _CreateMeetingScreenState();
}

class _CreateMeetingScreenState extends State<CreateMeetingScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController linkController = TextEditingController();
  final TextEditingController durationController = TextEditingController();
  final TextEditingController participantsController = TextEditingController();
  bool showParticipantsList = false;
  Map<String, String> nameToEmail = {};

  String meetingMode = 'Online';
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedStartTime = TimeOfDay.now();
  TimeOfDay selectedEndTime = TimeOfDay.now();
  List<String> participants = [];
  List<String> allParticipants = [];
  late final String hostEmail;
  Future<void> _saveMeeting() async {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    if (_formKey.currentState?.validate() ?? false) {
      final scheduledDateTime = DateTime(
        selectedDate.year,
        selectedDate.month,
        selectedDate.day,
        selectedStartTime.hour,
        selectedStartTime.minute,
      ).toUtc();
      final participantEmails = participants
          .map((participant) => nameToEmail[participant])
          .where((email) => email != null) // Ensure no null values
          .toList();

      participantEmails.insert(0, hostEmail);

      final meetingDetails = {
        "email": widget.email,
        "meetingTitle": titleController.text.trim(),
        "description": descriptionController.text.trim(),
        "meetingMode": meetingMode,
        "participants": participantEmails,
        "status": "OPEN",
        "duration": durationController.text.trim(),
        "date": DateFormat('yyyy-MM-dd').format(selectedDate),
        "scheduledTime": scheduledDateTime.toIso8601String(),
        "meetingLink": meetingMode == 'Offline'
            ? locationController.text.trim()
            : linkController.text.trim(),
      };

      print('Request Body: ${jsonEncode(meetingDetails)}');

      try {
        final apiService = ApiService();
        final response = await apiService.createMeeting(meetingDetails);

        print('Response status: ${response.statusCode}');
        print('Response body: ${response.body}');

        if (response.statusCode == 200 || response.statusCode == 201) {
          Fluttertoast.showToast(
            msg: "Meeting Saved Successfully!",
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

          _clearFields();
        } else {
          print('Error Response: ${response.body}');

          Fluttertoast.showToast(
            msg:
                "Error: ${jsonDecode(response.body)['error'] ?? 'Unable to save meeting'}",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0,
          );
        }
      } catch (e) {
        print('Exception: $e');

        Fluttertoast.showToast(
          msg: "Error: $e",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      }
    }
  }

  void _clearFields() {
    titleController.clear();
    descriptionController.clear();
    durationController.clear();
    participants.clear();
    locationController.clear();
    linkController.clear();
    setState(() {
      meetingMode = 'Online';
      selectedDate = DateTime.now();
      selectedStartTime = TimeOfDay.now();
      selectedEndTime = TimeOfDay.now();
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    hostEmail = widget.email!;
    fetchParticipants();
  }

  void fetchParticipants() async {
    try {
      final users = await ApiService.getAllUsersName();
      print("Fetched Users: $users");
      setState(() {
        allParticipants =
            users.map((user) => user['name'] as String? ?? 'Unknown').toList();
        nameToEmail = {
          for (var user in users) user['name']: user['email'],
        };
      });
    } catch (e) {
      print("Error fetching participants: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.themeData.brightness == Brightness.dark;
    print(
        "Filtered participants: ${allParticipants.where((participant) => participant.toLowerCase().contains(participantsController.text.toLowerCase()))}");

    return SafeArea(
      child: Scaffold(
        // appBar: AppBar(title: Text('Create Meeting'),
        // backgroundColor:Colors.red.shade900,
        // ),
        body: Padding(
          padding: EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Icon(
                            Icons.arrow_back_ios,
                            color: themeProvider.themeData.brightness ==
                                    Brightness.light
                                ? Colors.black
                                : Color(0xFF57C9E7),
                          )),
                      SizedBox(
                        width: 12,
                      ),
                      Text(
                        "Create Meeting",
                        style: TextStyle(
                            color: themeProvider.themeData.brightness ==
                                    Brightness.light
                                ? Colors.black
                                : Color(0xFF57C9E7),
                            fontSize: 24,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  // Title Field
                  TextFormField(
                    controller: titleController,
                    decoration: InputDecoration(
                      labelText: 'Meeting Title',
                      labelStyle: TextStyle(
                        color: themeProvider.themeData.brightness ==
                                Brightness.dark
                            ? Colors.grey
                            : Colors.black,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: themeProvider.themeData.brightness ==
                                  Brightness.dark
                              ? Colors.white
                              : Colors.black,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: themeProvider.themeData.brightness ==
                                  Brightness.dark
                              ? Colors.grey
                              : Colors.black,
                        ),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: themeProvider.themeData.brightness ==
                                  Brightness.dark
                              ? Colors.redAccent
                              : Colors.red,
                        ),
                      ),
                      filled: true,
                      fillColor:
                          themeProvider.themeData.brightness == Brightness.dark
                              ? Color(0xFF1C1F26)
                              : Colors.white,
                    ),
                    style: TextStyle(
                      color:
                          themeProvider.themeData.brightness == Brightness.dark
                              ? Colors.white
                              : Colors.black,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a title';
                      }
                      return null;
                    },
                  ),

                  SizedBox(height: 20),

                  // Description Field
                  TextFormField(
                    controller: descriptionController,
                    decoration: InputDecoration(
                      labelText: 'Description / Agenda',
                      labelStyle: TextStyle(
                        color: themeProvider.themeData.brightness ==
                                Brightness.dark
                            ? Colors.grey
                            : Colors.black,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: themeProvider.themeData.brightness ==
                                  Brightness.dark
                              ? Colors.white
                              : Colors.black,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: themeProvider.themeData.brightness ==
                                  Brightness.dark
                              ? Colors.grey
                              : Colors.black,
                        ),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: themeProvider.themeData.brightness ==
                                  Brightness.dark
                              ? Colors.redAccent
                              : Colors.red,
                        ),
                      ),
                      filled: true,
                      fillColor:
                          themeProvider.themeData.brightness == Brightness.dark
                              ? Color(0xFF1C1F26)
                              : Colors.white,
                    ),
                    style: TextStyle(
                      color:
                          themeProvider.themeData.brightness == Brightness.dark
                              ? Colors.white
                              : Colors.black,
                    ),
                    maxLines: 4,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a description';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20),

                  // Meeting Mode Dropdown
                  DropdownButtonFormField<String>(
                    value: meetingMode,
                    onChanged: (value) {
                      setState(() {
                        meetingMode = value!;
                      });
                    },
                    items: ['Online', 'Offline'].map((mode) {
                      return DropdownMenuItem(
                          value: mode,
                          child: Text(
                            mode,
                            style: TextStyle(
                              color: themeProvider.themeData.brightness ==
                                      Brightness.light
                                  ? Colors.black
                                  : Colors.white,
                            ),
                          ));
                    }).toList(),
                    decoration: InputDecoration(
                      labelText: 'Meeting Mode',
                      labelStyle: TextStyle(
                        color: themeProvider.themeData.brightness ==
                                Brightness.dark
                            ? Colors.grey
                            : Colors.black,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: themeProvider.themeData.brightness ==
                                  Brightness.dark
                              ? Colors.white
                              : Colors.black,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: themeProvider.themeData.brightness ==
                                  Brightness.dark
                              ? Colors.grey
                              : Colors.black,
                        ),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: themeProvider.themeData.brightness ==
                                  Brightness.dark
                              ? Colors.redAccent
                              : Colors.red,
                        ),
                      ),
                      filled: true,
                      fillColor:
                          themeProvider.themeData.brightness == Brightness.dark
                              ? Color(0xFF1C1F26)
                              : Colors.white,
                    ),
                    style: TextStyle(
                      color:
                          themeProvider.themeData.brightness == Brightness.dark
                              ? Colors.white
                              : Colors.black,
                    ),
                  ),
                  SizedBox(height: 20),

                  // Participants Search Bar (TypeAhead)
                  TextField(
                    controller: participantsController,
                    decoration: InputDecoration(
                      labelText: 'Participants',
                      labelStyle: TextStyle(
                        color: themeProvider.themeData.brightness ==
                                Brightness.dark
                            ? Colors.grey
                            : Colors.black,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: themeProvider.themeData.brightness ==
                                  Brightness.dark
                              ? Colors.white
                              : Colors.black,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: themeProvider.themeData.brightness ==
                                  Brightness.dark
                              ? Colors.grey
                              : Colors.black,
                        ),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: themeProvider.themeData.brightness ==
                                  Brightness.dark
                              ? Colors.redAccent
                              : Colors.red,
                        ),
                      ),
                      filled: true,
                      fillColor:
                          themeProvider.themeData.brightness == Brightness.dark
                              ? Color(0xFF1C1F26)
                              : Colors.white,
                    ),
                    style: TextStyle(
                      color:
                          themeProvider.themeData.brightness == Brightness.dark
                              ? Colors.white
                              : Colors.black,
                    ),
                    onChanged: (query) {
                      print("Query: $query");
                      setState(() {
                        showParticipantsList =
                            query.isNotEmpty; // Show list when there's input
                      });
                    },
                    onTap: () {
                      setState(() {
                        showParticipantsList = true;
                      });
                    },
                  ),
                  SizedBox(height: 10),
                  Visibility(
                    visible: showParticipantsList && allParticipants.isNotEmpty,
                    child: allParticipants
                            .where((participant) => participant
                                .toLowerCase()
                                .contains(
                                    participantsController.text.toLowerCase()))
                            .isEmpty
                        ? Text("No participants found")
                        : ListView(
                            shrinkWrap: true,
                            children: allParticipants
                                .where((participant) => participant
                                    .toLowerCase()
                                    .contains(participantsController.text
                                        .toLowerCase()))
                                .map((participant) {
                              return ListTile(
                                title: Text(participant),
                                onTap: () {
                                  setState(() {
                                    participants.add(participant);
                                    participantsController.clear();
                                    showParticipantsList = false;
                                  });
                                },
                              );
                            }).toList(),
                          ),
                  ),
                  SizedBox(height: 20),
                  Wrap(
                    spacing: 8.0,
                    runSpacing: 4.0,
                    children: participants.map((participant) {
                      return Chip(
                        label: Text(participant),
                        deleteIcon: Icon(Icons.clear),
                        onDeleted: () {
                          setState(() {
                            participants.remove(participant);
                          });
                        },
                      );
                    }).toList(),
                  ),

                  SizedBox(height: 20),

                  // Duration (Time) Picker
                  TextFormField(
                    controller: durationController,
                    decoration: InputDecoration(
                      labelText: 'Duration (in minutes)',
                      labelStyle: TextStyle(
                        color: themeProvider.themeData.brightness ==
                                Brightness.dark
                            ? Colors.grey
                            : Colors.black,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: themeProvider.themeData.brightness ==
                                  Brightness.dark
                              ? Colors.white
                              : Colors.black,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: themeProvider.themeData.brightness ==
                                  Brightness.dark
                              ? Colors.grey
                              : Colors.black,
                        ),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: themeProvider.themeData.brightness ==
                                  Brightness.dark
                              ? Colors.redAccent
                              : Colors.red,
                        ),
                      ),
                      filled: true,
                      fillColor:
                          themeProvider.themeData.brightness == Brightness.dark
                              ? Color(0xFF1C1F26)
                              : Colors.white,
                    ),
                    style: TextStyle(
                      color:
                          themeProvider.themeData.brightness == Brightness.dark
                              ? Colors.white
                              : Colors.black,
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the duration';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20),

// Date Picker
                  GestureDetector(
                    onTap: _selectDate,
                    child: AbsorbPointer(
                      child: TextFormField(
                        controller: TextEditingController(
                            text: DateFormat.yMd().format(selectedDate)),
                        decoration: InputDecoration(
                          labelText: 'Date',
                          labelStyle: TextStyle(
                            color: themeProvider.themeData.brightness ==
                                    Brightness.dark
                                ? Colors.grey
                                : Colors.black,
                          ),
                          border: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: themeProvider.themeData.brightness ==
                                      Brightness.dark
                                  ? Colors.white
                                  : Colors.black,
                            ),
                          ),
                          filled: true,
                          fillColor: themeProvider.themeData.brightness ==
                                  Brightness.dark
                              ? Color(0xFF1C1F26)
                              : Colors.white,
                        ),
                        style: TextStyle(
                          color: themeProvider.themeData.brightness ==
                                  Brightness.dark
                              ? Colors.white
                              : Colors.black,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),

                  Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: _selectStartTime,
                          child: AbsorbPointer(
                            child: TextFormField(
                              controller: TextEditingController(
                                  text: selectedStartTime.format(context)),
                              decoration: InputDecoration(
                                labelText: 'StartTime',
                                labelStyle: TextStyle(
                                  color: themeProvider.themeData.brightness ==
                                          Brightness.dark
                                      ? Colors.grey
                                      : Colors.black,
                                ),
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: themeProvider.themeData.brightness ==
                                            Brightness.dark
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                                ),
                                filled: true,
                                fillColor: themeProvider.themeData.brightness ==
                                        Brightness.dark
                                    ? Color(0xFF1C1F26)
                                    : Colors.white,
                              ),
                              style: TextStyle(
                                color: themeProvider.themeData.brightness ==
                                        Brightness.dark
                                    ? Colors.white
                                    : Colors.black,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 20),

                  // Location or Link (for Online Meetings)
                  meetingMode == 'Offline'
                      ? TextFormField(
                          controller: locationController,
                          decoration: InputDecoration(
                            labelText: 'Location',
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a location';
                            }
                            return null;
                          },
                        )
                      : TextFormField(
                          controller: linkController,
                          decoration: InputDecoration(
                            labelText: 'Meeting Link (Zoom/Google Meet)',
                            labelStyle: TextStyle(
                              color: themeProvider.themeData.brightness ==
                                      Brightness.dark
                                  ? Colors.grey
                                  : Colors.black,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: themeProvider.themeData.brightness ==
                                        Brightness.dark
                                    ? Colors.white
                                    : Colors.black,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: themeProvider.themeData.brightness ==
                                        Brightness.dark
                                    ? Colors.grey
                                    : Colors.black,
                              ),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: themeProvider.themeData.brightness ==
                                        Brightness.dark
                                    ? Colors.redAccent
                                    : Colors.red,
                              ),
                            ),
                            filled: true,
                            fillColor: themeProvider.themeData.brightness ==
                                    Brightness.dark
                                ? Color(0xFF1C1F26)
                                : Colors.white,
                          ),
                          style: TextStyle(
                            color: themeProvider.themeData.brightness ==
                                    Brightness.dark
                                ? Colors.white
                                : Colors.black,
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a link';
                            }
                            return null;
                          },
                        ),
                  SizedBox(height: 30),

                  ElevatedButton(
                    onPressed: _saveMeeting,
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          themeProvider.themeData.brightness == Brightness.light
                              ? Colors.indigo.shade900
                              : Color(0xFF57C9E7),
                      padding: EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Center(
                        child: Text(
                      'Save Meeting',
                      style: TextStyle(color: Colors.white),
                    )),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _selectDate() async {
    final DateTime picked = await showDatePicker(
          context: context,
          initialDate: selectedDate,
          firstDate: DateTime(2020),
          lastDate: DateTime(2101),
          builder: (BuildContext context, Widget? child) {
            final themeProvider = Provider.of<ThemeProvider>(context);
            return Theme(
              data: Theme.of(context).copyWith(
                colorScheme: themeProvider.themeData.brightness ==
                        Brightness.light
                    ? ColorScheme.light(
                        primary:
                            Colors.indigo.shade900, // Header background color
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
        ) ??
        selectedDate;

    setState(() {
      selectedDate = picked;
    });
  }

  Future<void> _selectStartTime() async {
    final TimeOfDay picked = await showTimePicker(
          context: context,
          initialTime: selectedStartTime,
          builder: (BuildContext context, Widget? child) {
            final themeProvider = Provider.of<ThemeProvider>(context);
            return Theme(
              data: Theme.of(context).copyWith(
                colorScheme: themeProvider.themeData.brightness ==
                        Brightness.light
                    ? ColorScheme.light(
                        primary:
                            Colors.indigo.shade900, // Header background color
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
        ) ??
        selectedStartTime;

    setState(() {
      selectedStartTime = picked;
    });
  }
}
