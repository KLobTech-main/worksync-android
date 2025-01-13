import 'dart:convert';

import 'package:dass/colortheme/theme_maneger.dart';
import 'package:dass/screens/home_screen.dart';
import 'package:dass/ui/auth/forgetpassword.dart';
import 'package:dass/ui/auth/signup.dart';
import 'package:dass/webservices/api.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

// class LogIn extends StatefulWidget {
//   const LogIn({Key? key}) : super(key: key);

//   @override
//   State<LogIn> createState() => _LogInState();
// }

// class _LogInState extends State<LogIn> {
//   final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
//   final TextEditingController _emailController = TextEditingController();
//   final TextEditingController _passwordController = TextEditingController();

//   final double _roomLatitude = 37.4219983;
//   final double _roomLongitude = -122.084;
//   final double _radiusInMeters = 50;

//   bool _isLoading = false;
//   bool _passwordVisible = false;

//   Future<bool> _isWithinRadius() async {
//     bool serviceEnabled;
//     LocationPermission permission;

//     serviceEnabled = await Geolocator.isLocationServiceEnabled();
//     if (!serviceEnabled) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Please enable location services.")),
//       );
//       return false;
//     }

//     permission = await Geolocator.checkPermission();
//     if (permission == LocationPermission.denied) {
//       permission = await Geolocator.requestPermission();
//       if (permission == LocationPermission.denied) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text("Location permission is denied.")),
//         );
//         return false;
//       }
//     }

//     if (permission == LocationPermission.deniedForever) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//             content: Text("Location permissions are permanently denied.")),
//       );
//       return false;
//     }

//     Position position = await Geolocator.getCurrentPosition(
//       desiredAccuracy: LocationAccuracy.high,
//     );

//     debugPrint(
//         'Current Position: Latitude: ${position.latitude}, Longitude: ${position.longitude}');

//     double distance = Geolocator.distanceBetween(
//       position.latitude,
//       position.longitude,
//       _roomLatitude,
//       _roomLongitude,
//     );

//     debugPrint('Calculated Distance: $distance meters');
//     return distance <= _radiusInMeters;
//   }

//   Future<void> _login() async {
//     if (!_formKey.currentState!.validate()) return;

//     setState(() {
//       _isLoading = true;
//     });

//     try {
//       // bool isNearby = await _isWithinRadius();
//       // if (!isNearby) {
//       //   ScaffoldMessenger.of(context).showSnackBar(
//       //     SnackBar(
//       //       content:
//       //           Text("You must be within $_radiusInMeters meters to log in."),
//       //     ),
//       //   );
//       //   return;
//       // }
//       final response = await ApiService.loginUser(
//         _emailController.text.trim(),
//         _passwordController.text.trim(),
//       );

//       final data = jsonDecode(response.body);

//       if (response.statusCode == 200) {
//         if (data['status'] == 'PendingApproval') {
//           showDialog(
//             context: context,
//             builder: (context) {
//               return AlertDialog(
//                 title: const Text('Approval Needed'),
//                 content: const Text('Your account needs admin approval.'),
//                 actions: [
//                   TextButton(
//                     onPressed: () => Navigator.of(context).pop(),
//                     child: const Text('OK'),
//                   ),
//                 ],
//               );
//             },
//           );
//         } else {
//           final user = data['user'];
//           String? name = user['name'];
//           String? email = user['email'];

//           // Login success
//           ScaffoldMessenger.of(context).showSnackBar(
//             const SnackBar(content: Text('Login successful')),
//           );

//           SharedPreferences prefs = await SharedPreferences.getInstance();
//           prefs.setBool('isLoggedIn', true);
//           prefs.setString('userEmail', _emailController.text.trim());
//           await _saveLoginTimestamp();

//           Navigator.pushReplacement(
//             context,
//             MaterialPageRoute(
//               builder: (context) => HomeScreen(
//                 name: name,
//                 email: email,
//               ),
//             ),
//           );
//           debugPrint("namehome : $name");
//           debugPrint("emailtohome : $email");
//         }
//       } else if (response.statusCode == 401) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text("Incorrect email or password.")),
//         );
//       } else {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//               content:
//                   Text("Error: ${data['message'] ?? 'Something went wrong'}")),
//         );
//       }
//     } catch (e) {
//       if (e.toString().contains('SocketException')) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//               content: Text("Network Error: Please check your connection.")),
//         );
//       } else {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text("Unexpected Error: $e")),
//         );
//       }
//     } finally {
//       setState(() {
//         _isLoading = false;
//       });
//     }
//   }

//   Future<void> _saveLoginTimestamp() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     await prefs.setInt('loginTimestamp', DateTime.now().millisecondsSinceEpoch);
//   }

class LogIn extends StatefulWidget {
  const LogIn({Key? key}) : super(key: key);

  @override
  State<LogIn> createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isLoading = false;
  bool _passwordVisible = false;
  bool _isPressed = false;

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;
    FocusScope.of(context).unfocus();

    setState(() {
      _isLoading = true;
    });

    try {
      final response = await ApiService.loginUser(
        _emailController.text.trim(),
        _passwordController.text.trim(),
      );

      if (response == null) {
        Fluttertoast.showToast(
          timeInSecForIosWeb: 2,
          msg: "Network error: Unable to connect to the server.",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0,
        );

        return;
      }
      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        if (data['status'] == 'PendingApproval') {
          Fluttertoast.showToast(
            timeInSecForIosWeb: 2,
            msg: "Account approval pending. Please contact admin.",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0,
          );
        } else {
          final user = data['user'];
          String? name = user['name'];
          String? email = user['email'];

          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setBool('isLoggedIn', true);
          prefs.setString('userEmail', email ?? '');
          prefs.setString('userName', name ?? '');
          await _saveLoginTimestamp();

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => HomeScreen(name: name, email: email),
            ),
          );

          _showToast('Login successful');
        }
      } else if (response.statusCode == 400) {
        Fluttertoast.showToast(
          timeInSecForIosWeb: 2,
          msg: "Invalid email or password.",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      } else {
        Fluttertoast.showToast(
          timeInSecForIosWeb: 2,
          msg:
              'Error: ${response.body.isNotEmpty ? response.body : 'Something went wrong'}',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      }
    } catch (e) {
      Fluttertoast.showToast(
        timeInSecForIosWeb: 2,
        msg: 'Unexpected error: $e',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _saveLoginTimestamp() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('loginTimestamp', DateTime.now().millisecondsSinceEpoch);
  }

  void _showDialog({required String title, required String message}) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _showToast(String message) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    Fluttertoast.showToast(
      timeInSecForIosWeb: 3,
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: themeProvider.themeData.brightness == Brightness.light
          ? Colors.indigo.shade900 // Default active color in light mode
          : Color(0xFF57C9E7),
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  void showForgotPasswordDialog(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    TextEditingController emailController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          "Enter your email",
          style: TextStyle(
            color: themeProvider.themeData.brightness == Brightness.light
                ? Colors.black
                : Colors.white,
          ),
        ),
        content: TextField(
          style: TextStyle(
            color: themeProvider.themeData.brightness == Brightness.light
                ? Colors.black
                : Colors.white,
          ),
          controller: emailController,
          decoration: InputDecoration(
            labelText: "Email",
            labelStyle: TextStyle(
              color: themeProvider.themeData.brightness == Brightness.light
                  ? Colors.black
                  : Colors.white,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: BorderSide(
                color: themeProvider.themeData.brightness == Brightness.light
                    ? Colors.black.withOpacity(0.3)
                    : Colors.white.withOpacity(0.3),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: BorderSide(
                color: themeProvider.themeData.brightness == Brightness.light
                    ? Colors.black
                    : Colors.grey,
                width: 2,
              ),
            ), // Added border
          ),
        ),
        actions: [
          TextButton(
            onPressed: () async {
              final email = emailController.text.trim();
              final isSuccess = await ApiService.forgotPassword(email);

              if (isSuccess) {
                Navigator.pop(context); // Close the dialog
                print("OTP sent to your email!");

                // Show the toast message
                Fluttertoast.showToast(
                  msg: "OTP sent successfully!",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  backgroundColor:
                      themeProvider.themeData.brightness == Brightness.light
                          ? Colors.indigo
                              .shade900 // Default active color in light mode
                          : Color(0xFF57C9E7),
                  textColor: Colors.white,
                );

                // Navigate to ResetPasswordScreen with the entered email
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ResetPasswordScreen(email: email)),
                );
              } else {
                print("Failed to send OTP.");

                Fluttertoast.showToast(
                  msg: "Failed to send OTP. Please try again.",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  backgroundColor: Colors.red,
                  textColor: Colors.white,
                );
              }
            },
            child: Text(
              "Send OTP",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: themeProvider.themeData.brightness == Brightness.light
                    ? Colors.indigo.shade900
                    : const Color(0xFF57C9E7),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
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
        title: Center(
          child: Text("Log In",
              style: TextStyle(
                color: themeProvider.themeData.brightness == Brightness.light
                    ? Colors.white
                    : Color(0xFF57C9E7),
              )),
        ),
        automaticallyImplyLeading: false,
      ),
      body: Stack(
        children: [
          Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Image.asset('images/kl.jfif', height: 200, width: 350),
                    const SizedBox(height: 10),
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          TextFormField(
                            style: TextStyle(
                              color: themeProvider.themeData.brightness ==
                                      Brightness.light
                                  ? Colors.black
                                  : Colors.white,
                            ),
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            decoration: _buildInputDecoration(
                              'Email',
                              Icons.email,
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Please enter your email";
                              }
                              final emailRegex =
                                  RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                              if (!emailRegex.hasMatch(value)) {
                                return "Enter a valid email address";
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 20),
                          TextFormField(
                            style: TextStyle(
                              color: themeProvider.themeData.brightness ==
                                      Brightness.light
                                  ? Colors.black
                                  : Colors.white,
                            ),
                            controller: _passwordController,
                            obscureText: !_passwordVisible,
                            decoration: _buildInputDecoration(
                              'Password',
                              Icons.lock,
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
                          ),
                          // const SizedBox(height: 5),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              TextButton(
                                onPressed: () {
                                  // Show a dialog to enter email for OTP
                                  showForgotPasswordDialog(context);
                                },
                                child: Text(
                                  "Forgot Password",
                                  style: TextStyle(
                                    color: themeProvider.themeData.brightness ==
                                            Brightness.light
                                        ? Colors.black
                                        : Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 50),
                          Container(
                            height: 40,
                            width: double.infinity,
                            child: GestureDetector(
                              onTapDown: (_) {
                                setState(() {
                                  _isPressed =
                                      true; // Trigger animation on light press
                                });
                              },
                              onTapUp: (_) {
                                setState(() {
                                  _isPressed =
                                      false; // Revert animation when released
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
                                    milliseconds:
                                        100), // Duration of the animation
                                child: ElevatedButton(
                                  onPressed: _isLoading ? null : _login,
                                  child: Text(
                                    "Log In",
                                    style: TextStyle(
                                        fontSize: 20, color: Colors.white),
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
                          const SizedBox(height: 20),
                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => Signup(),
                                ),
                              );
                            },
                            child: Text(
                              "Sign Up",
                              style: TextStyle(
                                color: themeProvider.themeData.brightness ==
                                        Brightness.light
                                    ? Colors.indigo.shade900
                                    : Color(0xFF57C9E7),
                                fontSize: 18,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (_isLoading)
            Container(
              color: Colors.black.withOpacity(0.5),
              child: Center(
                child: CircularProgressIndicator(
                  color: themeProvider.themeData.brightness == Brightness.light
                      ? Colors.indigo.shade900
                      : Color(0xFF57C9E7),
                ),
              ),
            )
        ],
      ),
    );
  }

  InputDecoration _buildInputDecoration(
    String label,
    IconData icon,
  ) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return InputDecoration(
      labelText: label,

      labelStyle: TextStyle(
        color: themeProvider.themeData.brightness == Brightness.light
            ? Colors.black
            : Colors.white,
      ),
      suffixIcon: label == "Password"
          ? IconButton(
              icon: Icon(
                _passwordVisible ? Icons.visibility : Icons.visibility_off,
                color: themeProvider.themeData.brightness == Brightness.light
                    ? Colors.indigo.shade900
                    : Color(0xFF57C9E7),
              ),
              onPressed: () {
                setState(() {
                  _passwordVisible = !_passwordVisible;
                });
              },
            )
          : Icon(
              icon,
              color: themeProvider.themeData.brightness == Brightness.light
                  ? Colors.indigo.shade900
                  : Color(0xFF57C9E7),
            ),
      fillColor: themeProvider.themeData.brightness == Brightness.light
          ? Colors.white
          : Color(0xFF1C1F26), // Dark background for text field
      filled: true,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.0),
        borderSide: BorderSide(
          color: themeProvider.themeData.brightness == Brightness.light
              ? Colors.black.withOpacity(0.3)
              : Colors.white.withOpacity(0.3),
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.0),
        borderSide: BorderSide(
          color: themeProvider.themeData.brightness == Brightness.light
              ? Colors.black
              : Colors.grey,
          width: 2,
        ),
      ),
    );
  }
}
