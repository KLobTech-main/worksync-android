import 'package:dass/colortheme/theme_maneger.dart';
import 'package:dass/ui/jobdesk/jobdrawer/bankdetails.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../modal/alluser.dart';
import '../../../webservices/api.dart';

class UserBankDetailsPage extends StatefulWidget {
  final String email;

  UserBankDetailsPage({required this.email});

  @override
  _UserBankDetailsPageState createState() => _UserBankDetailsPageState();
}

class _UserBankDetailsPageState extends State<UserBankDetailsPage> {
  late Future<BankDetails?> userBankDetails;

  @override
  void initState() {
    super.initState(); // Close the current page
    userBankDetails = ApiService.getUserBankDetailsByEmail(widget.email);
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
          "User Bank Details",
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
              : Color(0xFF57C9E7),
        ),
      ),
      body: FutureBuilder<BankDetails?>(
        future: userBankDetails,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
                child: CircularProgressIndicator(
              color: themeProvider.themeData.brightness == Brightness.light
                  ? Colors.indigo.shade900
                  : Color(0xFF57C9E7),
            ));
          }

          if (snapshot.hasError) {
            return Center(
                child: Text(
              "Error: ${snapshot.error}",
              style: TextStyle(
                color: themeProvider.themeData.brightness == Brightness.light
                    ? Colors.black
                    : Colors.white,
              ),
            ));
          }

          final bankDetails = snapshot.data;

          if (bankDetails == null) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.account_balance_wallet,
                      size: 100,
                      color:
                          themeProvider.themeData.brightness == Brightness.light
                              ? Colors.blue.shade900
                              : Color(0xFF57C9E7),
                    ),
                    SizedBox(height: 20),
                    Text(
                      "No Bank Details Available",
                      style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: themeProvider.themeData.brightness ==
                                  Brightness.light
                              ? Colors.black54
                              : Colors.white),
                    ),
                    SizedBox(height: 10),
                    Text(
                      "Please add your bank details to proceed.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 16,
                          color: themeProvider.themeData.brightness ==
                                  Brightness.light
                              ? Colors.black54
                              : Colors.white),
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        final result = Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                BankDetailsPage(email: widget.email),
                          ),
                        );
                        if (result == true) {
                          setState(() {
                            userBankDetails =
                                ApiService.getUserBankDetailsByEmail(
                                    widget.email);
                          });
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: themeProvider.themeData.brightness ==
                                Brightness.light
                            ? Colors.indigo.shade900
                            : Color(0xFF57C9E7),
                        padding:
                            EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: Text(
                        "Add Bank Details",
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Account Holder: ${bankDetails.accountHolderName}",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color:
                        themeProvider.themeData.brightness == Brightness.light
                            ? Colors.black
                            : Colors.white,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  "Bank Name: ${bankDetails.bankName}",
                  style: TextStyle(
                    color:
                        themeProvider.themeData.brightness == Brightness.light
                            ? Colors.black
                            : Colors.white,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  "Account Type: ${bankDetails.accountType}",
                  style: TextStyle(
                    color:
                        themeProvider.themeData.brightness == Brightness.light
                            ? Colors.black
                            : Colors.white,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  "Account Number: ${bankDetails.accountNumber}",
                  style: TextStyle(
                    color:
                        themeProvider.themeData.brightness == Brightness.light
                            ? Colors.black
                            : Colors.white,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  "IFSC Code: ${bankDetails.ifscCode}",
                  style: TextStyle(
                    color:
                        themeProvider.themeData.brightness == Brightness.light
                            ? Colors.black
                            : Colors.white,
                  ),
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // Navigate to BankDetailsPage and wait for result
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => BankDetailsPage(email: widget.email),
            ),
          );

          // If result is true, refresh the bank details
          if (result == true) {
            setState(() {
              userBankDetails =
                  ApiService.getUserBankDetailsByEmail(widget.email);
            });
          }
        },
        backgroundColor: themeProvider.themeData.brightness == Brightness.light
            ? Colors.indigo.shade900
            : Color(0xFF57C9E7),
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }
}
