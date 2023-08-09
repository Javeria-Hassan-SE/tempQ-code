// This class handles the Page to edit the Name Section of the User Profile.
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:string_validator/string_validator.dart';
import '../../../components/button_widget.dart';
import '../../../components/showScaffoldClass.dart';
import '../../../components/textField_widget.dart';
import '../../../components/transaparentHeaderAppBar.dart';
import '../../../constants/constants.dart';
import '../../../models/userModel.dart';
import 'package:http/http.dart' as http;

class EditNameFormPage extends StatefulWidget {
  const EditNameFormPage({Key? key}) : super(key: key);

  @override
  EditNameFormPageState createState() {
    return EditNameFormPageState();
  }
}

class EditNameFormPageState extends State<EditNameFormPage> {
  final _formKey = GlobalKey<FormState>();
  final firstNameController = TextEditingController();
  final secondNameController = TextEditingController();
  var user = UserModel.myUser;
  bool loading = false;

  @override
  void dispose() {
    firstNameController.dispose();
    super.dispose();
  }

  void updateUserValue(String name) {
    user.userFullName = name;
  }
  Future updateUserName() async {
    Map<String, dynamic> data = {"userId":user.userId,
      "userName":user.userFullName};
    String jsonData = json.encode(data);
    var url = Uri.parse('http://tempq.frostcarusa.com/tempQ/user_profile/update_user_name.php');
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
                    width: 330,
                    child: Text(
                      "What's Your Name?",
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                          color: blackColor
                      ),
                    )),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                        padding: const EdgeInsets.fromLTRB(0, 40, 16, 0),
                        child: SizedBox(
                          height: 100,
                          width: 150,
                          child: TextFieldWidget(
                            text: 'First Name',
                            textInputType: TextInputType.name,
                            icon: Icons.person,
                            textColor: blackColor,
                            iconColor: headingColor,
                            obscureText: false,
                            textController: firstNameController,
                          ),
                        )),
                    Padding(
                        padding: const EdgeInsets.fromLTRB(0, 40, 16, 0),
                        child: SizedBox(
                            height: 100,
                            width: 150,
                            child: TextFormField(
                              // Handles Form Validation for Last Name
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your last name';
                                } else if (!isAlpha(value)) {
                                  return 'Only Letters Please';
                                }
                                return null;
                              },
                              style: const TextStyle(
                                  color: blackColor, fontSize: 14),
                              decoration: const InputDecoration(
                                  border: UnderlineInputBorder(),
                                  labelText: "Last Name",
                                  labelStyle: TextStyle(color: blackColor)),
                              controller: secondNameController,
                            )))
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
                              if (_formKey.currentState!.validate() &&
                                  isAlpha(firstNameController.text +
                                      secondNameController.text)) {
                                setState(() {
                                  loading=false;
                                });
                                updateUserValue(
                                    "${firstNameController.text} ${secondNameController.text}");
                                var response = await updateUserName();
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
                            },
                            size: size,
                          ),
                      ),
                    )),
                !loading
                    ?const Text("")
                    :const CircularProgressIndicator(
                  color: Colors.green,
                )
              ],
            ),
          ),
        ));
  }
}
