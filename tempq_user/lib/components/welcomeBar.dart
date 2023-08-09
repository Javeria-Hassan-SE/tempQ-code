import 'package:flutter/material.dart';
import '../constants/constants.dart';
import '../network/GetNetworkCalls.dart';
import '../screens/sensors/add_device_name_category.dart';
import 'button_widget.dart';

class WelcomeBar extends StatelessWidget {
  const WelcomeBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var networkCall = GetNetworkCalls();
    Size size = MediaQuery.of(context).size;
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children:  [
             const Text(
              titleWelcome,
              style: TextStyle(color: primaryColor,
                  fontWeight: FontWeight.bold,
                  fontSize: headingFontSize),
            ),
            const SizedBox(width: defaultPadding),
           const Icon(Icons.waving_hand_sharp, color: yellowColor,),
            const SizedBox(width: 40),
            ButtonWidget(
              text: 'Add Device',
              onClicked: () async {
                await networkCall.getSensorCategory();
                showAddScreen(context);
                },
              size: size*0.8,
            )
            ],
        ),
         const SizedBox(height: defaultPadding),
      ],
    );
  }
 void showAddScreen(context){
   Navigator.push(context, MaterialPageRoute(builder: (context)=>const AddDeviceNameCat()));

 }
}
