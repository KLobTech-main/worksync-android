import 'package:dass/colortheme/theme_maneger.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

import '../../../webservices/api.dart';

class BankDetailsPage extends StatefulWidget {
  final String email;

  BankDetailsPage({required this.email});
  @override
  _BankDetailsPageState createState() => _BankDetailsPageState();
}

class _BankDetailsPageState extends State<BankDetailsPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController accountHolderNameController =
      TextEditingController();
  final TextEditingController bankNameController = TextEditingController();
  final TextEditingController accountNumberController = TextEditingController();
  final TextEditingController ifscCodeController = TextEditingController();
  final TextEditingController branchNameController = TextEditingController();
  final TextEditingController upiIdController = TextEditingController();
  bool isLoading = false;

  String? selectedAccountType;
  @override
  void initState() {
    super.initState();
  }

  void _submitForm() async {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    if (_formKey.currentState!.validate()) {
      final bankDetails = {
        "accountHolderName": accountHolderNameController.text,
        "accountType": selectedAccountType ?? "",
        "accountNumber": accountNumberController.text,
        "ifscCode": ifscCodeController.text,
        "bankName": bankNameController.text,
      };

      try {
        await ApiService.submitBankDetails(
            email: widget.email, bankDetails: bankDetails, context);

        Fluttertoast.showToast(
          msg: "Bank details submitted successfully!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor:
              themeProvider.themeData.brightness == Brightness.light
                  ? Colors.indigo.shade900
                  : Color(0xFF57C9E7),
          textColor: Colors.white,
          fontSize: 16.0,
        );

        // Clear the form fields after submission
        accountHolderNameController.clear();
        bankNameController.clear();
        accountNumberController.clear();
        ifscCodeController.clear();
        selectedAccountType = null; // Reset account type

        // Go back to the previous page and refresh the bank details
        Navigator.pop(context, true); // Pass 'true' to indicate update success
      } catch (e) {
        Fluttertoast.showToast(
          msg: "Error submitting bank details: $e",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      }
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
        title: Text(
          "Bank Details",
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
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Bank Details",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: themeProvider.themeData.brightness == Brightness.light
                      ? Colors.blue.shade900
                      : Color(0xFF57C9E7),
                ),
              ),
              SizedBox(height: 20),

              // Account Holder Name
              TextFormField(
                controller: accountHolderNameController,
                decoration: InputDecoration(
                  labelText: "Account Holder Name",
                  labelStyle: TextStyle(
                    color:
                        themeProvider.themeData.brightness == Brightness.light
                            ? Colors.black
                            : Colors.white,
                  ),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                      color:
                          themeProvider.themeData.brightness == Brightness.light
                              ? Colors.grey
                              : Color(0xFF57C9E7),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color:
                          themeProvider.themeData.brightness == Brightness.light
                              ? Colors.blue
                              : Colors.grey,
                      width: 2.0,
                    ),
                  ),
                  filled: true,
                  fillColor:
                      themeProvider.themeData.brightness == Brightness.light
                          ? Colors.white
                          : Color(0xFF1C1F26),
                ),
                style: TextStyle(
                  color: themeProvider.themeData.brightness == Brightness.light
                      ? Colors.black
                      : Colors.white,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter account holder name";
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),

              TextFormField(
                controller: bankNameController,
                decoration: InputDecoration(
                  labelText: "Bank Name",
                  labelStyle: TextStyle(
                    color:
                        themeProvider.themeData.brightness == Brightness.light
                            ? Colors.black
                            : Colors.white,
                  ),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                      color:
                          themeProvider.themeData.brightness == Brightness.light
                              ? Colors.grey
                              : Color(0xFF57C9E7),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color:
                          themeProvider.themeData.brightness == Brightness.light
                              ? Colors.blue
                              : Colors.grey,
                      width: 2.0,
                    ),
                  ),
                  filled: true,
                  fillColor:
                      themeProvider.themeData.brightness == Brightness.light
                          ? Colors.white
                          : Color(0xFF1C1F26),
                ),
                style: TextStyle(
                  color: themeProvider.themeData.brightness == Brightness.light
                      ? Colors.black
                      : Colors.white,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter bank name";
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),

              // Account Number
              TextFormField(
                controller: accountNumberController,
                decoration: InputDecoration(
                  labelText: "Account Number",
                  labelStyle: TextStyle(
                    color:
                        themeProvider.themeData.brightness == Brightness.light
                            ? Colors.black
                            : Colors.white,
                  ),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                      color:
                          themeProvider.themeData.brightness == Brightness.light
                              ? Colors.grey
                              : Color(0xFF57C9E7),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color:
                          themeProvider.themeData.brightness == Brightness.light
                              ? Colors.blue
                              : Colors.grey,
                      width: 2.0,
                    ),
                  ),
                  filled: true,
                  fillColor:
                      themeProvider.themeData.brightness == Brightness.light
                          ? Colors.white
                          : Color(0xFF1C1F26),
                ),
                style: TextStyle(
                  color: themeProvider.themeData.brightness == Brightness.light
                      ? Colors.black
                      : Colors.white,
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter account number";
                  }
                  if (value.length < 10) {
                    return "Account number must be at least 10 digits";
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: ifscCodeController,
                decoration: InputDecoration(
                  labelText: "IFSC Code",
                  labelStyle: TextStyle(
                    color:
                        themeProvider.themeData.brightness == Brightness.light
                            ? Colors.black
                            : Colors.white,
                  ),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                      color:
                          themeProvider.themeData.brightness == Brightness.light
                              ? Colors.grey
                              : Color(0xFF57C9E7),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color:
                          themeProvider.themeData.brightness == Brightness.light
                              ? Colors.blue
                              : Colors.grey,
                      width: 2.0,
                    ),
                  ),
                  filled: true,
                  fillColor:
                      themeProvider.themeData.brightness == Brightness.light
                          ? Colors.white
                          : Color(0xFF1C1F26),
                ),
                style: TextStyle(
                  color: themeProvider.themeData.brightness == Brightness.light
                      ? Colors.black
                      : Colors.white,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter IFSC code";
                  }
                  if (!RegExp(r"^[A-Za-z]{4}\d{7}$").hasMatch(value)) {
                    return "Enter a valid IFSC code";
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              // Account Type
              DropdownButtonFormField<String>(
                value: selectedAccountType,
                decoration: InputDecoration(
                  labelText: "Account Type",
                  labelStyle: TextStyle(
                    color:
                        themeProvider.themeData.brightness == Brightness.light
                            ? Colors.black
                            : Colors.white,
                  ),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                      color:
                          themeProvider.themeData.brightness == Brightness.light
                              ? Colors.grey
                              : Color(0xFF57C9E7),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color:
                          themeProvider.themeData.brightness == Brightness.light
                              ? Colors.blue
                              : Colors.grey,
                      width: 2.0,
                    ),
                  ),
                  filled: true,
                  fillColor:
                      themeProvider.themeData.brightness == Brightness.light
                          ? Colors.white
                          : Color(0xFF1C1F26),
                ),
                style: TextStyle(
                  color: themeProvider.themeData.brightness == Brightness.light
                      ? Colors.black
                      : Colors.white,
                ),
                items: ["Savings", "Current"].map((String type) {
                  return DropdownMenuItem<String>(
                    value: type,
                    child: Text(type),
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    selectedAccountType = newValue;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please select account type";
                  }
                  return null;
                },
              ),
              SizedBox(height: 32),

              Center(
                child: ElevatedButton(
                  onPressed: _submitForm,
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                    backgroundColor:
                        themeProvider.themeData.brightness == Brightness.light
                            ? Colors.indigo.shade900
                            : Color(0xFF57C9E7),
                  ),
                  child: Text("Submit",
                      style: TextStyle(fontSize: 16, color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
