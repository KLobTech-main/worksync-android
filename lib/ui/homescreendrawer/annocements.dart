import 'package:dass/colortheme/theme_maneger.dart';
import 'package:dass/webservices/api.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AnnouncementPage extends StatefulWidget {
  final String userEmail;

  const AnnouncementPage({
    Key? key,
    required this.userEmail,
  }) : super(key: key);

  @override
  _AnnouncementPageState createState() => _AnnouncementPageState();
}

class _AnnouncementPageState extends State<AnnouncementPage> {
  late Future<List<dynamic>> _announcementsFuture;
  List<dynamic> _announcements = [];
  @override
  void initState() {
    super.initState();
    _loadAnnouncements();
  }

  Future<void> _loadAnnouncements() async {
    try {
      final data =
          await ApiService().fetchAnnouncements(widget.userEmail, context);
      setState(() {
        _announcements = data;
      });
    } catch (e) {
      print("Error fetching announcements: $e");
    }
  }

  Future<void> _markAsRead(String notificationId, int index) async {
    try {
      // Call the existing method from api.dart
      await ApiService()
          .markNotificationAsRead(notificationId, widget.userEmail, context);
      // Re-fetch announcements to update the UI
      setState(() {
        _announcements[index]['read'] = true;
      });
    } catch (e) {
      print("Error marking notification as read: $e");
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
          "Announcements",
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
      body: _announcements.isEmpty
          ? Center(
              child: CircularProgressIndicator(
              color: themeProvider.themeData.brightness == Brightness.light
                  ? Colors.indigo.shade900
                  : Color(0xFF57C9E7),
            ))
          : ListView.builder(
              itemCount: _announcements.length,
              itemBuilder: (context, index) {
                final announcement = _announcements[index];
                return ListTile(
                  leading: Icon(
                    Icons.announcement,
                    color:
                        themeProvider.themeData.brightness == Brightness.light
                            ? Colors.indigo.shade900
                            : Color(0xFF57C9E7),
                  ),
                  title: Text(announcement['title'] ?? 'No Title'),
                  subtitle: Text(
                    announcement['message'] ?? 'No Description',
                    style: TextStyle(
                      color:
                          themeProvider.themeData.brightness == Brightness.light
                              ? Colors.grey
                              : Colors.grey,
                    ),
                  ),
                  trailing: Icon(
                    announcement['read'] == true
                        ? Icons.check_circle
                        : Icons.radio_button_unchecked,
                    color: announcement['read'] == true
                        ? Colors.green
                        : Colors.red,
                  ),
                  onTap: () async {
                    if (announcement['read'] == false) {
                      await _markAsRead(announcement['id'], index);
                    }
                  },
                );
              },
            ),
    );
  }
}
