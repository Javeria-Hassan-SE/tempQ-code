import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../components/button_widget.dart';
import '../../components/gestureDetector_widget.dart';
import '../../components/textField_widget.dart';
import '../../constants/constants.dart';
import '../../models/userModel.dart';
import '../login/login_screen.dart';

class ForgetPassword extends StatefulWidget {
  const ForgetPassword({Key? key}) : super(key: key);
  @override
  State<ForgetPassword> createState() => _ForgetPasswordState();
}
class _ForgetPasswordState extends State<ForgetPassword> {
  final formKey = GlobalKey<FormState>();
  final userNameController = TextEditingController();
  final userPasswordController = TextEditingController();
  var user = UserModel.myUser;
  bool loading = false;

  showMessage(String message, Color color){
    ScaffoldMessenger.of(context).showSnackBar( SnackBar(
      content: Text(message ,style: TextStyle(color:color),),
    ));
  }

  /// Send Change Password Request
  Future changePasswordRequest() async {
    var url = Uri.parse('http://tempq.frostcarusa.com/tempQ/user_registration/forget_password.php');
    var response = await http.post(url,
        headers: {"Accept":"application/json"},
        body: {
          "user_name": userNameController.text,
          "user_type":'admin'
        });
    if (response.statusCode == 200) {
      var msg = json.decode(response.body);
      if (msg == "Error") {
        showMessage("Something went wrong!", Colors.red);
      }
      else if(msg == "Success"){
        sendUserToLoginScreen();
      }else if (msg == "Email is not valid") {
        showMessage("Kindly provide your registered email", Colors.red);
      }
    }
    else{
      return "Error";
    }
  }

  /// Navigate to Login
  void sendUserToLoginScreen(){
    userNameController.clear();
    Navigator.pop(context);
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => const LoginScreen()));
    showMessage('Password reset email has been sent to your registered email',Colors.green);

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
                'Reset Password',
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
                    ],
                  ),
                )),

            SizedBox(height: size.height * 0.05),
            Container(
              alignment: Alignment.centerRight,
              margin:
              const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
              child: ButtonWidget(
                text: 'Change',
                onClicked: () async {
                  if (formKey.currentState!.validate()) {
                    setState(() {
                      loading=true;
                    });
                    changePasswordRequest();
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
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const LoginScreen()));
                  },
                  text: "Return to Login",
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
}