import 'package:dass/colortheme/theme_maneger.dart';
import 'package:dass/webservices/api.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

class AttendanceDetailsScreen extends StatefulWidget {
  final String? name;
  final String? email;

  const AttendanceDetailsScreen(
      {Key? key, required this.email, required this.name})
      : super(key: key);

  @override
  _AttendanceDetailsScreenState createState() =>
      _AttendanceDetailsScreenState();
}

class _AttendanceDetailsScreenState extends State<AttendanceDetailsScreen> {
  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();
  Map<String, dynamic>? attendanceData;
  bool isLoading = false;

  Future<void> fetchAttendanceData() async {
    if (widget.email == null) {
      setState(() {
        attendanceData = null;
        isLoading = false;
      });
      return;
    }

    setState(() {
      isLoading = true;
    });

    final formattedDate = DateFormat('yyyy-MM-dd').format(_selectedDay);
    try {
      final data =
          await ApiService.getAttendanceDetails(widget.email!, formattedDate);
      setState(() {
        // Assuming the response is a list, get the first item in the list
        attendanceData = data?.isNotEmpty == true ? data![0].toJson() : null;
      });
    } catch (e) {
      setState(() {
        attendanceData = null;
      });
      debugPrint('Error fetching attendance data: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    fetchAttendanceData();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final theme = themeProvider.themeData;
    return Scaffold(
      backgroundColor: themeProvider.themeData.brightness == Brightness.light
          ? Colors.white
          : Color(0xFF1C1F26),
      appBar: AppBar(
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
        iconTheme: IconThemeData(
          color: themeProvider.themeData.brightness == Brightness.light
              ? Colors.white
              : Color(0xFF57C9E7),
        ),
        title: Text(
          "Attendance Details",
          style: TextStyle(
            color: themeProvider.themeData.brightness == Brightness.light
                ? Colors.white
                : Color(0xFF57C9E7),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),

              // Calendar
              Text("Select a Date:",
                  style: TextStyle(
                    fontSize: 18,
                    color:
                        themeProvider.themeData.brightness == Brightness.light
                            ? Colors.black
                            : Colors.white,
                  )),
              const SizedBox(height: 8),
              TableCalendar(
                calendarStyle: CalendarStyle(
                  todayTextStyle: TextStyle(
                      fontSize: 14,
                      color:
                          themeProvider.themeData.brightness == Brightness.light
                              ? Colors.white
                              : Colors.black),
                  weekendTextStyle: TextStyle(
                    fontSize: 14,
                    color:
                        themeProvider.themeData.brightness == Brightness.light
                            ? Colors.red
                            : Colors.orange,
                  ),
                  outsideTextStyle: TextStyle(
                      fontSize: 14,
                      color:
                          themeProvider.themeData.brightness == Brightness.light
                              ? Colors.black.withOpacity(0.5)
                              : Colors.white.withOpacity(0.5)),
                  defaultTextStyle: TextStyle(
                      fontSize: 14,
                      color:
                          themeProvider.themeData.brightness == Brightness.light
                              ? Colors.black
                              : Colors.white),
                ),
                headerStyle: HeaderStyle(
                  titleCentered: true,
                  titleTextFormatter: (date, locale) =>
                      DateFormat.yMMM(locale).format(date),
                  formatButtonVisible: false,
                  titleTextStyle: TextStyle(
                      fontSize: 16,
                      color:
                          themeProvider.themeData.brightness == Brightness.light
                              ? Colors.black
                              : Colors.white),
                ),
                rowHeight: MediaQuery.of(context).size.height * 0.05,
                firstDay: DateTime.utc(2010, 10, 16),
                lastDay: DateTime.utc(2030, 3, 14),
                focusedDay: _focusedDay,
                selectedDayPredicate: (day) => isSameDay(day, _selectedDay),
                onDaySelected: (selectedDay, focusedDay) {
                  if (!isSameDay(_selectedDay, selectedDay)) {
                    setState(() {
                      _selectedDay = selectedDay;
                      _focusedDay = focusedDay;
                    });
                    fetchAttendanceData();
                  }
                },
              ),

              const SizedBox(height: 16),

              // Date-wise Attendance Details
              if (isLoading)
                Center(
                    child: CircularProgressIndicator(
                  color: themeProvider.themeData.brightness == Brightness.light
                      ? Colors.indigo.shade900
                      : Color(0xFF57C9E7),
                ))
              else if (attendanceData != null)
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                            "Details for ${DateFormat.yMMMd().format(_selectedDay)}",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: themeProvider.themeData.brightness ==
                                      Brightness.light
                                  ? Colors.black
                                  : Color(0xFF57C9E7),
                            )),
                        const SizedBox(height: 15),
                        Text(
                          "Worked Hours: ${attendanceData?["attendance"]?["totalWorkingHours"] ?? 'N/A'}",
                          style: TextStyle(
                            color: themeProvider.themeData.brightness ==
                                    Brightness.light
                                ? Colors.black87
                                : Colors.white70,
                          ),
                        ),
                        Text(
                          "Overtime: ${attendanceData?["attendance"]?["overTime"] ?? 'N/A'}",
                          style: TextStyle(
                            color: themeProvider.themeData.brightness ==
                                    Brightness.light
                                ? Colors.black87
                                : Colors.white70,
                          ),
                        ),
                        Text(
                          "Late Time: ${attendanceData?["attendance"]?["lateTime"] ?? 'N/A'}",
                          style: TextStyle(
                            color: themeProvider.themeData.brightness ==
                                    Brightness.light
                                ? Colors.black87
                                : Colors.white70,
                          ),
                        ),
                        Text(
                          "Punch In Time: ${attendanceData?["attendance"]?["punchInTime"] ?? 'N/A'}",
                          style: TextStyle(
                            color: themeProvider.themeData.brightness ==
                                    Brightness.light
                                ? Colors.black87
                                : Colors.white70,
                          ),
                        ),
                        Text(
                          "Punch Out Time: ${attendanceData?["attendance"]?["punchOutTime"] ?? 'N/A'}",
                          style: TextStyle(
                            color: themeProvider.themeData.brightness ==
                                    Brightness.light
                                ? Colors.black87
                                : Colors.white70,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              else
                Center(
                    child: Text(
                  "No data available for the selected date.",
                  style: TextStyle(
                    color:
                        themeProvider.themeData.brightness == Brightness.light
                            ? Colors.black87
                            : Colors.white70,
                  ),
                )),
            ],
          ),
        ),
      ),
    );
  }
}
