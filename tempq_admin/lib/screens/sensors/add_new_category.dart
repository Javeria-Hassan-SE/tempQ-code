import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../components/button_widget.dart';
import '../../components/defaultAppBar.dart';
import '../../components/textField_widget.dart';
import '../../constants/constants.dart';
import '../../models/userModel.dart';
import '../notifications/send_notification.dart';

class AddNewCategory extends StatefulWidget {
  const AddNewCategory({Key? key}) : super(
      key: key
  );
  @override
  State<AddNewCategory> createState() => _AddNewCategoryState();
}
class _AddNewCategoryState extends State<AddNewCategory> {
  final formKey = GlobalKey<FormState>();
  final catNameController = TextEditingController();
  var user = UserModel.myUser;
  bool loading = false;

  String capitalize(String s) => s[0].toUpperCase() + s.substring(1);

  Future addNewCategory() async {
    String s = capitalize(catNameController.text);
    var url = Uri.parse('http://tempq.frostcarusa.com/tempQ/admin/add_new_category.php');
    var response = await http.post(url,
        headers: {"Accept":"application/json"},
        body: {
          "cat_name": s,
          "added_by": user.userId.toString(),
        });

    var msg = json.decode(response.body);
    return msg;
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: defaultAppBar(context, "Add New Device"),
      body:  Wrap(
        children: [

          const SizedBox(height: defaultPadding),
          Form(
            key: formKey,
            child: Column(
              children: [
                Container(
                  alignment: Alignment.center,
                  margin:const EdgeInsets.symmetric(horizontal: 40),
                  child:
                  TextFieldWidget(
                    text: 'Enter Category Name',
                    textInputType: TextInputType.text,
                    icon: Icons.category,
                    textColor: blackColor,
                    iconColor: headingColor,
                    obscureText: false,
                    textController: catNameController,
                  ),
                ),
                SizedBox(height: size.height * 0.02),
              ],
            ),
          ),
          const SizedBox(height: 40),
          Container(
              alignment: Alignment.centerRight,
              margin:const EdgeInsets.all(20),
              child:
              ButtonWidget(
                text: 'Add',
                onClicked: () async {
                  if (formKey.currentState!.validate()){
                     setState(() {
                      loading=true;
                    });
                    var msg = await addNewCategory();
                    if (msg == 'Success'){
                      catNameController.clear();
                      showNotification();
                      showMessage('Category Added Successfully',Colors.green);
                      Navigator.pop(context);
                    }
                    else{
                      showMessage('Invalid Input',Colors.red);
                    }
                    setState(() {
                      loading=false;
                    });
                  }
                },
                size: size,
              )
          ),
          !loading
              ?const Text("")
              :const Center(
                child: CircularProgressIndicator(
            color: Colors.green,
          ),
              )
        ],
      ),
    );
  }
  showMessage(String message, Color color){
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(message,
          style: TextStyle(fontSize: 16, color: color),
        )));

  }

  showNotification(){
    /// Send Notification to Admin
    SendUserNotification notifyUser = SendUserNotification();
    notifyUser.sendNotificationToAdmin(
        subject: "Alert: New Sensor Category Added - Temp Q Application",
        emailMessage:
        "A new sensor category has been added by ${user.userEmail} to Temp Q Application."
        ,
        messageType: "New Sensor category",
        messageTitle: "Alert: New Sensor Category",
        message:
        "A new sensor category has been added by ${user.userEmail} to Temp Q Application.");
  }
}