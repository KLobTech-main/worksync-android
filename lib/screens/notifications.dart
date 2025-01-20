import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:dass/colortheme/theme_maneger.dart';
import 'package:dass/services/notification_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../webservices/api.dart';

class NotificationsScreen extends StatefulWidget {
  final String recipientEmail;

  NotificationsScreen({required this.recipientEmail});

  @override
  _NotificationsScreenState createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  final ApiService apiService = ApiService();
  List<dynamic> notifications = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    AwesomeNotifications().setListeners(
      onActionReceivedMethod: NotificationController.onActionReceivedMethod,
      onNotificationCreatedMethod:
          NotificationController.onNotificationCreatedMethod,
      onNotificationDisplayedMethod:
          NotificationController.onNotificationDisplayedMethod,
      onDismissActionReceivedMethod:
          NotificationController.onDismissActionReceivedMethod,
    );
    fetchNotifications();
  }

  void fetchNotifications() async {
    try {
      final data =
          await apiService.fetchNotifications(widget.recipientEmail, context);
      setState(() {
        notifications = data;
        isLoading = false;
      });

      for (var notification in data) {
        debugPrint("in for loop");
        int notificationId;
        try {
          notificationId = int.parse(notification['id'] ?? '0');
          notificationId = notificationId % 2147483647; // Convert id to int
        } catch (e) {
          notificationId = DateTime.now().millisecondsSinceEpoch %
              2147483647; // Use fallback ID
        }
        debugPrint("id $notificationId");
        debugPrint("message $notification['title']");

        showNotification(
          id: notificationId,
          title: notification['title'] ?? 'Notification',
          body: notification['message'] ?? 'You have a new notification',
        );
      }
    } catch (e) {
      print("Error fetching notifications: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  void showNotification(
      {required int id, required String title, required String body}) {
    debugPrint("Show notification method called");
    AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: id,
        channelKey: 'basic_channel',
        title: title,
        body: body,
        notificationLayout: NotificationLayout.BigText,
      ),
    );
    debugPrint("notification created");
  }

  void markAsRead(String notificationId) async {
    // Update local state first
    setState(() {
      for (var notification in notifications) {
        if (notification['id'] == notificationId) {
          notification['isRead'] = true;
          break;
        }
      }
    });

    // Then make the API call
    try {
      await apiService.markNotificationAsRead(
          notificationId, widget.recipientEmail, context);
    } catch (e) {
      print("Error marking notification as read: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      backgroundColor: themeProvider.themeData.brightness == Brightness.light
          ? Colors.white
          : Color(0xFF1C1F26),
      appBar: AppBar(
        title: Text(
          "Notifications",
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
          : notifications.isEmpty
              ? Center(
                  child: Text(
                  "No notifications available",
                  style: TextStyle(
                    color:
                        themeProvider.themeData.brightness == Brightness.light
                            ? Color(0xFF1C1F26)
                            : Colors.white,
                  ),
                ))
              : ListView.builder(
                  itemCount: notifications.length,
                  itemBuilder: (context, index) {
                    final notification = notifications[index];
                    return ListTile(
                      title: Text(
                        notification['title'] ?? "No Title",
                        style: TextStyle(
                          color: themeProvider.themeData.brightness ==
                                  Brightness.light
                              ? Color(0xFF1C1F26)
                              : Colors.white,
                        ),
                      ),
                      subtitle: Text(
                        notification['message'] ?? "No Message",
                        style: TextStyle(
                          color: themeProvider.themeData.brightness ==
                                  Brightness.light
                              ? Color(0xFF1C1F26)
                              : Colors.white,
                        ),
                      ),
                      trailing: Checkbox(
                        value: notification['isRead'] ?? false,
                        onChanged: (value) {
                          if (value == true) {
                            markAsRead(notification['id']); // PATCH API Call
                          }
                        },
                        activeColor: themeProvider.themeData.brightness ==
                                Brightness.light
                            ? Colors.indigo.shade900 // Light theme active color
                            : Colors.white, // Dark theme active color
                        checkColor: themeProvider.themeData.brightness ==
                                Brightness.light
                            ? Colors.white // Light theme check color
                            : Colors.black, // Dark theme check color
                      ),
                    );
                  },
                ),
    );
  }
}
