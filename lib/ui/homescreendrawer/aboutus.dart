import 'package:dass/colortheme/theme_maneger.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AboutPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Fetch the themeProvider once and pass it to helper methods
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);

    return Scaffold(
      backgroundColor: themeProvider.themeData.brightness == Brightness.light
          ? const Color.fromARGB(255, 246, 244, 244)
          : Color(0xFF1C1F26),
      appBar: AppBar(
        title: Text(
          "About",
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
      ),
      body: SingleChildScrollView(
        child: Container(
          color: themeProvider.themeData.brightness == Brightness.light
              ? const Color.fromARGB(255, 246, 244, 244)
              : Color(0xFF1C1F26),
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "About This App",
                style: TextStyle(
                  color: themeProvider.themeData.brightness == Brightness.light
                      ? Colors.indigo.shade900
                      : Color(0xFF57C9E7),
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16.0),
              Text(
                "Welcome to the Employee Management System, your all-in-one solution for streamlining workplace operations. This app is designed to enhance efficiency and collaboration within your organization by offering the following features:",
                style: TextStyle(
                  fontSize: 16.0,
                  color: themeProvider.themeData.brightness == Brightness.light
                      ? Colors.black87
                      : Colors.white,
                ),
              ),
              SizedBox(height: 16.0),
              _buildFeatureItem(
                themeProvider,
                "Task Management",
                "Assign, track, and complete tasks seamlessly.",
              ),
              _buildFeatureItem(
                themeProvider,
                "Data Logs",
                "Maintain a detailed history of work activities and updates.",
              ),
              _buildFeatureItem(
                themeProvider,
                "Ticket Raising",
                "Quickly report and resolve issues with our efficient ticketing system.",
              ),
              _buildFeatureItem(
                themeProvider,
                "Meetings",
                "Schedule and manage meetings with ease.",
              ),
              _buildFeatureItem(
                themeProvider,
                "Attendance System",
                "Simplify attendance tracking with punch-in and punch-out functionality.",
              ),
              _buildFeatureItem(
                themeProvider,
                "Work Insights",
                "Get comprehensive insights into employee performance and organizational workflow.",
              ),
              SizedBox(height: 16.0),
              Text(
                "Our app is secure, user-friendly, and tailored to meet the diverse needs of employees and managers alike. Experience a new level of productivity and collaboration with the Employee Management System.",
                style: TextStyle(
                  fontSize: 16.0,
                  color: themeProvider.themeData.brightness == Brightness.light
                      ? Colors.black87
                      : Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureItem(
    ThemeProvider themeProvider,
    String title,
    String description,
  ) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.check_circle,
            color: themeProvider.themeData.brightness == Brightness.light
                ? Colors.indigo.shade900
                : Color(0xFF57C9E7),
            size: 20,
          ),
          SizedBox(width: 8.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                    color:
                        themeProvider.themeData.brightness == Brightness.light
                            ? Colors.indigo.shade900
                            : Color(0xFF57C9E7),
                  ),
                ),
                SizedBox(height: 4.0),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 14.0,
                    color:
                        themeProvider.themeData.brightness == Brightness.light
                            ? Colors.black87
                            : Colors.grey,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
