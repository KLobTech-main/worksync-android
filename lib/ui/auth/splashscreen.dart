import 'package:dass/screens/home_screen.dart';
import 'package:dass/webservices/api.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'login.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkUserStatus();
  }

  Future<void> _checkUserStatus() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();

      // Load the token using ApiService
      await ApiService.loadAuthToken();

      // Check login status and token availability
      final bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
      final String? authToken = prefs.getString('authToken');
      final String? email = isLoggedIn ? prefs.getString('userEmail') : null;
      final String? name = isLoggedIn ? prefs.getString('userName') : null;

      debugPrint('User logged in status: $isLoggedIn');
      debugPrint('Auth Token: $authToken');
      debugPrint('User Email: $email');
      debugPrint('User Name: $name');

      // Navigate based on login and token status
      Future.delayed(const Duration(milliseconds: 1900), () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => isLoggedIn && authToken != null
                ? HomeScreen(name: name, email: email)
                : LogIn(),
          ),
        );
      });
    } catch (e) {
      debugPrint('Error in SharedPreferences: $e');
      // Navigate to Login screen on error
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LogIn()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('images/kl.jfif', height: 250, width: 400),
            const SizedBox(height: 60),
            const Text(
              'Welcome to My App',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
