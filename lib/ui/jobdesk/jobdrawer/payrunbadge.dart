import 'package:dass/colortheme/theme_maneger.dart';
import 'package:dass/modal/getuserbyemailmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../webservices/api.dart';

class PayrunAndBadgeScreen extends StatefulWidget {
  final String email;

  const PayrunAndBadgeScreen({Key? key, required this.email}) : super(key: key);
  @override
  State<PayrunAndBadgeScreen> createState() => _PayrunAndBadgeScreenState();
}

class _PayrunAndBadgeScreenState extends State<PayrunAndBadgeScreen> {
  late Future<SalaryDetails?> salaryDetailsFuture;

  @override
  void initState() {
    super.initState();
    salaryDetailsFuture = fetchSalaryDetails();
  }

  Future<SalaryDetails?> fetchSalaryDetails() async {
    try {
      final user = await ApiService.getUserByEmail(widget.email);
      if (user == null) {
        print('Error: User not found for email ${widget.email}');
        return null;
      }

      if (user.salaryDetails == null) {
        print('Error: Salary details are null for user: ${user.email}');
        return null;
      }

      // Directly return the SalaryDetails object since it's already deserialized
      return user.salaryDetails;
    } catch (e) {
      print('Error fetching salary details: $e');
      return null;
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
        iconTheme: IconThemeData(
          color: themeProvider.themeData.brightness == Brightness.light
              ? Colors.white
              : Color(0xFF57C9E7),
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
        elevation: 0,
        title: Text(
          'Payrun And Badge',
          style: TextStyle(
            color: themeProvider.themeData.brightness == Brightness.light
                ? Colors.white
                : Color(0xFF57C9E7),
          ),
        ),
        centerTitle: false,
      ),
      body: FutureBuilder<SalaryDetails?>(
        future: salaryDetailsFuture,
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
              "Error loading salary details",
              style: TextStyle(
                color: themeProvider.themeData.brightness == Brightness.light
                    ? Colors.black
                    : Colors.white,
              ),
            ));
          } else {
            final salaryDetails = snapshot.data;
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Payrun And Badge',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color:
                          themeProvider.themeData.brightness == Brightness.light
                              ? Colors.black
                              : Colors.white,
                    ),
                  ),
                  SizedBox(height: 20),
                  _buildSectionCard(
                    Icons.attach_money,
                    'Payrun period',
                    salaryDetails?.payRunPeriod ??
                        'Monthly\nConsider type - None',
                  ),
                  SizedBox(height: 20),
                  _buildSectionCard(
                    Icons.add,
                    'Allowance',
                    salaryDetails != null
                        ? 'House Rent Allowance: ${salaryDetails.houseRentAllowance}\n'
                            'Conveyance Allowance: ${salaryDetails.conveyanceAllowance}\n'
                            'Medical Allowances: ${salaryDetails.medicalAllowance}\n'
                            'Special Allowances: ${salaryDetails.specialAllowance}'
                        : 'Details not available',
                  ),
                  SizedBox(height: 20),
                  _buildSectionCard(
                    Icons.remove,
                    'Deduction',
                    'Details not available', // Update this when deduction data is available
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }

  Widget _buildSectionCard(IconData icon, String title, String description) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: themeProvider.themeData.brightness == Brightness.light
            ? Colors.white
            : Color.fromARGB(255, 21, 24, 30),
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: themeProvider.themeData.brightness == Brightness.light
                ? Colors.grey.withOpacity(0.5)
                : const Color.fromARGB(255, 0, 0, 0).withOpacity(0.3),
            blurRadius: 5,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon Section
          CircleAvatar(
            radius: 20,
            backgroundColor:
                themeProvider.themeData.brightness == Brightness.light
                    ? Colors.blue.shade900
                    : Color(0xFF57C9E7),
            child: Icon(icon, color: Colors.white),
          ),
          SizedBox(width: 16),

          // Title and Description Section
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color:
                          themeProvider.themeData.brightness == Brightness.light
                              ? Colors.black
                              : Colors.white),
                ),
                SizedBox(height: 8),
                Text(
                  description,
                  style: TextStyle(
                      fontSize: 14,
                      color:
                          themeProvider.themeData.brightness == Brightness.light
                              ? Colors.grey[700]
                              : Colors.grey),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
