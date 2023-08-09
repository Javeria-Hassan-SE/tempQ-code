import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tempq_user/screens/splash_screen.dart';
import 'constants/constants.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message)async {
  await Firebase.initializeApp();
}


void main()async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  runApp( MyApp());
}


class MyApp extends StatelessWidget {
  MyApp({super.key});

  final darkNotifier = ValueNotifier<bool>(false);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final darkTheme = ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: bgColor,
      textTheme: GoogleFonts.poppinsTextTheme(Theme
          .of(context)
          .textTheme)
          .apply(bodyColor: blackColor),
      canvasColor: secondaryColor,
      fontFamily: 'Roboto',
      // backgroundColor: Colors.black,
      primaryColor: primaryColor,
      visualDensity: VisualDensity.adaptivePlatformDensity,
      // other theme attributes
    );

    final lightTheme = ThemeData(
      brightness: Brightness.light,
      scaffoldBackgroundColor: bgColor,
      textTheme: GoogleFonts.poppinsTextTheme(Theme
          .of(context)
          .textTheme)
          .apply(bodyColor: blackColor),
      canvasColor: secondaryColor,
      fontFamily: 'Roboto',
      // backgroundColor: Colors.black,
      primaryColor: primaryColor,
      visualDensity: VisualDensity.adaptivePlatformDensity,
      // other theme attributes
    );
    return ValueListenableBuilder<bool>(
        valueListenable: darkNotifier,
        builder: (BuildContext context, bool isDark, Widget? child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Temp Q',
            themeMode: isDark ? ThemeMode.dark : ThemeMode.light,
            theme: isDarkTheme ? darkTheme : lightTheme,
            home: const SplashScreen(),
          );
        });
  }
}


