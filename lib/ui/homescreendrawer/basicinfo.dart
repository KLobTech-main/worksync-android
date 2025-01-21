import 'package:dass/colortheme/theme_maneger.dart';
import 'package:dass/modal/getuserbyemailmodel.dart';
import 'package:dass/webservices/api.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BasicInformationPage extends StatefulWidget {
  final String userEmail;

  const BasicInformationPage({required this.userEmail, Key? key})
      : super(key: key);

  @override
  _BasicInformationPageState createState() => _BasicInformationPageState();
}

class _BasicInformationPageState extends State<BasicInformationPage> {
  GetUserByEmailModel? userData;
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    try {
      final data = await ApiService.getUserByEmail(widget.userEmail, context);
      if (data != null) {
        setState(() {
          userData = data;
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
          errorMessage = "Failed to fetch user data.";
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
        errorMessage = "An error occurred: $e";
      });
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
          "Basic Information",
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
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(
              color: themeProvider.themeData.brightness == Brightness.light
                  ? Colors.indigo.shade900
                  : Color(0xFF57C9E7),
            ))
          : errorMessage != null
              ? Center(
                  child: Text(
                    errorMessage!,
                    style: TextStyle(color: Colors.red, fontSize: 16),
                  ),
                )
              : SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        // Header Section
                        _buildHeaderSection(),
                        SizedBox(height: 20),
                        // Information Card
                        _buildInfoCard(
                          "Name",
                          userData?.name ?? "Not Available",
                          Icons.person,
                        ),
                        _buildInfoCard("Email",
                            userData?.email ?? "Not Available", Icons.email),
                        _buildInfoCard("Mobile No",
                            userData?.mobileNo ?? "Not Available", Icons.phone),
                        _buildInfoCard("DOB", userData?.dob ?? "Not Available",
                            Icons.cake),
                        _buildInfoCard("Role",
                            userData?.role ?? "Not Available", Icons.work),
                      ],
                    ),
                  ),
                ),
    );
  }

  Widget _buildHeaderSection() {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Container(
      decoration: BoxDecoration(
        color: themeProvider.themeData.brightness == Brightness.light
            ? Colors.indigo.shade900
            : Color(0xFF57C9E7),
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: Colors.indigo.shade100,
            child: Icon(Icons.person, size: 30, color: Colors.indigo.shade900),
          ),
          SizedBox(height: 12),
          Text(
            userData?.name ?? "User",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          Text(
            userData?.email ?? "unknown@example.com",
            style: TextStyle(
                fontSize: 16,
                color: themeProvider.themeData.brightness == Brightness.light
                    ? Colors.white70
                    : Colors.white),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(String title, String value, IconData icon) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor:
              themeProvider.themeData.brightness == Brightness.light
                  ? Colors.indigo.shade100
                  : Color.fromARGB(255, 24, 28, 37),
          child: Icon(icon,
              color: themeProvider.themeData.brightness == Brightness.light
                  ? Colors.indigo.shade900
                  : Color(0xFF57C9E7)),
        ),
        title: Text(
          title,
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: themeProvider.themeData.brightness == Brightness.light
                  ? Colors.indigo.shade900
                  : Colors.white),
        ),
        subtitle: Text(
          value,
          style: TextStyle(
              fontSize: 14,
              color: themeProvider.themeData.brightness == Brightness.light
                  ? Colors.grey.shade700
                  : Colors.grey),
        ),
      ),
    );
  }
}
