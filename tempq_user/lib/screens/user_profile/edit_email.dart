import 'dart:convert';
import 'package:connectivity/connectivity.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import '../../components/button_widget.dart';
import '../../components/showScaffoldClass.dart';
import '../../components/textField_widget.dart';
import '../../components/transaparentHeaderAppBar.dart';
import '../../constants/constants.dart';
import '../../models/userModel.dart';
import 'package:http/http.dart' as http;

// This class handles the Page to edit the Email Section of the User Profile.
class EditEmailFormPage extends StatefulWidget {
  const EditEmailFormPage({Key? key}) : super(key: key);

  @override
  EditEmailFormPageState createState() {
    return EditEmailFormPageState();
  }
}

class EditEmailFormPageState extends State<EditEmailFormPage> {
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  var user = UserModel.myUser;
  bool loading =false;

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  void updateUserValue(String email) {
    user.userEmail = email;
  }
  Future updateEmail() async {
    Map<String, dynamic> data = {"userId":user.userId,
      "userEmail":user.userEmail};
    String jsonData = json.encode(data);
    var url = Uri.parse('http://tempq.frostcarusa.com/tempQ/user_profile/update_user_email.php');

    var response = await http.post(url,
        headers: {"Accept":"application/json"},
        body: jsonData);

    if (response.statusCode == 200) {
      var msg = json.decode(response.body);
      return msg;
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: transparentHeaderAppBar(context),
        body: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  const SizedBox(
                      width: 320,
                      child: Text(
                        "What's your email?",
                        style:
                            TextStyle(fontSize: 25, color: blackColor,fontWeight: FontWeight.bold),
                        textAlign: TextAlign.left,
                      )),
                  Padding(
                      padding: const EdgeInsets.only(top: 40),
                      child: SizedBox(
                        height: 100,
                        width: 320,
                        child: TextFieldWidget(
                          text: 'Your Email Address',
                          textInputType: TextInputType.emailAddress,
                          icon: Icons.email,
                          textColor: blackColor,
                          iconColor: headingColor,
                          obscureText: false,
                          textController: emailController,
                        ),
                      )),
                  Padding(
                      padding: const EdgeInsets.only(top: 150),
                      child: Align(
                          alignment: Alignment.bottomCenter,
                          child: SizedBox(
                              width: 320,
                              height: 50,
                              child: ButtonWidget(
                                text: 'Update',
                                onClicked: () async {
                                  var connectivity = await checkInternetConnectivity();
                                  if(connectivity){
                                    if (_formKey.currentState!.validate() &&
                                        EmailValidator.validate(
                                            emailController.text)) {
                                      setState(() {
                                        loading=false;
                                      });
                                      updateUserValue(emailController.text);
                                      var response = await updateEmail();
                                      if(response=="Success"){
                                        ShowScaffoldClass().showScaffoldMessage(context, 'Updated Successfully',Colors.green);

                                        Navigator.pop(context);
                                      }else{
                                        ShowScaffoldClass().showScaffoldMessage(context, 'Failed to update',Colors.red);
                                      }
                                      setState(() {
                                        loading=false;
                                      });
                                    }
                                  }else{
                                    ShowScaffoldClass().showScaffoldMessage(context, 'Check your internet connectivity',Colors.red);
                                  }
                                  // Validate returns true if the form is valid, or false otherwise.

                                },
                                size: size,
                              )))),
                  !loading
                      ?const Text("")
                      :const CircularProgressIndicator(
                    color: Colors.green,
                  )
                ]),
          ),
        ));
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
