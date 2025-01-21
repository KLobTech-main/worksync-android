import 'package:dass/colortheme/theme_maneger.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

import '../../webservices/api.dart';

class RaiseTicketPage extends StatefulWidget {
  final String? name;
  final String? email;
  final VoidCallback? onTicketRaised;

  RaiseTicketPage({Key? key, this.name, this.email, this.onTicketRaised})
      : super(key: key);

  @override
  _RaiseTicketPageState createState() => _RaiseTicketPageState();
}

class _RaiseTicketPageState extends State<RaiseTicketPage> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final List<String> priorities = ['Low', 'Medium', 'High'];
  String? selectedPriority = 'Low';

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isLightTheme = themeProvider.themeData.brightness == Brightness.light;

    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: isLightTheme ? Colors.black : Color(0xFF57C9E7),
          width: 2,
        ),
      ),
      title: Text(
        'Raise a Ticket',
        style: TextStyle(
          color: isLightTheme ? Colors.black : Color(0xFF57C9E7),
          fontWeight: FontWeight.bold,
        ),
      ),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildLabel('Ticket Title', isLightTheme),
            SizedBox(height: 8),
            buildTextField(
              controller: titleController,
              hintText: 'Enter ticket title',
              isLightTheme: isLightTheme,
              hintStyle: TextStyle(
                color: isLightTheme ? Colors.black : Colors.white,
              ),
            ),
            SizedBox(height: 20),
            buildLabel('Description', isLightTheme),
            SizedBox(height: 8),
            buildTextField(
              controller: descriptionController,
              hintText: 'Describe the issue',
              isLightTheme: isLightTheme,
              hintStyle: TextStyle(
                color: isLightTheme ? Colors.black : Colors.white,
              ),
              maxLines: 5,
            ),
            SizedBox(height: 20),
            buildLabel('Priority', isLightTheme),
            SizedBox(height: 8),
            DropdownButtonFormField<String>(
              value: selectedPriority,
              onChanged: (String? newValue) {
                setState(() {
                  selectedPriority = newValue;
                });
              },
              items: priorities.map((String priority) {
                return DropdownMenuItem<String>(
                  value: priority,
                  child: Text(
                    priority,
                    style: TextStyle(
                      color: isLightTheme ? Colors.black : Colors.white,
                    ),
                  ),
                );
              }).toList(),
              decoration: buildInputDecoration(
                hintText: 'Select priority',
                isLightTheme: isLightTheme,
              ),
            ),
            SizedBox(height: 20),
            Row(
              children: [
                buildLabel('Status: ', isLightTheme),
                SizedBox(width: 10),
                Text(
                  'Open',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: isLightTheme ? Colors.black : Colors.white,
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text(
            'Cancel',
            style: TextStyle(
              color: isLightTheme ? Colors.blue.shade900 : Color(0xFF57C9E7),
            ),
          ),
        ),
        ElevatedButton(
          onPressed: () async {
            if (titleController.text.isEmpty ||
                descriptionController.text.isEmpty) {
              if (mounted) {
                Fluttertoast.showToast(
                  msg: 'Please fill in all required fields',
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIosWeb: 1,
                  backgroundColor: Colors.redAccent,
                  textColor: Colors.white,
                  fontSize: 16.0,
                );
              }
            } else {
              Map<String, dynamic> ticketData = {
                "email": widget.email,
                "name" : widget.name,
                "title": titleController.text,
                "description": descriptionController.text,
                "status": "OPEN",
                "priority": selectedPriority,
              };

              try {
                if (mounted) {
                  Navigator.of(context).pop();
                }

                final response =
                    await ApiService.createTicket(context, ticketData);

                if (response.statusCode == 200 || response.statusCode == 201) {
                  if (mounted) {
                    Fluttertoast.showToast(
                      msg: 'Ticket Raised Successfully!',
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
                  }

                  widget.onTicketRaised?.call();
                  titleController.clear();
                  descriptionController.clear();
                } else {
                  if (mounted) {
                    Fluttertoast.showToast(
                      msg: 'Failed to raise the ticket. Try again!',
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Colors.redAccent,
                      textColor: Colors.white,
                      fontSize: 16.0,
                    );
                  }
                }
              } catch (e) {
                if (mounted) {
                  Fluttertoast.showToast(
                    msg: 'Error: $e',
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    timeInSecForIosWeb: 1,
                    backgroundColor: Colors.redAccent,
                    textColor: Colors.white,
                    fontSize: 16.0,
                  );
                }
              }
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor:
                isLightTheme ? Colors.indigo.shade900 : Color(0xFF57C9E7),
          ),
          child: Text(
            'Submit',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ],
    );
  }

  Widget buildLabel(String text, bool isLightTheme) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: isLightTheme ? Colors.black : Colors.white,
      ),
    );
  }

  InputDecoration buildInputDecoration({
    required String hintText,
    required bool isLightTheme,
  }) {
    return InputDecoration(
      hintText: hintText,
      hintStyle: TextStyle(
          color: isLightTheme ? Colors.black : Colors.white, fontSize: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(
          color: isLightTheme ? Colors.indigo.shade900 : Color(0xFF57C9E7),
          width: 1,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(
          color: isLightTheme ? Colors.indigo.shade900 : Color(0xFF57C9E7),
          width: 1,
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(
          color: isLightTheme ? Colors.indigo.shade900 : Color(0xFF57C9E7),
          width: 1,
        ),
      ),
    );
  }

  Widget buildTextField({
    required TextEditingController controller,
    required String hintText,
    required bool isLightTheme,
    required TextStyle hintStyle,
    int maxLines = 1,
  }) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      inputFormatters: [
        FilteringTextInputFormatter
            .singleLineFormatter, // Only single-line text (no line breaks)
        WordLimiterInputFormatter(200),
      ],
      style: TextStyle(
        color: isLightTheme ? Colors.black : Colors.white,
      ),
      decoration: buildInputDecoration(
        hintText: hintText,
        isLightTheme: isLightTheme,
      ),
    );
  }
}

class WordLimiterInputFormatter extends TextInputFormatter {
  final int maxWords;

  WordLimiterInputFormatter(this.maxWords);

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final wordCount = _getWordCount(newValue.text);

    if (wordCount > maxWords) {
      // Return the old value if word count exceeds limit
      return oldValue;
    }
    return newValue;
  }

  int _getWordCount(String text) {
    // Splits by whitespace and counts non-empty words
    return text
        .trim()
        .split(RegExp(r'\s+'))
        .where((word) => word.isNotEmpty)
        .length;
  }
}
