import 'package:dass/colortheme/theme_maneger.dart';
import 'package:dass/modal/leavesummarymodel.dart';
import 'package:dass/ui/leave/leave_request_screen.dart';
import 'package:dass/ui/leave/leavestatuscreen.dart';
import 'package:dass/webservices/api.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../holiday/holiday.dart';

class LeaveGridScreen extends StatefulWidget {
  final String? email;
  final String? name;

  LeaveGridScreen({required this.email, required this.name});

  @override
  _LeaveGridScreenState createState() => _LeaveGridScreenState();
}

class _LeaveGridScreenState extends State<LeaveGridScreen> {
  LeaveSummaryModel? user;
  bool isLoading = true;
  int _currentIndex = 0;

  // Define colors for leave types
  final Map<String, Color> leaveColors = {
    'Optional': Colors.blue,
    'Sick': Colors.green,
    'Casual': Colors.orange,
    'Paternity': Colors.red,
  };

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    setState(() {
      isLoading = true;
    });

    final data = await ApiService.getLeave(widget.email!, context);

    setState(() {
      user = data;
      isLoading = false;
    });
  }

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
    if (index == 0) {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => LeaveRequestPage(
                  email: widget.email,
                  name: widget.name,
                )),
      );
    } else if (index == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => LeaveManagementScreen(
                  email: widget.email,
                  name: widget.name,
                )),
      );
    }
    else if (index == 2) {
      Navigator.push(
          context,
          MaterialPageRoute(builder: (context)=>CalendarHolidayScreen())
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      backgroundColor: themeProvider.themeData.brightness == Brightness.light
          ? const Color.fromARGB(255, 246, 244, 244)
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
        iconTheme: IconThemeData(
          color: themeProvider.themeData.brightness == Brightness.light
              ? Colors.white
              : Color(0xFF57C9E7),
        ),
        title: Text(
          "Leave Summary",
          style: TextStyle(
            color: themeProvider.themeData.brightness == Brightness.light
                ? Colors.white
                : Color(0xFF57C9E7),
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: themeProvider.themeData.brightness == Brightness.light
            ? Colors.indigo.shade900
            : Color.fromARGB(255, 24, 28, 37),
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white60,
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.add_box),
            label: "Leave Request",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.pending_actions),
            label: "Leave Status",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.holiday_village),
            label: "Holidays",
          ),
        ],
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(
              color: themeProvider.themeData.brightness == Brightness.light
                  ? Colors.indigo.shade900
                  : Color(0xFF57C9E7),
            ))
          : user == null
              ? Center(
                  child: Text(
                  'Failed to load data',
                  style: TextStyle(
                    color:
                        themeProvider.themeData.brightness == Brightness.light
                            ? Colors.black
                            : Colors.grey,
                  ),
                ))
              : Column(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: GridView.count(
                          crossAxisCount: 2,
                          crossAxisSpacing: 16.0,
                          mainAxisSpacing: 16.0,
                          children: [
                            buildLeaveCard(
                              'Optional',
                              user!.monthlyLeaves,
                              user!.allLeaves,
                            ),
                            buildLeaveCard(
                                'Sick', user!.monthlyLeaves, user!.allLeaves),
                            buildLeaveCard(
                                'Casual', user!.monthlyLeaves, user!.allLeaves),
                            buildLeaveCard('Paternity', user!.monthlyLeaves,
                                user!.allLeaves),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: PieChart(
                          PieChartData(
                            sections: getPieChartSections(),
                            centerSpaceRadius: 40,
                            sectionsSpace: 4,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    )
                  ],
                ),
    );
  }

  List<PieChartSectionData> getPieChartSections() {
    final leaveTypes = ['Optional', 'Sick', 'Casual', 'Paternity'];
    final leaveValues = leaveTypes
        .map((type) => user?.allLeaves?.leaveTypeBalance?[type] ?? 0.0)
        .toList();

    return List.generate(leaveTypes.length, (i) {
      final color = [Colors.blue, Colors.green, Colors.orange, Colors.red][i];
      return PieChartSectionData(
        color: color,
        value: leaveValues[i],
        title: '${leaveValues[i]}',
        radius: 50,
        titleStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      );
    });
  }

  Widget buildLeaveCard(
      String leaveType, MonthlyLeaves? monthly, AllLeaves? total) {
    double monthlyLeave = 0;
    double totalLeave = 0;
    final themeProvider = Provider.of<ThemeProvider>(context);
    // Get the current month key
    String currentMonthKey =
        "${DateTime.now().year}-${DateTime.now().month.toString().padLeft(2, '0')}";

    // Access monthly leave balance
    if (monthly?.leaveDetails != null &&
        monthly!.leaveDetails!.containsKey(currentMonthKey)) {
      final leaveTypeBalance =
          monthly.leaveDetails![currentMonthKey]?.leaveTypeBalance;
      if (leaveTypeBalance != null && leaveTypeBalance.containsKey(leaveType)) {
        monthlyLeave = leaveTypeBalance[leaveType]!;
      }
    }

    if (total?.leaveTypeBalance != null &&
        total!.leaveTypeBalance!.containsKey(leaveType)) {
      totalLeave = total.leaveTypeBalance![leaveType]!;
    }

    return Card(
      elevation: 4.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              leaveType,
              style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                  color: themeProvider.themeData.brightness == Brightness.light
                      ? Colors.black
                      : Colors.white),
            ),
            SizedBox(height: 8.0),
            Text(
              'Monthly: $monthlyLeave',
              style: TextStyle(fontSize: 16.0, color: Colors.blueGrey),
            ),
            Text(
              'Total: $totalLeave',
              style: TextStyle(fontSize: 16.0, color: Colors.blueGrey),
            ),
          ],
        ),
      ),
    );
  }
}
