
import 'dart:convert';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:tempq_admin/http/post_request.dart';
import 'package:tempq_admin/screens/sensors/temp_history_chart.dart';
import 'package:tempq_admin/screens/sensors/temperature_pie_chart.dart';

import '../../components/alert_dialog_widget.dart';
import '../../components/defaultAppBar.dart';
import '../../components/showScaffoldClass.dart';
import '../../constants/constants.dart';
import '../../models/sensorDeviceModel.dart';
import '../../models/userModel.dart';
import '../../responsive/responsive.dart';
import '../../utils/format_date.dart';
import '../notifications/send_notification.dart';
import 'battery_widget.dart';
import 'package:http/http.dart' as http;

class UserInfo {
  final String? userName;
  final String? userEmail;
  final String? deviceStatus;
  final String? subscriptionType;
  final String? subscriptionExpiry;
  final String? paidStatus;

  UserInfo({this.userName, this.userEmail,  this.deviceStatus, this.subscriptionType,  this.subscriptionExpiry, this.paidStatus});

  factory UserInfo.fromJson(Map<String, dynamic> json) {
    return UserInfo(
      userName: json['user_full_name'] ?? "No user has registered yet",
      userEmail: json['user_email'] ?? "NA",
      deviceStatus: json['status'] ?? "NA",
      subscriptionType: json['plan_type'] ?? "NA",
      subscriptionExpiry: json['valid_till'] ?? "NA",
      paidStatus: json['is_paid']?? "NA"
    );
  }
}

class ViewSensor extends StatefulWidget {
  final String deviceID;
  final String deviceName;
  final String status;

  const ViewSensor({Key? key, required this.deviceID, required this.deviceName, required this.status}) : super(key: key);

  @override
  State<ViewSensor> createState() => _ViewSensorState();
}

class _ViewSensorState extends State<ViewSensor> {
  var networkCall = SendPostRequest();
  late Future<List<UserSensorDeviceModel>> futureSensor;
  late List<ChartSampleData> chartData1 = <ChartSampleData>[];
  late DateTime dateTime;
  String deviceStatus='';
  SendUserNotification notify = SendUserNotification();
  var user = UserModel.myUser;
  List<UserInfo> pdfList = [];

  Future<void> fetchUserData(String deviceID) async {
    const url = 'http://tempq.frostcarusa.com/tempQ/admin/fetch_user_data_for_sensor.php'; // Replace with your API endpoint
    // final response = await http.post(Uri.parse(url));
    var response = await http.post(Uri.parse(url), headers: {"Accept": "application/json"},
        body: {"deviceId": deviceID});

    if (response.statusCode == 200) {
      List<dynamic> jsonData = jsonDecode(response.body);
      if (jsonData.isNotEmpty) {
        setState(() {
          pdfList = jsonData.map((item) => UserInfo.fromJson(item)).toList();
        });
      } else {
        // Handle case when no data found
        setState(() {
          pdfList = []; // Set an empty list to clear any previous data
        });
        print('No data found for the given device ID.');
      }
    } else {
      print('Failed to fetch user data.');
    }
  }



  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // fetchUserData(widget.deviceID);
    getData();
  }
  getData() async {
    if(mounted){
      await fetchUserData(widget.deviceID);
      var connectivity = await checkInternetConnectivity();
      if(connectivity){
        futureSensor = networkCall.fetchSensorData(widget.deviceID);
        _updateData();
      }else{
        showMessage('Check your internet connectivity',Colors.red);
      }
      if(widget.status=="Activated"){
        deviceStatus='Disable';
      }else{
        deviceStatus='Enable';
      }
    }

  }
  showMessage(String message, Color color){
    ShowScaffoldClass().showScaffoldMessage(context, message,color);

  }
  void _updateData() {
    setState(() {
      futureSensor = networkCall.fetchSensorData(widget.deviceID);
    });
    Future.delayed(const Duration(seconds: 10), _updateData);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: defaultAppBar(context, "Device History"),
        body: SafeArea(
            child: SingleChildScrollView(
          padding: const EdgeInsets.all(defaultPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (Responsive.isMobile(context))
                const SizedBox(
                  height: defaultPadding,
                ),
              Container(
                  width: MediaQuery.of(context).size.width,
                  padding: const EdgeInsets.all(defaultPadding),
                  decoration: const BoxDecoration(
                    color: secondaryColor,
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        widget.deviceName,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),


                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Theme.of(context)
                              .colorScheme
                              .onSecondaryContainer,
                          backgroundColor: headingColor,
                        ).copyWith(elevation: ButtonStyleButton.allOrNull(0.0)),
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (context) => AlertDialogWidget(
                                icon: const Icon(
                                  Icons.info,
                                  size: 40,
                                  color: Colors.red,
                                ),
                                text: 'Do you want to $deviceStatus this Device?',
                                content:
                                '',
                                button1Text: 'No',
                                button2Text: 'Yes',
                                onPressed1: () {
                                  Navigator.pop(context);
                                },
                                onPressed2: () async {

                                  var msg;
                                  if(deviceStatus=="Disable"){
                                    msg = await SendPostRequest
                                        .callDisableDeviceFunction(
                                        widget.deviceID);

                                  }else if(deviceStatus=="Enable"){
                                    msg = await SendPostRequest
                                        .callEnableDeviceFunction(
                                        widget.deviceID);
                                    Navigator.pop(context);

                                  }

                                  if (msg == 'Success') {
                                    if(mounted) {
                                      setState(() {
                                        deviceStatus = deviceStatus;
                                      });
                                    }
                                    notifyUsers(deviceStatus);
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar( SnackBar(
                                        content: Text(
                                          'Device has been $deviceStatus',
                                          style: const TextStyle(
                                              fontSize: 16,
                                              color: Colors.green),
                                        )));
                                    Navigator.pop(context);
                                  } else {
                                    Navigator.pop(context);
                                    showMessage('This device is not registered by any other user.', Colors.red);
                                  }
                                },
                              ));
                        },
                        child: Container(
                          alignment: Alignment.center,
                          height: 50.0,
                          // width: size.width * 0.3,
                          padding: const EdgeInsets.all(0),
                          child:  Text(
                            deviceStatus,
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                    ],
                  )),
              const SizedBox(
                height: defaultPadding,
              ),

              FutureBuilder(
                builder: (context, snapshot) {
                  // Checking if future is resolved or not
                  if (snapshot.connectionState == ConnectionState.done) {
                    // If we got an error
                    if (snapshot.hasError) {
                      return const Center(
                        child: Text(
                          'No data Found',
                          style: TextStyle(fontSize: 18),
                        ),
                      );
                      // if we got our data
                    } else if (snapshot.hasData) {
                      // Extracting data from snapshot object
                      final data = snapshot.data;
                      if (data != null && data[0].sensTempF != -127 ) {
                        for(var i=0;i<data.length;i++){
                          chartData1.add(ChartSampleData(x: data[i].readingDateTime, yValue: data[i].sensTempF));
                        }
                        String timestampString = data[0].timeStamp;
                        String readingDate = data[0].readingDate;
                        DateTime timestamp = DateTime.parse(readingDate +" "+ timestampString);
                        Duration difference = DateTime.now().difference(timestamp);
                        int hoursAgo = difference.inHours;
                        String hours="hours";
                        if(hoursAgo<1){
                          hoursAgo= difference.inMinutes;
                          hours="minutes";
                          if(hoursAgo<60){
                            hoursAgo= difference.inSeconds;
                            hours="seconds";
                          }
                        }else if(hoursAgo >24){
                          hoursAgo= difference.inDays;
                          hours="days";
                        }
                        return Column(
                          
                            children: [
                              Container(
                                width: MediaQuery.of(context).size.width,
                                padding: const EdgeInsets.all(defaultPadding),
                                decoration: const BoxDecoration(
                                  color: secondaryColor,
                                  borderRadius: BorderRadius.all(Radius.circular(10)),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Customer Name: ${pdfList[0].userName}",
                                      style: const TextStyle(fontWeight: FontWeight.w400, ),
                                    ),
                                    Text(
                                      "Device Status: ${pdfList[0].deviceStatus}",
                                      style: const TextStyle(fontWeight: FontWeight.w400),
                                    ),

                                    Text(
                                      "Subscription Type: ${pdfList[0].subscriptionType}",
                                      style: const TextStyle(fontWeight: FontWeight.w400),
                                    ),
                                    Text(
                                      "Subscription Status: ${pdfList[0].paidStatus}",
                                      style: const TextStyle(fontWeight: FontWeight.w400),
                                    ),
                                    Text(
                                      "Your subscription is valid till ${pdfList[0].subscriptionExpiry}",
                                      style: const TextStyle(fontWeight: FontWeight.w400),
                                    ),
                                  ],
                                ),



                              ),
                              const SizedBox(height: defaultPadding,),
                              Container(
                                width: MediaQuery.of(context).size.width,
                                padding: const EdgeInsets.all(defaultPadding),
                                decoration: const BoxDecoration(
                                  color: secondaryColor,
                                  borderRadius: BorderRadius.all(Radius.circular(10)),
                                ),
                                child:
                                Text(
                                  "Last Data Fetched on ${FormatDate.formatDateTime(data[0].readingDateTime.toString())}",
                                  style: const TextStyle(fontWeight: FontWeight.w400),
                                ),


                              ),
                              const SizedBox(height: defaultPadding,),
                              Row(
                                children: [
                                  TemperaturePieChart(
                                      width: 2.3,
                                      height: 200,
                                      tempValue: data[0].sensTempF),
                                  const SizedBox(
                                    width: defaultPadding,
                                  ),
                                  BatteryWidget(
                                      width: 2.3,
                                      height: 200,
                                      voltage: data[0].sensorPercentage),
                                  const SizedBox(
                                    height: defaultPadding,
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: defaultPadding,
                              ),
                              //
                              TempHistoryChart(chartData1: chartData1,),
                            ],
                          );

                      }
                      else{
                        return const Center(
                          child: Text(
                            'Device is offline',
                            style: TextStyle(fontSize: 18, color: Colors.red),
                          ),
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
                // future: fetchData(),
                future: networkCall.fetchSensorData(widget.deviceID),
              )
            ],
          ),

        )
        )
    );
  }
  clearData(){
    chartData1.clear();
  }
  Future<bool> checkInternetConnectivity() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      return false;
    } else {
      return true;
    }
  }
  void notifyUsers(String status)async{
    /// Send Notification to User
    await notify.sendEnableDisableNotification(
      deviceId: widget.deviceID,
      subject: "Device $status - Temp Q Application",
      emailMessage:
      "The admin ${user.userEmail} has $status your device ID ${widget.deviceID}."
          "If you think it's a mistake, you may contact admin.",
      messageType: "Device $status",
      messageTitle: "Device Disabled",
      message:
      "The admin ${user.userEmail} has disabled your device ID ${widget.deviceID}.",);

    /// Send Notification to Admin
    notify.sendNotificationToAdmin(
        deviceId: widget.deviceID,
        subject: "Alert: Device Disabled - Temp Q Application",
        emailMessage:
        "A device ${widget.deviceID} has been disabled by admin ${user.userEmail}.",
        messageType: "Device Disabled",
        messageTitle: "Device Disabled by User ${user.userEmail}",
        message:
        "A device ${widget.deviceID} has been disabled by admin ${user.userEmail}.");

  }
}
