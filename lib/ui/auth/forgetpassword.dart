import 'package:dass/colortheme/theme_maneger.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

import '../../webservices/api.dart';

class ResetPasswordScreen extends StatefulWidget {
  String? email;
  ResetPasswordScreen({required this.email});
  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final TextEditingController emailController = TextEditingController();

  final TextEditingController otpController = TextEditingController();

  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmNewPasswordController =
      TextEditingController();

  final _formKey = GlobalKey<FormState>();

  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return "Email cannot be empty.";
    }
    final emailRegex =
        RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$");
    if (!emailRegex.hasMatch(value)) {
      return "Enter a valid email address.";
    }
    return null;
  }

  String? validateOTP(String? value) {
    if (value == null || value.isEmpty) {
      return "OTP cannot be empty.";
    }
    if (value.length != 6) {
      return "OTP must be 6 digits.";
    }
    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return "Password cannot be empty.";
    }
    if (value.length < 8) {
      return "Password must be at least 8 characters.";
    }
    if (!RegExp(r'[A-Z]').hasMatch(value) ||
        !RegExp(r'[a-z]').hasMatch(value) ||
        !RegExp(r'[0-9]').hasMatch(value) ||
        !RegExp(r'[!@#\$&*~]').hasMatch(value)) {
      return "Password must include upper, lower, digit, and special character.";
    }
    return null;
  }

  String? validateConfirmPassword(String? value) {
    if (value != newPasswordController.text) {
      return "Passwords do not match.";
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context,listen:false);
    return Scaffold(
      backgroundColor: themeProvider.themeData.brightness == Brightness.light
          ? Colors.white
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
          "Reset Password",
          style: TextStyle(
              color: themeProvider.themeData.brightness == Brightness.light
                  ? Colors.white
                  : Color(0xFF57C9E7)),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                style: TextStyle(
                  color: themeProvider.themeData.brightness == Brightness.light
                      ? Colors.black
                      : Colors.white,
                ),
                controller: emailController,
                decoration: InputDecoration(
                  labelText: "Email",

                  labelStyle: TextStyle(
                    color:
                        themeProvider.themeData.brightness == Brightness.light
                            ? Colors.black
                            : Colors.white,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide(
                      color:
                          themeProvider.themeData.brightness == Brightness.light
                              ? Colors.black.withOpacity(0.3)
                              : Colors.white.withOpacity(0.3),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide(
                      color:
                          themeProvider.themeData.brightness == Brightness.light
                              ? Colors.black
                              : Colors.grey,
                      width: 2,
                    ),
                  ), // Added border
                ),
                validator: validateEmail,
              ),
              SizedBox(height: 10),
              TextFormField(
                style: TextStyle(
                  color: themeProvider.themeData.brightness == Brightness.light
                      ? Colors.black
                      : Colors.white,
                ),
                controller: otpController,
                decoration: InputDecoration(
                  labelText: "OTP",
                  labelStyle: TextStyle(
                    color:
                        themeProvider.themeData.brightness == Brightness.light
                            ? Colors.black
                            : Colors.white,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide(
                      color:
                          themeProvider.themeData.brightness == Brightness.light
                              ? Colors.black.withOpacity(0.3)
                              : Colors.white.withOpacity(0.3),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide(
                      color:
                          themeProvider.themeData.brightness == Brightness.light
                              ? Colors.black
                              : Colors.grey,
                      width: 2,
                    ),
                  ), // Added border
                ),
                validator: validateOTP,
              ),
              SizedBox(height: 10),
              TextFormField(
                style: TextStyle(
                  color: themeProvider.themeData.brightness == Brightness.light
                      ? Colors.black
                      : Colors.white,
                ),
                controller: newPasswordController,
                decoration: InputDecoration(
                  labelText: "New Password",
                  labelStyle: TextStyle(
                    color:
                        themeProvider.themeData.brightness == Brightness.light
                            ? Colors.black
                            : Colors.white,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide(
                      color:
                          themeProvider.themeData.brightness == Brightness.light
                              ? Colors.black.withOpacity(0.3)
                              : Colors.white.withOpacity(0.3),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide(
                      color:
                          themeProvider.themeData.brightness == Brightness.light
                              ? Colors.black
                              : Colors.grey,
                      width: 2,
                    ),
                  ), // Added border
                ),
                validator: validatePassword,
                obscureText: true,
              ),
              SizedBox(height: 10),
              TextFormField(
                style: TextStyle(
                  color: themeProvider.themeData.brightness == Brightness.light
                      ? Colors.black
                      : Colors.white,
                ),
                controller: confirmNewPasswordController,
                decoration: InputDecoration(
                  labelText: "Confirm New Password",
                  labelStyle: TextStyle(
                    color:
                        themeProvider.themeData.brightness == Brightness.light
                            ? Colors.black
                            : Colors.white,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide(
                      color:
                          themeProvider.themeData.brightness == Brightness.light
                              ? Colors.black.withOpacity(0.3)
                              : Colors.white.withOpacity(0.3),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide(
                      color:
                          themeProvider.themeData.brightness == Brightness.light
                              ? Colors.black
                              : Colors.grey,
                      width: 2,
                    ),
                  ), // Added border
                ),
                validator: validateConfirmPassword,
                obscureText: true,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    final email = emailController.text.trim();
                    final otp = otpController.text.trim();
                    final newPassword = newPasswordController.text.trim();
                    final isSuccess = await ApiService.resetForgotPassword(
                        email, otp, newPassword, context);

                    if (isSuccess) {
                      Fluttertoast.showToast(
                        msg: "Password reset successfully!",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        timeInSecForIosWeb: 1,
                        backgroundColor: themeProvider.themeData.brightness ==
                                Brightness.light
                            ? Colors.indigo.shade900
                            : Color(0xFF57C9E7),
                        textColor: Colors.white,
                        fontSize: 16.0,
                      );
                    } else {
                      Fluttertoast.showToast(
                        msg: "Failed to reset password.",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Colors.red,
                        textColor: Colors.white,
                        fontSize: 16.0,
                      );
                    }
                  }
                },
                child: Text(
                  "Confirm Password",
                ),
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.resolveWith<Color>((states) {
                    if (states.contains(MaterialState.pressed)) {
                      // Color when pressed
                      return themeProvider.themeData.brightness ==
                              Brightness.light
                          ? Colors.indigo.shade900
                          : Color(0xFF57C9E7);
                    }
                    // Default color
                    return themeProvider.themeData.brightness ==
                            Brightness.light
                        ? Colors.indigo.shade900
                        : Color(0xFF57C9E7);
                  }),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
