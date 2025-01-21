import 'package:dass/colortheme/theme_maneger.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FAQPage extends StatelessWidget {
  final List<Map<String, String>> faqs = [
    {
      "question": "What is the purpose of this app?",
      "answer":
          "This app helps employees and managers streamline work processes by managing tasks, meetings, attendance, and tickets effectively."
    },
    {
      "question": "How do I log in to the app?",
      "answer":
          "Use your registered email and password to log in. If you are a new user, contact the admin for registration."
    },
    {
      "question": "How do I reset my password?",
      "answer":
          "Go to the login page and click on 'Forgot Password' to reset your password."
    },
    {
      "question": "How do I create a new task?",
      "answer":
          "Navigate to the 'Tasks' module, click the 'Create Task' button, fill in the details, and assign it to yourself or a team member."
    },
    {
      "question": "Can I track the progress of a task?",
      "answer":
          "Yes, the status of each task can be viewed in the task list. You can update the status as you make progress."
    },
    {
      "question": "What information is stored in data logs?",
      "answer":
          "The data logs record your work-related activities, including task updates, attendance punches, and ticket submissions."
    },
    {
      "question": "How do I raise a ticket?",
      "answer":
          "Go to the 'Tickets' section, click 'Raise a Ticket,' fill out the details, and submit. The relevant team will address your issue."
    },
    {
      "question": "How do I schedule a meeting?",
      "answer":
          "Go to the 'Meetings' module, click 'Schedule Meeting,' fill in the details (title, participants, mode, etc.), and save."
    },
    {
      "question": "How do I mark my attendance?",
      "answer":
          "Use the 'Punch-In' button at the start of your workday and the 'Punch-Out' button when you finish."
    },
    {
      "question": "How can I view my attendance records?",
      "answer":
          "Go to the 'Attendance' module to view your daily, weekly, or monthly records."
    },
    {
      "question": "What should I do if I face technical issues?",
      "answer":
          "Raise a ticket under the 'Technical Support' category, and the support team will assist you."
    },
  ];

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context,listen:false);

    return Scaffold(
      backgroundColor: themeProvider.themeData.brightness == Brightness.light
          ? const Color.fromARGB(255, 246, 244, 244)
          : Color(0xFF1C1F26),
      appBar: AppBar(
        title: Text(
          "FAQs",
          style: TextStyle(
            color: themeProvider.themeData.brightness == Brightness.light
                ? Colors.white
                : Color(0xFF57C9E7),
          ),
        ),
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
        ),
      ),
      body: Container(
        color: themeProvider.themeData.brightness == Brightness.light
            ? const Color.fromARGB(255, 246, 244, 244)
            : Color(0xFF1C1F26),
        padding: EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: faqs.length,
          itemBuilder: (context, index) {
            return Card(
              margin: EdgeInsets.symmetric(vertical: 8.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              elevation: 4,
              child: ExpansionTile(
                collapsedBackgroundColor:
                    themeProvider.themeData.brightness == Brightness.light
                        ? Colors.indigo.shade900
                        : Color(0xFF57C9E7),
                backgroundColor:
                    themeProvider.themeData.brightness == Brightness.light
                        ? Colors.indigo.shade900
                        : Color(0xFF57C9E7),
                iconColor: Colors.white,
                collapsedIconColor: Colors.white,
                textColor: Colors.white,
                collapsedTextColor: Colors.white,
                title: Text(
                  faqs[index]['question']!,
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                children: [
                  Container(
                    color: Colors.white,
                    padding: EdgeInsets.all(12.0),
                    child: Text(
                      faqs[index]['answer']!,
                      style: TextStyle(
                        fontSize: 14.0,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
