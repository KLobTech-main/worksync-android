import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';

class NotificationController {
  /// Called when a new notification is created
  @pragma("vm:entry-point")
  static Future<void> onNotificationCreatedMethod(
      ReceivedNotification receivedNotification) async {
    debugPrint('Notification Created: ${receivedNotification.id}');
    // Your custom logic here
  }

  /// Called when a notification is displayed
  @pragma("vm:entry-point")
  static Future<void> onNotificationDisplayedMethod(
      ReceivedNotification receivedNotification) async {
    debugPrint('Notification Displayed: ${receivedNotification.id}');
    // Your custom logic here
  }

  /// Called when a notification is dismissed
  @pragma("vm:entry-point")
  static Future<void> onDismissActionReceivedMethod(
      ReceivedAction receivedAction) async {
    debugPrint('Notification Dismissed: ${receivedAction.id}');
    // Your custom logic here
  }

  /// Called when the user taps on a notification or an action button
  @pragma("vm:entry-point")
  static Future<void> onActionReceivedMethod(
      ReceivedAction receivedAction) async {
    debugPrint('Notification Action Received: ${receivedAction.id}');
    // Navigate to a specific page if needed
    // Example: MyApp.navigatorKey.currentState?.pushNamed('/notification-page', arguments: receivedAction);
  }
}
