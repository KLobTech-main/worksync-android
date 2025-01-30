import 'package:dass/colortheme/theme_maneger.dart';
import 'package:dass/webservices/api.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

class LeaveManagementScreen extends StatefulWidget {
  final String? name;
  final String? email;

  LeaveManagementScreen({
    Key? key,
    this.name,
    this.email,
  }) : super(key: key);

  @override
  _LeaveManagementScreenState createState() => _LeaveManagementScreenState();
}

class _LeaveManagementScreenState extends State<LeaveManagementScreen>
    with SingleTickerProviderStateMixin {
  String? email;
  String? date;
  late TabController _tabController;
  List<Map<String, dynamic>> allLeaveData = [];
  List<Map<String, dynamic>> filteredLeaveData = [];
  bool isLoading = false;
  String selectedFilter = 'All';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    fetchLeaveData();

    // Listen to tab changes
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        _filterByTab(_tabController.index);
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> fetchLeaveData() async {
    setState(() {
      isLoading = true;
    });

    // Ensure you pass the correct email and date values
    // Replace with the actual date value
    String date = DateTime.now().toIso8601String();
    String? email = widget.email;

    final data = await ApiService.getLeaveStatus(
        email!, date, context); // Pass the values correctly

    setState(() {
      allLeaveData = data;
      filteredLeaveData = allLeaveData; // Default to showing all data
      isLoading = false;
    });
  }

  void _filterByTab(int tabIndex) {
    setState(() {
      DateTime now = DateTime.now();

      if (tabIndex == 0) {
        // Today
        filteredLeaveData = allLeaveData.where((leave) {
          DateTime startDate = DateTime.parse(leave['startDate']);
          return isSameDay(now, startDate);
        }).toList();
      } else if (tabIndex == 1) {
        // Week
        filteredLeaveData = allLeaveData.where((leave) {
          DateTime startDate = DateTime.parse(leave['startDate']);
          return isSameWeek(now, startDate);
        }).toList();
      } else if (tabIndex == 2) {
        // Month
        filteredLeaveData = allLeaveData.where((leave) {
          DateTime startDate = DateTime.parse(leave['startDate']);
          return isSameMonth(now, startDate);
        }).toList();
      } else if (tabIndex == 3) {
        // Year
        filteredLeaveData = allLeaveData.where((leave) {
          DateTime startDate = DateTime.parse(leave['startDate']);
          return isSameYear(now, startDate);
        }).toList();
      }
    });
  }

  bool isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  bool isSameWeek(DateTime currentDate, DateTime compareDate) {
    int currentWeekday = currentDate.weekday;
    DateTime startOfWeek =
        currentDate.subtract(Duration(days: currentWeekday - 1));
    DateTime endOfWeek = currentDate.add(Duration(days: 7 - currentWeekday));

    return compareDate.isAfter(startOfWeek.subtract(Duration(seconds: 1))) &&
        compareDate.isBefore(endOfWeek.add(Duration(seconds: 1)));
  }

  bool isSameMonth(DateTime currentDate, DateTime compareDate) {
    return currentDate.year == compareDate.year &&
        currentDate.month == compareDate.month;
  }

  bool isSameYear(DateTime currentDate, DateTime compareDate) {
    return currentDate.year == compareDate.year;
  }

  void showDeleteDialog(BuildContext context, String id, String userEmail) {
    final TextEditingController reasonController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Delete Leave Request"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("Please provide a reason for deleting the leave request."),
              SizedBox(height: 10),
              TextField(
                controller: reasonController,
                decoration: InputDecoration(
                  labelText: "Reason",
                  border: OutlineInputBorder(),
                ),
                maxLength: 200,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
              },
              child: Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () async {
                final reason = reasonController.text.trim();

                if (reason.isNotEmpty) {
                  // Call the delete API
                  final success = await ApiService.deleteLeaveRequest(
                      context, id, userEmail, reason);

                  Navigator.pop(context); // Close the dialog

                  // Show a toast message
                  Fluttertoast.showToast(
                    msg: success
                        ? "Leave cancel request send successfully."
                        : "Failed to delete leave request.",
                    toastLength: Toast.LENGTH_LONG,
                    gravity: ToastGravity.BOTTOM,
                    backgroundColor: success ? Colors.green : Colors.red,
                    textColor: Colors.white,
                    fontSize: 16.0,
                  );

                  if (success) {
                    // Refresh the leave list after deletion
                    fetchLeaveData();
                  }
                } else {
                  Fluttertoast.showToast(
                    msg: "Reason cannot be empty.",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    backgroundColor: Colors.orange,
                    textColor: Colors.white,
                    fontSize: 16.0,
                  );
                }
              },
              child: Text("Submit"),
            ),
          ],
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context,listen: false);
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
          'Leave Status',
          style: TextStyle(
            color: themeProvider.themeData.brightness == Brightness.light
                ? Colors.white
                : Color(0xFF57C9E7),
          ),
        ),
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          labelColor: Colors.white, // Active tab text color
          unselectedLabelColor: Colors.white60,
          indicatorColor: Colors.white, // Unselected tab text color
          tabs: [
            Tab(
              text: 'Today',
            ),
            Tab(text: 'Week'),
            Tab(text: 'Month'),
            Tab(text: 'Year')
          ],
        ),
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(
              color: themeProvider.themeData.brightness == Brightness.light
                  ? Colors.indigo.shade900
                  : Color(0xFF57C9E7),
            ))
          : Column(
              children: [
                // Filter Section
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      DropdownButton<String>(
                        value: selectedFilter,
                        items: [
                          'All',
                          'Sick',
                          'Casual',
                          'Paternity',
                          'Optional'
                        ].map((filter) {
                          return DropdownMenuItem<String>(
                            value: filter,
                            child: Text(filter),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            selectedFilter = value!;
                            _applyFilters();
                          });
                        },
                        hint: Text('Filter'),
                        style: TextStyle(
                          color: themeProvider.themeData.brightness ==
                                  Brightness.light
                              ? Colors.black
                              : Color(0xFF57C9E7),
                        ),
                      ),
                    ],
                  ),
                ),
                // Leave List
                Expanded(
                  child: buildLeaveList(filteredLeaveData),
                ),
              ],
            ),
    );
  }

  void _applyFilters() {
    setState(() {
      filteredLeaveData = allLeaveData.where((leave) {
        final typeMatch = selectedFilter == 'All' ||
            (leave['leaveType'] ?? '').toLowerCase().contains(
                  selectedFilter.toLowerCase(),
                );
        return typeMatch;
      }).toList();
    });
  }

  Widget buildLeaveList(List<Map<String, dynamic>> leaveData) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    if (leaveData.isEmpty) {
      return Center(
          child: Text(
        'No leaves found.',
        style: TextStyle(
          color: themeProvider.themeData.brightness == Brightness.light
              ? Colors.black
              : Colors.grey,
        ),
      ));
    }

    return ListView.builder(
      padding: EdgeInsets.all(16),
      itemCount: leaveData.length,
      itemBuilder: (context, index) {
        final leave = leaveData[index];
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Start Date: ${leave['startDate'] ?? 'N/A'}',
                  style: TextStyle(
                    color:
                        themeProvider.themeData.brightness == Brightness.light
                            ? Colors.grey[800]
                            : Colors.white,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'End Date: ${leave['endDate'] ?? 'N/A'}',
                  style: TextStyle(
                    color:
                        themeProvider.themeData.brightness == Brightness.light
                            ? Colors.grey[800]
                            : Colors.white,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Leave Type: ${leave['leaveType'] ?? 'N/A'}',
                  style: TextStyle(
                    fontSize: 14,
                    color:
                        themeProvider.themeData.brightness == Brightness.light
                            ? Colors.grey[800]
                            : Colors.white,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Duration Type: ${leave['durationType'] ?? 'N/A'}',
                  style: TextStyle(
                    fontSize: 14,
                    color:
                        themeProvider.themeData.brightness == Brightness.light
                            ? Colors.grey[800]
                            : Colors.white,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Reason: ${leave['reason'] ?? 'N/A'}',
                  style: TextStyle(
                    fontSize: 14,
                    color:
                        themeProvider.themeData.brightness == Brightness.light
                            ? Colors.grey[800]
                            : Colors.white,
                  ),
                ),
                SizedBox(height: 8),
                Row(
                  mainAxisAlignment:MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Status: ${leave['status'] ?? 'N/A'}',
                      style: TextStyle(
                        fontSize: 14,
                        color:
                            themeProvider.themeData.brightness == Brightness.light
                                ? Colors.grey[800]
                                : Colors.white,
                      ),
                    ),
                    if (leave['status']?.toLowerCase() == 'pending') // Check for status
                      IconButton(
                        icon: Icon(Icons.delete, color: Colors.red.shade900),
                        onPressed: () {
                          showDeleteDialog(context, leave['id'], widget.email!);
                        },
                      ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
