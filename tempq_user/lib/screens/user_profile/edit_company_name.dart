// This class handles the Page to edit the Name Section of the User Profile.
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:string_validator/string_validator.dart';
import '../../components/button_widget.dart';
import '../../components/showScaffoldClass.dart';
import '../../components/textField_widget.dart';
import '../../components/transaparentHeaderAppBar.dart';
import '../../constants/constants.dart';
import '../../models/userModel.dart';
import 'package:http/http.dart' as http;
import 'package:connectivity/connectivity.dart';

class EditCompanyNameFormPage extends StatefulWidget {
  const EditCompanyNameFormPage({Key? key}) : super(key: key);

  @override
  EditCompanyNameFormPageState createState() {
    return EditCompanyNameFormPageState();
  }
}

class EditCompanyNameFormPageState extends State<EditCompanyNameFormPage> {
  final _formKey = GlobalKey<FormState>();
  final companyNameController = TextEditingController();
  var user = UserModel.myUser;
  bool loading =false;

  @override
  void dispose() {
    companyNameController.dispose();
    super.dispose();
  }

  void updateUserValue(String companyName) {
    user.userCompany = companyName;
  }

  Future updateCompanyName() async {
    Map<String, dynamic> data = {"userId":user.userId,
      "userCompany": user.userCompany};
    String jsonData = json.encode(data);
    var url = Uri.parse('http://tempq.frostcarusa.com/tempQ/user_profile/update_user_company.php');

    var response = await http.post(url,
        headers: {"Accept": "application/json"},
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
                    width: 330,
                    child: Text(
                      "What's Your Company Name?",
                      style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          color: blackColor),
                    )),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                        padding: const EdgeInsets.only(top: 40),
                        child: SizedBox(
                          height: 100,
                          width: 320,
                          child: TextFieldWidget(
                            text: 'Company Name',
                            textInputType: TextInputType.name,
                            icon: Icons.store,
                            textColor: blackColor,
                            iconColor: headingColor,
                            obscureText: false,
                            textController: companyNameController,
                          ),
                        ))
                  ],
                ),
                Padding(
                    padding: const EdgeInsets.only(top: 150),
                    child: Align(
                        alignment: Alignment.bottomCenter,
                        child: SizedBox(
                            width: 330,
                            height: 50,
                            child: ButtonWidget(
                              text: 'Update',
                              onClicked: () async {
                                var connectivity = await checkInternetConnectivity();
                                if(connectivity){
                                  // Validate returns true if the form is valid, or false otherwise.
                                  if (_formKey.currentState!.validate() &&
                                      isAlpha(companyNameController.text)) {
                                    updateUserValue(companyNameController.text);
                                    var response = await updateCompanyName();
                                    if (response == "Success") {
                                      ShowScaffoldClass().showScaffoldMessage(context, 'Updated Successfully',Colors.green);
                                      Navigator.pop(context);
                                    } else {
                                      ShowScaffoldClass().showScaffoldMessage(context, 'Failed to update',Colors.red);

                                    }
                                    setState(() {
                                      loading = false;
                                    });
                                  }
                                }else{
                                  ShowScaffoldClass().showScaffoldMessage(context, 'Check your internet connectivity',Colors.red);
                                }

                              },
                              size: size,
                            )))),
                !loading
                    ? const Text("")
                    : const CircularProgressIndicator(
                        color: Colors.green,
                      )
              ],
            ),
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
