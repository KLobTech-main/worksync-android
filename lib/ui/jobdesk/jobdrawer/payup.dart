import 'package:dass/colortheme/theme_maneger.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../modal/payslipmodel.dart';
import '../../../webservices/api.dart';

class PaySlipScreen extends StatefulWidget {
  final String email;

  PaySlipScreen({required this.email});

  @override
  _PaySlipScreenState createState() => _PaySlipScreenState();
}

class _PaySlipScreenState extends State<PaySlipScreen> {
  late Future<List<PaySlipModel>> paySlipsFuture;

  @override
  void initState() {
    super.initState();
    paySlipsFuture = ApiService().getPaySlips(widget.email, context);
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
          'Payslips',
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
      body: FutureBuilder<List<PaySlipModel>>(
        future: paySlipsFuture,
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
                      : Colors.white),
            ));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
                child: Text(
              'No payslips found.',
              style: TextStyle(
                  color: themeProvider.themeData.brightness == Brightness.light
                      ? Colors.black
                      : Colors.white),
            ));
          } else {
            final payslips = snapshot.data!;
            print(payslips); // Print the response for debugging
            return ListView.builder(
              itemCount: payslips.length,
              itemBuilder: (context, index) {
                final payslip = payslips[index];
                return Card(
                  margin: EdgeInsets.all(10),
                  elevation: 5,
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Pay Slip ID: ${payslip.id}',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: themeProvider.themeData.brightness ==
                                      Brightness.light
                                  ? Colors.black
                                  : Colors.white),
                        ),
                        SizedBox(height: 5),
                        Text(
                          'Pay Run Period: ${payslip.payRunPeriod}',
                          style: TextStyle(
                              color: themeProvider.themeData.brightness ==
                                      Brightness.light
                                  ? Colors.black
                                  : Colors.grey),
                        ),
                        Text(
                          'Pay Run Type: ${payslip.payRunType}',
                          style: TextStyle(
                              color: themeProvider.themeData.brightness ==
                                      Brightness.light
                                  ? Colors.black
                                  : Colors.grey),
                        ),
                        Text(
                          'Status: ${payslip.status}',
                          style: TextStyle(
                              color: themeProvider.themeData.brightness ==
                                      Brightness.light
                                  ? Colors.black
                                  : Colors.grey),
                        ),
                        Text(
                          'Salary: ${payslip.salary}',
                          style: TextStyle(
                              color: themeProvider.themeData.brightness ==
                                      Brightness.light
                                  ? Colors.black
                                  : Colors.grey),
                        ),
                        Text(
                          'Net Salary: ${payslip.netSalary}',
                          style: TextStyle(
                              color: themeProvider.themeData.brightness ==
                                      Brightness.light
                                  ? Colors.black
                                  : Colors.grey),
                        ),
                        SizedBox(height: 10),
                        if (payslip.paySlipUrl != null &&
                            payslip.paySlipUrl!.isNotEmpty)
                          ElevatedButton(
                            onPressed: () {
                              // Open the payslip URL or navigate to a page
                              print(
                                  'Opening PaySlip URL: ${payslip.paySlipUrl}');
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: themeProvider
                                          .themeData.brightness ==
                                      Brightness.light
                                  ? Colors.indigo.shade900
                                  : Color(
                                      0xFF57C9E7), // Set the background color
                            ),
                            child: Text(
                              'View PaySlip',
                              style: TextStyle(
                                  color: themeProvider.themeData.brightness ==
                                          Brightness.light
                                      ? Colors.black
                                      : Colors.white),
                            ),
                          ),
                        SizedBox(height: 10),
                        Text(
                          'Details: ${payslip.details}',
                          style: TextStyle(
                              color: themeProvider.themeData.brightness ==
                                      Brightness.light
                                  ? Colors.black
                                  : Colors.white),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
