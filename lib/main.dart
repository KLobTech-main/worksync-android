import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dass/colortheme/theme_maneger.dart';
import 'package:dass/services/notification_controller.dart';
import 'package:dass/ui/auth/splashscreen.dart';
import 'package:dass/webservices/api.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();

//   await ApiService.loadAuthToken();
//   AwesomeNotifications().initialize(
//     null, // Set null to use the default app icon
//     [
//       NotificationChannel(
//           channelKey: 'basic_channel',
//           channelName: 'Basic Notifications',
//           channelDescription: 'Notification channel for basic tests',
//           defaultColor: Colors.indigo,
//           ledColor: Colors.white,
//           playSound: true,
//           enableLights: true,
//           enableVibration: true,
//           importance: NotificationImportance.High)
//     ],
//   );
//   AwesomeNotifications().setListeners(
//     onActionReceivedMethod: NotificationController.onActionReceivedMethod,
//     onNotificationCreatedMethod:
//         NotificationController.onNotificationCreatedMethod,
//     onNotificationDisplayedMethod:
//         NotificationController.onNotificationDisplayedMethod,
//     onDismissActionReceivedMethod:
//         NotificationController.onDismissActionReceivedMethod,
//   );

//   // Load the theme preference
//   final themeProvider = await ThemeProvider.loadTheme();

//   // Debugging information for the loaded theme
//   print("Loaded Theme: ${themeProvider.themeData.brightness}");

//   runApp(
//     ChangeNotifierProvider<ThemeProvider>(
//       create: (_) => themeProvider,
//       child: MyApp(),
//     ),
//   );
// }
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Check connectivity before running the app
  var connectivityResult = await (Connectivity().checkConnectivity());
  if (connectivityResult == ConnectivityResult.none) {
    runApp(
      MaterialApp(
        home: Scaffold(
          body: Center(
            child:
                Text('No internet connection. Please connect to the internet.'),
          ),
        ),
      ),
    );
  } else {
    // Proceed with initialization if internet is available
    await ApiService.loadAuthToken();
    AwesomeNotifications().initialize(
      null,
      [
        NotificationChannel(
          channelKey: 'basic_channel',
          channelName: 'Basic Notifications',
          channelDescription: 'Notification channel for basic tests',
          defaultColor: Colors.indigo,
          ledColor: Colors.white,
          playSound: true,
          enableLights: true,
          enableVibration: true,
          importance: NotificationImportance.High,
        )
      ],
    );
    AwesomeNotifications().setListeners(
      onActionReceivedMethod: NotificationController.onActionReceivedMethod,
      onNotificationCreatedMethod:
          NotificationController.onNotificationCreatedMethod,
      onNotificationDisplayedMethod:
          NotificationController.onNotificationDisplayedMethod,
      onDismissActionReceivedMethod:
          NotificationController.onDismissActionReceivedMethod,
    );

    final themeProvider = await ThemeProvider.loadTheme();
    print("Loaded Theme: ${themeProvider.themeData.brightness}");

    runApp(
      ChangeNotifierProvider<ThemeProvider>(
        create: (_) => themeProvider,
        child: MyApp(),
      ),
    );
  }
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    // TODO: implement initState
    AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
      if (isAllowed) {
        AwesomeNotifications().requestPermissionToSendNotifications();
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    debugPrint("Theme in MyApp: ${themeProvider.themeData.brightness}");

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: themeProvider.themeData.copyWith(
        textTheme: GoogleFonts.robotoTextTheme(),
      ),
      home: SplashScreen(),
    );
  }
}
