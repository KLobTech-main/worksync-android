import 'package:dass/colortheme/theme_maneger.dart';
import 'package:dass/modal/timelogmodelnew.dart';
import 'package:dass/ui/attendance/attendance_request.dart';
import 'package:dass/ui/attendance/attendance_summary.dart';
import 'package:dass/ui/attendance/attendencedetail.dart';
import 'package:dass/ui/attendance/dailylog.dart';
import 'package:dass/webservices/api.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Attendance extends StatefulWidget {
  final String? name;
  final String? email;

  Attendance({Key? key, this.name, this.email}) : super(key: key);
  @override
  State<Attendance> createState() => _AttendanceState();
}

class _AttendanceState extends State<Attendance> {
  bool isLoading = true;
  TimeLogModelNew? timeLogData;
  String? year;
  String? month;
  String? email;
  @override
  void initState() {
    super.initState();

    // Use the actual email from the widget, not a hardcoded string
    String email = widget.email!; // Accessing widget property for dynamic email
    String year = DateTime.now().year.toString();
    String month = DateTime.now()
        .month
        .toString()
        .padLeft(2, '0'); // Ensures two digits for month

    // Fetch the time log
    fetchTimeLog(email, year, month);
  }

  Future<void> fetchTimeLog(String email, String year, String month) async {
    try {
      if (!mounted)
        return; // Ensure the widget is still in the widget tree before calling setState
      setState(() {
        isLoading = true;
      });

      final result = await ApiService.getTimeLog(email, year, month);

      if (!mounted)
        return; // Ensure the widget is still in the widget tree before calling setState
      setState(() {
        isLoading = false;
        timeLogData = result; // Assign the TimeLogModel object to timeLogData
      });
    } catch (e) {
      if (!mounted)
        return; // Ensure the widget is still in the widget tree before calling setState
      setState(() {
        isLoading = false;
        // timeLogData = null;
      });
      print('Error: $e');
    }
    debugPrint("timeLogData: $timeLogData");
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      backgroundColor: themeProvider.themeData.brightness == Brightness.light
          ? const Color.fromARGB(255, 246, 244, 244)
          : Color(0xFF1C1F26),
      appBar: AppBar(
        title: Text(
          "Attendance",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
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
              : Color(0xFF57C9E7), // Adjust icon color for dark theme
        ),
        elevation: 0,
      ),
      // actions: [
      //   Padding(
      //     padding: const EdgeInsets.all(8.0),
      //     child: CircleAvatar(
      //       backgroundImage: NetworkImage(
      //           'https://www.w3schools.com/w3images/avatar2.png'), // Profile picture
      //     ),
      //   ),
      // ],

      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Welcome Section
            Container(
              height: 70,
              width: double.infinity,
              decoration: BoxDecoration(
                color: themeProvider.themeData.brightness == Brightness.light
                    ? Colors.white
                    : Color.fromARGB(255, 21, 24, 30),
                borderRadius: BorderRadius.circular(8.0),
                boxShadow: [
                  BoxShadow(
                    color: themeProvider.themeData.brightness ==
                            Brightness.light
                        ? Colors.grey.withOpacity(0.5)
                        : const Color.fromARGB(255, 0, 0, 0).withOpacity(0.3),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildSummaryItem(
                    "234:00:00",
                    "Total schedule hour",
                  ),
                  _buildSummaryItem("  ${timeLogData?.totalWorkedHours ?? 0} h",
                      "Total active hour"),
                ],
              ),
            ),
            SizedBox(height: 20),

            // House Icon
            Center(
              child: Icon(
                Icons.calendar_month,
                size: 150,
                color: themeProvider.themeData.brightness == Brightness.light
                    ? Colors.grey
                    : Color.fromARGB(
                        255, 21, 24, 30), // Theme-based color with opacity
              ),
            ),

            SizedBox(height: 20),

            // Employee Attendance Title
            Text(
              "Employee Attendance",
              style: TextStyle(
                  fontSize: 20,
                  //  fontWeight: FontWeight.bold,
                  color: themeProvider.themeData.brightness == Brightness.light
                      ? Colors.black
                      : Color(0xFF57C9E7)),
            ),

            SizedBox(height: 10),

            // Grid of Cards
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                children: [
                  _buildSmartDeviceCard(
                    context,
                    "Daily Log",
                    Icons.assignment,
                    () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DailyLogScreen(
                            name: widget.name,
                            email: widget.email,
                          ),
                        ),
                      );
                      debugPrint("name : ${widget.name}");
                      debugPrint("email : ${widget.email}");
                    },
                  ),
                  _buildSmartDeviceCard(
                    context,
                    "Attendance Request",
                    Icons.request_quote,

                    () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AttendanceRequest(
                            name: widget.name,
                            email: widget.email,
                          ),
                        ),
                      );
                      debugPrint("name : ${widget.name}");
                      debugPrint("email : ${widget.email}");
                    }, // Add navigation for this card if needed
                  ),
                  _buildSmartDeviceCard(
                    context,
                    "Attendance Details",
                    Icons.fact_check,

                    () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AttendanceDetailsScreen(
                            name: widget.name,
                            email: widget.email,
                          ),
                        ),
                      );
                      debugPrint("name : ${widget.name}");
                      debugPrint("email : ${widget.email}");
                    }, // Add navigation for this card if needed
                  ),
                  _buildSmartDeviceCard(
                    context,
                    "Summary",
                    Icons.summarize,

                    () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AttendanceSummaryScreen(
                                  name: widget.name,
                                  email: widget.email,
                                )),
                      );
                      debugPrint("name : ${widget.name}");
                      debugPrint("email : ${widget.email}");
                    }, // Add navigation for this card if needed
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryItem(String value, String label) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: themeProvider.themeData.brightness == Brightness.light
                  ? Colors.black
                  : Colors.white, // Use theme color for value
            ),
          ),
          Text(
            label,
            style: TextStyle(
              fontSize: 15,
              color: themeProvider.themeData.brightness == Brightness.light
                  ? Colors.black54
                  : Colors.grey, // Use theme color for label
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSmartDeviceCard(
    BuildContext context,
    String title,
    IconData icon,
    VoidCallback onTap,
  ) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    // Default color setup for containers
    Color containerColor = Colors.transparent;
    Gradient containerGradient = LinearGradient(
      colors: [Colors.transparent, Colors.transparent],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );

    if (themeProvider.themeData.brightness == Brightness.light) {
      // Set gradient for "Daily Log" and "Summary"
      if (title == "Daily Log" || title == "Summary") {
        containerGradient = LinearGradient(
          colors: [Colors.indigo.shade300, Colors.indigo.shade900],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      } else if (title == "Attendance Request" ||
          title == "Attendance Details") {
        // Set grey color for "Attendance Request" and "Attendance Details"
        containerColor = Colors.grey.shade400;
      }
    } else {
      // Set color for dark theme
      containerColor = const Color.fromARGB(255, 0, 0, 0).withOpacity(0.3);
    }

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: containerGradient.colors.first != Colors.transparent
            ? BoxDecoration(
                gradient: containerGradient,
                borderRadius: BorderRadius.circular(12))
            : BoxDecoration(
                color: containerColor,
                borderRadius: BorderRadius.circular(12),
              ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 40,
                color: themeProvider.themeData.brightness == Brightness.light
                    ? (title == "Attendance Request" ||
                            title == "Attendance Details"
                        ? Colors.black
                        : Colors.white)
                    : Color(0xFF57C9E7),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    //fontWeight: FontWeight.bold,
                    color:
                        themeProvider.themeData.brightness == Brightness.light
                            ? (title == "Attendance Request" ||
                                    title == "Attendance Details"
                                ? Colors.black
                                : Colors.white)
                            : Colors.white, // Ensure white text for dark theme
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
