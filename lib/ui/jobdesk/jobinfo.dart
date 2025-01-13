import 'package:dass/colortheme/theme_maneger.dart';
import 'package:dass/ui/jobdesk/jobdrawer/assets.dart';
import 'package:dass/ui/jobdesk/jobdrawer/jobhistory.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'jobdrawer/adressdetails.dart';
import 'jobdrawer/documents.dart';
import 'jobdrawer/emergencycontacts.dart';
import 'jobdrawer/payrunbadge.dart';
import 'jobdrawer/payup.dart';
import 'jobdrawer/salaryoverview.dart';
import 'jobdrawer/userbankdetailinfo.dart';

class JobProfile extends StatefulWidget {
  final String? name;
  final String? email;
  JobProfile({Key? key, this.name, this.email}) : super(key: key);
  @override
  State<JobProfile> createState() => _JobProfileState();
}

class _JobProfileState extends State<JobProfile> {
  Widget _buildDrawerItem({
    required IconData icon,
    required String text,
    required VoidCallback onTap,
  }) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return ListTile(
      leading: Icon(
        icon,
        color: themeProvider.themeData.brightness == Brightness.light
            ? Colors.indigo.shade900
            : Color(0xFF57C9E7),
      ),
      title: Text(text,
          style: TextStyle(
              color: themeProvider.themeData.brightness == Brightness.light
                  ? Colors.indigo.shade900
                  : Color(0xFF57C9E7),
              fontWeight: FontWeight.bold)),
      onTap: onTap,
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      backgroundColor: themeProvider.themeData.brightness == Brightness.light
          ? Colors.white
          : Color(0xFF1C1F26),
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: themeProvider.themeData.brightness == Brightness.light
              ? Colors.white
              : Color(0xFF57C9E7),
        ),
        elevation: 0,
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
        title: Text(
          'Job Desk',
          style: TextStyle(
              color: themeProvider.themeData.brightness == Brightness.light
                  ? Colors.white
                  : Color(0xFF57C9E7),
              fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              color: themeProvider.themeData.brightness == Brightness.light
                  ? Colors.white
                  : Color(0xFF57C9E7),
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
      drawer: Drawer(
        backgroundColor: themeProvider.themeData.brightness == Brightness.light
            ? const Color.fromARGB(255, 246, 244, 244)
            : Color(0xFF1C1F26),
        child: Column(
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                gradient: themeProvider.themeData.brightness == Brightness.light
                    ? LinearGradient(
                        colors: [
                          Colors.indigo.shade900,
                          Colors.indigo.shade900
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      )
                    : LinearGradient(
                        colors: [
                          Color(0xFF57C9E7),
                          Color(0xFF57C9E7),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Profile photo
                  SizedBox(width: 16),
                  Text(
                    'Clock in pro',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            // List of drawer items
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  _buildDrawerItem(
                    icon: Icons.file_copy,
                    text: 'Documents',
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => DocumentPage(
                                    email: widget.email,
                                  )));
                    },
                  ),
                  _buildDrawerItem(
                    icon: Icons.work,
                    text: 'Assets',
                    onTap: () {
                      Navigator.pop(context);
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AssetsDialog(
                            email: widget.email!,
                          );
                        },
                      );
                    },
                  ),
                  _buildDrawerItem(
                    icon: Icons.history,
                    text: 'Job History',
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => JobHistoryScreen(
                                    email: widget.email!,
                                  )));
                    },
                  ),
                  _buildDrawerItem(
                    icon: Icons.attach_money,
                    text: 'Salary Overview',
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SalaryOverviewPage(
                                    email: widget.email!,
                                  )));
                    },
                  ),
                  _buildDrawerItem(
                    icon: Icons.badge,
                    text: 'Payrun and Badge',
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => PayrunAndBadgeScreen(
                                    email: widget.email!,
                                  )));
                    },
                  ),
                  _buildDrawerItem(
                    icon: Icons.payment,
                    text: 'PaySlip',
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => PaySlipScreen(
                                    email: widget.email!,
                                  )));
                    },
                  ),
                  _buildDrawerItem(
                    icon: Icons.account_balance,
                    text: 'Bank Details',
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => UserBankDetailsPage(
                                    email: widget.email!,
                                  )));
                    },
                  ),
                  _buildDrawerItem(
                    icon: Icons.location_city_sharp,
                    text: 'Address Details',
                    onTap: () {
                      Navigator.pop(context);
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AddressPage(
                            email: widget.email!,
                          );
                        },
                      );
                    },
                  ),
                  _buildDrawerItem(
                    icon: Icons.contact_phone,
                    text: 'Emergency Contacts',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              EmergencyContactPage(email: widget.email!),
                        ),
                      );
                    },
                  ),
                  // _buildDrawerItem(
                  //   icon: Icons.reset_tv,
                  //   text: 'Reset Password',
                  //   onTap: () {
                  //     showDialog(
                  //       context: context,
                  //       builder: (BuildContext context) {
                  //         return ResetPasswordDialog();
                  //       },
                  //     );
                  //   },
                  // ),
                ],
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Stack(
            children: [
              // Gradient Background Container
              Container(
                height: MediaQuery.of(context).size.height * 0.3,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: Theme.of(context).brightness == Brightness.light
                        ? [
                            Colors.indigo.shade200,
                            Colors.indigo.shade900
                          ] // Light theme colors
                        : [
                            Color.fromARGB(255, 21, 24, 30),
                            Color.fromARGB(255, 21, 24, 30),
                          ], // Dark theme gradient colors

                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(40),
                    bottomRight: Radius.circular(40),
                  ),
                ),
              ),

              // Positioned content inside the stack
              Positioned.fill(
                top: MediaQuery.of(context).size.height *
                    0.05, // Adjust according to screen
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // Profile Picture
                          CircleAvatar(
                            radius: constraints.maxWidth * 0.10,
                            backgroundColor:
                                themeProvider.themeData.brightness ==
                                        Brightness.light
                                    ? Colors.white
                                    : Color(0xFF57C9E7),
                            child: Icon(Icons.person,
                                size: constraints.maxWidth * 0.1,
                                color: themeProvider.themeData.brightness ==
                                        Brightness.light
                                    ? Colors.blue.shade900
                                    : Colors.white),
                          ),
                          SizedBox(height: constraints.maxHeight * 0.02),
                          // User Name
                          Flexible(
                            child: SizedBox(
                              child: Text(
                                widget.name ?? "User Name",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: constraints.maxWidth * 0.06,
                                  fontWeight: FontWeight.bold,
                                  color: themeProvider.themeData.brightness ==
                                          Brightness.light
                                      ? Colors.white
                                      : Color(0xFF57C9E7),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: constraints.maxHeight * 0.03),
                          // Job Title
                          Flexible(
                            child: Text(
                              'Business Development Executive',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: constraints.maxWidth * 0.04,
                                  color: themeProvider.themeData.brightness ==
                                          Brightness.light
                                      ? Colors.white.withOpacity(0.9)
                                      : Colors.grey),
                            ),
                          ),
                          SizedBox(height: constraints.maxHeight * 0.005),
                          // Employee Details
                          Flexible(
                            child: Text(
                              'EMP-18 | Permanent Employee',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: constraints.maxWidth * 0.035,
                                  color: themeProvider.themeData.brightness ==
                                          Brightness.light
                                      ? Colors.white.withOpacity(0.8)
                                      : Colors.grey),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),

          SizedBox(height: 20),

          // Data Cards Section
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: GridView.count(
                crossAxisCount: 2,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                children: [
                  _buildInfoCard(
                    context,
                    icon: Icons.apartment,
                    title: 'Department',
                    value: 'Sales & Business\nDevelopment',
                    color: Colors.orange,
                  ),
                  _buildInfoCard(
                    context,
                    icon: Icons.attach_money,
                    title: 'Salary',
                    value: 'Not Added Yet',
                    color: Colors.red,
                  ),
                  _buildInfoCard(
                    context,
                    icon: Icons.date_range,
                    title: 'Joining Date',
                    value: '05-02-2024',
                    color: Colors.green,
                  ),
                  _buildInfoCard(
                    context,
                    icon: Icons.timer,
                    title: 'Work Shift',
                    value: 'Regular Work Shift',
                    color: Colors.purple,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(BuildContext context,
      {required IconData icon,
      required String title,
      required String value,
      required Color color}) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: themeProvider.themeData.brightness == Brightness.light
            ? Colors.white
            : Color.fromARGB(255, 21, 24, 30),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: themeProvider.themeData.brightness == Brightness.light
                ? Colors.grey.withOpacity(0.5)
                : Colors.black.withOpacity(0.3),
            blurRadius: 8,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            backgroundColor: color.withOpacity(0.1),
            child: Icon(icon, color: color),
          ),
          SizedBox(height: 10),
          Text(
            title,
            style: TextStyle(
                fontSize: 14,
                color: themeProvider.themeData.brightness == Brightness.light
                    ? Colors.grey[700]
                    : Color(0xFF57C9E7),
                fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 12,
              color: themeProvider.themeData.brightness == Brightness.light
                  ? Colors.black
                  : Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}
