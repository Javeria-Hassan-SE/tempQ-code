import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../components/button_widget.dart';
import '../../components/defaultAppBar.dart';
import '../../components/textField_widget.dart';
import '../../constants/constants.dart';
import '../../models/userModel.dart';
import '../notifications/send_notification.dart';

class AddNewSensor extends StatefulWidget {
  const AddNewSensor({Key? key}) : super(
      key: key
  );
  @override
  State<AddNewSensor> createState() => _AddNewSensorState();
}
class _AddNewSensorState extends State<AddNewSensor> {
  final formKey = GlobalKey<FormState>();
  final deviceNameController = TextEditingController();
  final deviceIDController = TextEditingController();
  List <String> deviceValues=[];
  var user = UserModel.myUser;
  bool loading = false;

  String capitalize(String s) => s[0].toUpperCase() + s.substring(1);

  Future addNewCategory() async {
    String s = capitalize(deviceNameController.text);
    var url = Uri.parse('http://tempq.frostcarusa.com/tempQ/admin/admin_add_new_sesnor.php');
    var response = await http.post(url,
        headers: {"Accept":"application/json"},
        body: {
          "device_name": deviceNameController.text,
          "device_Id": deviceIDController.text,
          "user_Id": user.userId.toString(),
          "cat_name": deviceValues[0]
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
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Column(
                children: [
                  Container(
                    alignment: Alignment.center,
                    margin:const EdgeInsets.symmetric(horizontal: 40),
                    child:
                    TextFieldWidget(
                      text: 'Enter Device Name',
                      textInputType: TextInputType.text,
                      icon: Icons.sensors,
                      textColor: blackColor,
                      iconColor: Colors.green,
                      obscureText: false,
                      textController: deviceNameController,
                    ),
                  ),
                  SizedBox(height: size.height * 0.02),
                  Container(
                    alignment: Alignment.center,
                    margin:const EdgeInsets.symmetric(horizontal: 40),
                    child:
                    TextFieldWidget(
                      text: 'Enter Device ID',
                      textInputType: TextInputType.text,
                      icon: Icons.device_hub,
                      textColor: blackColor,
                      iconColor: headingColor,
                      obscureText: false,
                      textController: deviceIDController,
                    ),
                  ),
                  SizedBox(height: size.height * 0.02),
                  Container(
                      alignment: Alignment.center,
                      margin: const EdgeInsets.only(right: 30, left: 55),
                      child:  CategoryDropDown(deviceValues: deviceValues,)
                  ),
                ],
              ),
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
                  if (formKey.currentState!.validate() && deviceValues.length != 0){
                    setState(() {
                      loading=true;
                    });
                    var msg = await addNewCategory();

                    if (msg == 'Success'){
                      showNotification();
                      deviceNameController.clear();
                      deviceIDController.clear();
                      showMessage('Device Added Successfully',Colors.green);
                      Navigator.pop(context);
                    }
                    else{
                      showMessage('Invalid Input',Colors.red);
                    }
                    setState(() {
                      loading=false;
                    });
                  }
                  else{
                    showMessage('Kindly select all values',Colors.red);

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
    UserModel user = UserModel.myUser;
    notifyUser.sendNotificationToAdmin(
        subject: "Alert: New Sensor Device Added by Admin- Temp Q Application",
        emailMessage:
        "A new sensor device has been added by admin ${user.userEmail} to Temp Q Application."
        ,
        messageType: "New Sensor Device",
        messageTitle: "Alert: New Sensor Device Added by Admin",
        message:
        "A new sensor device has been added by admin ${user.userEmail} to Temp Q Application.");
  }
}

class CategoryDropDown extends StatefulWidget {
  final List <String> deviceValues;
  CategoryDropDown({super.key, required this.deviceValues});
  @override
  State<CategoryDropDown> createState() => _CategoryDropDownState();
}
class _CategoryDropDownState extends State<CategoryDropDown> {
  String dropdownValue = dropDownCategoryList.first;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(defaultPadding),
      child: DropdownButton<String>(
        hint: const Text("Select Device Category",
            style: TextStyle(color: blackColor, fontSize: 14)),
        icon: const Icon(Icons.arrow_drop_down_outlined),
        elevation: 16,
        isExpanded: true,
        style: const TextStyle(color: blackColor),
        underline: Container(
          height: 1.5,
          color: greyColor,
        ),
        items: dropDownCategoryList.map<DropdownMenuItem<String>>((String items) {
          return DropdownMenuItem<String>(
            value: items,
            child: Text(items),
          );
        }).toList(),
        onChanged: (String? newValue) {
          // This is called when the user selects an item.
          setState(() {
            dropdownValue = newValue!;
            widget.deviceValues.add(dropdownValue);
          });
        },
        value: dropdownValue,
      ),
    );
  }


}