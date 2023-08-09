
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:connectivity/connectivity.dart';
import 'package:tempq_user/network/GetNetworkCalls.dart';
import '../../components/button_widget.dart';
import '../../components/gestureDetector_widget.dart';
import '../../components/showScaffoldClass.dart';
import '../../components/textField_widget.dart';
import '../../constants/constants.dart';
import 'email_code_verification.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);
  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}
class _SignUpScreenState extends State<SignUpScreen> {
  String userEmail = "";
  bool loading=false;
  final formKey = GlobalKey<FormState>();
  final userFullNameController = TextEditingController();
  final userEmailController = TextEditingController();
  final userContactController = TextEditingController();
  final userCompanyNameController = TextEditingController();
  final userPasswordController = TextEditingController();
  final userLocationController = TextEditingController();
  final phoneController = TextEditingController();
  String contact="";
  String fcmToken = "";

  @override
  initState(){
    super.initState();
    final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance ;
    firebaseMessaging.getToken().then((token) {
      fcmToken = token!;
    });
  }

     void showVerificationPage(String email){
       showToaster('An OTP has been sent to your email', Colors.green);
       Navigator.pushReplacement(
           context,
           MaterialPageRoute(
               builder: (context) =>  VerifyEmail(userEmail: email)));
     }
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
          alignment: Alignment.center,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage(
                "assets/images/background.jpg",
              ),
              fit: BoxFit.cover,
            ),
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: const Text(
                    "Sign Up",
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
                          text: 'Full Name',
                          textInputType: TextInputType.text,
                          icon: Icons.person,
                          textColor: blackColor,
                          iconColor: headingColor,
                          obscureText: false,
                          textController: userFullNameController,
                        ),
                        SizedBox(height: size.height * 0.03),
                        TextFieldWidget(
                          text: 'Email',
                          textInputType: TextInputType.emailAddress,
                          icon: Icons.email,
                          textColor: blackColor,
                          iconColor: headingColor,
                          obscureText: false,
                          textController: userEmailController,
                        ),
                        SizedBox(height: size.height * 0.03),

                        IntlPhoneField(
                          decoration: const InputDecoration(
                              border: UnderlineInputBorder(),
                              labelText: 'Phone NUmber',
                              labelStyle: TextStyle(color: greyColor)
                          ),

                          initialCountryCode: 'PK',
                          dropdownIconPosition: IconPosition.trailing,
                          onChanged: (phone) {
                            contact = phone.completeNumber;
                          },
                        ),
                        SizedBox(height: size.height * 0.03),
                        TextFieldWidget(
                          text: 'Store/CompanyName',
                          textInputType: TextInputType.text,
                          icon: Icons.store,
                          textColor: blackColor,
                          iconColor: headingColor,
                          obscureText: false,
                          textController: userCompanyNameController,
                        ),
                        TextFieldWidget(
                          text: 'Location',
                          textInputType: TextInputType.streetAddress,
                          icon: Icons.location_city,
                          textColor: blackColor,
                          iconColor: headingColor,
                          obscureText: false,
                          textController: userLocationController,
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
                  ),
                ),
                SizedBox(height: size.height * 0.05),
                Container(
                    alignment: Alignment.centerRight,
                    margin: const EdgeInsets.symmetric(
                        horizontal: 40, vertical: 10),
                    child:
                    ButtonWidget(
                      text: 'SignUp',
                      onClicked: () async {
                        var connectivity = await checkInternetConnectivity();
                        if(connectivity){
                          if (formKey.currentState!.validate() && contact !="") {
                            registerUser();
                          }
                        }else{
                          showToaster('Check your internet connectivity', Colors.red);
                        }
                      },
                      size: size,
                    )),
                !loading
                    ?const Text("")
                    :const Center(
                      child: CircularProgressIndicator(
                  color: Colors.green,
                ),
                    ),
                Container(
                    alignment: Alignment.centerRight,
                    margin: const EdgeInsets.symmetric(
                        horizontal: 40, vertical: 10),
                    child: GestureDetectorWidget(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      text: 'Already have an account? Login',
                    )),
              ],
            ),
          )),
    );
  }

  void sendUserToVerifyEmail(BuildContext context, String email) {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) =>  VerifyEmail(userEmail: email,)));
  }
  Future<bool> checkInternetConnectivity() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      return false;
    } else {
      return true;
    }
  }

  void registerUser()async {
    setState(() {
      loading=true;
    });
    GetNetworkCalls getRegister= GetNetworkCalls();
    var msg = await getRegister.register(userEmailController.text,
        userFullNameController.text, userCompanyNameController.text,
        contact, userPasswordController.text, userLocationController.text, fcmToken);
    if (msg == "User already exist!") {
      showToaster('This Email is already registered. Kindly register with a different email', Colors.red);
     }else  if (msg == "OTP could not sent") {
     showToaster('Your registered email is not valid. Kindly register with a valid email', Colors.red);
    }
    else if (msg == 'Success'){
      showVerificationPage(userEmailController.text);
    }
    userFullNameController.clear();
    userEmailController.clear();
    userContactController.clear();
    userCompanyNameController.clear();
    userPasswordController.clear();
    userLocationController.clear();
    setState(() {
      loading=false;
    });
  }
   void showToaster(String message, Color color){
     ShowScaffoldClass().showScaffoldMessage(context, message,color);

   }

}
