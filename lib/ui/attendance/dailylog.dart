import 'package:dass/colortheme/theme_maneger.dart';
import 'package:dass/screens/daily_log_model.dart';
import 'package:dass/webservices/api.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class DailyLogScreen extends StatefulWidget {
  final String? name;
  final String? email;

  DailyLogScreen({Key? key, this.name, this.email}) : super(key: key);

  @override
  State<DailyLogScreen> createState() => _DailyLogScreenState();
}

class _DailyLogScreenState extends State<DailyLogScreen> {
  late Future<DailyLogModel?> dailyLog;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    dailyLog = fetchDailyLog(); // Fetch data on initialization
  }

  Future<DailyLogModel?> fetchDailyLog() async {
    setState(() {
      isLoading = true;
    });

    try {
      final String todayDate = DateFormat('yyyy-MM-dd').format(DateTime.now());

      print(
          "Fetching attendance with email: ${widget.email} and date: $todayDate");

      final result =
          await ApiService.getDailyLog(widget.email ?? '', todayDate, context);

      return result;
    } catch (e, stackTrace) {
      print("Error fetching logs: $e");
      print("Stack Trace: $stackTrace");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
    return null;
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
        title: Text(
          "Daily Log",
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
        elevation: 0,
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(
              color: themeProvider.themeData.brightness == Brightness.light
                  ? Colors.indigo.shade900
                  : Color(0xFF57C9E7),
            ))
          : FutureBuilder<DailyLogModel?>(
              future: dailyLog,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                      child: CircularProgressIndicator(
                    color:
                        themeProvider.themeData.brightness == Brightness.light
                            ? Colors.indigo.shade900
                            : Color(0xFF57C9E7),
                  ));
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      "Error fetching data. Please try again.",
                      style: TextStyle(
                        color: theme.colorScheme.error,
                      ),
                    ),
                  );
                } else if (!snapshot.hasData ||
                    snapshot.data?.attendance == null) {
                  return Center(
                    child: Text(
                      "No logs available for today.",
                      style: TextStyle(
                        color: theme.colorScheme.onBackground,
                      ),
                    ),
                  );
                }

                final attendance = snapshot.data!.attendance;

                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Container(
                    height: 400,
                    child: Card(
                      color: theme.cardColor,
                      elevation: 4,
                      margin: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                CircleAvatar(
                                  backgroundColor:
                                      themeProvider.themeData.brightness ==
                                              Brightness.light
                                          ? Colors.indigo.shade900
                                          : Color(0xFF57C9E7),
                                  child: Text(
                                    attendance?.name?.substring(0, 1) ?? 'U',
                                    style: TextStyle(
                                      color: theme.colorScheme.onPrimary,
                                    ),
                                  ),
                                ),
                                SizedBox(width: 15),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      attendance?.name ?? "User Name",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20,
                                        color: theme.colorScheme.onSurface,
                                      ),
                                    ),
                                    SizedBox(height: 5),
                                    Text(
                                      attendance?.email ?? "No Email Available",
                                      style: TextStyle(
                                        color:
                                            theme.colorScheme.onSurfaceVariant,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            SizedBox(height: 25),
                            _buildRow(
                              "Punched In:",
                              _formatDateTime(attendance?.punchInTime),
                              theme,
                            ),
                            _buildRow(
                              "Punched Out:",
                              _formatDateTime(attendance?.punchOutTime),
                              theme,
                            ),
                            _buildRow(
                              "Total Hours:",
                              attendance?.totalWorkingHours?.toString() ??
                                  "N/A",
                              theme,
                            ),
                            _buildRow(
                              "Break Time:",
                              attendance?.teaStartTime ?? "N/A",
                              theme,
                            ),
                            _buildRow(
                              "Overtime:",
                              attendance?.overTime?.toString() ?? "N/A",
                              theme,
                            ),
                            _buildRow(
                              "Late Time:",
                              attendance?.lateTime?.toString() ?? "N/A",
                              theme,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }

  Widget _buildRow(String label, String value, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Row(
        children: [
          Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onSurface,
            ),
          ),
          SizedBox(width: 8),
          Text(
            value,
            style: TextStyle(color: theme.colorScheme.onSurfaceVariant),
          ),
        ],
      ),
    );
  }
}

String _formatDateTime(String? isoDate) {
  if (isoDate == null || isoDate.isEmpty) {
    return "No Date Available";
  }

  try {
    // Parse the ISO string to DateTime
    DateTime dateTime = DateTime.parse(isoDate);

    // Format the date and time using intl
    String formattedDate = DateFormat('dd MMM yyyy, hh:mm a').format(dateTime);
    return formattedDate;
  } catch (e) {
    return "Invalid Date Format";
  }
}
