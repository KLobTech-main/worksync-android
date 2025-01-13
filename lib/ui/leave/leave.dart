import 'package:dass/colortheme/theme_maneger.dart';
import 'package:dass/ui/leave/leave_request_screen.dart';
import 'package:dass/ui/leave/leavestatuscreen.dart';
import 'package:dass/webservices/api.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LeaveSummaryPage extends StatefulWidget {
  final String? name;
  final String? email;

  LeaveSummaryPage({Key? key, this.name, this.email}) : super(key: key);

  @override
  _LeaveSummaryPageState createState() => _LeaveSummaryPageState();
}

class _LeaveSummaryPageState extends State<LeaveSummaryPage> {
  int _currentIndex = 0;
  Map<String, double>? monthlyLeaves;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadLeaveSummary();
  }

  Future<void> _loadLeaveSummary() async {
    try {
      final response = await ApiService.getLeaveSummary(widget.email ?? '');
      if (response != null) {
        if (!mounted) return; // Ensure widget is still mounted
        setState(() {
          // Safely parse the response
          final rawMonthlyLeaves =
              response['monthlyLeaves'] as Map<String, dynamic>?;

          if (rawMonthlyLeaves != null) {
            monthlyLeaves = rawMonthlyLeaves.map((key, value) {
              if (value is num) {
                return MapEntry(key, value.toDouble());
              } else {
                debugPrint('Invalid value for $key: $value');
                return MapEntry(
                    key, 0.0); // Default to 0.0 if the value is invalid
              }
            });
          } else {
            monthlyLeaves = {}; // Set to empty if null
          }

          // Ensure there are always four types of leave, if not, fallback to default values
          const defaultLeaveTypes = [
            'Casual Leave',
            'Sick Leave',
            'Paternity Leave',
            'Optional Leave'
          ];
          for (var leaveType in defaultLeaveTypes) {
            if (!monthlyLeaves!.containsKey(leaveType)) {
              monthlyLeaves![leaveType] = 0.0;
            }
          }

          isLoading = false;
        });
      } else {
        debugPrint('No valid data returned from API');
        if (!mounted) return;
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      debugPrint('Error: $e');
      if (!mounted) return;
      setState(() {
        isLoading = false;
      });
    }
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
        ],
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(
              color: themeProvider.themeData.brightness == Brightness.light
                  ? Colors.indigo.shade900
                  : Color(0xFF57C9E7),
            ))
          : monthlyLeaves != null
              ? SingleChildScrollView(
                  child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Text(
                        "Leave Details",
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: themeProvider.themeData.brightness ==
                                    Brightness.light
                                ? Colors.indigo.shade900
                                : Colors.white),
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: monthlyLeaves!.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 12,
                          crossAxisSpacing: 12,
                          childAspectRatio: 2 / 1.2,
                        ),
                        itemBuilder: (context, index) {
                          final entry = monthlyLeaves!.entries.elementAt(index);
                          final color = customColor(entry.key);

                          return Container(
                            decoration: BoxDecoration(
                              color: color.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  entry.key,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: color,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  "${entry.value}/10",
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: themeProvider.themeData.brightness ==
                                            Brightness.light
                                        ? Colors.black
                                        : Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 20),
                      Text(
                        "Monthly Leave Summary",
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: themeProvider.themeData.brightness ==
                                    Brightness.light
                                ? Colors.indigo.shade900
                                : Colors.white),
                      ),
                      const SizedBox(height: 20),

                      // PieChart Section
                      AspectRatio(
                        aspectRatio: 1.3,
                        child: PieChart(
                          PieChartData(
                            sections: monthlyLeaves!.entries.map((entry) {
                              return PieChartSectionData(
                                value: entry.value,
                                color: customColor(entry.key),
                                // title: '${entry.key}\n${entry.value}',
                                titleStyle: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              );
                            }).toList(),
                            sectionsSpace: 4,
                            centerSpaceRadius: 50,
                            borderData: FlBorderData(show: false),
                          ),
                        ),
                      ),
                    ],
                  ),
                ))
              : Center(
                  child: Text(
                  "No data available",
                  style: TextStyle(
                    color:
                        themeProvider.themeData.brightness == Brightness.light
                            ? Colors.black
                            : Colors.grey,
                  ),
                )),
    );
  }

  // Custom function to define your preferred colors
  Color customColor(String key) {
    // Define your custom colors here
    List<Color> customColors = [
      Colors.blue, // Blue
      Colors.red, // Red
      Colors.green, // Green
      Colors.orange, // Orange
    ];

    // Assign colors based on the key's hashCode, looping if necessary
    return customColors[key.hashCode % customColors.length];
  }
}
