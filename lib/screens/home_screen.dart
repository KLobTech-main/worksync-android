import 'package:dass/colortheme/theme_maneger.dart';
import 'package:dass/screens/notifications.dart';
import 'package:dass/ui/attendance/attendance_screen.dart';
import 'package:dass/ui/auth/login.dart';
import 'package:dass/ui/dashboard/dashboardscreen.dart';
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
import 'package:dass/ui/taskandlogs/taskoverview.dart';
import 'package:dass/ui/ticketing/myticket.dart';
import 'package:flutter/material.dart';
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
                // gradient: LinearGradient(
                //   colors: [Colors.indigo.shade300, Colors.indigo.shade900],
                //   begin: Alignment.topLeft,
                //   end: Alignment.bottomRight,
                // ),
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
            const SizedBox(height: 20),
            // Grid View Section
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                children: [
                  _buildGridOption(Icons.dashboard, "Dashboard", onTap: () {
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
    );
  }

  Widget _buildGridOption(IconData icon, String title, {VoidCallback? onTap}) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return GestureDetector(
      onTap: onTap, // Trigger the navigation function
      child: Container(
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
