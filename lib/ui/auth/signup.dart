import 'dart:convert';

import 'package:dass/colortheme/theme_maneger.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

import '../../webservices/api.dart';
import 'appvalidation.dart';
import 'login.dart';

class Signup extends StatefulWidget {
  Signup({Key? key}) : super(key: key);

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _userNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _mobileNoController = TextEditingController();

  final TextEditingController _dobController = TextEditingController();
  bool _isPressed = false;
  bool _passwordVisible = false;
  bool _isLoader = false;
  bool isChecked = false;
  bool _approvedByAdmin = false;

  final AppValidator appValidator = AppValidator();

  Future<void> _submitForm() async {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (!isChecked) {
      Fluttertoast.showToast(
        msg: "Please agree to the terms and conditions",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: themeProvider.themeData.brightness == Brightness.light
            ? Colors.indigo.shade900
            : Color(0xFF57C9E7),
        textColor: Colors.white,
        fontSize: 16.0,
      );

      return;
    }

    final userData = {
      "name": _userNameController.text.trim(),
      "email": _emailController.text.trim(),
      "password": _passwordController.text.trim(),
      "mobileNo": _mobileNoController.text.trim(),
      "approvedByAdmin": _approvedByAdmin,
      "dob": _dobController.text
    };

    setState(() {
      _isLoader = true;
    });

    try {
      final response = await ApiService.registerUser(userData);

      if (response.statusCode == 200) {
        Fluttertoast.showToast(
          msg: "Registration Successful!",
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
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LogIn()),
        );
      } else {
        final errorData = jsonDecode(response.body);

        Fluttertoast.showToast(
          msg: "Error: ${errorData['message']}",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      }
    } catch (e) {
      Fluttertoast.showToast(
        msg: "Error: $e",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    } finally {
      setState(() {
        _isLoader = false;
      });
    }
  }

  Future<void> _selectDOB() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime(2000),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.dark(
              primary: Color(0xFF57C9E7), // Header background color
              onPrimary: Colors.white, // Header text color
              surface: Colors.grey[850]!, // Dialog background color
              onSurface: Colors.white, // Text color
            ),
            dialogBackgroundColor:
                Colors.grey[900], // Background color for the dialog
          ),
          child: child!,
        );
      },
    );

    if (pickedDate != null) {
      // Format the date as dd/mm/yyyy
      String formattedDate = "${pickedDate.day.toString().padLeft(2, '0')}/"
          "${pickedDate.month.toString().padLeft(2, '0')}/"
          "${pickedDate.year}";
      setState(() {
        _dobController.text = formattedDate;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.themeData.brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : Colors.black;
    final fieldColor = isDark ? Color(0xFF1C1F26) : Colors.white;

    return Scaffold(
      backgroundColor: themeProvider.themeData.brightness == Brightness.light
          ? Colors.white
          : Color(0xFF1C1F26),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Center(
          child: Text(
            "Sign Up",
            style: TextStyle(
                color: themeProvider.themeData.brightness == Brightness.light
                    ? Colors.white
                    : Color(0xFF57C9E7)),
          ),
        ),
        iconTheme: IconThemeData(
            color: themeProvider.themeData.brightness == Brightness.light
                ? Colors.white
                : Color(0xFF57C9E7)),
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
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildTextField(
                    controller: _userNameController,
                    label: 'Name',
                    validator: appValidator.validateUsername,
                    textColor: textColor,
                    fieldColor: fieldColor,
                  ),
                  SizedBox(height: 20),
                  _buildTextField(
                    controller: _emailController,
                    label: 'Email',
                    keyboardType: TextInputType.emailAddress,
                    validator: appValidator.validateEmail,
                    textColor: textColor,
                    fieldColor: fieldColor,
                  ),
                  SizedBox(height: 20),
                  _buildTextField(
                    controller: _mobileNoController,
                    label: 'Mobile Number',
                    keyboardType: TextInputType.phone,
                    validator: appValidator.validateMobileNo,
                    textColor: textColor,
                    fieldColor: fieldColor,
                  ),
                  SizedBox(height: 20),
                  _buildTextField(
                    controller: _passwordController,
                    label: 'Password',
                    obscureText: !_passwordVisible,
                    suffixIcon: IconButton(
                      icon: Icon(
                        _passwordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                          _passwordVisible = !_passwordVisible;
                        });
                      },
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter your password";
                      }
                      if (value.length < 6) {
                        return "Password must be at least 6 characters";
                      }
                      return null;
                    },
                    textColor: textColor,
                    fieldColor: fieldColor,
                  ),
                  SizedBox(height: 20),
                  // _buildTextField(
                  //   controller: _joiningDateController,
                  //   label: 'Joining Date',
                  //   validator: appValidator.validateJoinDate,
                  //   readOnly: true,
                  //   suffixIcon: Icon(Icons.calendar_today),
                  //   onTap: () async {
                  //     DateTime? pickedDate = await showDatePicker(
                  //       context: context,
                  //       initialDate: DateTime.now(),
                  //       firstDate: DateTime(2000),
                  //       lastDate: DateTime(2100),
                  //     );

                  //     if (pickedDate != null) {
                  //       String formattedDate =
                  //           "${pickedDate.day}-${pickedDate.month}-${pickedDate.year}";
                  //       setState(() {
                  //         _joiningDateController.text = formattedDate;
                  //       });
                  //     }
                  //   },
                  // ),
                  // SizedBox(height: 20),
                  _buildTextField(
                    controller: _dobController,
                    label: 'Date of Birth',
                    readOnly: true,
                    onTap: _selectDOB,
                    suffixIcon: Icon(Icons.calendar_today),
                    validator: (value) => value?.isEmpty == true
                        ? "Please select your DOB"
                        : null,
                    textColor: textColor,
                    fieldColor: fieldColor,
                  ),
                  // SizedBox(height: 20),
                  // _buildTextField(
                  //     controller: _departmentController,
                  //     label: 'Department',
                  //     validator: appValidator.validateDepartment),
                  SizedBox(height: 40),
                  Row(
                    children: [
                      Checkbox(
                        value: isChecked,
                        onChanged: (value) {
                          setState(() {
                            isChecked = value!;
                          });
                        },
                        activeColor: isDark
                            ? Color(0xFF57C9E7)
                            : Colors.indigo.shade900, // Checkbox color
                        checkColor: isDark
                            ? Colors.black
                            : Colors.white, // Checkmark color
                        side: BorderSide(
                          color: isDark
                              ? Colors.white
                              : Colors.black, // Border color for the checkbox
                          width: 1.5,
                        ),
                      ),
                      Flexible(
                        child: RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                  text: "By Signing up, you agree to the ",
                                  style: TextStyle(
                                    color: themeProvider.themeData.brightness ==
                                            Brightness.light
                                        ? Colors.black
                                        : Colors.white,
                                  )),
                              TextSpan(
                                text: "Terms ",
                                style: TextStyle(
                                  color: themeProvider.themeData.brightness ==
                                          Brightness.light
                                      ? Color.fromRGBO(127, 61, 255, 1)
                                      : Color(0xFF57C9E7),
                                  fontSize: 15,
                                ),
                              ),
                              TextSpan(
                                text: "of Service and Privacy Policy",
                                style: TextStyle(
                                  color: themeProvider.themeData.brightness ==
                                          Brightness.light
                                      ? Color.fromRGBO(127, 61, 255, 1)
                                      : Color(0xFF57C9E7),
                                  fontSize: 15,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),

                  Container(
                    height: 50,
                    width: double.infinity,
                    child: GestureDetector(
                      onTapDown: (_) {
                        setState(() {
                          _isPressed = true; // Trigger animation on light press
                        });
                      },
                      onTapUp: (_) {
                        setState(() {
                          _isPressed = false; // Revert animation when released
                        });
                      },
                      onTapCancel: () {
                        setState(() {
                          _isPressed =
                              false; // Revert animation if press is canceled
                        });
                      },
                      child: AnimatedScale(
                        scale: _isPressed
                            ? 0.95
                            : 1.0, // Zoom in on press, zoom out when released
                        duration: Duration(
                            milliseconds: 100), // Duration of the animation
                        child: ElevatedButton(
                          onPressed: _isLoader ? null : _submitForm,
                          child: Text(
                            "Sign Up",
                            style: TextStyle(fontSize: 20, color: Colors.white),
                          ),
                          // style: ButtonStyle(
                          //   backgroundColor:
                          //       MaterialStateProperty.resolveWith<Color>((states) {
                          //     if (states.contains(MaterialState.pressed)) {
                          //       return Colors.indigo.shade900; // Color when pressed
                          //     }
                          //     return Colors.indigo.shade900; // Default color
                          //   }),
                          // ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                themeProvider.themeData.brightness ==
                                        Brightness.light
                                    ? Colors.indigo.shade900
                                    : Color(0xFF57C9E7),
                          ),
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: 20),
                  TextButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => LogIn()),
                      );
                    },
                    child: RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: "Already have an account? ",
                            style: TextStyle(color: Colors.grey, fontSize: 17),
                          ),
                          TextSpan(
                            text: "Login",
                            style: TextStyle(
                              color: themeProvider.themeData.brightness ==
                                      Brightness.light
                                  ? Color.fromRGBO(127, 61, 255, 1)
                                  : Color(0xFF57C9E7),
                              fontSize: 17,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (_isLoader)
            Container(
                color: Colors.black.withOpacity(0.5),
                child: Center(
                    child: CircularProgressIndicator(
                  color: themeProvider.themeData.brightness == Brightness.light
                      ? Colors.indigo.shade900
                      : Color(0xFF57C9E7),
                )))
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    FormFieldValidator<String>? validator,
    TextInputType keyboardType = TextInputType.text,
    bool obscureText = false,
    VoidCallback? onTap,
    bool readOnly = false,
    Widget? suffixIcon,
    required Color textColor,
    required Color fieldColor,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      readOnly: readOnly,
      onTap: onTap,
      validator: validator,
      style: TextStyle(color: textColor), // Text color
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: textColor), // Label color
        hintStyle: TextStyle(color: textColor.withOpacity(0.6)), // Hint color
        filled: true,
        fillColor: fieldColor, // Background color
        suffixIcon: suffixIcon,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide:
              BorderSide(color: textColor.withOpacity(0.4)), // Enabled border
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(color: textColor), // Focused border
        ),
      ),
    );
  }
}
