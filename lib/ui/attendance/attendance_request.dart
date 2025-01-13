import 'package:dass/colortheme/theme_maneger.dart';
import 'package:dass/webservices/api.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class AttendanceRequest extends StatefulWidget {
  final String? name;
  final String? email;

  AttendanceRequest({Key? key, this.name, this.email}) : super(key: key);

  @override
  _AttendanceRequestState createState() => _AttendanceRequestState();
}

class _AttendanceRequestState extends State<AttendanceRequest> {
  DateTime? startDate;
  DateTime? endDate;
  List<Map<String, dynamic>> attendanceData = [];
  bool isLoading = false;

  // Fetch attendance data
  Future<void> fetchAttendanceRequestData() async {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    if (startDate == null || endDate == null) {
      Fluttertoast.showToast(
        msg: "Please select both start and end dates.",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: themeProvider.themeData.brightness == Brightness.light
            ? Colors.indigo.shade900
            : Color(0xFF57C9E7),
        textColor: Colors.white,
        fontSize: 16.0,
      );

      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      final formattedStartDate = DateFormat('yyyy-MM-dd').format(startDate!);
      final formattedEndDate = DateFormat('yyyy-MM-dd').format(endDate!);

      // Ensure email is not null
      if (widget.email == null) {
        throw Exception("Email is required for fetching attendance.");
      }

      final responseData = await ApiService.getAttendanceRequest(
        widget.email!,
        formattedStartDate,
        formattedEndDate,
      );

      setState(() {
        attendanceData = responseData.map((e) => e.toJson()).toList();
      });
    } catch (e) {
      Fluttertoast.showToast(
        msg: "Failed to load attendance data.",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
      print("Error: $e");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _selectStartDate(BuildContext context) async {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
      builder: (context, child) {
        return Theme(
          data: themeProvider.themeData.copyWith(
            dialogBackgroundColor:
                themeProvider.themeData.brightness == Brightness.dark
                    ? Colors.grey.shade900
                    : Colors.white,
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor:
                    themeProvider.themeData.brightness == Brightness.dark
                        ? Colors.white
                        : Colors.indigo.shade900,
              ),
            ),
            colorScheme: themeProvider.themeData.colorScheme.copyWith(
              primary: themeProvider.themeData.brightness == Brightness.dark
                  ? Color(0xFF57C9E7)
                  : Colors.indigo.shade900,
              surface: themeProvider.themeData.brightness == Brightness.dark
                  ? Colors.grey.shade900
                  : Colors.white,
              onSurface: themeProvider.themeData.brightness == Brightness.dark
                  ? Colors.white
                  : Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        startDate = picked;
        // Reset the end date when the start date is changed
        endDate = null;
      });
    }
  }

  Future<void> _selectEndDate(BuildContext context) async {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    if (startDate == null) {
      Fluttertoast.showToast(
        msg: "Please select start date first.",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: themeProvider.themeData.brightness == Brightness.light
            ? Colors.indigo.shade900
            : Color(0xFF57C9E7),
        textColor: Colors.white,
        fontSize: 16.0,
      );
      return;
    }

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: startDate!,
      firstDate: startDate!, // Make sure the end date is after the start date
      lastDate: DateTime(2101),
      builder: (context, child) {
        return Theme(
          data: themeProvider.themeData.copyWith(
            dialogBackgroundColor:
                themeProvider.themeData.brightness == Brightness.dark
                    ? Colors.grey.shade900
                    : Colors.white,
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor:
                    themeProvider.themeData.brightness == Brightness.dark
                        ? Colors.white
                        : Colors.indigo.shade900,
              ),
            ),
            colorScheme: themeProvider.themeData.colorScheme.copyWith(
              primary: themeProvider.themeData.brightness == Brightness.dark
                  ? Color(0xFF57C9E7)
                  : Colors.indigo.shade900,
              surface: themeProvider.themeData.brightness == Brightness.dark
                  ? Colors.grey.shade900
                  : Colors.white,
              onSurface: themeProvider.themeData.brightness == Brightness.dark
                  ? Colors.white
                  : Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        endDate = picked;
      });
    }
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
          "Attendance Request",
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
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: themeProvider.themeData.brightness == Brightness.light
                ? Colors.white
                : Color(0xFF57C9E7),
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  children: [
                    _buildDatePicker(
                        "Start Date", true, context, themeProvider),
                    SizedBox(width: 12),
                    _buildDatePicker("End Date", false, context, themeProvider),
                    SizedBox(width: 12),
                    Padding(
                      padding: const EdgeInsets.only(top: 26),
                      child: ElevatedButton(
                        onPressed:
                            fetchAttendanceRequestData as void Function()?,
                        style: ElevatedButton.styleFrom(
                          shape: CircleBorder(),
                          padding: EdgeInsets.all(8),
                          backgroundColor: themeProvider.themeData.brightness ==
                                  Brightness.light
                              ? Colors.indigo.shade900
                              : Color(0xFF57C9E7),
                        ),
                        child: Icon(Icons.arrow_forward,
                            color: themeProvider.themeData.brightness ==
                                    Brightness.light
                                ? Colors.white
                                : Colors.white),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                Expanded(
                  child: attendanceData.isNotEmpty
                      ? ListView.builder(
                          itemCount: attendanceData.length,
                          itemBuilder: (context, index) {
                            final record = attendanceData[index];
                            final date = DateTime.parse(record['date']);
                            return Card(
                              elevation: 4,
                              color: themeProvider.themeData.brightness ==
                                      Brightness.light
                                  ? Colors.white
                                  : Colors.black,
                              child: ListTile(
                                title: Text(
                                  DateFormat(
                                    'dd MMM yyyy',
                                  ).format(date),
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 17,
                                    color: themeProvider.themeData.brightness ==
                                            Brightness.light
                                        ? Colors.black
                                        : Colors.white,
                                  ),
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Punch In: ${record['punchInTime']}',
                                      style: TextStyle(
                                        color: themeProvider
                                                    .themeData.brightness ==
                                                Brightness.light
                                            ? Colors.black87
                                            : Colors.white70,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      'Punch Out: ${record['punchOutTime']}',
                                      style: TextStyle(
                                        color: themeProvider
                                                    .themeData.brightness ==
                                                Brightness.light
                                            ? Colors.black87
                                            : Colors.white70,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      'Working Hours: ${record['totalWorkingHours']}',
                                      style: TextStyle(
                                        color: themeProvider
                                                    .themeData.brightness ==
                                                Brightness.light
                                            ? Colors.black87
                                            : Colors.white70,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        )
                      : Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.info_outline,
                                  size: 48,
                                  color: themeProvider.themeData.brightness ==
                                          Brightness.light
                                      ? Colors.grey
                                      : Colors.white60),
                              SizedBox(height: 8),
                              Text(
                                "No data available for the selected range.",
                                style: TextStyle(
                                  color: themeProvider.themeData.brightness ==
                                          Brightness.light
                                      ? Colors.grey
                                      : Colors.white70,
                                ),
                              ),
                            ],
                          ),
                        ),
                ),
              ],
            ),
          ),
          if (isLoading)
            Center(
              child: CircularProgressIndicator(
                color: themeProvider.themeData.brightness == Brightness.light
                    ? Colors.indigo.shade900
                    : Color(0xFF57C9E7),
              ),
            ),
        ],
      ),
    );
  }

  Expanded _buildDatePicker(String label, bool isStartDate,
      BuildContext context, ThemeProvider themeProvider) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              color: themeProvider.themeData.brightness == Brightness.light
                  ? Colors.black
                  : Colors.white,
            ),
          ),
          SizedBox(height: 8),
          GestureDetector(
            onTap: () => isStartDate
                ? _selectStartDate(context)
                : _selectEndDate(context),
            child: Container(
              height: 60,
              padding: EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                border: Border.all(
                  color: themeProvider.themeData.brightness == Brightness.light
                      ? Colors.black
                      : Colors.white,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    (isStartDate ? startDate : endDate) != null
                        ? DateFormat('dd MMM yy')
                            .format((isStartDate ? startDate : endDate)!)
                        : label,
                    style: TextStyle(
                      fontSize: 16,
                      color:
                          themeProvider.themeData.brightness == Brightness.light
                              ? Colors.black
                              : Colors.white70,
                    ),
                  ),
                  Icon(
                    Icons.calendar_today,
                    color:
                        themeProvider.themeData.brightness == Brightness.light
                            ? Colors.black
                            : Colors.white,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
