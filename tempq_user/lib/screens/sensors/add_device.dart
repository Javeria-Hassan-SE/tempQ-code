
import 'package:flutter/material.dart';
import '../../components/alert_dialog_widget.dart';
import '../../components/button_widget.dart';
import '../../components/defaultAppBar.dart';
import '../../components/textField_widget.dart';
import '../../constants/constants.dart';
import '../../models/userModel.dart';
import '../../network/GetNetworkCalls.dart';
import '../notifications/send_notification.dart';
import '../payments/payment_screen.dart';
import 'package:connectivity/connectivity.dart';

class AddDevice extends StatefulWidget {
  const AddDevice({Key? key}) : super(key: key);

  @override
  State<AddDevice> createState() => _AddDeviceState();
}

class _AddDeviceState extends State<AddDevice> {
  final formKey = GlobalKey<FormState>();
  final deviceIDController = TextEditingController();
  final securityCodeController = TextEditingController();
  var user = UserModel.myUser;
  bool loading = false;
  var networkCall = GetNetworkCalls();
  SendUserNotification notify = SendUserNotification();


  /// Add Device UI
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: defaultAppBar(context, "Add New Device"),
      body: Wrap(
        children: [
          const SizedBox(height: defaultPadding),
          Container(
              alignment: Alignment.center,
              child: const Icon(
                Icons.qr_code_sharp,
                color: blackColor,
                size: 150,
              )),
          const SizedBox(height: defaultPadding),
          Container(
              alignment: Alignment.center,
              child: ButtonWidget(
                text: 'Scan QR Code',
                onClicked: () {},
                size: size,
              )),
          const SizedBox(height: defaultPadding),
          Container(
            padding: const EdgeInsets.all(20),
            alignment: Alignment.center,
            child: const Text(
              "- or -",
              style: TextStyle(fontSize: 16, color: blackColor),
            ),
          ),
          SizedBox(height: size.height * 0.02),
          Form(
            key: formKey,
            child: Column(
              children: [
                Container(
                  alignment: Alignment.center,
                  margin: const EdgeInsets.symmetric(horizontal: 40),
                  child: TextFieldWidget(
                    text: 'Your Device ID',
                    textInputType: TextInputType.text,
                    icon: Icons.sensors,
                    textColor: blackColor,
                    iconColor: headingColor,
                    obscureText: false,
                    textController: deviceIDController,
                  ),
                ),
                SizedBox(height: size.height * 0.02),
              ],
            ),
          ),
          const SizedBox(height: 40),
          Container(
              alignment: Alignment.centerRight,
              margin: const EdgeInsets.all(20),
              child: ButtonWidget(
                text: 'Add',
                onClicked: () async {
                  var connectivity = await checkInternetConnectivity();
                  if (connectivity) {
                    if (formKey.currentState!.validate()) {
                      deviceValues.add(deviceIDController.text);
                      // deviceValues.add(securityCodeController.text);
                      deviceValues.add("1234");
                      setState(() {
                        loading = true;
                      });
                      addDevice();
                      setState(() {
                        loading = false;
                      });
                    }
                  } else {
                    showError('Check your internet connectivity');
                  }
                },
                size: size,
              )),
          !loading
              ? const Text("")
              : const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Center(
                    child: CircularProgressIndicator(
                      color: Colors.green,
                    ),
                  ),
                )
        ],
      ),
    );
  }

  /// Navigate to Payment Screen
  void sendUserToNewScreen(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const PaymentScreen()),
    );
  }

  /// Check Internet Connection
  Future<bool> checkInternetConnectivity() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      return false;
    } else {
      return true;
    }
  }

  /// Add Device to database
  void addDevice() async {
    String userId = user.userId.toString();
    var msg = await networkCall.addDevice(
        category: deviceValues[0],
        deviceName: deviceValues[1],
        deviceId: deviceValues[2],
        securityCode: deviceValues[3],
        userId: userId);
    if (msg == 'Success') {
      /// Send Notification to User
      notify.sendNotification(
          subject: "New Device Added - Temp Q Application",
          emailMessage:
              "A new device with ID ${deviceValues[2]} has been added to your account. "
                  "Currently you have not buy the subscription, "
                  "Therefore your device is disabled. After payment, You can monitor your sensor",
          messageType: "Device Added",
          messageTitle: "New Device Added",
          message:
              "A new device with ID ${deviceValues[2]} has been added to your account.");

      /// Send Notification to Admin
      notify.sendNotificationToAdmin(
          subject: "Alert: New Device Added - Temp Q Application",
          emailMessage:
              "New Device Added by User ${user.userEmail} to Temp Q Application. "
                  "Currently, user has not buy the subscription",
          messageType: "Device Added",
          messageTitle: "New Device Added by User ${user.userEmail}",
          message:
              "A new device with ID ${deviceValues[2]} has been added by User ${user.userEmail}");

      deviceIDController.clear();
      // securityCodeController.clear();
      deviceValues.clear();

      /// Navigate to buy Payment Plan
      navigateToPaymentScreen();

    } else {
      showError(msg);

    }
  }

  /// Show Error
  void showError(String msg){
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          msg.toString(),
          style: const TextStyle(fontSize: 16, color: Colors.red),
        )));
  }

  /// Show Dialogue Box to Navigate to Payment
  void navigateToPaymentScreen(){
    showDialog(
        context: context,
        builder: (context) => AlertDialogWidget(
          icon: const Icon(
            Icons.check,
            size: 40,
            color: greenColor,
          ),
          text: 'Device Added Successfully',
          content:
          'Your Device is added successfully. Choose Your Payment'
              ' plan to check your sensor readings.',
          button1Text: 'Cancel',
          button2Text: 'Choose Payment Plan',
          onPressed1: () {
            Navigator.pop(context);
          },
          onPressed2: () {
            sendUserToNewScreen(context);
          },
        ));
  }
}
