import 'dart:async';
import 'package:flutter/material.dart';
import 'package:tempq_user/screens/sensors/sensor_alarm_screen.dart';
import '../../../network/GetNetworkCalls.dart';
import '../../components/alert_dialog_widget.dart';
import '../../components/defaultAppBar.dart';
import '../../constants/constants.dart';
import '../../models/userModel.dart';
import '../../utils/format_date.dart';
import '../notifications/send_notification.dart';

class SensorSetting extends StatefulWidget {
  const SensorSetting({Key? key}) : super(key: key);

  @override
  State<SensorSetting> createState() => _SensorSettingState();
}

class _SensorSettingState extends State<SensorSetting> {
  var notifications = GetNetworkCalls();
  late Future<List<dynamic>> futureSensor;
  var user = UserModel.myUser;
  SendUserNotification notify = SendUserNotification();

  @override
  initState() {
    super.initState();
    futureSensor = notifications.getSensorAlarmList(user.userId.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: defaultAppBar(context, "Sensors Alarm"),
      body: Padding(
          padding: const EdgeInsets.all(defaultPadding),
          child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                listTile(context),
              ])),
      floatingActionButton: FloatingActionButton(
        backgroundColor: greenColor,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AlarmScreen(),
            ),
          ).then((onGoBack));
        },
        child: const Icon(
          Icons.add,
          color: secondaryColor,
        ),
      ),
    );
  }

  FutureOr onGoBack(dynamic value) {
    setState(() {
      futureSensor = notifications.getSensorAlarmList(user.userId.toString());
    });
  }

  Widget listTile(BuildContext context) {
    return FutureBuilder(
      builder: (context, snapshot) {
        // Checking if future is resolved or not
        if (snapshot.connectionState == ConnectionState.done) {
          // If we got an error
          if (snapshot.hasError) {
            return const Center(
              child: Text(
                'You have not set any notifications yet',
                style: TextStyle(fontSize: 16),
              ),
            );

            // if we got our data
          } else if (snapshot.hasData) {
            // Extracting data from snapshot object
            final data = snapshot.data;
            if (data != null) {
              return Expanded(
                child: ListView.builder(
                    itemCount: data.length,
                    itemBuilder: (BuildContext context, int index) {
                      return InkWell(
                        child: Card(
                          color: Colors.white,
                          child: ListTile(
                            isThreeLine: true,
                            leading: const Icon(
                              Icons.notifications_active,
                              color: primaryColor,
                            ),
                            trailing:
                                const Icon(Icons.delete, color: Colors.red),
                            title:
                                Text("Device: ${data[index]['device_name']}"),
                            subtitle: Text(
                                "You have set the alarm for this device on"
                                " min. temp: ${data[index]['minValue']}"
                                "\n and max. temp: ${data[index]['maximumValue']}"
                                "\n on${FormatDate.formatDateTime(data[index]['time_slot'])}"),
                          ),
                        ),
                        onTap: () async {
                          showDeleteAlert(data[index]['device_id']);
                        },
                      );
                    }),
              );
            }
          }
        }

        /// Displaying LoadingSpinner to indicate waiting state
        return const Center(
          child: CircularProgressIndicator(),
        );
      },

      // Future that needs to be resolved
      // inorder to display something on the Canvas
      future: notifications.getSensorAlarmList(user.userId.toString()),
    );
  }

  /// Show Message
  void showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
      message,
      style: const TextStyle(fontSize: 16, color: Colors.red),
    )));
  }

  /// Show Delete Alert Box
  void showDeleteAlert(String deviceId) {
    showDialog(
        context: context,
        builder: (context) => AlertDialogWidget(
              icon: const Icon(
                Icons.info,
                size: 40,
                color: Colors.red,
              ),
              text: 'Do you want to Delete this alarm?',
              content: '',
              button1Text: 'No',
              button2Text: 'Yes',
              onPressed1: () {
                Navigator.pop(context);
              },
              onPressed2: () async {
                var msg =
                    await GetNetworkCalls.callDeleteAlarmFunction(deviceId);
                if (msg == 'Success') {
                  sendNotification(deviceId);
                  setState(() {
                    futureSensor = notifications
                        .getSensorAlarmList(user.userId.toString());
                  });
                  Navigator.pop(context);
                } else {
                  showMessage('Something went wrong');
                }
              },
            ));
  }

  void sendNotification(String deviceId)async{
    /// Send Notification to User
    await notify.sendNotification(
      deviceId: deviceId,
      subject: "Delete Sensor Temperature Alert - Temp Q Application",
      emailMessage:
      "Dear user, you have deleted the temperature alert for device ID $deviceId.",
      messageType: "Delete Sensor Temperature Alert",
      messageTitle: "Delete Sensor Temperature Alert",
      message:
      "Dear user, you have deleted the temperature alert for device ID $deviceId.");

  }

}
