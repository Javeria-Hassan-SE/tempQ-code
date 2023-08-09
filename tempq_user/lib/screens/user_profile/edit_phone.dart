import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import '../../components/button_widget.dart';
import '../../components/showScaffoldClass.dart';
import '../../components/transaparentHeaderAppBar.dart';
import '../../constants/constants.dart';
import '../../models/userModel.dart';
import 'package:http/http.dart' as http;
import 'package:connectivity/connectivity.dart';

// This class handles the Page to edit the Phone Section of the User Profile.
class EditPhoneFormPage extends StatefulWidget {
  const EditPhoneFormPage({Key? key}) : super(key: key);

  @override
  EditPhoneFormPageState createState() {
    return EditPhoneFormPageState();
  }
}

class EditPhoneFormPageState extends State<EditPhoneFormPage> {
  final _formKey = GlobalKey<FormState>();
  final phoneController = TextEditingController();
  late String contact="";
  var user = UserModel.myUser;
  bool loading = false;

  @override
  void dispose() {
    phoneController.dispose();
    super.dispose();
  }

  void updateUserValue(String phone) {
    String formattedPhoneNumber =
        "(${phone.substring(0, 3)}) ${phone.substring(3, 6)}-${phone.substring(6, phone.length)}";
    user.userContact = formattedPhoneNumber;
  }
  Future updateContact() async {
   
    Map<String, dynamic> data = {"userId":user.userId,
      "userContact":user.userContact};
    String jsonData = json.encode(data);
    var url = Uri.parse('http://tempq.frostcarusa.com/tempQ/user_profile/update_user_contact.php');

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
                        "What's Your Phone Number?",
                        style:
                            TextStyle(fontSize: 22,
                                color: blackColor,
                                fontWeight: FontWeight.bold),
                      )),
                  Padding(
                      padding: const EdgeInsets.only(top: 40),
                      child: SizedBox(
                        height: 100,
                        width: 320,
                        child:
                        IntlPhoneField(
                          decoration: InputDecoration(
                              border: const UnderlineInputBorder(),
                              labelText: 'Phone NUmber',
                              labelStyle: TextStyle(color: greyColor)
                          ),

                          initialCountryCode: 'PK',
                          onChanged: (phone) {
                            contact = phone.completeNumber;
                          },
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
                                    // Validate returns true if the form is valid, or false otherwise.
                                    if (_formKey.currentState!.validate() &&
                                        contact !="") {
                                      setState(() {
                                        loading=false;
                                      });
                                      updateUserValue(contact);
                                      var response = await updateContact();
                                      if(response=="Success"){
                                        ShowScaffoldClass().showScaffoldMessage(context, 'Updated Successfully',Colors.green);
                                        Navigator.pop(context);
                                      }else{
                                        ShowScaffoldClass().showScaffoldMessage(context, 'Failed to Update',Colors.red);
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
