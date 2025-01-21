import 'package:dass/colortheme/theme_maneger.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../modal/jobhistorymodel.dart';
import '../../../webservices/api.dart';

class JobHistoryScreen extends StatefulWidget {
  final String email;

  JobHistoryScreen({required this.email});

  @override
  _JobHistoryScreenState createState() => _JobHistoryScreenState();
}

class _JobHistoryScreenState extends State<JobHistoryScreen> {
  late Future<JobHistoryModel?> jobHistoryFuture;

  @override
  void initState() {
    super.initState();
    jobHistoryFuture = ApiService().getJobHistory(widget.email, context);
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      backgroundColor: themeProvider.themeData.brightness == Brightness.light
          ? const Color.fromARGB(255, 246, 244, 244)
          : Color(0xFF1C1F26),
      appBar: AppBar(
        title: Text(
          'Job History',
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
              : Color(0xFF57C9E7), // Adjust icon color for dark theme),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FutureBuilder<JobHistoryModel?>(
          future: jobHistoryFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                  child: CircularProgressIndicator(
                color: themeProvider.themeData.brightness == Brightness.light
                    ? Colors.indigo.shade900
                    : Color(0xFF57C9E7),
              ));
            } else if (snapshot.hasError) {
              return Center(
                  child: Text(
                'Error: ${snapshot.error}',
                style: TextStyle(
                  color: themeProvider.themeData.brightness == Brightness.light
                      ? Colors.black
                      : Colors.white, // Adjust icon color for dark theme
                ),
              ));
            } else if (snapshot.hasData) {
              final jobHistory = snapshot.data;
              return jobHistory != null
                  ? _buildJobHistory(jobHistory)
                  : _buildJobHistoryDefault();
            } else {
              return _buildJobHistoryDefault();
            }
          },
        ),
      ),
    );
  }

  Widget _buildJobHistory(JobHistoryModel jobHistory) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        JobDetailRow(
          title: 'Department',
          value: jobHistory.department ?? 'Department Name',
          icon: Icons.apartment,
        ),
        SizedBox(height: 10),
        JobDetailRow(
          title: 'Work Shift',
          value: jobHistory.workShift?.shiftType ?? 'Regular Work Shift',
          icon: Icons.schedule,
        ),
        SizedBox(height: 10),
        JobDetailRow(
          title: 'Designation',
          value: jobHistory.designation ?? 'Business Development Executive',
          icon: Icons.badge,
        ),
        SizedBox(height: 10),
        JobDetailRow(
          title: 'Employment Status',
          value: jobHistory.employmentStatus ?? 'Permanent',
          icon: Icons.person,
        ),
        SizedBox(height: 10),
        JobDetailRow(
          title: 'Role',
          value: 'Employee', // Modify this based on API if required
          icon: Icons.flag,
        ),
        SizedBox(height: 10),
        JobDetailRow(
          title: 'Joining Date',
          value: jobHistory.joiningDate ?? '05 Feb, 2024',
          icon: Icons.calendar_today,
        ),
      ],
    );
  }

  Widget _buildJobHistoryDefault() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        JobDetailRow(
          title: 'Department',
          value: 'Department Name',
          icon: Icons.apartment,
        ),
        SizedBox(height: 10),
        JobDetailRow(
          title: 'Work Shift',
          value: 'Regular Work Shift',
          icon: Icons.schedule,
        ),
        SizedBox(height: 10),
        JobDetailRow(
          title: 'Designation',
          value: 'Business Development Executive',
          icon: Icons.badge,
        ),
        SizedBox(height: 10),
        JobDetailRow(
          title: 'Employment Status',
          value: 'Permanent',
          icon: Icons.person,
        ),
        SizedBox(height: 10),
        JobDetailRow(
          title: 'Role',
          value: 'Employee',
          icon: Icons.flag,
        ),
        SizedBox(height: 10),
        JobDetailRow(
          title: 'Joining Date',
          value: 'DD MM YYYY',
          icon: Icons.calendar_today,
        ),
      ],
    );
  }
}

class JobDetailRow extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;

  const JobDetailRow({
    required this.title,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(
            icon,
            color: themeProvider.themeData.brightness == Brightness.light
                ? Colors.indigo.shade900
                : Color(0xFF57C9E7),
          ),
          SizedBox(width: 16.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                      fontSize: 14.0,
                      color:
                          themeProvider.themeData.brightness == Brightness.light
                              ? Colors.grey[700]
                              : Colors.grey),
                ),
                SizedBox(height: 12),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                    color:
                        themeProvider.themeData.brightness == Brightness.light
                            ? Colors.black
                            : Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
