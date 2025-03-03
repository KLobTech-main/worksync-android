import 'package:dass/colortheme/theme_maneger.dart';
import 'package:dass/modal/timelogmodelnew.dart';
import 'package:dass/webservices/api.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Dashboard extends StatefulWidget {
  final String? name;
  final String? email;

  Dashboard({
    Key? key,
    this.name,
    this.email,
  }) : super(key: key);
  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  bool isLoading = true;
  TimeLogModelNew? timeLogData;
  bool hasPunchedIn = false;
  bool isPunchInLoading = false;
  bool isPunchOutLoading = false;
  bool isTeaBreakActive = false;
  bool isPunchOutActive = false;
  bool isPunchInActive = false;
  bool isTeaBreakLoading = false;
  bool isLunchBreakActive = false;
  bool isLunchBreakLoading = false;

  String? punchInTime;
  String? punchOutTime;
  //bool isLoading = false;
  String? lateMessage;

  DateTime? teaStartTime;
  DateTime? teaEndTime;
  String? lunchStartTime;
  String? lunchEndTime;

  String? name;
  String? email;
  String? date;
  String? punchInId;
  String? year;
  String? month;
  @override
  void initState() {
    super.initState();
    // _loadUserData();
    //checkAttendanceStatus();

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

  // Fetch Time Log API
  Future<void> fetchTimeLog(String email, String year, String month) async {
    try {
      setState(() {
        isLoading = true;
      });

      final result = await ApiService.getTimeLog(email, year, month, context);

      setState(() {
        isLoading = false;
        timeLogData = result; // Assign the TimeLogModel object to timeLogData
      });
    } catch (e) {
      isLoading = false;
      // timeLogData = null;

      print('Error: $e');
    }
    debugPrint("timeLogData: $timeLogData");
  }

  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    print(timeLogData?.totalWorkedHours ?? 0);
    return Scaffold(
        backgroundColor: themeProvider.themeData.brightness == Brightness.light
            ? Colors.white
            : Color(0xFF1C1F26),
        // backgroundColor: Colors.grey.shade900,
        appBar: AppBar(
          title: Text('TimeLog',
              style: TextStyle(
                color: themeProvider.themeData.brightness == Brightness.light
                    ? Colors.white
                    : Color(0xFF57C9E7),
              )),
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
          ), // Adjust icon color for dark theme

          elevation: 0,
        ),
        body: isLoading
            ? Center(
                child: CircularProgressIndicator(
                color: themeProvider.themeData.brightness == Brightness.light
                    ? Colors.indigo.shade900
                    : Color(0xFF57C9E7),
              ))
            : SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 20.0),
                        // Time Log Container
                        Container(
                          decoration: BoxDecoration(
                            color: themeProvider.themeData.brightness ==
                                    Brightness.light
                                ? Colors.white
                                : Color.fromARGB(255, 24, 28, 37),
                            //  border: Border.all(color: Colors.black),
                            borderRadius: BorderRadius.circular(8.0),
                            boxShadow: [
                              BoxShadow(
                                color: themeProvider.themeData.brightness ==
                                        Brightness.light
                                    ? Colors.grey.withOpacity(0.5)
                                    : Colors.black.withOpacity(0.3),
                                spreadRadius: 2,
                                blurRadius: 5,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Center(
                                  child: Text(
                                    'Time Log',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20.0,
                                      color: themeProvider
                                                  .themeData.brightness ==
                                              Brightness.light
                                          ? Colors.black
                                          : Color(
                                              0xFF57C9E7), // title color based on theme
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 16.0),
                                Column(
                                  children: [
                                    Text(
                                      "Today",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18.0,
                                          color: themeProvider
                                                      .themeData.brightness ==
                                                  Brightness.light
                                              ? Colors.black
                                              : Colors.white),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 13.0),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      children: [
                                        Text(
                                          '9:00',
                                          style: TextStyle(
                                              fontSize: 16.0,
                                              color: themeProvider.themeData
                                                          .brightness ==
                                                      Brightness.light
                                                  ? Colors.black
                                                  : Colors.white),
                                        ),
                                        Text(
                                          'Schedule',
                                          style: TextStyle(
                                              color: themeProvider.themeData
                                                          .brightness ==
                                                      Brightness.light
                                                  ? Colors.black
                                                  : Colors.grey),
                                        ),
                                      ],
                                    ),
                                    Column(
                                      children: [
                                        Text(
                                          '${timeLogData?.totalWorkedHours ?? 0} h',
                                          style: TextStyle(
                                              fontSize: 16.0,
                                              color: themeProvider.themeData
                                                          .brightness ==
                                                      Brightness.light
                                                  ? Colors.black
                                                  : Colors.white),
                                        ),
                                        Text(
                                          'Worked',
                                          style: TextStyle(
                                              color: themeProvider.themeData
                                                          .brightness ==
                                                      Brightness.light
                                                  ? Colors.black
                                                  : Colors.grey),
                                        ),
                                      ],
                                    ),
                                    Column(
                                      children: [
                                        Text(
                                          '${timeLogData?.totalBreakMinutes ?? 0} m',
                                          style: TextStyle(
                                              fontSize: 16.0,
                                              color: themeProvider.themeData
                                                          .brightness ==
                                                      Brightness.light
                                                  ? Colors.black
                                                  : Colors.white),
                                        ),
                                        Text(
                                          'Break',
                                          style: TextStyle(
                                              color: themeProvider.themeData
                                                          .brightness ==
                                                      Brightness.light
                                                  ? Colors.black
                                                  : Colors.grey),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 25.0),
                                Text(
                                  'This Month',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: themeProvider.themeData.brightness ==
                                            Brightness.light
                                        ? Colors.black
                                        : Colors
                                            .white, // subtitle color based on theme
                                  ),
                                ),
                                const SizedBox(height: 20.0),
                                Row(
                                  children: [
                                    Container(
                                      height: 50,
                                      width: 50,
                                      decoration: BoxDecoration(
                                        color: themeProvider
                                                    .themeData.brightness ==
                                                Brightness.light
                                            ? Colors.blue
                                            : Colors.blue[700],
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                        boxShadow: [
                                          BoxShadow(
                                            color: themeProvider
                                                        .themeData.brightness ==
                                                    Brightness.light
                                                ? Colors.grey.withOpacity(0.5)
                                                : Colors.black.withOpacity(0.3),
                                            spreadRadius: 2,
                                            blurRadius: 5,
                                            offset: const Offset(0, 3),
                                          ),
                                        ],
                                      ),
                                      child: const Icon(
                                        Icons.schedule,
                                        color: Colors.white,
                                      ),
                                    ),
                                    const SizedBox(width: 14.0),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          '234 h',
                                          style: TextStyle(
                                              fontSize: 16.0,
                                              color: themeProvider.themeData
                                                          .brightness ==
                                                      Brightness.light
                                                  ? Colors.black
                                                  : Colors.white),
                                        ),
                                        Text(
                                          "Total scheduled time",
                                          style: TextStyle(color: Colors.grey),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 20.0),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Total Worked  ${timeLogData?.totalWorkedHours ?? 0}h',
                                      style: TextStyle(
                                          fontSize: 16.0,
                                          color: themeProvider
                                                      .themeData.brightness ==
                                                  Brightness.light
                                              ? Colors.black
                                              : Colors.white),
                                    ),
                                    const SizedBox(height: 8.0),
                                    LinearProgressIndicator(
                                      value:
                                          (timeLogData?.totalWorkedHours ?? 0) /
                                              234.0,
                                      backgroundColor: themeProvider
                                                  .themeData.brightness ==
                                              Brightness.light
                                          ? Colors.grey[300]
                                          : Colors.grey[
                                              700], // background progress color based on theme
                                      color:
                                          themeProvider.themeData.brightness ==
                                                  Brightness.light
                                              ? Colors.green
                                              : Colors.green[300],
                                      minHeight: 8.0,
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(10)),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 20.0),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Late Time  ${((timeLogData?.totalLateMinutes ?? 0) / 60).toStringAsFixed(1)} h',
                                      style: TextStyle(
                                          color: themeProvider
                                                      .themeData.brightness ==
                                                  Brightness.light
                                              ? Colors.black
                                              : Colors.white),
                                    ),
                                    SizedBox(height: 8.0),
                                    LinearProgressIndicator(
                                      value:
                                          (timeLogData?.totalLateMinutes ?? 0) /
                                              60 /
                                              234,
                                      backgroundColor: themeProvider
                                                  .themeData.brightness ==
                                              Brightness.light
                                          ? Colors.grey[300]
                                          : Colors.grey[
                                              700], // background progress color based on theme
                                      color: Colors.red,
                                      minHeight: 8.0,
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(10)),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 20.0),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'OverTime   ${(timeLogData?.totalOvertimeMinutes ?? 0) / 60} h ',
                                      style: TextStyle(
                                          color: themeProvider
                                                      .themeData.brightness ==
                                                  Brightness.light
                                              ? Colors.black
                                              : Colors.white),
                                    ),
                                    LinearProgressIndicator(
                                      value:
                                          (timeLogData?.totalOvertimeMinutes ??
                                                  0) /
                                              60 /
                                              234.0,
                                      backgroundColor: themeProvider
                                                  .themeData.brightness ==
                                              Brightness.light
                                          ? Colors.grey[300]
                                          : Colors.grey[
                                              700], // background progress color based on theme
                                      color: Colors.red,
                                      minHeight: 8.0,
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(10)),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ]),
                ),
                //),
              ));
  }

  Widget buildTimeLogUI() {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: themeProvider.themeData.brightness == Brightness.light
            ? Colors.white
            : Colors.grey[800],
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: [
          BoxShadow(
            color: themeProvider.themeData.brightness == Brightness.light
                ? Colors.grey.withOpacity(0.5)
                : Colors.black.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Center(
            child: Text(
              'Time Log',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20.0,
              ),
            ),
          ),
          const SizedBox(height: 20),
          _buildStats(),
        ],
      ),
    );
  }

  Widget _buildStats() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Total Stats',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        const SizedBox(height: 10),
        _buildStatItem(
          "Total Late Minutes",
          '${timeLogData!.totalLateMinutes} minutes',
        ),
        const SizedBox(height: 10),
        _buildStatItem(
          "Total Overtime Minutes",
          '${timeLogData!.totalOvertimeMinutes} minutes',
        ),
        const SizedBox(height: 10),
        _buildStatItem(
          "Total Break Minutes",
          '${timeLogData!.totalBreakMinutes} minutes',
        ),
        const SizedBox(height: 10),
        _buildStatItem(
          "Total Worked Hours",
          '${timeLogData!.totalWorkedHours} hours',
        ),
      ],
    );
  }

  Widget _buildStatItem(String title, String value) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: themeProvider.themeData.brightness == Brightness.light
            ? Colors.grey.withOpacity(0.5)
            : Colors.black.withOpacity(0.3),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
          Text(
            value,
            style: TextStyle(
              color: themeProvider.themeData.brightness == Brightness.light
                  ? Colors.black87
                  : Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}

class IconButtonWidget extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color iconColor;

  const IconButtonWidget({
    Key? key,
    required this.icon,
    required this.label,
    required this.iconColor,
    required List<BoxShadow> boxShadow,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: themeProvider.themeData.brightness == Brightness.light
                ? Colors.white
                : Colors.grey[800],
            //  border: Border.all(color: Colors.black),
            borderRadius: BorderRadius.circular(8.0),
            boxShadow: [
              BoxShadow(
                color: themeProvider.themeData.brightness == Brightness.light
                    ? Colors.grey.withOpacity(0.5)
                    : Colors.black.withOpacity(0.3),
                spreadRadius: 2,
                blurRadius: 5,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Icon(
            icon,
            size: 32.0,
            color: iconColor,
          ),
        ),
        const SizedBox(height: 8.0),
        Text(
          label,
          style: TextStyle(
            color: themeProvider.themeData.brightness == Brightness.light
                ? Colors.black87
                : Colors.white, // text color based on theme
          ),
        )
      ],
    );
  }
}
