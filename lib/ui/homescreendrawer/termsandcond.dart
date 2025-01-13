import 'package:dass/colortheme/theme_maneger.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

class TermsAndConditionsScreen extends StatefulWidget {
  @override
  _TermsAndConditionsScreenState createState() =>
      _TermsAndConditionsScreenState();
}

class _TermsAndConditionsScreenState extends State<TermsAndConditionsScreen> {
  bool isAccepted = false;

  void _showToast() {
    final themeProvider = Provider.of<ThemeProvider>(context);
    Fluttertoast.showToast(
      msg: "Your Terms & Conditions have been successfully accepted.",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: themeProvider.themeData.brightness == Brightness.light
          ? Colors.indigo.shade900 // Default active color in light mode
          : Color(0xFF57C9E7),
      textColor: Colors.white,
      fontSize: 16.0,
    );
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
          'Terms & Conditions',
          style: TextStyle(
            color: themeProvider.themeData.brightness == Brightness.light
                ? Colors.white
                : Color(0xFF57C9E7),
          ),
        ),
        centerTitle: true,
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Terms & Conditions",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: themeProvider.themeData.brightness ==
                                Brightness.light
                            ? Colors.black
                            : Colors.white,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Introduction",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 17,
                            color: themeProvider.themeData.brightness ==
                                    Brightness.light
                                ? Colors.black
                                : Colors.white,
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          "Welcome to our app. By using our services, you agree to comply with these terms and conditions.",
                          style: TextStyle(
                            fontSize: 16,
                            color: themeProvider.themeData.brightness ==
                                    Brightness.light
                                ? Colors.black
                                : Colors.grey,
                          ),
                        )
                      ],
                    ),
                    const SizedBox(height: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "User Responsibilities",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 17,
                            color: themeProvider.themeData.brightness ==
                                    Brightness.light
                                ? Colors.black
                                : Colors.white,
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          "You must use the app in a lawful and ethical manner. Any misuse will result in account termination.",
                          style: TextStyle(
                            fontSize: 16,
                            color: themeProvider.themeData.brightness ==
                                    Brightness.light
                                ? Colors.black
                                : Colors.grey,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "Privacy Policy, ",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 17,
                        color: themeProvider.themeData.brightness ==
                                Brightness.light
                            ? Colors.black
                            : Colors.white,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      "We value your privacy and are committed to protecting your personal data. Please read our Privacy Policy for more details.",
                      style: TextStyle(
                        fontSize: 16,
                        color: themeProvider.themeData.brightness ==
                                Brightness.light
                            ? Colors.black
                            : Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "Liability Limitation",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 17,
                        color: themeProvider.themeData.brightness ==
                                Brightness.light
                            ? Colors.black
                            : Colors.white,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      "We are not responsible for any loss or damage arising from the use of our app.",
                      style: TextStyle(
                        fontSize: 16,
                        color: themeProvider.themeData.brightness ==
                                Brightness.light
                            ? Colors.black
                            : Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "Changes to Terms",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 17,
                        color: themeProvider.themeData.brightness ==
                                Brightness.light
                            ? Colors.black
                            : Colors.white,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      "We reserve the right to update these terms at any time without prior notice.",
                      style: TextStyle(
                        fontSize: 16,
                        color: themeProvider.themeData.brightness ==
                                Brightness.light
                            ? Colors.black
                            : Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "Governing Law",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 17,
                        color: themeProvider.themeData.brightness ==
                                Brightness.light
                            ? Colors.black
                            : Colors.white,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      "These terms are governed by the laws of [Your Country/State].",
                      style: TextStyle(
                        fontSize: 16,
                        color: themeProvider.themeData.brightness ==
                                Brightness.light
                            ? Colors.black
                            : Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      "If you have any questions regarding these Terms and Conditions, please contact us at support@example.com.",
                      style: TextStyle(
                        fontSize: 16,
                        fontStyle: FontStyle.italic,
                        color: themeProvider.themeData.brightness ==
                                Brightness.light
                            ? Colors.black
                            : Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Row(
            //   children: [
            //     Checkbox(
            //       value: isAccepted,
            //       onChanged: (bool? value) {
            //         setState(() {
            //           isAccepted = value ?? false;
            //         });
            //       },
            //     ),
            //     const Text('I accept the Terms and Conditions'),
            //   ],
            // ),
            // if (isAccepted)
            //   ElevatedButton(
            //     onPressed: () {
            //       _showToast(); // Show toast message when accepted
            //       Navigator.pop(context); // Go back to the previous screen
            //     },
            //     style: ElevatedButton.styleFrom(
            //       backgroundColor: Colors.red.shade900,
            //       padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            //     ),
            //     child: const Text(
            //       "Continue",
            //       style: TextStyle(color: Colors.white),
            //     ),
            //   ),
          ],
        ),
      ),
    );
  }
}
