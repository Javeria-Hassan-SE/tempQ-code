import 'dart:async';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart' hide MenuController;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import 'package:tempq_admin/http/post_request.dart';
import 'package:tempq_admin/screens/main/main_screen.dart';
import '../constants/constants.dart';
import '../controller/menu_controller.dart';
import 'login/login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}
class _SplashScreenState extends State<SplashScreen> {
  String fcmToken = "";
  @override
  initState() {
    super.initState();
    final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance ;
    firebaseMessaging.getToken().then((token) {
      fcmToken = token!;
    });
    getLoginStatus();
  }

  getLoginStatus() async {
    if (await isLoggedIn()) {
      Timer(const Duration(seconds: 3),
              () =>
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        MultiProvider(
                          providers: [
                            ChangeNotifierProvider(
                              create: (context) => MenuController(),
                            ),
                          ],
                          child: const  MainScreen(),
                        ),
                  )));
    } else {
      Timer(const Duration(seconds: 3),
              () =>
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder:
                      (context) =>
                  const LoginScreen()
                  )
              )
      );
    }
  }

  Future<bool> isLoggedIn() async {
    const storage = FlutterSecureStorage();
    final email = await storage.read(key: 'tempQEmail');
    final password = await storage.read(key: 'tempQPassword');
    if (email != null && password != null && email.isNotEmpty && password.isNotEmpty) {
      var data = SendPostRequest();
      var userList = await data.loginRequest(email, password,fcmToken);
      if(userList == "Success") {
        return true;
      }
      else{
        return false;
      }
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery
        .of(context)
        .size;
    return Scaffold(
        backgroundColor: splashColor,
        body: SizedBox(
          width: double.infinity,
          height: size.height,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Align(
                alignment: Alignment.center,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset("assets/images/tempq.png", height: 200,),
                  ],
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: defaultPadding),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Powered by", style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white, fontSize: bodyFontSize),),
                      Image.asset(
                          "assets/images/white.png", width: size.width * 0.40),
                    ],
                  ),
                ),
              ),
            ],
          ),
        )
    );
  }
}


