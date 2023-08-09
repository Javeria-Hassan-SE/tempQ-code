import 'dart:convert';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:tempq_admin/screens/login/login_screen.dart';
import 'package:http/http.dart' as http;

import '../../components/defaultAppBar.dart';
import '../../components/showScaffoldClass.dart';
import '../../constants/constants.dart';
import '../notifications/send_notification.dart';

class VerifyEmail extends StatefulWidget {
  final String userEmail;

  const VerifyEmail({Key? key, required this.userEmail}) : super(key: key);

  @override
  _VerifyEmailState createState() => _VerifyEmailState();
}

class _VerifyEmailState extends State<VerifyEmail> {
  // 4 text editing controllers that associate with the 4 input fields
  final TextEditingController _fieldOne = TextEditingController();
  final TextEditingController _fieldTwo = TextEditingController();
  final TextEditingController _fieldThree = TextEditingController();
  final TextEditingController _fieldFour = TextEditingController();
  bool loading = false;

  // This is the entered code
  // It will be displayed in a Text widget
  String? _otp;

  Future verify() async {
    var url = Uri.parse('http://tempq.frostcarusa.com/tempQ/user_registration/verify_email.php');
    var response = await http.post(url,
        headers: {"Accept": "application/json"},
        body: {"userEmail": widget.userEmail, "otp": _otp});
    var list = json.decode(response.body);
    return list;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: defaultAppBar(context, "Email Verification"),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Please Enter an OTP',
            style: TextStyle(fontSize: subHeadingFontSize),
          ),
          const SizedBox(
            height: 30,
          ),
          // Implement 4 input fields
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              OtpInput(_fieldOne, true),
              OtpInput(_fieldTwo, false),
              OtpInput(_fieldThree, false),
              OtpInput(_fieldFour, false)
            ],
          ),
          const SizedBox(
            height: 30,
          ),
          ElevatedButton(
              style: ElevatedButton.styleFrom(
                foregroundColor:
                    Theme.of(context).colorScheme.onSecondaryContainer,
                backgroundColor: headingColor,
              ).copyWith(elevation: ButtonStyleButton.allOrNull(0.0)),
              onPressed: () async {
                setState(() {
                  _otp = _fieldOne.text +
                      _fieldTwo.text +
                      _fieldThree.text +
                      _fieldFour.text;
                  loading = true;
                });
                if (_otp == null) {
                  ShowScaffoldClass().showScaffoldMessage(
                      context, 'Please enter valid OTP', Colors.red);
                } else {
                  var connectivity = await checkInternetConnectivity();
                  if (connectivity) {
                    var response = await verify();
                    if (response == 'Success') {
                      sendUserToHomeScreen(context);
                    } else if (response == 'Invalid OTP') {
                      showMessage('Please enter valid OTP',Colors.red);

                    } else if (response == 'Invalid Email') {
                      showMessage('Your Email is not Valid. Kindly register account with a valid email',Colors.red);
                    } else {
                      showMessage('Please enter valid OTP',Colors.red);
                    }
                  } else {
                    showMessage('Please enter valid OTP',Colors.red);
                  }
                }
                setState(() {
                  loading = false;
                });
              },
              child: const Text('Submit')),
          const SizedBox(
            height: 30,
          ),
          !loading
              ? const Text("")
              : const Center(
                  child:  CircularProgressIndicator(
                    color: Colors.green,
                  ),
                )
          // Display the entered OTP code
        ],
      ),
    );
  }

  /// Show Toast Message
  showMessage(String message, Color color){
    ShowScaffoldClass().showScaffoldMessage(
        context, message, color);
  }

  /// Check Internet Connection
  Future<bool> checkInternetConnectivity() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      return false;
    } else {
      return true;
    }
  }

  /// Send User to Home Screen
  void sendUserToHomeScreen(context) {
    _fieldOne.clear();
    _fieldTwo.clear();
    _fieldThree.clear();
    _fieldFour.clear();

    Navigator.push(
        context, MaterialPageRoute(builder: (context) => const LoginScreen()));
    ShowScaffoldClass().showScaffoldMessage(
        context, 'Email Verified Successfully', Colors.green);

    /// Send Notification to User
    SendUserNotification notifyUser = SendUserNotification();
    notifyUser.sendAccountVerificationNotification(
        userEmail: widget.userEmail,
        messageType: "Account Verification",
        messageTitle: "Account Verification",
        message: "Your Account has been verified successfully!");


    /// Send Notification to Admin
    notifyUser.sendNotificationToAdmin(
        subject: "Alert: New User Account Verification - Temp Q Application",
        emailMessage:
        "A new User account wit Email ID: ${widget.userEmail} has successfully verified."
        ,
        messageType: "Account Verification",
        messageTitle: "Alert: Account Verification",
        message:
        "A new User account wit Email ID: ${widget.userEmail} has successfully verified.");

  }
}

// Create an input widget that takes only one digit
class OtpInput extends StatelessWidget {
  final TextEditingController controller;
  final bool autoFocus;

  const OtpInput(this.controller, this.autoFocus, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60,
      width: 50,
      child: TextField(
        autofocus: autoFocus,
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        controller: controller,
        maxLength: 1,
        cursorColor: Theme.of(context).primaryColor,
        decoration: const InputDecoration(
            border: OutlineInputBorder(),
            counterText: '',
            hintStyle: TextStyle(color: Colors.black, fontSize: 20.0)),
        onChanged: (value) {
          if (value.length == 1) {
            FocusScope.of(context).nextFocus();
          }
        },
      ),
    );
  }
}
