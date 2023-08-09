import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:connectivity/connectivity.dart';
import 'package:tempq_user/screens/payments/payment_screen.dart';
import 'package:tempq_user/screens/sensors/sensors_summary.dart';
import 'package:tempq_user/screens/sensors/view_sensor.dart';
import '../components/alert_dialog_widget.dart';
import '../components/showScaffoldClass.dart';
import '../components/welcomeBar.dart';
import '../constants/constants.dart';
import '../models/sensors_summary_model.dart';
import '../models/userDeviceModel.dart';
import '../models/userModel.dart';
import '../network/GetNetworkCalls.dart';
import '../services/notification_services.dart';
import 'notifications/send_notification.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  NotificationServices notificationServices = NotificationServices();
  var networkCall = GetNetworkCalls();
  var user = UserModel.myUser;
  var activeDeviceSummary = SensorsSummaryModel.activeDevices;
  var disableDeviceSummary = SensorsSummaryModel.disableDevices;
  bool loading = false;
  bool visibility = false;
  int minValue = 0;
  int maxValue = 0;
  late Future<List<UserDeviceModel>> futureSensor;
  SendUserNotification notify = SendUserNotification();
  Timer? _timer;


  /// Init State
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    dropDownCategoryList.clear();
    _startFetchingData();
  }
  /// Update records for every 10 seconds
  void _startFetchingData() {
    // Fetch data every 10 seconds using Timer.periodic
    _timer = Timer.periodic(const Duration(seconds: 30), (timer) {
      if(mounted){
        setState(() {
          getData();
        });
      }
    });
  }
  /// Dispose API Call

  @override
  void dispose() {
    // Cancel the timer when the screen is disposed (navigated away)
    _timer?.cancel();
    super.dispose();
  }

  /// get Data when dashboard screen first initialize
  getData() async {
    var connectivity = await checkInternetConnectivity();
    if (connectivity) {
      getNetworkCalls();
      networkCall.getDevicesToTriggerForAlarm();
      listenNotifications();
    } else {
      showMessage('Check your internet connectivity', Colors.red);
    }
  }

  /// show Toast Messages
  void showMessage(String message, Color color){
    ShowScaffoldClass().showScaffoldMessage(
        context, message, color);
  }

  /// Listen for firebase notifications
  listenNotifications(){
    notificationServices.requestNotificationPermission();
    notificationServices.forgroundMessage();
    notificationServices.firebaseInit(context);
    notificationServices.setupInteractMessage(context);
    notificationServices.isTokenRefresh();
    notificationServices.getDeviceToken().then((value){
      if (kDebugMode) {
        print('device token');
        print(value);
      }
    });
  }

  /// getUserDevices Data
  getNetworkCalls()  {
    futureSensor =  networkCall.getUserDevicesData();
  }

  /// Dashboard UI
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(defaultPadding),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: defaultPadding,
            ),
            const WelcomeBar(),
            const SensorsSummary(),
            const SizedBox(
              height: 5,
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.all(defaultPadding),
              decoration: const BoxDecoration(
                color: bgColor,
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              child:
              const Text(
                "My Devices",
                style: TextStyle(
                    color: primaryColor,
                    fontWeight: FontWeight.bold,
                    fontSize: subHeadingFontSize),
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            listTile(context),
          ],
        ),
      ),
    );
  }

  /// List Widget to show Devices
  Widget listTile(BuildContext context) {
    return FutureBuilder(
      builder: (context, snapshot) {
        // Checking if future is resolved or not
        if (snapshot.connectionState == ConnectionState.done) {
          // If we got an error
          if (snapshot.hasError) {
            return const Padding(
              padding: EdgeInsets.all(16),
              child: Center(
                child: Text(
                  'Currently You have no Device',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            );

            // if we got our data
          } else if (snapshot.hasData) {
            // Extracting data from snapshot object
            final data = snapshot.data;
            if (data != null) {
              return Expanded(
                flex: 1,
                child: ListView.builder(
                    itemCount: data.length,
                    itemBuilder: (BuildContext context, int index) {
                      activeDeviceSummary.total = data.length;
                      disableDeviceSummary.total = data.length;
                      int activeCount = 0;
                      int disableCount = 0;
                      userUnpaidDevices.clear();
                      userPaidDevices.clear();
                      for (var i = 0; i < data.length; i++) {
                        if (data[i].status == 'Not Activated') {
                          disableCount++;
                          userUnpaidDevices.add(data[i].deviceId);
                        } else {
                          activeCount++;
                          userPaidDevices.add(data[i].deviceId);
                        }
                      }
                      activeDeviceSummary.count = activeCount;
                      disableDeviceSummary.count = disableCount;
                      activeDeviceSummary.percentage =
                          (activeCount * 100) / data.length;
                      disableDeviceSummary.percentage =
                          (disableCount * 100) / data.length;
                      String status = "";
                      if (data[index].status == "Disabled" &&
                          data[index].isEnabled == 1) {
                        status = "Pending Enabled Request";
                      } else {
                        status = data[index].status;
                      }
                      return InkWell(
                        child: Card(
                          color: Colors.white,
                          child: ListTile(
                            isThreeLine: false,
                            leading: const Icon(
                              Icons.sensors,
                              color: Colors.green,
                            ),
                            trailing: const Icon(Icons.arrow_forward_outlined,
                                color: primaryColor),
                            title: Text(data[index].deviceName),
                            subtitle: Text(
                              status,
                              style: const TextStyle(color: Colors.grey),
                            ),
                          ),
                        ),
                        onTap: () {
                          if (data[index].isInvoiceGenerated == 'No') {
                            /// navigate to payment
                            navigateUserToPayForDevice();
                          } else if (data[index].status == 'Disabled' &&
                              data[index].isPaid == 'false') {
                            /// navigate to show that admin approval is required
                           showAdminApprovalRequiredForPayment();
                          } else if (data[index].status == 'Disabled' &&
                              data[index].isEnabled == 1) {
                            /// show message that you've already requested to enable your device
                            showMessage('Your device enable request has been already sent to admin for approval', Colors.red);
                          } else if (data[index].status == 'Disabled') {
                            /// sendEnableRequest
                            sendEnableRequest(data[index].deviceId);
                          } else {
                           viewSensor(data[index].deviceId, data[index].deviceName);

                          }

                        },
                      );
                    }),
              );
            }
          }
        }
        // Displaying LoadingSpinner to indicate waiting state
        return const Center(
          child: CircularProgressIndicator(),
        );
      },

      // Future that needs to be resolved
      // inorder to display something on the Canvas
      future: networkCall.getUserDevicesData(),
    );
  }

  /// Navigate to View Sensor
  void viewSensor(String deviceId, String deviceName){
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ViewSensor(
              deviceID: deviceId,
              deviceName: deviceName,
            ))).then(onGoBack);
  }

  /// Send Enable Request
  void sendEnableRequest(String deviceId){
    showDialog(
        context: context,
        builder: (context) => AlertDialogWidget(
          icon: const Icon(
            Icons.info,
            size: 40,
            color: Colors.red,
          ),
          text: 'Your Device is Disabled',
          content:
          'Do you want to Enable your device?',
          button1Text: 'No',
          button2Text: 'Yes',
          onPressed1: () {
            Navigator.pop(context);
          },
          onPressed2: ()  {
            sendNotification(deviceId);
            showMessage('Your device enable request has been sent to admin for approval', Colors.green);
            Navigator.pop(context);
          },
        ));
  }

  /// Send Enable Request with Notifications to both User and Admin
  void sendNotification(String deviceId)async{
    var message =  await GetNetworkCalls
        .sendEnableRequest(
        deviceId);
    if(message == 'Success'){
      /// Send Notification to User
      notify.sendNotification(
          subject: "Device Enable Request - Temp Q Application",
          emailMessage:
          "Your request to enable '$deviceId' has been send to admin. It may take some time, "
              "when the admin will approve your request, you will be able to monitor your sensor."
             ,
          messageType: "Device Enabled Request",
          messageTitle: "Device Enabled Request",
          message:
          "Your request to enable '$deviceId' has been send to admin. It may take some time, "
              "when the admin will approve your request, you will be able to monitor your sensor.");

      /// Send Notification to Admin
      notify.sendNotificationToAdmin(
          subject: "Alert: Device Enable Request - Temp Q Application",
          emailMessage:
          "A request has been received by user: ${user.userEmail} to enable device $deviceId. Kindly check the application to process accordingly.",
          messageType: "Device Enabled Request",
          messageTitle: "Device Enabled Request",
          message:
          "A request has been received by user: ${user.userEmail} to enable device $deviceId.");
    }else{

    }

  }
  /// Get Fresh data from database every time when user return from another screen
  FutureOr onGoBack(dynamic value) {
    if(mounted) {
      setState(() {
        getNetworkCalls();
      });
    }
  }

  /// Navigate to Payment Screen
  sendPaymentMethod() {
    Navigator.push(context,
            MaterialPageRoute(builder: (context) => const PaymentScreen()))
        .then(onGoBack);
  }

  /// Show Admin Approval Required for User Payment Verification
  void showAdminApprovalRequiredForPayment(){
    showDialog(
        context: context,
        builder: (context) => AlertDialogWidget(
          icon: const Icon(
            Icons.info,
            size: 40,
            color: Colors.red,
          ),
          text: 'Payment Required',
          content:
          'Your payment is still not approved by admin. Kindly wait for approval.',
          button1Text: 'Cancel',
          button2Text: 'Ok',
          onPressed1: () {
            Navigator.pop(context);
          },
          onPressed2: () {
            Navigator.pop(context);
          },
        ));
  }

  /// Navigate User for Payment
  void navigateUserToPayForDevice(){
    showDialog(
        context: context,
        builder: (context) => AlertDialogWidget(
          icon: const Icon(
            Icons.payment,
            size: 40,
            color: Colors.red,
          ),
          text: 'Unpaid Device',
          content:
          'Kindly select payment for your device',
          button1Text: 'Cancel',
          button2Text: 'Payment',
          onPressed1: () {
            Navigator.pop(context);
          },
          onPressed2: () {
            Navigator.pop(context);
            sendPaymentMethod();
          },
        ));
  }

  /// Check Internet Connectivity
  Future<bool> checkInternetConnectivity() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      return false;
    } else {
      return true;
    }
  }


}
