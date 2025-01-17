import 'package:dass/colortheme/theme_maneger.dart';
import 'package:dass/modal/timelogmodelnew.dart';
import 'package:dass/screens/attendance_summary_model.dart';
import 'package:dass/webservices/api.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class AttendanceSummaryScreen extends StatefulWidget {
  final String? name;
  final String? email;

  AttendanceSummaryScreen({Key? key, this.name, this.email}) : super(key: key);
  @override
  _AttendanceSummaryScreenState createState() =>
      _AttendanceSummaryScreenState();
}

class _AttendanceSummaryScreenState extends State<AttendanceSummaryScreen> {
  bool isLoadingSummary = true;
  List<AttendanceSummaryModel> attendanceSummary = [];
  String? email;
  String? year;
  String? month;
  int _currentIndex = 0;
  TimeLogModelNew? timeLogData;
  bool isLoading = true;
  //bool? errorMessage;

  @override
  void initState() {
    super.initState();
    print('Email received: ${widget.email}');
    String email = widget.email!; // Accessing widget property for dynamic email
    String year = DateTime.now().year.toString();
    String month = DateTime.now()
        .month
        .toString()
        .padLeft(2, '0'); // Ensures two digits for month

    // Fetch the time log
    fetchTimeLog(email, year, month);
    fetchAttendanceSummary(email);
  }

  Future<void> fetchAttendanceSummary(email) async {
    try {
      if (email == null || email.isEmpty) {
        print('Error: Email is null or empty.');
        if (mounted) {
          setState(() {
            isLoadingSummary = false;
          });
        }
        return;
      }

      if (mounted) {
        setState(() {
          isLoadingSummary = true;
        });
      }

      final result = await ApiService.getAttendanceSummary(email, context);
      print('Raw API Response: $result'); // Log raw API response

      // Assuming the result is a list of maps
      final parsedData = result
          .map((item) =>
              AttendanceSummaryModel.fromJson(item as Map<String, dynamic>))
          .toList();
      print('Parsed Attendance Data: $parsedData');

      if (mounted) {
        setState(() {
          attendanceSummary = parsedData;
          isLoadingSummary = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          isLoadingSummary = false;
        });
      }
      print('Error fetching attendance summary: $e');
    }
  }

  // Track the current index of the carousel

  Future<void> fetchTimeLog(String email, String year, String month) async {
    try {
      if (!mounted)
        return; // Check if the widget is still mounted before updating state

      setState(() {
        isLoading = true;
      });

      final result = await ApiService.getTimeLog(email, year, month, context);

      if (!mounted)
        return; // Check if the widget is still mounted before updating state

      setState(() {
        isLoading = false;
        timeLogData = result; // Assign the TimeLogModel object to timeLogData
      });
    } catch (e) {
      if (!mounted)
        return; // Check if the widget is still mounted before updating state

      setState(() {
        isLoading = false;
        timeLogData = null;
      });
      print('Error: $e');
    }
    debugPrint("timeLogData: $timeLogData");
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final theme = themeProvider.themeData;
    final totalScheduledMinutes = 234 * 60; // Example: 234 hours scheduled
    final lateMinutes = timeLogData?.totalLateMinutes ?? 0;
    final availableMinutes = totalScheduledMinutes - lateMinutes;
    final workAvailabilityPercentage = totalScheduledMinutes > 0
        ? (availableMinutes / totalScheduledMinutes) * 100
        : 0;
    print(timeLogData?.totalLateMinutes);
    return Scaffold(
      backgroundColor: themeProvider.themeData.brightness == Brightness.light
          ? Colors.white
          : Color(0xFF1C1F26),
      appBar: AppBar(
        backgroundColor: Colors.indigo.shade900,
        iconTheme: IconThemeData(
          color: themeProvider.themeData.brightness == Brightness.light
              ? Colors.white
              : Color(0xFF57C9E7),
        ),
        title: Text(
          'Summary',
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
        elevation: 0,
        // actions: [
        //   IconButton(
        //     icon: Icon(Icons.notifications),
        //     onPressed: () {},
        //   ),
        //   IconButton(
        //     icon: Icon(Icons.account_circle),
        //     onPressed: () {},
        //   ),
        // ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Summary - ${DateTime.now().month} ${DateTime.now().year}',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: themeProvider.themeData.brightness == Brightness.light
                    ? Colors.black
                    : Colors.white,
              ),
            ),
            SizedBox(height: 16),
            Container(
              child: Center(
                child: Wrap(
                  spacing: 10,
                  runSpacing: 8,
                  children: [
                    _buildStatCard(
                      'Total Schedule Hours',
                      '234:00:00',
                    ),
                    _buildStatCard('Leave Hours (Paid)', '00:00:00'),
                    _buildStatCard(
                      'Work Availability',
                      '${workAvailabilityPercentage.toStringAsFixed(2)}%',
                    ),
                    _buildStatCard(
                      'Total Active Hours',
                      '${timeLogData?.totalWorkedHours ?? 0} h',
                    ),
                    _buildStatCard(
                      'Balance (Lack)',
                      '${timeLogData?.totalLateMinutes ?? 0 / 60} ',
                    ),
                    _buildStatCard('Average Behavior',
                        ' ${((timeLogData?.totalLateMinutes ?? 0) / 60).toStringAsFixed(1)} h'),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16),
            SizedBox(
              height: 250,
              child: Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: PieChart(
                      PieChartData(
                        sections: _getPieChartSections(),
                        centerSpaceRadius: 40,
                        sectionsSpace: 4,
                      ),
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    flex: 1,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildLegendItem(Colors.green, 'Regular', '4 Days'),
                        SizedBox(height: 8),
                        _buildLegendItem(Colors.orange, 'Early', '0 Days'),
                        SizedBox(height: 8),
                        _buildLegendItem(Colors.red, 'Late', '25 Days'),
                        SizedBox(height: 8),
                        _buildLegendItem(Colors.purple, 'On Leave', '0 Days'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16),
            // buildWeeklyAttendanceSummary(),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String title, String value) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Card(
      elevation: 2,
      child: LayoutBuilder(
        builder: (context, constraints) {
          // Use MediaQuery to get screen width and adjust accordingly
          double width = constraints.maxWidth;
          double fontSizeTitle =
              width < 350 ? 10 : 12; // Adjust font size for small screens
          double fontSizeValue =
              width < 350 ? 14 : 16; // Adjust font size for small screens

          return Container(
            decoration: BoxDecoration(
              color: themeProvider.themeData.brightness == Brightness.light
                  ? Colors.white
                  : Color.fromARGB(255, 21, 24, 30),
              borderRadius: BorderRadius.circular(8.0),
              boxShadow: [
                BoxShadow(
                  color: themeProvider.themeData.brightness == Brightness.light
                      ? Colors.grey.withOpacity(0.5)
                      : const Color.fromARGB(255, 0, 0, 0).withOpacity(0.3),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            padding: EdgeInsets.all(16),
            width: width * 0.46, // Adjust width to be relative to screen size
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: GoogleFonts.roboto(
                    fontSize: fontSizeValue,
                    fontWeight: FontWeight.bold,
                    color:
                        themeProvider.themeData.brightness == Brightness.light
                            ? Colors.black
                            : Color(0xFF57C9E7),
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  title,
                  style: GoogleFonts.roboto(
                    fontSize: fontSizeTitle,
                    color:
                        themeProvider.themeData.brightness == Brightness.light
                            ? Colors.grey[600]
                            : Colors.grey,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  List<PieChartSectionData> _getPieChartSections() {
    return [
      PieChartSectionData(
        color: Colors.green,
        value: 4,
        title: '4 Days',
        radius: 50,
        titleStyle: TextStyle(
            fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white),
      ),
      PieChartSectionData(
        color: Colors.orange,
        value: 0,
        title: '0 Days',
        radius: 50,
        titleStyle: TextStyle(
            fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white),
      ),
      PieChartSectionData(
        color: Colors.red,
        value: 25,
        title: '25 Days',
        radius: 50,
        titleStyle: TextStyle(
            fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white),
      ),
      PieChartSectionData(
        color: Colors.purple,
        value: 0,
        title: '0 Days',
        radius: 50,
        titleStyle: TextStyle(
            fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white),
      ),
    ];
  }

  Widget buildWeeklyAttendanceSummary() {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Attendance Summary',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 16),
        if (isLoading)
          Center(
              child: CircularProgressIndicator(
            color: themeProvider.themeData.brightness == Brightness.light
                ? Colors.indigo.shade900
                : Color(0xFF57C9E7),
          ))
        else
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Attendance Details",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              ...attendanceSummary.map((data) {
                return Card(
                  margin: EdgeInsets.symmetric(vertical: 8.0),
                  child: Padding(
                    padding: EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Date: ${data.date ?? "-"}",
                          style: TextStyle(
                            fontSize: 14,
                            color: themeProvider.themeData.brightness ==
                                    Brightness.light
                                ? Colors.black87
                                : Colors.white,
                          ),
                        ),
                        Text(
                          "Name: ${data.name ?? "-"}",
                          style: TextStyle(fontSize: 14),
                        ),
                        Text(
                          "Punch In: ${data.punchInTime ?? "-"}",
                          style: TextStyle(fontSize: 14),
                        ),
                        Text(
                          "Punch Out: ${data.punchOutTime ?? "-"}",
                          style: TextStyle(fontSize: 14),
                        ),
                        Text(
                          "Over Time: ${data.overTime ?? 0} hours",
                          style: TextStyle(fontSize: 14),
                        ),
                        Text(
                          "Late Time: ${data.lateTime ?? 0} minutes",
                          style: TextStyle(fontSize: 14),
                        ),
                        Text(
                          "Total Working Hours: ${data.totalWorkingHours ?? 0} hours",
                          style: TextStyle(fontSize: 14),
                        ),
                        Text(
                          "Lunch Time: ${data.lunchStartTime ?? "-"} to ${data.lunchEndTime ?? "-"}",
                          style: TextStyle(fontSize: 14),
                        ),
                        Text(
                          "Tea Time: ${data.teaStartTime ?? "-"} to ${data.teaEndTime ?? "-"}",
                          style: TextStyle(fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ],
          ),
      ],
    );
  }

  Widget _buildLegendItem(Color color, String title, String value) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        SizedBox(width: 10),
        Text(
          '$title: $value',
          style: TextStyle(
            fontSize: 14,
            color: themeProvider.themeData.brightness == Brightness.light
                ? Colors.black
                : Colors.white,
          ),
        ),
      ],
    );
  }
}
