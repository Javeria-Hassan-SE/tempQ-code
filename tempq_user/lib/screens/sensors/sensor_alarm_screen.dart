import 'dart:async';
import 'package:flutter/material.dart';
import '../../components/button_widget.dart';
import '../../components/defaultAppBar.dart';
import '../../components/showScaffoldClass.dart';
import '../../constants/constants.dart';
import '../../models/userModel.dart';
import '../../network/GetNetworkCalls.dart';
import '../notifications/send_notification.dart';

class AlarmScreen extends StatefulWidget {
  const AlarmScreen({Key? key}) : super(key: key);

  @override
  State<AlarmScreen> createState() => _AlarmScreenState();
}

class _AlarmScreenState extends State<AlarmScreen> {
  String dropdownValue = userActiveDevices.first;
  final minController = TextEditingController();
  final maxController = TextEditingController();
  var data = GetNetworkCalls();
  final formKey = GlobalKey<FormState>();
  List selectedIndex = [];
  bool selectedDevice = false;
  bool loading = false;
  var user = UserModel.myUser;
  double _minTemperature = 0.0;
  double _maxTemperature = 100.0;
  SendUserNotification notify = SendUserNotification();


  /// Init State
  @override
  void initState() {
    super.initState();
    getNetworkCalls();
  }

  /// Get User devices data to show in dropdown
  getNetworkCalls() async {
    await data.getUserDevicesData();
  }

  /// UI
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery
        .of(context)
        .size;
    return Scaffold(
      appBar: defaultAppBar(context, 'Set Alarm'),
      body: Padding(
          padding: const EdgeInsets.all(defaultPadding),
          child:  Container(
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.all(30),
            decoration: const BoxDecoration(
              color: secondaryColor,
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            child:
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(height: defaultPadding,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    const Text("Select Your Device", style: TextStyle(fontWeight: FontWeight.bold),),
                    DropdownButton<String>(
                      hint: const Text("Select Device: ",
                          style: TextStyle(color: blackColor, fontSize: 14)),
                      icon: const Icon(Icons.arrow_drop_down_outlined),
                      elevation: 16,
                      // isExpanded: true,
                      style: const TextStyle(color: blackColor),
                      underline: Container(
                        height: 1.5,
                        color: greyColor,
                      ),
                      items: userActiveDevices.map<DropdownMenuItem<String>>((String items) {
                        return DropdownMenuItem<String>(
                          value: items,
                          child: Text(items),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        // This is called when the user selects an item.
                        setState(() {
                          dropdownValue = newValue!;
                          selectedAlarmDevice.add(dropdownValue);
                        });
                      },
                      value: dropdownValue,
                    ),
                  ],
                ),

                const SizedBox(height: defaultPadding),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Min. Temp Range',
                      style: TextStyle(fontSize: 16.0),
                    ),
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.remove),
                          onPressed: () {
                            setState(() {
                              _minTemperature -= 1.0;
                            });
                          },
                        ),
                        Text(
                          '$_minTemperature',
                          style: const TextStyle(fontSize: 16.0),
                        ),
                        IconButton(
                          icon: const Icon(Icons.add),
                          onPressed: () {
                            setState(() {
                              _minTemperature += 1.0;
                            });
                          },
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: defaultPadding),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Max. Temp Range',
                      style: TextStyle(fontSize: 16.0),
                    ),
                    Row(
                      children: [
                        IconButton(
                          icon:const  Icon(Icons.remove),
                          onPressed: () {
                            setState(() {
                              _maxTemperature -= 1.0;
                            });
                          },
                        ),
                        Text(
                          '$_maxTemperature',
                          style:const TextStyle(fontSize: 16.0),
                        ),
                        IconButton(
                          icon: const Icon(Icons.add),
                          onPressed: () {
                            setState(() {
                              _maxTemperature += 1.0;
                            });
                          },
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: defaultPadding),
                ButtonWidget(
                  text: 'Set Alarm',
                  onClicked: () async {
                    String minimum = _minTemperature.toString();
                    String maximum = _maxTemperature.toString();
                    if (minimum.isNotEmpty && maximum.isNotEmpty) {
                      setState(() {
                        loading = true;
                      });

                      var userList = data.setAlarm(
                          minimum, maximum, dropdownValue);
                      if (userList == "Success") {
                        showMessage('Alarm Set');
                        sendNotification(dropdownValue);
                        Navigator.pop(context);
                      } else {
                        showMessage('Alarm Set');
                        sendNotification(dropdownValue);
                        Navigator.pop(context);
                      }
                      setState(() {
                        loading = false;
                      });
                    }
                  },
                  size: size,
                ),

              ],
            )
          ),


      ),
    );
  }

/// Show Message
  void showMessage(String message){
    ShowScaffoldClass().showScaffoldMessage(
        context, message, Colors.green);
  }
  void sendNotification(String deviceId)async{
    /// Send Notification to User
    await notify.sendNotification(
        deviceId: deviceId,
        subject: "Set Sensor Temperature Alert - Temp Q Application",
        emailMessage:
        "Dear user, you have set the temperature alert for device ID $deviceId.",
        messageType: "Set Sensor Temperature Alert",
        messageTitle: "Set Sensor Temperature Alert",
        message:
        "Dear user, you have set the temperature alert for device ID $deviceId.");

  }
  /// Pop this Screen from Stack when user back
  FutureOr onGoBack(dynamic value) {
    Navigator.pop(context);
  }

}

