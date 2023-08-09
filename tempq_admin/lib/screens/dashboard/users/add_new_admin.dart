import 'dart:convert';
import 'package:connectivity/connectivity.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../../components/button_widget.dart';
import '../../../components/defaultAppBar.dart';
import '../../../components/showScaffoldClass.dart';
import '../../../components/textField_widget.dart';
import '../../../constants/constants.dart';
import '../../../models/userModel.dart';
import '../../notifications/send_notification.dart';


class AddNewAdmin extends StatefulWidget {
  @override
  State<AddNewAdmin> createState() => _AddNewAdminState();
}
class _AddNewAdminState extends State<AddNewAdmin> {
  String userEmail = "", password = "";
  bool loading=false;
  final formKey = GlobalKey<FormState>();
  final userFullNameController = TextEditingController();
  final userEmailController = TextEditingController();
  final userContactController = TextEditingController();
  final userCompanyNameController = TextEditingController();
  final userPasswordController = TextEditingController();
  final userLocationController = TextEditingController();
  String contact = "";
  SendUserNotification notify = SendUserNotification();
  UserModel user = UserModel.myUser;

  Future register() async {
    userEmail = userEmailController.text;
    password = userPasswordController.text;
    var url = Uri.parse('http://tempq.frostcarusa.com/tempQ/user_registration/register_user.php');
    var response = await http.post(url,
        headers: {"Accept":"application/json"},
        body: {
          "userFullName": userFullNameController.text,
          "userEmail": userEmailController.text,
          "userCompany": userCompanyNameController.text,
          "userContact": contact,
          "userType": "admin",
          "userPassword": userPasswordController.text,
          "userLocation": userLocationController.text,
          "isVerified":"false"
        });
    var msg = json.decode(response.body);
    return msg;
  }
  /// Show Message
  showMessage(String message, Color color){
    ShowScaffoldClass().showScaffoldMessage(context,message,color);

  }
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: defaultAppBar(context, 'Add New Admin'),
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
                    "Add New Admin",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: primaryColor,
                        fontSize: 20),
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
                      text: 'Add',
                      onClicked: () async {
                        var connectivity = await checkInternetConnectivity();
                        if(connectivity){
                          if (formKey.currentState!.validate() && contact !="") {
                            setState(() {
                              loading=true;
                            });
                            var msg = await register();
                            if (msg == "User already exist!") {
                              showMessage('This Email is already registered. Kindly register with a different email',Colors.red);

                            }else  if (msg == "OTP could not sent") {
                              showMessage('Your registered email is not valid. Kindly register with a valid email',Colors.red);
                            }
                            else if (msg == 'Success'){
                              showNotification();
                              showMessage('User Registered',Colors.red);
                              Navigator.pop(context);

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
                        }else{
                          showMessage( 'Check your internet connectivity',Colors.red);
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
              ],
            ),
          )),
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

  showNotification(){
    /// Send Notification to User
    notify.sendNotification(
        subject: "User Registered - Temp Q Application",
        emailMessage:
        "You have added a new user ",
        messageType: "New User Registration",
        messageTitle: "New User Registration",
        message:
        "You have registered a new admin with email ID $email with admin privileges.");

    /// Send Notification to Admin
    notify.sendNotificationToAdmin(
        subject: "Alert: User Registered - Temp Q Application",
        emailMessage:
        "A new user has been added by ${user.userEmail} with admin privileges.",
        messageType: "New User Registration",
        messageTitle: "New User Registration",
        message:
        "A new user has been added by ${user.userEmail} with admin privileges.");

    /// Send Email to New Admin
    notify.sendEmailToNewAdmin(
      email: userEmail,
        subject: "Temp Q Account Credentials",
        emailMessage: "Congratulations! You have successfully got the access to Temp Q Admin Application\n"
            "Your Account Credentials are given below:\n"
            "Email: $userEmail\n"
            "Password: $password\n"
            "\n"
            "Note: Do not share your credentials with any one. Download and Install the Temp Q Application, You can change your password later with forget password method.",
        messageType: "Account Registration");
  }
}
