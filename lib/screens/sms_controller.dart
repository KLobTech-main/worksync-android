// import 'package:flutter_notification_listener/flutter_notification_listener.dart';
// import 'package:get/get.dart';

// class SMSConroller extends GetxController {
//   void startListening() async {
//     print("start listening");
//     var hasPermission = await NotificationsListener.hasPermission;
//     if (hasPermission!) {
//       print("no permission, so open settings");
//       NotificationsListener.openPermissionSettings();
//       return;
//     }

//     var isR = await NotificationsListener.isRunning;

//     if (isR!) {
//       await NotificationsListener.startService();
//     }
//   }

//   void requestForPermission() async {
//     print("request for permission");
//     var hasPermission = await NotificationsListener.hasPermission;
//     if (hasPermission!) {
//       print("no permission");
//       NotificationsListener.openPermissionSettings();
//       return;
//     }
//     listenNotification();
//   }

//   void listenNotification() async {
//     print("listing notification");
//     Future<void> initPlatformState() async {
//       NotificationsListener.initialize();
//       // register you event handler in the ui logic.
//       NotificationsListener.receivePort?.listen((e) => print(e));
//     }
//   }
// }
