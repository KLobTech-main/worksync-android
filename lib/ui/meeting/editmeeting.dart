import 'package:dass/colortheme/theme_maneger.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

import '../../modal/meetingsmodel.dart';
import '../../webservices/api.dart';

class EditMeetingScreen extends StatefulWidget {
  final MeetingModal meeting;

  EditMeetingScreen({required this.meeting});

  @override
  State<EditMeetingScreen> createState() => _EditMeetingScreenState();
}

class _EditMeetingScreenState extends State<EditMeetingScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController titleController;
  late TextEditingController descriptionController;
  late TextEditingController modeController;
  late TextEditingController durationController;
  late TextEditingController dateController;
  late TextEditingController linkController;

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: widget.meeting.meetingTitle);
    descriptionController =
        TextEditingController(text: widget.meeting.description);
    modeController = TextEditingController(text: widget.meeting.meetingMode);
    durationController = TextEditingController(text: widget.meeting.duration);
    dateController = TextEditingController(text: widget.meeting.date);
    linkController = TextEditingController(text: widget.meeting.meetingLink);
  }

  void _showToast(String message) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: themeProvider.themeData.brightness == Brightness.light
          ? Colors.indigo.shade900
          : Color(0xFF57C9E7),
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  void _saveEdits() async {
    if (_formKey.currentState?.validate() ?? false) {
      try {
        final response = await ApiService.editMeeting(
          meetingId: widget.meeting.id ?? '',
          meetingTitle: titleController.text,
          description: descriptionController.text,
          meetingMode: modeController.text,
          duration: durationController.text,
          date: dateController.text,
          meetingLink: linkController.text,
        );
        if (response.statusCode == 200) {
          _showToast('Meeting updated successfully!');
          Navigator.pop(context);
        } else {
          Fluttertoast.showToast(
            msg: "Failed to update: ${response.body}",
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
          msg: 'Error: $e',
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

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isLightTheme = themeProvider.themeData.brightness == Brightness.light;

    return Scaffold(
      backgroundColor: isLightTheme
          ? const Color.fromARGB(255, 246, 244, 244)
          : const Color(0xFF1C1F26),
      appBar: AppBar(
        title: const Text('Edit Meeting'),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: isLightTheme
                ? LinearGradient(
                    colors: [Colors.indigo.shade900, Colors.indigo.shade700],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  )
                : null,
            color: !isLightTheme ? const Color.fromARGB(255, 24, 28, 37) : null,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  style: TextStyle(
                    color: isLightTheme ? Colors.black : Colors.white,
                  ),
                  controller: titleController,
                  decoration:
                      _buildInputDecoration('Meeting Title', isLightTheme),
                ),
                SizedBox(
                  height: 15,
                ),
                TextFormField(
                  style: TextStyle(
                    color: isLightTheme ? Colors.black : Colors.white,
                  ),
                  controller: descriptionController,
                  decoration:
                      _buildInputDecoration('Description', isLightTheme),
                ),
                SizedBox(
                  height: 15,
                ),
                TextFormField(
                  style: TextStyle(
                    color: isLightTheme ? Colors.black : Colors.white,
                  ),
                  controller: modeController,
                  decoration: _buildInputDecoration(
                      'Mode (Online/Offline)', isLightTheme),
                ),
                SizedBox(
                  height: 15,
                ),
                TextFormField(
                  style: TextStyle(
                    color: isLightTheme ? Colors.black : Colors.white,
                  ),
                  controller: durationController,
                  decoration: _buildInputDecoration('Duration', isLightTheme),
                ),
                SizedBox(
                  height: 15,
                ),
                TextFormField(
                  style: TextStyle(
                    color: isLightTheme ? Colors.black : Colors.white,
                  ),
                  controller: dateController,
                  decoration:
                      _buildInputDecoration('Date (YYYY-MM-DD)', isLightTheme),
                ),
                SizedBox(
                  height: 15,
                ),
                TextFormField(
                  style: TextStyle(
                    color: isLightTheme ? Colors.black : Colors.white,
                  ),
                  controller: linkController,
                  decoration:
                      _buildInputDecoration('Meeting Link', isLightTheme),
                ),
                const SizedBox(height: 25),
                ElevatedButton(
                  onPressed: _saveEdits,
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(
                      isLightTheme
                          ? Colors.indigo.shade900
                          : const Color(0xFF57C9E7),
                    ),
                  ),
                  child: const Text('Save Changes'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration _buildInputDecoration(String label, bool isLightTheme) {
    return InputDecoration(
      labelText: label,
      filled: true,
      fillColor: isLightTheme
          ? Color.fromARGB(255, 246, 244, 244)
          : const Color(0xFF1C1F26),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(
          color: isLightTheme ? Colors.indigo : Colors.grey.shade600,
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(
          color: isLightTheme ? Colors.indigo : Colors.grey.shade600,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(
          color: isLightTheme ? Colors.indigo.shade900 : Colors.cyan.shade300,
          width: 2,
        ),
      ),
      labelStyle: TextStyle(
        color: isLightTheme ? Colors.black : Colors.white,
      ),
    );
  }
}
