import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart' hide MenuController;
import 'package:provider/provider.dart';
import 'package:connectivity/connectivity.dart';
import '../../components/button_widget.dart';
import '../../components/gestureDetector_widget.dart';
import '../../components/showScaffoldClass.dart';
import '../../components/textField_widget.dart';
import '../../constants/constants.dart';
import '../../controller/menu_controller.dart';
import '../../network/GetNetworkCalls.dart';
import '../forget_password/forget_password.dart';
import '../main/main_screen.dart';
import '../sign_up/email_code_verification.dart';
import '../sign_up/sign_up.dart';


class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}
class _LoginScreenState extends State<LoginScreen> {
  final formKey = GlobalKey<FormState>();
  final userNameController = TextEditingController();
  final userPasswordController = TextEditingController();
  String email="";
  String password="";
  String fcmToken = "";
  bool loading = false;

  @override
  initState(){
    super.initState();
    final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance ;
    firebaseMessaging.getToken().then((token) {
        fcmToken = token!;
      });
  }
  Future<void> sendUserToHomeScreen(context) async {
    userNameController.clear();
    userPasswordController.clear();
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => MultiProvider(
            providers: [
              ChangeNotifierProvider(
                create: (context) => MenuController(),
              ),
            ],
            child:  MainScreen(),
          ),
        ));
    ShowScaffoldClass().showScaffoldMessage(context, 'Login Successfully',Colors.green);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
              "assets/images/background.jpg",
            ),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: const Text(
                titleLogin,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: primaryColor,
                    fontSize: displayFontSize),
                textAlign: TextAlign.left,
              ),
            ),
            Form(
              key: formKey,
                child: Container(
              alignment: Alignment.center,
              margin: const EdgeInsets.symmetric(horizontal: 40),
              child: Column(
                children: [
                  TextFieldWidget(
                    text: 'Email',
                    textInputType: TextInputType.emailAddress,
                    icon: Icons.email,
                    textColor: blackColor,
                    iconColor: headingColor,
                    obscureText: false,
                    textController: userNameController,
                  ),
                  SizedBox(height: size.height * 0.03),
                  TextFieldWidget(
                    text: 'Password',
                    textInputType: TextInputType.visiblePassword,
                    icon: Icons.lock,
                    textColor: blackColor,
                    iconColor: headingColor,
                    obscureText: true,
                    textController: userPasswordController,
                  ),
                ],
              ),
            )),
            Container(
                alignment: Alignment.centerRight,
                margin:
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                child: GestureDetectorWidget(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) =>const ForgetPassword()));
                  },
                  text: "Forget Password?",
                )),
            SizedBox(height: size.height * 0.05),
            Container(
                alignment: Alignment.centerRight,
                margin:
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                child: ButtonWidget(
                  text: 'Login',
                  onClicked: () async {
                    var connectivity = await checkInternetConnectivity();
                    if(connectivity){
                      if (formKey.currentState!.validate()) {
                        setState(() {
                          loading=true;
                        });
                        email = userNameController.text;
                        password = userPasswordController.text;
                        print("FCM Token: $fcmToken");
                        var userList = await GetNetworkCalls().login(email, password,fcmToken);
                        if(userList == "OTP Send"){
                          ShowScaffoldClass().showScaffoldMessage(context, 'An OTP has been sent to your Email. Kindly check your email',Colors.green);
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>  VerifyEmail(userEmail: email)));

                        }else if(userList == "Error"){
                          ShowScaffoldClass().showScaffoldMessage(context, 'Invalid Username or password',Colors.red);
                        }
                        else if (userList=='Success'){
                          userNameController.clear();
                          userPasswordController.clear();
                          sendUserToHomeScreen(context);
                        }else{
                          ShowScaffoldClass().showScaffoldMessage(context, 'Network Error',Colors.red);
                        }
                        setState(() {
                          loading=false;
                        });
                      }
                    }else{
                      ShowScaffoldClass().showScaffoldMessage(context, 'Check your internet connectivity',Colors.red);
                    }


                  },
                  size: size,
                ),
            ),
            Container(
                alignment: Alignment.centerRight,
                margin:
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                child: GestureDetectorWidget(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const SignUpScreen()));
                    //Navigator.pop(context);
                  },
                  text: "Don't have an account? SignUp",
                )),
        !loading
            ?const Text("")
            :const CircularProgressIndicator(
          color: Colors.green,
        )
          ],
        ),
      ),
    );
  }
  Future<bool> checkInternetConnectivity() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      return false;
    } else {
      return true;
    }
  }


}