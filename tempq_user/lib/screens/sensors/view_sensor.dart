import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:connectivity/connectivity.dart';
import 'package:tempq_user/screens/sensors/temp_history_chart.dart';
import 'package:tempq_user/screens/sensors/temperature_pie_chart.dart';
import '../../components/alert_dialog_widget.dart';
import '../../components/defaultAppBar.dart';
import '../../components/showScaffoldClass.dart';
import '../../constants/constants.dart';
import '../../models/sensorDeviceModel.dart';
import '../../models/userModel.dart';
import '../../network/GetNetworkCalls.dart';
import '../../responsive/responsive.dart';
import '../../utils/format_date.dart';
import '../notifications/send_notification.dart';
import 'battery_widget.dart';

class ViewSensor extends StatefulWidget {
  final String deviceID;
  final String deviceName;


  const ViewSensor({Key? key, required this.deviceID, required this.deviceName}) : super(key: key);

  @override
  State<ViewSensor> createState() => _ViewSensorState();
}

class _ViewSensorState extends State<ViewSensor> {
  var networkCall = GetNetworkCalls();
  late Future<List<UserSensorDeviceModel>> futureSensor;
  late List<ChartSampleData> chartData1 = <ChartSampleData>[];
  late DateTime dateTime;
  SendUserNotification notify = SendUserNotification();
  var user = UserModel.myUser;
  Timer? _timer;


  /// Init State
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _startFetchingData();
  }
  /// Update records for every 10 seconds
  void _startFetchingData() {
    // Fetch data every 10 seconds using Timer.periodic
    _timer = Timer.periodic(const Duration(seconds: 20), (timer) {
      getData();
    });
  }


  /// Get Sensor Data from database
  getData() async {
    var connectivity = await checkInternetConnectivity();
    if (connectivity) {
      futureSensor = networkCall.fetchSensorData(widget.deviceID);
    } else {
      showMessage('Check your internet connectivity', Colors.red);
    }
  }

  /// Show Toast Message
  showMessage(String message, Color color){
    ShowScaffoldClass().showScaffoldMessage(
        context, message, color );
  }

  @override
  void dispose() {
    // Cancel the timer when the screen is disposed (navigated away)
    _timer?.cancel();
    super.dispose();
  }

  /// UI
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
                        style: const TextStyle(fontWeight: FontWeight.bold,),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Theme.of(context)
                              .colorScheme
                              .onSecondaryContainer,
                          backgroundColor: headingColor,
                        ).copyWith(elevation: ButtonStyleButton.allOrNull(0.0)),
                        onPressed: () {
                         sendDisableDeviceRequest();
                        },
                        child: Container(
                          alignment: Alignment.center,
                          height: 50.0,
                          // width: size.width * 0.3,
                          padding: const EdgeInsets.all(0),
                          child: const Text(
                            "Disable",
                            textAlign: TextAlign.center,
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                    ],
                  )),
              const SizedBox(height: defaultPadding,),
              FutureBuilder(
                builder: (context, snapshot) {
                  // Checking if future is resolved or not
                  if (snapshot.connectionState == ConnectionState.done) {

                    // If we got an error
                    if (snapshot.hasError) {
                      return const Center(
                        child: Text(
                          'No Data Found',
                          style: TextStyle(fontSize: 18),
                        ),
                      );
                      // if we got our data
                    } else if (snapshot.hasData) {
                      // Extracting data from snapshot object
                      final data = snapshot.data;
                      // if (data != null && data[0].sensTempF != -127) {
                      if (data != null) {
                        for (var i = 0; i < data.length; i++) {
                          chartData1.add(ChartSampleData(
                              x: data[i].readingDateTime,
                              yValue: data[i].sensTempF));

                        }
                        String timestampString = data[0].timeStamp;
                        String readingDate = data[0].readingDate;
                        DateTime timestamp = DateTime.parse("$readingDate $timestampString");
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
                            TempHistoryChart(
                              chartData1: chartData1,
                            ),
                          ],
                        );
                      } else {
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
                future: networkCall.fetchSensorData(widget.deviceID),
              )
            ],
          ),
        )));
  }

  /// Clear Data after every 60 sec to get filled up with new data
  clearData() {
    chartData1.clear();
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

  /// Send Disable Device Request with Notification
  void sendDisableDeviceRequest(){
    showDialog(
        context: context,
        builder: (context) => AlertDialogWidget(
          icon: const Icon(
            Icons.info,
            size: 40,
            color: Colors.red,
          ),
          text: 'Do you want to Disable this Device?',
          content:
          'After Disable, you will be unable to see device history',
          button1Text: 'No',
          button2Text: 'Yes',
          onPressed1: () {
            Navigator.pop(context);
          },
          onPressed2: () async {
            var msg = await GetNetworkCalls
                .callDisableDeviceFunction(
                widget.deviceID);
            if (msg == 'Success') {
               notifyUsers();
              showMessage('Device has been Disabled', Colors.green);
              Navigator.pop(context);
              Navigator.pop(context);
            } else {
              showMessage('Something went wrong', Colors.red);

            }
          },
        ));
  }

  /// Refresh Screen State
  FutureOr onGoBack(dynamic value) {
    setState(() {});
  }
  void notifyUsers()async{
    /// Send Notification to User
    await notify.sendNotification(
      deviceId: widget.deviceID,
        subject: "Device Disabled - Temp Q Application",
        emailMessage:
        "You have disabled your device ID ${widget.deviceID}."
            "Now you will be unable to check your sensor readings until you request to enable to it.",
        messageType: "Device Disabled",
        messageTitle: "Device Disabled",
        message:
        "You have disabled your device ID ${widget.deviceID}."
            "Now you will be unable to check your sensor readings until you request to enable to it.",);

    /// Send Notification to Admin
    notify.sendNotificationToAdmin(
        deviceId: widget.deviceID,
        subject: "Alert: Device Disabled - Temp Q Application",
        emailMessage:
        "A device ${widget.deviceID} has been disabled by its user ${user.userEmail}.",
        messageType: "Device Disabled",
        messageTitle: "Device Disabled by User ${user.userEmail}",
        message:
        "A device ${widget.deviceID} has been disabled by its user ${user.userEmail}.");

  }
}
