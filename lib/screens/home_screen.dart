import 'dart:convert';

import 'package:dass/colortheme/theme_maneger.dart';
import 'package:dass/screens/notifications.dart';
import 'package:dass/ui/attendance/attendance_screen.dart';
import 'package:dass/ui/auth/login.dart';
import 'package:dass/ui/holiday/holiday.dart';
import 'package:dass/ui/homescreendrawer/aboutus.dart';
import 'package:dass/ui/homescreendrawer/annocements.dart';
import 'package:dass/ui/homescreendrawer/faqs.dart';
import 'package:dass/ui/homescreendrawer/privacyandpolicy.dart';
import 'package:dass/ui/homescreendrawer/settings.dart';
import 'package:dass/ui/homescreendrawer/submitfeedback.dart';
import 'package:dass/ui/homescreendrawer/termsandcond.dart';
import 'package:dass/ui/jobdesk/jobinfo.dart';
import 'package:dass/ui/leave/leave_summary.dart';
import 'package:dass/ui/meeting/meetingscreen.dart';
import 'package:dass/ui/taskandlogs/createnewtask.dart';
import 'package:dass/ui/taskandlogs/taskoverview.dart';
import 'package:dass/ui/ticketing/myticket.dart';
import 'package:dass/ui/timelogs/timelogscreen.dart';
import 'package:dass/webservices/api.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeScreen extends StatefulWidget {
  final String? name;
  final String? email;

  HomeScreen({Key? key, this.name, this.email}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

// // Logout function
// Future<void> _logout(BuildContext context) async {
//   SharedPreferences prefs = await SharedPreferences.getInstance();
//   await prefs.setBool('isLoggedIn', false); // Set login status to false
//   Navigator.pushReplacement(
//     context,
//     MaterialPageRoute(
//       builder: (context) => LogIn(), // Navigate to login screen
//     ),
//   );
// }

class _HomeScreenState extends State<HomeScreen> {
  bool _isLoading = false;
  final String compEmail = "info@klobtech.com";
  final String phone = "+919024790200";
  String? lateMessage;
  bool isLoading = true;

  bool hasPunchedIn = false;
  bool isPunchInLoading = false;
  bool isPunchOutLoading = false;

  bool isPunchOutActive = false;
  bool isPunchInActive = false;

  String? punchInTime;
  String? punchOutTime;

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
    _checkAttendanceStatus();

    // Use the actual email from the widget, not a hardcoded string
    String email = widget.email!; // Accessing widget property for dynamic email
    String year = DateTime.now().year.toString();
    String month = DateTime.now().month.toString().padLeft(2, '0');
  }

  void _checkAttendanceStatus() async {
    String email1 = widget.email!; // Ensure email is not null
    final result = await ApiService.fetchAttendanceStatus(email1, context);

    // Ensure result is not null and contains required keys
    String status = result['status'] ?? 'error'; // Default to 'error' if null
    String message = result['message'] ?? 'Unable to fetch attendance status.';

    // Call the dialog with non-null values
    _showAttendanceDialog(status, message);
    print("result.... : $result");
  }

  void _showAttendanceDialog(String status, String message) {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(status == 'success' ? 'Attendance Status' : 'Error'),
          titleTextStyle: TextStyle(
            color: themeProvider.themeData.brightness == Brightness.light
                ? Colors.black
                : Colors.white,
            fontSize: 24,
          ),
          content: Text(
            message,
            style: TextStyle(
              color: themeProvider.themeData.brightness == Brightness.light
                  ? Colors.black
                  : Colors.white,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog
              },
              child: Text(
                'Cancel',
                style: TextStyle(
                  color: themeProvider.themeData.brightness == Brightness.light
                      ? Colors.indigo.shade900
                      : const Color(0xFF57C9E7),
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Perform action and close dialog
              },
              child: Text(
                'Okay',
                style: TextStyle(
                  color: themeProvider.themeData.brightness == Brightness.light
                      ? Colors.indigo.shade900
                      : const Color(0xFF57C9E7),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _logout(BuildContext context) async {
    setState(() {
      _isLoading = true;
    });

    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', false); // Set login status to false

    setState(() {
      _isLoading = false;
    });

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => LogIn(), // Navigate to login screen
      ),
    );
  }

  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    // Navigate to different screens based on index
    switch (index) {
      case 0:
        // Navigate to Home
        break;
      case 1:
        // Navigate to Notifications
        break;
      case 2:
        // Navigate to Profile
        break;
    }
  }

  Future<void> _loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userData =
        prefs.getString(widget.email!); // Retrieve user data by email key
    if (userData != null) {
      Map<String, dynamic> data =
          jsonDecode(userData); // Decode the JSON string
      setState(() {
        hasPunchedIn = data['hasPunchedIn'] ?? false;

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
      'punchInTime': punchInTime,
      'punchInId': punchInId,
      'lateMessage': lateMessage,
    };
    await prefs.setString(widget.email!, jsonEncode(data));
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

  Future<void> PunchOutTime() async {
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

    if (!mounted) return;
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
        if (!mounted) return;
        setState(() {
          isPunchOutActive = false;
        });
        Fluttertoast.showToast(
          msg: "Punch Out Successful!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor:
              themeProvider.themeData.brightness == Brightness.light
                  ? Colors.indigo.shade900
                  : Color(0xFF57C9E7),
          textColor: Colors.white,
          fontSize: 16.0,
        );
      } else if (response.statusCode == 404) {
        Fluttertoast.showToast(
          msg: "Attendance record not found",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red,
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
      if (!mounted) return;
      setState(() {
        isPunchOutLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    //  SMSConroller smsConroller = Get.put(SMSConroller());
    return Scaffold(
      backgroundColor: themeProvider.themeData.brightness == Brightness.light
          ? const Color.fromARGB(255, 246, 244, 244)
          : Color(0xFF1C1F26),
      drawer: Drawer(
        backgroundColor: themeProvider.themeData.brightness == Brightness.light
            ? const Color.fromARGB(255, 246, 244, 244)
            : Color(0xFF1C1F26),
        child: Column(
          children: [
            Stack(
              children: [
                Container(
                  height: 170,
                  width: double.infinity,
                  color: themeProvider.themeData.brightness == Brightness.light
                      ? Colors.indigo.shade900
                      : Color(0xFF57C9E7),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        radius: 20,
                        backgroundColor: Colors.white,
                        child: Icon(
                          Icons.person,
                          size: 25,
                          color: themeProvider.themeData.brightness ==
                                  Brightness.light
                              ? Colors.indigo.shade900
                              : Color(0xFF57C9E7),
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        widget.name ?? "user",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        widget.email ?? "unknown@example.com",
                        style: TextStyle(
                          color: themeProvider.themeData.brightness ==
                                  Brightness.light
                              ? Colors.white70
                              : Colors.white,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Expanded(
              child: ListView(
                children: [
                  ExpansionTile(
                    leading: Icon(
                      Icons.support_agent,
                      color:
                          themeProvider.themeData.brightness == Brightness.light
                              ? Colors.indigo.shade900
                              : Color(0xFF57C9E7),
                    ),
                    title: Text(
                      "Support & Feedback",
                      style: TextStyle(
                          color: themeProvider.themeData.brightness ==
                                  Brightness.light
                              ? Colors.indigo.shade900
                              : Color(0xFF57C9E7),
                          fontWeight: FontWeight.bold),
                    ),
                    children: [
                      ListTile(
                        title: Text(
                          "Help Center",
                          style: TextStyle(
                              color: themeProvider.themeData.brightness ==
                                      Brightness.light
                                  ? Colors.indigo.shade900
                                  : Color(0xFF57C9E7),
                              fontWeight: FontWeight.bold),
                        ),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => FAQPage()));
                        },
                      ),
                      ListTile(
                        title: Text(
                          "Submit Feedback",
                          style: TextStyle(
                              color: themeProvider.themeData.brightness ==
                                      Brightness.light
                                  ? Colors.indigo.shade900
                                  : Color(0xFF57C9E7),
                              fontWeight: FontWeight.bold),
                        ),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => FeedbackPage(
                                        email: widget.email,
                                      )));
                        },
                      ),
                      ListTile(
                        title: Text(
                          "Contact Us",
                          style: TextStyle(
                              color: themeProvider.themeData.brightness ==
                                      Brightness.light
                                  ? Colors.indigo.shade900
                                  : Color(0xFF57C9E7),
                              fontWeight: FontWeight.bold),
                        ),
                        onTap: () {
                          _showContactDialog(context);
                        },
                      ),
                    ],
                  ),
                  ExpansionTile(
                    leading: Icon(
                      Icons.support_agent,
                      color:
                          themeProvider.themeData.brightness == Brightness.light
                              ? Colors.indigo.shade900
                              : Color(0xFF57C9E7),
                    ),
                    title: Text(
                      "Privacy And Security",
                      style: TextStyle(
                          color: themeProvider.themeData.brightness ==
                                  Brightness.light
                              ? Colors.indigo.shade900
                              : Color(0xFF57C9E7),
                          fontWeight: FontWeight.bold),
                    ),
                    children: [
                      ListTile(
                        title: Text(
                          "Terms And Condition",
                          style: TextStyle(
                              color: themeProvider.themeData.brightness ==
                                      Brightness.light
                                  ? Colors.indigo.shade900
                                  : Color(0xFF57C9E7),
                              fontWeight: FontWeight.bold),
                        ),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      TermsAndConditionsScreen()));
                        },
                      ),
                      ListTile(
                        title: Text(
                          "Privacy And Policy",
                          style: TextStyle(
                              color: themeProvider.themeData.brightness ==
                                      Brightness.light
                                  ? Colors.indigo.shade900
                                  : Color(0xFF57C9E7),
                              fontWeight: FontWeight.bold),
                        ),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => PrivacyPolicyScreen()));
                        },
                      ),
                    ],
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.settings,
                      color:
                      themeProvider.themeData.brightness == Brightness.light
                          ? Colors.indigo.shade900
                          : Color(0xFF57C9E7),
                    ),
                    title: Text(
                      "Settings",
                      style: TextStyle(
                          color: themeProvider.themeData.brightness ==
                              Brightness.light
                              ? Colors.indigo.shade900
                              : Color(0xFF57C9E7),
                          fontWeight: FontWeight.bold),
                    ),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SettingsPage(
                                name: widget.name,
                                email: widget.email,
                              )));
                    },
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.announcement,
                      color:
                          themeProvider.themeData.brightness == Brightness.light
                              ? Colors.indigo.shade900
                              : Color(0xFF57C9E7),
                    ),
                    title: Text(
                      "Announcements",
                      style: TextStyle(
                          color: themeProvider.themeData.brightness ==
                                  Brightness.light
                              ? Colors.indigo.shade900
                              : Color(0xFF57C9E7),
                          fontWeight: FontWeight.bold),
                    ),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AnnouncementPage(
                                    userEmail: widget.email!,
                                  )));
                    },
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.info_outline,
                      color:
                          themeProvider.themeData.brightness == Brightness.light
                              ? Colors.indigo.shade900
                              : Color(0xFF57C9E7),
                    ),
                    title: Text(
                      "About",
                      style: TextStyle(
                          color: themeProvider.themeData.brightness ==
                                  Brightness.light
                              ? Colors.indigo.shade900
                              : Color(0xFF57C9E7),
                          fontWeight: FontWeight.bold),
                    ),
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => AboutPage()));
                    },
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.calendar_month,
                      color:
                      themeProvider.themeData.brightness == Brightness.light
                          ? Colors.indigo.shade900
                          : Color(0xFF57C9E7),
                    ),
                    title: Text(
                      "Google Calendar",
                      style: TextStyle(
                          color: themeProvider.themeData.brightness ==
                              Brightness.light
                              ? Colors.indigo.shade900
                              : Color(0xFF57C9E7),
                          fontWeight: FontWeight.bold),
                    ),
                    onTap: () {
                    },
                  ),
                  ListTile(
                    leading: _isLoading
                        ? SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                themeProvider.themeData.brightness ==
                                        Brightness.light
                                    ? Colors.indigo.shade900
                                    : Color(0xFF57C9E7),
                              ),
                            ),
                          )
                        : Icon(
                            Icons.logout,
                            color: themeProvider.themeData.brightness ==
                                    Brightness.light
                                ? Colors.indigo.shade900
                                : Color(0xFF57C9E7),
                          ),
                    title: Text(
                      "Logout",
                      style: TextStyle(
                          color: themeProvider.themeData.brightness ==
                                  Brightness.light
                              ? Colors.indigo.shade900
                              : Color(0xFF57C9E7),
                          fontWeight: FontWeight.bold),
                    ),
                    onTap: _isLoading
                        ? null
                        : () {
                            _logout(context);
                          },
                  ),
                ],
              ),
            ),
            Divider(
              color: themeProvider.themeData.brightness == Brightness.light
                  ? Colors.indigo.shade900
                  : Color(0xFF57C9E7),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Text(
                  "App Version 1.0.0",
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      body: Builder(builder: (context) {
        final themeProvider = Provider.of<ThemeProvider>(context);
        return Column(
          children: [
            // Header Section
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 40),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 5,
                    spreadRadius: 2,
                  ),
                ],
                color: themeProvider.themeData.brightness == Brightness.light
                    ? Colors.indigo.shade900
                    : Color.fromARGB(255, 21, 24, 30),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header Row with Avatar, User Name, and Notification Icon
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          InkWell(
                            onTap: () {
                              Scaffold.of(context).openDrawer();
                            },
                            child: CircleAvatar(
                              radius: 30,
                              backgroundColor:
                                  themeProvider.themeData.brightness ==
                                          Brightness.light
                                      ? Colors.white
                                      : Color(0xFF57C9E7),
                              child: Icon(Icons.person,
                                  size: 35,
                                  color: themeProvider.themeData.brightness ==
                                          Brightness.light
                                      ? Colors.blue.shade900
                                      : Colors.white),
                            ),
                          ),
                          SizedBox(width: 15),
                          Column(
                            children: [
                              Text(
                                widget.name ?? "User Name",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: themeProvider.themeData.brightness ==
                                          Brightness.light
                                      ? Colors.white
                                      : Colors.white,
                                ),
                              ),
                              Text(
                                "Softwere Developer",
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  color: themeProvider.themeData.brightness ==
                                          Brightness.light
                                      ? Colors.white
                                      : Colors.grey,
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                      InkWell(
                        child: Icon(
                          Icons.notification_add,
                          color: themeProvider.themeData.brightness ==
                                  Brightness.light
                              ? Colors.white
                              : Colors.white,
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => NotificationsScreen(
                                recipientEmail:
                                    widget.email ?? "unknown@example.com",
                              ),
                            ),
                          );
                        },
                      )
                    ],
                  ),

                  const SizedBox(height: 20),

                  // Centered CrewSync Text
                  Center(
                    child: Text(
                      "CrewSync",
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        color: themeProvider.themeData.brightness ==
                                Brightness.light
                            ? Colors.white
                            : Color(0xFF57C9E7),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
            // SizedBox(
            //   height: 10,
            // ),

            const SizedBox(height: 50),
            // Grid View Section
            Expanded(
              child: GridView.count(
                crossAxisCount: 3,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                crossAxisSpacing: 30,
                mainAxisSpacing: 30,
                children: [
                  _buildGridOption(Icons.timelapse, "TimeLog", onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Dashboard(
                                name: widget.name,
                                email: widget.email,
                              )),
                    );
                    debugPrint("name : ${widget.name}");
                    debugPrint("email : ${widget.email}");
                  }),
                  _buildGridOption(Icons.work, "Job Desk", onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => JobProfile(
                                name: widget.name,
                                email: widget.email,
                              )),
                    );
                    debugPrint("name : ${widget.name}");
                    debugPrint("email : ${widget.email}");
                  }),
                  _buildGridOption(Icons.check_circle, "Attendance", onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Attendance(
                                name: widget.name,
                                email: widget.email,
                              )),
                    );
                    debugPrint("name : ${widget.name}");
                    debugPrint("email : ${widget.email}");
                  }),
                  _buildGridOption(Icons.beach_access, "Leave", onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => LeaveGridScreen(
                                name: widget.name,
                                email: widget.email,
                              )),
                    );
                    debugPrint("name : ${widget.name}");
                    debugPrint("email : ${widget.email}");
                  }),
                  _buildGridOption(Icons.video_call, "Meeting", onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => MeetingListScreen(
                                name: widget.name,
                                email: widget.email,
                              )),
                    );
                  }),
                  _buildGridOption(Icons.history, "Logs", onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => TaskOverviewScreen(
                                name: widget.name,
                                email: widget.email,
                              )),
                    );
                  }),
                  // _buildGridOption(Icons.task_outlined, "Create Task",
                  //     onTap: () {
                  //   Navigator.push(
                  //     context,
                  //     MaterialPageRoute(
                  //       builder: (context) => CreateTaskScreen(
                  //         name: widget.name,
                  //         email: widget.email,
                  //       ),
                  //     ),
                  //   );
                  //   debugPrint("name : ${widget.name}");
                  //   debugPrint("email : ${widget.email}");
                  // }),
                  _buildGridOption(Icons.support_agent, "Ticket", onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => MyTicketsPage(
                                name: widget.name,
                                email: widget.email,
                              )),
                    );
                  }),
                  _buildGridOption(Icons.list, "ToDo List", onTap: () {

                  }),
                  _buildGridOption(Icons.admin_panel_settings_outlined, "project panel", onTap: () {

                  }),
                  _buildGridOption(Icons.holiday_village, "Holiday", onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => CalendarHolidayScreen()),
                    );
                  }),

                ],
              ),
            ),

            SizedBox(
              height: 20,
            )
          ],
        );
      }),
      bottomNavigationBar: BottomAppBar(
        color: themeProvider.themeData.brightness == Brightness.light
            ? Colors.indigo.shade900
            : Color.fromARGB(255, 21, 24, 30),
        shape: const CircularNotchedRectangle(),
        notchMargin: 9.0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // IconButton(
            //   icon: const Icon(Icons.home),
            //   onPressed: () => _onItemTapped(0),
            // ),
            // const SizedBox(width: 40), // Space for the floating button
            // IconButton(
            //   icon: const Icon(Icons.person),
            //   onPressed: () => _onItemTapped(2),
            // ),
          ],
        ),
      ),
      floatingActionButton: Container(
        width: 70.0, // Increase width to make it bigger
        height: 70.0, // Increase height to make it bigger
        child: FloatingActionButton(
          onPressed: () async {
            if (!hasPunchedIn) {
              // Handle Punch In if not already punched in
              await handlePunchIn();
            } else {
              // Handle Punch Out if already punched in
              await PunchOutTime();
            }
          },
          backgroundColor: hasPunchedIn
              ? Colors.red.shade800
              : Colors.green.shade800,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
                35),
          ),
          child: Icon(
            hasPunchedIn ? Icons.exit_to_app : Icons.fingerprint,
            color: Colors.white, 
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  Widget _buildGridOption(IconData icon, String title, {VoidCallback? onTap}) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return GestureDetector(
      onTap: onTap, // Trigger the navigation function
      child: Container(
        height: 70,
        width: 200,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: themeProvider.themeData.brightness == Brightness.light
              ? Colors.white
              : Color.fromARGB(255, 21, 24, 30),
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: themeProvider.themeData.brightness == Brightness.light
                  ? Colors.black12
                  : const Color.fromARGB(255, 0, 0, 0).withOpacity(0.3),
              blurRadius: 5,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon,
                size: 40,
                color: themeProvider.themeData.brightness == Brightness.light
                    ? Colors.indigo.shade900
                    : Color(0xFF57C9E7)),
            const SizedBox(height: 10),
            Text(title,
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color:
                        themeProvider.themeData.brightness == Brightness.light
                            ? Colors.indigo.shade900
                            : Colors.grey)),
          ],
        ),
      ),
    );
  }

  void _showContactDialog(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          "Contact Us",
          style: TextStyle(
            color: themeProvider.themeData.brightness == Brightness.light
                ? Colors.indigo.shade900
                : Color(0xFF57C9E7),
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            GestureDetector(
              onTap: () => _launchEmail(compEmail),
              child: Row(
                children: [
                  Icon(
                    Icons.email,
                    color:
                        themeProvider.themeData.brightness == Brightness.light
                            ? Colors.indigo.shade900
                            : Color(0xFF57C9E7),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      compEmail,
                      style: TextStyle(
                        fontSize: 16,
                        color: themeProvider.themeData.brightness ==
                                Brightness.light
                            ? Colors.indigo.shade900
                            : Colors.white,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16),
            GestureDetector(
              onTap: () => _launchPhone(phone),
              child: Row(
                children: [
                  Icon(
                    Icons.phone,
                    color:
                        themeProvider.themeData.brightness == Brightness.light
                            ? Colors.indigo.shade900
                            : Color(0xFF57C9E7),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      phone,
                      style: TextStyle(
                        fontSize: 16,
                        color: themeProvider.themeData.brightness ==
                                Brightness.light
                            ? Colors.indigo.shade900
                            : Colors.white,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              "Close",
              style: TextStyle(
                color: themeProvider.themeData.brightness == Brightness.light
                    ? Colors.indigo.shade900
                    : Color(0xFF57C9E7),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _launchEmail(String email) async {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: email,
    );
    if (await canLaunchUrl(emailUri)) {
      await launchUrl(emailUri);
    } else {
      throw "Could not launch $email";
    }
  }

  void _launchPhone(String phone) async {
    final Uri phoneUri = Uri(
      scheme: 'tel',
      path: phone,
    );
    if (await canLaunchUrl(phoneUri)) {
      await launchUrl(phoneUri);
    } else {
      throw "Could not launch $phone";
    }
  }
}
