import 'package:dass/colortheme/theme_maneger.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      backgroundColor: themeProvider.themeData.brightness == Brightness.light
          ? const Color.fromARGB(255, 246, 244, 244)
          : Color(0xFF1C1F26),
      appBar: AppBar(
        title: Text(
          'Privacy Policy',
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
              : Color(0xFF57C9E7), // Sets the drawer icon color to white
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Privacy Policy',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: themeProvider.themeData.brightness == Brightness.light
                    ? Colors.black
                    : Colors.white,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Effective Date: [Insert Date]',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: themeProvider.themeData.brightness == Brightness.light
                    ? Colors.black
                    : Colors.white,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Welcome to [Your App Name]! Your privacy is important to us. This Privacy Policy explains how we collect, use, disclose, and safeguard your information when you use our app, and outlines your rights regarding that information. By using our app, you agree to the terms of this policy.',
              style: TextStyle(
                fontSize: 16,
                height: 1.5,
                color: themeProvider.themeData.brightness == Brightness.light
                    ? Colors.black
                    : Colors.grey,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              '1. Information We Collect',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: themeProvider.themeData.brightness == Brightness.light
                    ? Colors.black
                    : Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '1.1 Personal Information\n     Name\n     Email address\n     Phone number\n     Address\n\n'
              '1.2  Non-Personal Information\n      Device information (e.g., model, operating  \n      system, unique identifiers)\n'
              '      App usage data\n      IP address\n      Location data (if enabled)',
              style: TextStyle(
                fontSize: 16,
                height: 1.5,
                color: themeProvider.themeData.brightness == Brightness.light
                    ? Colors.black
                    : Colors.grey,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              '2. How We Use Your Information',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: themeProvider.themeData.brightness == Brightness.light
                    ? Colors.black
                    : Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '  We use the collected information for:\n'
              '  Providing and improving our services.\n'
              '  Personalizing user experience.\n'
              '  Responding to inquiries or support requests.\n'
              '  Sending notifications or updates related to the \n  app. \n'
              '  Ensuring compliance with legal obligations.',
              style: TextStyle(
                fontSize: 16,
                height: 1.5,
                color: themeProvider.themeData.brightness == Brightness.light
                    ? Colors.black
                    : Colors.grey,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              '3. Sharing Your Information',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: themeProvider.themeData.brightness == Brightness.light
                    ? Colors.black
                    : Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'We do not sell, rent, or trade your personal information to third parties. We may share your information:\n'
              'With service providers: To assist in delivering our services.\n'
              'For legal purposes: If required to comply with laws, regulations, or legal proceedings.',
              style: TextStyle(
                fontSize: 16,
                height: 1.5,
                color: themeProvider.themeData.brightness == Brightness.light
                    ? Colors.black
                    : Colors.grey,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              '4. Data Security',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: themeProvider.themeData.brightness == Brightness.light
                    ? Colors.black
                    : Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'We take reasonable measures to protect your data from unauthorized access, disclosure, or alteration. However, no method of transmission over the Internet, or method of electronic storage, is 100% secure.',
              style: TextStyle(
                fontSize: 16,
                height: 1.5,
                color: themeProvider.themeData.brightness == Brightness.light
                    ? Colors.black
                    : Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
