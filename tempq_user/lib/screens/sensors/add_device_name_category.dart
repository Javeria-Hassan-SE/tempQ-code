
import 'package:flutter/material.dart';
import '../../components/button_widget.dart';
import '../../components/defaultAppBar.dart';
import '../../components/textField_widget.dart';
import '../../constants/constants.dart';
import 'add_device.dart';

class AddDeviceNameCat extends StatefulWidget {
  const AddDeviceNameCat({Key? key}) : super(key: key);

  @override
  State<AddDeviceNameCat> createState() => _AddDeviceNameCatState();
}

class _AddDeviceNameCatState extends State<AddDeviceNameCat> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    deviceValues.clear();

  }
  final formKey = GlobalKey<FormState>();
  final deviceNameController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: defaultAppBar(context, "Add New Device"),
      body:  Wrap(
          spacing: 20,
          children: [
            const SizedBox(height: 20,),
            Container(
              alignment: Alignment.center,
              margin: const EdgeInsets.symmetric(horizontal: 40),
              child:
                  Form(
                    key: formKey,
                    child: TextFieldWidget(
                      text: 'Your Device Name',
                      textInputType: TextInputType.text,
                      icon: Icons.sensors,
                      textColor: blackColor,
                      iconColor: headingColor,
                      obscureText: false,
                      textController: deviceNameController,
                    ),
                  ),
            ),
            SizedBox(height: size.height * 0.02),
            Container(
              alignment: Alignment.center,
                margin: const EdgeInsets.only(right: 30, left: 55),
              child:  const CategoryDropDown()
            ),
            SizedBox(height: size.height * 0.02),
            Container(
              alignment: Alignment.centerRight,
              margin: const EdgeInsets.only(right: 40),
              child:
              ButtonWidget(
                text: 'Next',
                onClicked: () {
                  if (formKey.currentState!.validate() && deviceValues.isNotEmpty) {
                    deviceValues.add(deviceNameController.text);
                      Navigator.push(context, MaterialPageRoute(
                          builder: (context) =>
                              const AddDevice()));
                      deviceNameController.clear();

                }
                else{
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text('Please Select all Fields',
                          style: TextStyle(fontSize: 16, color: Colors.red),
                        )));
                  }

                  },
                size: size,
              )
            ),
          ],
        ),
    );
  }
}
class CategoryDropDown extends StatefulWidget {
    const CategoryDropDown({super.key});
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
            deviceValues.add(dropdownValue);
          });
        },
        value: dropdownValue,
      ),
    );
  }
}

