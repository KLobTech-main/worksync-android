import 'dart:convert';

import 'package:dass/colortheme/theme_maneger.dart';
import 'package:dass/modal/timelogmodelnew.dart';
import 'package:dass/webservices/api.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
    _loadUserData();
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

  // @override
  // void didChangeDependencies() {
  //   super.didChangeDependencies();

  //   // Use context-dependent operations here
  //   checkAttendanceStatus();
  // }

  // Future<void> checkAttendanceStatus() async {
  //   print('................................');
  //   try {
  //     final response = await ApiService.getAttendanceStatus(email!);
  //     print("Response: $response");

  //     if (response != null) {
  //       final statusCode = response['statusCode'];
  //       final body = response['body'];

  //       if (statusCode == 200) {
  //         if (body != null && body['punched_in'] == true) {
  //           _showPopup("You already punched in", Colors.green);
  //         } else {
  //           _showPopup("You are not punched in", Colors.red);
  //         }
  //       } else if (statusCode == 404) {
  //         _showPopup("You are not punched in", Colors.red);
  //       } else {
  //         _showPopup("Unexpected response: $statusCode", Colors.orange);
  //       }
  //     } else {
  //       _showPopup("Failed to fetch attendance status", Colors.orange);
  //     }
  //   } catch (e) {
  //     _showPopup("Error connecting to server: $e", Colors.red);
  //   }
  // }

  // void _showPopup(String message, Color color) {
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return AlertDialog(
  //         title: const Text("Attendance Status"),
  //         content: Text(message),
  //         backgroundColor: color.withOpacity(0.2),
  //         actions: [
  //           TextButton(
  //             onPressed: () {
  //               Navigator.of(context).pop();
  //             },
  //             child: const Text("OK"),
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }

  Future<void> _loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userData =
        prefs.getString(widget.email!); // Retrieve user data by email key
    if (userData != null) {
      Map<String, dynamic> data =
          jsonDecode(userData); // Decode the JSON string
      setState(() {
        hasPunchedIn = data['hasPunchedIn'] ?? false; // Load user-specific data
        isTeaBreakActive = data['isTeaBreakActive'] ?? false;
        isLunchBreakActive = data['isLunchBreakActive'] ?? false;
        punchInTime = data['punchInTime'];
        punchInId = data['punchInId'];
        lateMessage = data['lateMessage'];
      });
    }
  }

  Future<void> _saveUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Map<String, dynamic> data = {
      'hasPunchedIn': hasPunchedIn,
      'isTeaBreakActive': isTeaBreakActive,
      'isLunchBreakActive': isLunchBreakActive,
      'punchInTime': punchInTime,
      'punchInId': punchInId,
      'lateMessage': lateMessage,
    };
    await prefs.setString(widget.email!, jsonEncode(data));
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

  Future<void> handlePunchIn() async {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    // Show confirmation dialog before proceeding
    bool? confirmation = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor:
              themeProvider.themeData.brightness == Brightness.light
                  ? Colors.white
                  : Color(0xFF1C1F26),
          title: Text("Confirm Punch In",
              style: TextStyle(
                color: themeProvider.themeData.brightness == Brightness.light
                    ? Colors.black
                    : Colors.white,
              )),
          content: Text("Are you sure you want to punch in?",
              style: TextStyle(
                color: themeProvider.themeData.brightness == Brightness.light
                    ? Colors.black
                    : Colors.white,
              )),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text("Cancel",
                  style: TextStyle(
                    color:
                        themeProvider.themeData.brightness == Brightness.light
                            ? Colors.black
                            : Colors.white,
                  )),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text("Confirm",
                  style: TextStyle(
                    color:
                        themeProvider.themeData.brightness == Brightness.light
                            ? Colors.blue
                            : const Color(0xFF57C9E7),
                  )),
            ),
          ],
        );
      },
    );

    // If user cancels the confirmation, do nothing
    if (confirmation != true) {
      return;
    }

    // Check persistent storage for today's punch-in status
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? lastPunchDateForUser =
        prefs.getString('lastPunchDate_${widget.email}');

    if (lastPunchDateForUser == DateTime.now().toIso8601String()) {
      Fluttertoast.showToast(
        msg: "You have already punched in today.",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
      return;
    }

    setState(() {
      isPunchInLoading = true;
      hasPunchedIn = true;
    });

    // Prepare API payload
    String punchInTime = DateTime.now().toIso8601String();
    String email = widget.email ?? ""; // Ensure email is not null

    Map<String, dynamic> payload = {
      "punchInTime": punchInTime,
      "email": email, // Add email to the payload as required by the API
    };

    print("PunchIn Payload: $payload");

    try {
      // Call the API
      final response =
          await ApiService.punchIn(payload, punchInTime, email, context);

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);

        setState(() {
          isPunchInLoading = false;
          this.punchInTime = punchInTime;
          punchInId = responseData['id'];

          // Store punch-in status with the current date
          prefs.setString(
              'lastPunchDate_$email', DateTime.now().toIso8601String());

          // Check for late punch-in
          DateTime punchInDateTime = DateTime.parse(punchInTime);
          DateTime lateThreshold = DateTime(
            punchInDateTime.year,
            punchInDateTime.month,
            punchInDateTime.day,
            10,
            30,
          );

          if (punchInDateTime.isAfter(lateThreshold)) {
            Duration lateDuration = punchInDateTime.difference(lateThreshold);
            lateMessage =
                "You are late by ${lateDuration.inHours} hours and ${lateDuration.inMinutes % 60} minutes.";
          } else {
            lateMessage = null;
          }
        });

        await _saveUserData();

        // Show success message using Toast
        Fluttertoast.showToast(
          msg: "Punch In Successful!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor:
              themeProvider.themeData.brightness == Brightness.light
                  ? Colors.indigo.shade900 // Default active color in light mode
                  : Color(0xFF57C9E7),
          textColor: Colors.white,
          fontSize: 16.0,
        );
      } else {
        // Handle API error response with Toast
        Fluttertoast.showToast(
          msg: "Failed to Punch In: ${response.body}",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      }
    } catch (e) {
      // Handle exceptions with Toast
      Fluttertoast.showToast(
        msg: "Error: $e",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    } finally {
      // Hide loading indicator
      setState(() {
        isPunchInLoading = false;
      });
    }
  }

  Future<void> handleTeaBreakStart() async {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    // Show confirmation dialog before proceeding
    bool? confirmation = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor:
              themeProvider.themeData.brightness == Brightness.light
                  ? Colors.white
                  : Color(0xFF1C1F26),
          title: Text(
            "Start Tea Break",
            style: TextStyle(
                color: themeProvider.themeData.brightness == Brightness.light
                    ? Colors.black
                    : Colors.white),
          ),
          content: Text(
            "Are you sure you want to start the tea break?",
            style: TextStyle(
                color: themeProvider.themeData.brightness == Brightness.light
                    ? Colors.black
                    : Colors.white),
          ),
          actions: [
            TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text(
                  "Cancel",
                  style: TextStyle(
                      color:
                          themeProvider.themeData.brightness == Brightness.light
                              ? Colors.black
                              : Colors.white),
                )),
            TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: Text(
                  "Confirm",
                  style: TextStyle(
                    color:
                        themeProvider.themeData.brightness == Brightness.light
                            ? Colors.blue
                            : const Color(0xFF57C9E7),
                  ),
                ))
          ],
        );
      },
    );

    if (confirmation != true) return;

    DateTime now = DateTime.now();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? lastTeaStartDateForUser =
        prefs.getString('lastTeaStartDate_${widget.email}');
    String todayDate = DateFormat('yyyy-MM-dd').format(now);

    // Check if tea break is already started today
    if (lastTeaStartDateForUser == todayDate) {
      Fluttertoast.showToast(
        msg: "You have already started a tea break today.",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
      return;
    }

    setState(() {
      isTeaBreakLoading = true;
      isTeaBreakActive = true;
    });
    await _saveUserData();
    await prefs.setString('lastTeaStartDate_${widget.email}', todayDate);

    String teaStartTime = now.toIso8601String();
    String email = widget.email ?? "";

    Map<String, dynamic> payload = {
      "teaStartTime": teaStartTime,
      "email": email,
      "id": punchInId,
    };

    try {
      final response = await ApiService.teaStart(
          payload, email, punchInId!, teaStartTime, context);

      if (response.statusCode == 200) {
        setState(() {
          isTeaBreakActive = true;
        });
        Fluttertoast.showToast(
          msg: "Tea Break Started!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor:
              themeProvider.themeData.brightness == Brightness.light
                  ? Colors.indigo.shade900 // Default active color in light mode
                  : Color(0xFF57C9E7),
          textColor: Colors.white,
          fontSize: 16.0,
        );
      } else {
        Fluttertoast.showToast(
          msg: "Failed to start tea break: ${response.body}",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      }
    } catch (e) {
      Fluttertoast.showToast(
        msg: "Error: $e",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    } finally {
      setState(() {
        isTeaBreakLoading = false;
      });
    }
  }

  Future<void> handleTeaBreakEnd() async {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    // Show confirmation dialog before proceeding
    bool? confirmation = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor:
              themeProvider.themeData.brightness == Brightness.light
                  ? Colors.white
                  : Color(0xFF1C1F26),
          title: Text("End Tea Break",
              style: TextStyle(
                color: themeProvider.themeData.brightness == Brightness.light
                    ? Colors.black
                    : Colors.white,
              )),
          content: Text("Are you sure you want to end the tea break?",
              style: TextStyle(
                color: themeProvider.themeData.brightness == Brightness.light
                    ? Colors.black
                    : Colors.white,
              )),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text("Cancel",
                  style: TextStyle(
                    color:
                        themeProvider.themeData.brightness == Brightness.light
                            ? Colors.black
                            : Colors.white,
                  )),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text("Confirm",
                  style: TextStyle(
                    color:
                        themeProvider.themeData.brightness == Brightness.light
                            ? Colors.blue
                            : const Color(0xFF57C9E7),
                  )),
            ),
          ],
        );
      },
    );

    if (confirmation != true) return;

    if (punchInId == null) {
      Fluttertoast.showToast(
        msg: "Punch In first to end tea break!",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.orange,
        textColor: Colors.white,
        fontSize: 16.0,
      );
      return;
    }

    setState(() {
      isTeaBreakLoading = true;
      isTeaBreakActive = false;
    });

    String teaEndTime = DateTime.now().toIso8601String();
    String email = widget.email ?? "";

    Map<String, dynamic> payload = {
      "teaEndTime": teaEndTime,
      "email": email,
      "id": punchInId,
    };

    try {
      final response = await ApiService.teaEnd(
          payload, email, punchInId!, teaEndTime, context);

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        setState(() {
          isTeaBreakActive = false;
        });
        Fluttertoast.showToast(
          msg: "Tea Break Ended!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor:
              themeProvider.themeData.brightness == Brightness.light
                  ? Colors.indigo.shade900 // Default active color in light mode
                  : Color(0xFF57C9E7),
          textColor: Colors.white,
          fontSize: 16.0,
        );
      } else {
        Fluttertoast.showToast(
          msg: "Failed to end tea break: ${response.body}",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      }
    } catch (e) {
      Fluttertoast.showToast(
        msg: "Error: $e",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    } finally {
      setState(() {
        isTeaBreakLoading = false;
      });
    }
  }

  Future<void> handleLunchBreakStart() async {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    // Show confirmation dialog before proceeding
    bool? confirmation = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor:
              themeProvider.themeData.brightness == Brightness.light
                  ? Colors.white
                  : Color(0xFF1C1F26),
          title: Text(
            "Start Lunch Break",
            style: TextStyle(
                color: themeProvider.themeData.brightness == Brightness.light
                    ? Colors.black
                    : Colors.white),
          ),
          content: Text(
            "Are you sure you want to start the lunch break?",
            style: TextStyle(
                color: themeProvider.themeData.brightness == Brightness.light
                    ? Colors.black
                    : Colors.white),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(
                "Cancel",
                style: TextStyle(
                    color:
                        themeProvider.themeData.brightness == Brightness.light
                            ? Colors.black
                            : Colors.white),
              ),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text("Confirm",
                  style: TextStyle(
                    color:
                        themeProvider.themeData.brightness == Brightness.light
                            ? Colors.blue
                            : const Color(0xFF57C9E7),
                  )),
            ),
          ],
        );
      },
    );

    if (confirmation != true) return;
    DateTime now = DateTime.now();

    // Retrieve shared preferences instance
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Get the stored date for this user's last lunch break
    String? lastLunchStartDateForUser =
        prefs.getString('lastLunchStartDate_${widget.email}');

    // Format the current date for comparison
    String todayDate = DateFormat('yyyy-MM-dd').format(now);

    // Check if the user has already started their lunch break today
    if (lastLunchStartDateForUser == todayDate) {
      Fluttertoast.showToast(
        msg: "You have already started lunch break  today.",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
      return;
    }
    // if (punchInId == null) {
    //   Fluttertoast.showToast(
    //     msg: "Punch In first to start a lunch break!",
    //     toastLength: Toast.LENGTH_SHORT,
    //     gravity: ToastGravity.BOTTOM,
    //     backgroundColor: Colors.orange,
    //     textColor: Colors.white,
    //     fontSize: 16.0,
    //   );
    //   return;
    // }

    setState(() {
      isLunchBreakLoading = true;
      isLunchBreakActive = true;
    });
    await _saveUserData();
    // Save today's date for this user in shared preferences
    await prefs.setString('lastLunchStartDate_${widget.email}', todayDate);

    String lunchStartTime = DateTime.now().toIso8601String();
    String email = widget.email ?? "";

    Map<String, dynamic> payload = {
      "lunchStartTime": lunchStartTime,
      "email": widget.email,
      "id": punchInId,
    };

    print("email:$widget.email");
    print("id:$widget.punchInId");
    print("Payload: $payload");

    try {
      final response = await ApiService.startLunchBreak(
          payload, widget.email!, punchInId!, lunchStartTime, context);

      if (response.statusCode == 200) {
        setState(() {
          isLunchBreakActive = true;
        });
        Fluttertoast.showToast(
          msg: "Lunch Break Started!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor:
              themeProvider.themeData.brightness == Brightness.light
                  ? Colors.indigo.shade900 // Default active color in light mode
                  : Color(0xFF57C9E7),
          textColor: Colors.white,
          fontSize: 16.0,
        );
      } else {
        Fluttertoast.showToast(
          msg: "Failed to start lunch break: ${response.body}",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      }
    } catch (e) {
      Fluttertoast.showToast(
        msg: "Error: $e",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    } finally {
      setState(() {
        isLunchBreakLoading = false;
      });
    }
  }

  Future<void> handleLunchBreakEnd() async {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);

    // Show confirmation dialog before proceeding
    bool? confirmation = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor:
              themeProvider.themeData.brightness == Brightness.light
                  ? Colors.white
                  : Color(0xFF1C1F26),
          title: Text("End Lunch Break",
              style: TextStyle(
                color: themeProvider.themeData.brightness == Brightness.light
                    ? Colors.black
                    : Colors.white,
              )),
          content: Text("Are you sure you want to end the lunch break?",
              style: TextStyle(
                color: themeProvider.themeData.brightness == Brightness.light
                    ? Colors.black
                    : Colors.white,
              )),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text("Cancel",
                  style: TextStyle(
                    color:
                        themeProvider.themeData.brightness == Brightness.light
                            ? Colors.black
                            : Colors.white,
                  )),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text("Confirm",
                  style: TextStyle(
                    color:
                        themeProvider.themeData.brightness == Brightness.light
                            ? Colors.blue
                            : const Color(0xFF57C9E7),
                  )),
            ),
          ],
        );
      },
    );

    if (confirmation != true) return;
    if (punchInId == null) {
      Fluttertoast.showToast(
        msg: "Punch In first to end lunch break!",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.orange,
        textColor: Colors.white,
        fontSize: 16.0,
      );
      return;
    }

    setState(() {
      isLunchBreakLoading = true;
      isLunchBreakActive = false;
    });
    await _saveUserData();
    String lunchEndTime = DateTime.now().toIso8601String();
    String email = widget.email ?? "";

    Map<String, dynamic> payload = {
      "endLunchTime": lunchEndTime,
      "email": widget.email,
      "id": punchInId,
    };

    print("email:$widget.email");
    print("id:$widget.punchInId");
    print("Payload: $payload");

    try {
      final response = await ApiService.endLunchBreak(
          payload, widget.email!, punchInId!, lunchEndTime, context);

      if (response.statusCode == 200) {
        // final responseData = json.decode(response.body);
        // setState(() {
        //   isLunchBreakActive = false;
        // });
        Fluttertoast.showToast(
          msg: "Lunch Break Ended!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor:
              themeProvider.themeData.brightness == Brightness.light
                  ? Colors.indigo.shade900 // Default active color in light mode
                  : Color(0xFF57C9E7),
          textColor: Colors.white,
          fontSize: 16.0,
        );
      } else {
        Fluttertoast.showToast(
          msg: "Failed to end lunch break: ${response.body}",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      }
    } catch (e) {
      Fluttertoast.showToast(
        msg: "Error: $e",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    } finally {
      setState(() {
        isLunchBreakLoading = false;
      });
    }
  }

  Future<void> endPunchOutTime() async {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);

    // Show confirmation dialog before proceeding
    bool? confirmation = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor:
              themeProvider.themeData.brightness == Brightness.light
                  ? Colors.white
                  : Color(0xFF1C1F26),
          title: Text(
            "Punch Out",
            style: TextStyle(
                color: themeProvider.themeData.brightness == Brightness.light
                    ? Colors.black
                    : Colors.white),
          ),
          content: Text(
            "Are you sure you want to punchout?",
            style: TextStyle(
                color: themeProvider.themeData.brightness == Brightness.light
                    ? Colors.black
                    : Colors.white),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(
                "Cancel",
                style: TextStyle(
                    color:
                        themeProvider.themeData.brightness == Brightness.light
                            ? Colors.black
                            : Colors.white),
              ),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text(
                "Confirm",
                style: TextStyle(
                  color: themeProvider.themeData.brightness == Brightness.light
                      ? Colors.blue
                      : const Color(0xFF57C9E7),
                ),
              ),
            ),
          ],
        );
      },
    );

    if (punchInId == null || widget.email == null || widget.name == null) {
      Fluttertoast.showToast(
        msg: "Punch In first to end punchout!",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.orange,
        textColor: Colors.white,
        fontSize: 16.0,
      );
      return;
    }

    if (!mounted) return; // Ensure the widget is still in the widget tree
    setState(() {
      isPunchOutLoading = true;
      hasPunchedIn = false;
    });

    await _saveUserData(); // Save user-specific data

    String punchOutTime = DateTime.now().toIso8601String();
    Map<String, dynamic> payload = {
      "punchOutTime": punchOutTime,
      "email": widget.email,
      "id": punchInId,
      "name": widget.name,
    };
    print("PunchIn Payload: $payload");

    try {
      final response = await ApiService.punchOut(payload, widget.email!,
          punchInId!, widget.name!, punchOutTime, context);

      if (response.statusCode == 200) {
        if (!mounted) return; // Ensure the widget is still in the widget tree
        setState(() {
          isPunchOutActive = false;
        });
        Fluttertoast.showToast(
          msg: "Punch Out Successful!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor:
              themeProvider.themeData.brightness == Brightness.light
                  ? Colors.indigo.shade900 // Default active color in light mode
                  : Color(0xFF57C9E7),
          textColor: Colors.white,
          fontSize: 16.0,
        );
      } else {
        Fluttertoast.showToast(
          msg: "Failed punch out: ${response.body}",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      }
    } catch (e) {
      Fluttertoast.showToast(
        msg: "Error: $e",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    } finally {
      if (!mounted) return; // Ensure the widget is still in the widget tree
      setState(() {
        isPunchOutLoading = false;
      });
    }
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
            //       : Center(
            //           child: Text(
            //             hasPunchedIn
            //                 ? "You have already punched in."
            //                 : "You are not punched in.",
            //             style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            //           ),
            //         ),
            // )

            : SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Top Row with Icons and Labels
                        // Row(
                        //   mainAxisAlignment: MainAxisAlignment.spaceAround,
                        //   children: [
                        //     Flexible(
                        //       child: GestureDetector(
                        //         onTap: () {
                        //           if (!isPunchInLoading && !hasPunchedIn) {
                        //             handlePunchIn(); // Call handlePunchIn only when conditions are met
                        //           }
                        //           // else if (hasPunchedIn) {
                        //           //   Fluttertoast.showToast(
                        //           //     msg: "You have already punched in.",
                        //           //     toastLength: Toast.LENGTH_SHORT,
                        //           //     gravity: ToastGravity.BOTTOM,
                        //           //     backgroundColor: Colors.red,
                        //           //     textColor: Colors.white,
                        //           //     fontSize: 16.0,
                        //           //   );
                        //           // }
                        //         },
                        //         child: IconButtonWidget(
                        //           icon: Icons.login,
                        //           label: isPunchInLoading
                        //               ? "Punching In"
                        //               : (hasPunchedIn
                        //                   ? "Punched In"
                        //                   : "Punch In"),
                        //           iconColor:
                        //               themeProvider.themeData.brightness ==
                        //                       Brightness.light
                        //                   ? Colors.green
                        //                   : Colors.greenAccent,
                        //           boxShadow: [
                        //             BoxShadow(
                        //               color:
                        //                   themeProvider.themeData.brightness ==
                        //                           Brightness.light
                        //                       ? Colors.grey.withOpacity(0.5)
                        //                       : Colors.black.withOpacity(0.3),
                        //               spreadRadius: 2,
                        //               blurRadius: 5,
                        //               offset: const Offset(0, 3),
                        //             ),
                        //           ],
                        //         ),
                        //       ),
                        //     ),
                        //     Flexible(
                        //       child: GestureDetector(
                        //         onTap: isPunchOutLoading || !hasPunchedIn
                        //             ? null
                        //             : endPunchOutTime, // Disable if not punched in
                        //         child: Opacity(
                        //           opacity: isPunchOutLoading || !hasPunchedIn
                        //               ? 0.5
                        //               : 1.0, // Reduce opacity when disabled
                        //           child: IconButtonWidget(
                        //             icon: Icons.logout,
                        //             label: isPunchOutLoading
                        //                 ? "Punching Out"
                        //                 : "Punched Out",
                        //             iconColor: isPunchOutLoading ||
                        //                     !hasPunchedIn
                        //                 ? themeProvider.themeData.brightness ==
                        //                         Brightness.light
                        //                     ? Colors.grey
                        //                     : Colors.grey
                        //                         .shade700 // Adjust color when disabled
                        //                 : themeProvider.themeData.brightness ==
                        //                         Brightness.light
                        //                     ? Colors.red
                        //                     : Colors
                        //                         .redAccent, // Adjust icon color for dark theme
                        //             boxShadow: [
                        //               BoxShadow(
                        //                 color: themeProvider
                        //                             .themeData.brightness ==
                        //                         Brightness.light
                        //                     ? Colors.grey.withOpacity(0.5)
                        //                     : Colors.black.withOpacity(0.3),
                        //                 spreadRadius: 2,
                        //                 blurRadius: 5,
                        //                 offset: const Offset(0, 3),
                        //               ),
                        //             ],
                        //           ),
                        //         ),
                        //       ),
                        //     ),
                        //   ],
                        // ),

                        // const SizedBox(height: 30.0),
                        // if (hasPunchedIn) ...[
                        //   const SizedBox(height: 10),
                        // ],
                        // Row(
                        //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        //   children: [
                        //     Flexible(
                        //       child: GestureDetector(
                        //         onTap: !hasPunchedIn
                        //             ? null
                        //             : () async {
                        //                 if (isTeaBreakActive) {
                        //                   await handleTeaBreakEnd(); // Handle tea break end
                        //                 } else {
                        //                   await handleTeaBreakStart(); // Handle tea break start
                        //                 }
                        //               },
                        //         child: Container(
                        //           padding: EdgeInsets.symmetric(
                        //               vertical: 8.0, horizontal: 16.0),
                        //           decoration: BoxDecoration(
                        //             color: hasPunchedIn
                        //                 ? (isTeaBreakActive
                        //                     ? Colors.red
                        //                     : Colors.green.shade800)
                        //                 : Colors.grey,
                        //             borderRadius: BorderRadius.circular(8.0),
                        //             boxShadow: [
                        //               BoxShadow(
                        //                 color: themeProvider
                        //                             .themeData.brightness ==
                        //                         Brightness.light
                        //                     ? Colors.grey.withOpacity(0.5)
                        //                     : Colors.black.withOpacity(0.3),
                        //                 spreadRadius: 2,
                        //                 blurRadius: 5,
                        //                 offset: const Offset(0, 3),
                        //               ),
                        //             ],
                        //           ),
                        //           child: Row(
                        //             mainAxisAlignment: MainAxisAlignment.center,
                        //             children: [
                        //               Icon(
                        //                 isTeaBreakActive
                        //                     ? Icons.pause
                        //                     : Icons.play_arrow,
                        //                 color: Colors.white,
                        //                 size: 20,
                        //               ),
                        //               SizedBox(width: 5),
                        //               Flexible(
                        //                 child: Text(
                        //                   isTeaBreakActive
                        //                       ? "End Tea Break"
                        //                       : "Start Tea Break",
                        //                   style: TextStyle(
                        //                     color: Colors.white,
                        //                     fontSize: MediaQuery.of(context)
                        //                             .size
                        //                             .width *
                        //                         0.04,
                        //                     fontWeight: FontWeight.bold,
                        //                   ),
                        //                   overflow: TextOverflow.ellipsis,
                        //                 ),
                        //               ),
                        //             ],
                        //           ),
                        //         ),
                        //       ),
                        //     ),
                        //     SizedBox(width: 8.0),
                        //     Flexible(
                        //       child: GestureDetector(
                        //         onTap: !hasPunchedIn
                        //             ? null
                        //             : () async {
                        //                 if (isLunchBreakActive) {
                        //                   await handleLunchBreakEnd();
                        //                 } else {
                        //                   await handleLunchBreakStart();
                        //                 }
                        //               },
                        //         child: Container(
                        //           padding: EdgeInsets.symmetric(
                        //               vertical: 8.0, horizontal: 8),
                        //           decoration: BoxDecoration(
                        //             color: hasPunchedIn
                        //                 ? (isLunchBreakActive
                        //                     ? Colors.red
                        //                     : Colors.green.shade800)
                        //                 : Colors.grey,
                        //             borderRadius: BorderRadius.circular(8.0),
                        //             boxShadow: [
                        //               BoxShadow(
                        //                 color: themeProvider
                        //                             .themeData.brightness ==
                        //                         Brightness.light
                        //                     ? Colors.grey.withOpacity(0.5)
                        //                     : Colors.black.withOpacity(0.3),
                        //                 spreadRadius: 2,
                        //                 blurRadius: 5,
                        //                 offset: const Offset(0, 3),
                        //               ),
                        //             ],
                        //           ),
                        //           child: Row(
                        //             // mainAxisAlignment: MainAxisAlignment.center,
                        //             children: [
                        //               Icon(
                        //                 isLunchBreakActive
                        //                     ? Icons.pause
                        //                     : Icons.play_arrow,
                        //                 color: Colors.white,
                        //                 size: 20,
                        //               ),
                        //               SizedBox(width: 2.0),
                        //               Flexible(
                        //                 child: Text(
                        //                   isLunchBreakActive
                        //                       ? "End Lunch Break"
                        //                       : "Start Lunch Break",
                        //                   style: TextStyle(
                        //                     color: Colors.white,
                        //                     fontSize: MediaQuery.of(context)
                        //                             .size
                        //                             .width *
                        //                         0.04,
                        //                     fontWeight: FontWeight.bold,
                        //                   ),
                        //                   overflow: TextOverflow.ellipsis,
                        //                 ),
                        //               ),
                        //             ],
                        //           ),
                        //         ),
                        //       ),
                        //     ),
                        //   ],
                        // ),

                        const SizedBox(height: 10.0),
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
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      widget.name ?? "User Name",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: themeProvider
                                                    .themeData.brightness ==
                                                Brightness.light
                                            ? Colors.black
                                            : Color(0xFF57C9E7),
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        // Navigator.push(
                                        //   context,
                                        //   MaterialPageRoute(
                                        //       builder: (context) =>
                                        //           CalendarHolidayScreen()),
                                        // );
                                      },
                                      child: Container(
                                        height: 30,
                                        width: 50,
                                        decoration: BoxDecoration(
                                          color: themeProvider
                                                      .themeData.brightness ==
                                                  Brightness.light
                                              ? Colors.red
                                              : Colors.red[400],
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                          boxShadow: [
                                            BoxShadow(
                                              color: themeProvider.themeData
                                                          .brightness ==
                                                      Brightness.light
                                                  ? Colors.grey.withOpacity(0.5)
                                                  : Colors.black
                                                      .withOpacity(0.3),
                                              spreadRadius: 2,
                                              blurRadius: 5,
                                              offset: const Offset(0, 3),
                                            ),
                                          ],
                                        ),
                                        child: Center(
                                          child: Text(
                                            "Late",
                                            style: TextStyle(
                                              color: themeProvider.themeData
                                                          .brightness ==
                                                      Brightness.light
                                                  ? Colors.white
                                                  : Colors
                                                      .white, // Text color remains white for both themes
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 8,
                                ),
                                if (lateMessage != null)
                                  Text(
                                    lateMessage!,
                                    style: TextStyle(
                                        color: themeProvider
                                                    .themeData.brightness ==
                                                Brightness.light
                                            ? Colors.red
                                            : Colors.red[400],
                                        fontSize: 17),
                                  ),
                              ],
                            ),
                          ),
                        ),
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
