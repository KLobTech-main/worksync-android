import 'package:dass/colortheme/theme_maneger.dart';
import 'package:dass/ui/jobdesk/jobdrawer/resetpassword.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'basicinfo.dart';

class SettingsPage extends StatefulWidget {
  final String? name;
  final String? email;
  SettingsPage({Key? key, this.name, this.email}) : super(key: key);
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      backgroundColor: themeProvider.themeData.brightness == Brightness.light
          ? const Color.fromARGB(255, 246, 244, 244)
          : Color(0xFF1C1F26),
      appBar: AppBar(
        title: Text(
          "Settings",
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
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        iconTheme: IconThemeData(
          color: themeProvider.themeData.brightness == Brightness.light
              ? Colors.white
              : Color(0xFF57C9E7),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Settings",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: themeProvider.themeData.brightness == Brightness.light
                    ? Colors.black
                    : Colors.white,
              ),
            ),
            SizedBox(height: 16),
            Expanded(
              child: ListView(
                children: [
                  _buildSettingsCard(
                    context,
                    icon: Icons.info,
                    title: "Basic Information",
                    description: "View and update your basic profile details.",
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => BasicInformationPage(
                                    userEmail: widget.email!,
                                  )));
                    },
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  _buildSettingsCard(
                    context,
                    icon: Icons.lock_reset,
                    title: "Reset Password",
                    description:
                        "Change your password to keep your account secure.",
                    onTap: () {
                      Navigator.pop(context);
                      showDialog(
                        context: context,
                        builder: (context) => ResetPasswordDialog(),
                      );
                    },
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  _buildSettingsCard(
                    context,
                    icon: Icons.schedule,
                    title: "Time Management",
                    description:
                        "Configure your time and task management settings.",
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            title: Center(
                              child: Text(
                                "Time Management",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                    color: themeProvider.themeData.brightness ==
                                            Brightness.light
                                        ? Colors.indigo.shade900
                                        : Color(0xFF57C9E7)),
                              ),
                            ),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                _buildTimeDetailRow(
                                  icon: Icons.access_time,
                                  label: "Working Hours",
                                  value: "9 Hours",
                                ),
                                SizedBox(height: 10),
                                _buildTimeDetailRow(
                                  icon: Icons.lunch_dining,
                                  label: "Lunch Time",
                                  value: "1 Hour",
                                ),
                                SizedBox(height: 10),
                                _buildTimeDetailRow(
                                  icon: Icons.emoji_food_beverage,
                                  label: "Tea Break",
                                  value: "20 Min",
                                ),
                              ],
                            ),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context); // Close the dialog
                                },
                                child: Text(
                                  "Close",
                                  style: TextStyle(
                                    color: themeProvider.themeData.brightness ==
                                            Brightness.light
                                        ? Colors.indigo.shade900
                                        : Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      );
                    },
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  _buildSettingsCard(
                    context,
                    icon: Icons.color_lens,
                    title: "Color Theme",
                    description: "Customize the app’s appearance with themes.",
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            title: Center(
                              child: Text(
                                "Choose Theme",
                                style: Theme.of(context)
                                    .textTheme
                                    .titleLarge
                                    ?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(context).brightness ==
                                              Brightness.light
                                          ? Colors.black
                                          : Color(0xFF57C9E7),
                                    ),
                              ),
                            ),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                ListTile(
                                  title: Text(
                                    "Light Theme",
                                    style: TextStyle(
                                      color: Theme.of(context).brightness ==
                                              Brightness.light
                                          ? Colors.black
                                          : Colors.white,
                                    ),
                                  ),
                                  leading: Radio(
                                    value: Brightness.light,
                                    groupValue:
                                        themeProvider.themeData.brightness,
                                    onChanged: (Brightness? value) {
                                      if (value == Brightness.light) {
                                        themeProvider.toggleTheme();
                                      } else {
                                        themeProvider
                                            .toggleTheme(); // Switch to light theme
                                      }
                                      Navigator.pop(
                                          context); // Close the dialog
                                    },
                                    activeColor: themeProvider
                                                .themeData.brightness ==
                                            Brightness.light
                                        ? Colors.indigo
                                            .shade900 // Default active color in light mode
                                        : Color(0xFF57C9E7),
                                  ),
                                ),
                                ListTile(
                                  title: Text("Dark Theme"),
                                  leading: Radio(
                                    value: Brightness.dark,
                                    groupValue:
                                        themeProvider.themeData.brightness,
                                    onChanged: (Brightness? value) {
                                      if (value == Brightness.dark) {
                                        themeProvider
                                            .toggleTheme(); // Switch to dark theme
                                      } else {
                                        themeProvider
                                            .toggleTheme(); // Switch to light theme
                                      }
                                      Navigator.pop(
                                          context); // Close the dialog
                                    },
                                    activeColor: themeProvider
                                                .themeData.brightness ==
                                            Brightness.light
                                        ? Colors.indigo
                                            .shade900 // Default active color in light mode
                                        : Color(0xFF57C9E7),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String description,
    required VoidCallback onTap,
    // Assuming themeProvider is passed to this widget
  }) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        decoration: BoxDecoration(
          color: themeProvider.themeData.brightness == Brightness.light
              ? Colors.white
              : Color.fromARGB(
                  255, 21, 24, 30), // Set background color for light/dark mode
          borderRadius: BorderRadius.circular(12),
        ),
        child: ListTile(
          leading: CircleAvatar(
            backgroundColor:
                themeProvider.themeData.brightness == Brightness.light
                    ? Colors.indigo.shade100
                    : Color.fromARGB(255, 24, 28, 37),
            child: Icon(icon,
                color: themeProvider.themeData.brightness == Brightness.light
                    ? Colors.indigo.shade900
                    : Color(0xFF57C9E7)),
          ),
          title: Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: themeProvider.themeData.brightness == Brightness.light
                  ? Colors.black
                  : Colors.white,
            ),
          ),
          subtitle: Text(
            description,
            style: TextStyle(
              color: themeProvider.themeData.brightness == Brightness.light
                  ? Colors.black.withOpacity(0.6)
                  : Colors.white.withOpacity(0.6),
            ),
          ),
          onTap: onTap,
        ),
      ),
    );
  }

  Widget _buildTimeDetailRow(
      {required IconData icon, required String label, required String value}) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Row(
      children: [
        CircleAvatar(
          radius: 20,
          backgroundColor:
              themeProvider.themeData.brightness == Brightness.light
                  ? Colors.indigo.shade100
                  : Color.fromARGB(255, 24, 28, 37),
          child: Icon(icon,
              color: themeProvider.themeData.brightness == Brightness.light
                  ? Colors.indigo.shade900
                  : Color(0xFF57C9E7)),
        ),
        SizedBox(width: 15),
        Expanded(
          child: Text(
            label,
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: themeProvider.themeData.brightness == Brightness.light
                    ? Colors.black
                    : Colors.white),
          ),
        ),
        Text(
          value,
          style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: themeProvider.themeData.brightness == Brightness.light
                  ? Colors.indigo.shade900
                  : Colors.grey),
        ),
      ],
    );
  }
}
