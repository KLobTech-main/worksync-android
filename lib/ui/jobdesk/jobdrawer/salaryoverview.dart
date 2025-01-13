import 'package:dass/colortheme/theme_maneger.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../webservices/api.dart';

class SalaryOverviewPage extends StatefulWidget {
  final String email;

  const SalaryOverviewPage({Key? key, required this.email}) : super(key: key);

  @override
  _SalaryOverviewPageState createState() => _SalaryOverviewPageState();
}

class _SalaryOverviewPageState extends State<SalaryOverviewPage> {
  late Future<List<String>> salaryOverviewFuture;

  @override
  void initState() {
    super.initState();
    salaryOverviewFuture = fetchSalaryOverview(widget.email);
  }

  Future<List<String>> fetchSalaryOverview(String email) async {
    final user = await ApiService.getUserByEmail(
        email); // Ensure the class is correctly referenced
    return user?.salaryOverview ?? ["0", "0"];
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
        title: Text(
          "Salary Overview",
          style: TextStyle(
            color: themeProvider.themeData.brightness == Brightness.light
                ? Colors.white
                : Color(0xFF57C9E7),
          ),
        ),
        iconTheme: IconThemeData(
          color: themeProvider.themeData.brightness == Brightness.light
              ? Colors.white
              : Color(0xFF57C9E7),
        ),
      ),
      body: FutureBuilder<List<String>>(
        future: salaryOverviewFuture,
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
              "Error loading salary data",
              style: TextStyle(
                color: themeProvider.themeData.brightness == Brightness.light
                    ? Colors.black
                    : Colors.white,
              ),
            ));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
                child: Text(
              "No data available",
              style: TextStyle(
                color: themeProvider.themeData.brightness == Brightness.light
                    ? Colors.black
                    : Colors.white,
              ),
            ));
          }

          final salaryOverview = snapshot.data!;
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Salary Overview",
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color:
                          themeProvider.themeData.brightness == Brightness.light
                              ? Colors.black
                              : Colors.white),
                ),
                SizedBox(height: 16),
                Expanded(
                  child: ListView.builder(
                    itemCount: salaryOverview.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        leading: Icon(
                          Icons.monetization_on,
                          color: themeProvider.themeData.brightness ==
                                  Brightness.light
                              ? Colors.indigo.shade900
                              : Color(0xFF57C9E7),
                        ),
                        title: Text(
                          "Pay Period ${index + 1}",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Text(
                          "₹${salaryOverview[index]}",
                          style: TextStyle(
                              color: themeProvider.themeData.brightness ==
                                      Brightness.light
                                  ? Colors.black
                                  : Colors.grey),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
