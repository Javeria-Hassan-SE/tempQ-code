import 'dart:async';
import 'package:flutter/material.dart';
import 'package:tempq_admin/http/delete_request.dart';
import 'package:tempq_admin/http/get_request.dart';
import 'package:tempq_admin/http/post_request.dart';
import 'package:tempq_admin/screens/sensors/sensor_details.dart';
import 'package:tempq_admin/screens/sensors/view_sensor.dart';
import '../../components/alert_dialog_widget.dart';
import '../../components/defaultAppBar.dart';
import '../../constants/constants.dart';
import '../../models/sensorsModel.dart';
import 'add_new_sensor_device.dart';
import 'approve_sensor.dart';

class ShowSensors extends StatefulWidget {
  const ShowSensors({Key? key}) : super(key: key);

  @override
  State<ShowSensors> createState() => _ShowSensorsState();
}

class _ShowSensorsState extends State<ShowSensors> {
  var data1 = GetRequest();
  var data2 = SendPostRequest();
  late Future<List<AdminSensorsDevice>> futureSensor;

  @override
  initState() {
    super.initState();
    futureSensor = data1.fetchData();
  }

  @override
  Widget build(BuildContext context) {
    var categories = SendPostRequest();
    return Scaffold(
        appBar: defaultAppBar(context, "Sensors"),
        body: Padding(
            padding: const EdgeInsets.all(defaultPadding),
            child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [listTile(context)])),
        floatingActionButton: FloatingActionButton(
          backgroundColor: greenColor,
          onPressed: ()async {
            await categories.getSensorCategory();
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const AddNewSensor())).then(onGoBack);
          },
          child: const Icon(
            Icons.add,
            color: secondaryColor,
          ),
        ));
  }

  FutureOr onGoBack(dynamic value) {
    setState(() {
      futureSensor = data1.fetchData();
      data2.getSensorCategory();
    });
  }

  Future<void> _pullRefresh() async {
    setState(() {
      futureSensor = data1.fetchData();
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
                'Currently there is no device',
                style: TextStyle(fontSize: 16),
              ),
            );

            // if we got our data
          } else if (snapshot.hasData) {
            // Extracting data from snapshot object
            final data = snapshot.data;
            if (data != null) {
              return Expanded(
                child: RefreshIndicator(
                  onRefresh: _pullRefresh,
                  child: ListView.builder(
                      itemCount: data.length,
                      itemBuilder: (BuildContext context, int index) {
                        return InkWell(
                          child: Card(
                            color: Colors.white,
                            child: ListTile(
                              leading: IconButton(
                                icon: const Icon(Icons.info),
                                color: Colors.green,
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => SensorDetails(
                                              deviceId: data[index].deviceId)));
                                },
                              ),
                              trailing: IconButton(
                                color: Colors.red,
                                onPressed: () async {
                                  if(data[index].status == "Activated"){
                                    showAlert(data[index].deviceId, 'This device is currently registered by some user, Do you actually want to delete it?');
                                  }else{
                                    showAlert(data[index].deviceId, 'Do you want to delete this device?');

                                  }

                                },
                                icon: const Icon(Icons.delete),
                              ),
                              title: Text(data[index].deviceName),
                              subtitle: Text(
                                "${data[index].deviceId}\n${data[index].status}",
                                style: const TextStyle(color: Colors.grey),
                              ),
                            ),
                          ),
                          onTap: () async {
                            var msg = await data1
                                .checkIsUserDevice(data[index].deviceId);

                            // var msg = await data.checkIsUserDevice(data[index].deviceId);
                            if (msg == "User has Not paid yet") {
                              navigateToViewSensorData(
                                  data[index].deviceId,
                                  data[index].deviceName,
                                  data[index].status,
                                  'Unpaid',
                                  'This device is not paid and not active');
                            } else if (msg == "Require Admin Approval") {
                              showApproveSensor(data[index].deviceId);
                            } else if (msg == "Error") {
                              navigateToViewSensorData(
                                  data[index].deviceId,
                                  data[index].deviceName,
                                  data[index].status,
                                  'Unregistered Device',
                                  'No user has register this device yet');
                            } else if (msg == "Success") {
                              showViewSensorScreen(data[index].deviceId,
                                  data[index].deviceName, data[index].status);
                            }
                          },
                        );
                      }),
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
      future: data1.fetchData(),
    );
  }

  showApproveSensor(String deviceId) {
    showDialog(
        context: context,
        builder: (context) => AlertDialogWidget(
              icon: const Icon(
                Icons.info,
                size: 40,
                color: Colors.red,
              ),
              text: 'Require admin Approval',
              content:
                  'User has paid for this device and it requires admin approval',
              button1Text: 'Cancel',
              button2Text: 'Approve',
              onPressed1: () {
                Navigator.pop(context);
              },
              onPressed2: () {
                Navigator.pop(context);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ApproveSensor(
                              deviceId: deviceId,
                            ))).then(onGoBack);

              },
            ));
  }

  /// View Sensor
  showViewSensorScreen(String deviceId, String deviceName, String status) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ViewSensor(
                deviceID: deviceId,
                deviceName: deviceName,
                status: status))).then(onGoBack);
  }

  /// Show Alert box before deleting
  showAlert(String id, String content) {
    showDialog(
        context: context,
        builder: (context) => AlertDialogWidget(
              icon: const Icon(
                Icons.close,
                size: 40,
                color: Colors.red,
              ),
              text: 'Delete',
              content: content,
              button1Text: 'No',
              button2Text: 'Yes',
              onPressed1: () {
                Navigator.pop(context);
              },
              onPressed2: () async {
                Navigator.pop(context);
                var msg = await DeleteRequest.callDeleteDeviceFunction(id);
                if (msg == 'Success') {
                  setState(() {
                    futureSensor = data1.fetchData();
                    data2.getSensorCategory();
                  });
                  showMessage('Deleted', Colors.green);
                } else {
                  showMessage(
                      'This device is registered by some user', Colors.red);
                }
              },
            ));
  }

  /// Show Message
  showMessage(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
      message,
      style: TextStyle(fontSize: 16, color: color),
    )));
  }

  /// If the device is not paid but admin can still see the data
  void navigateToViewSensorData(String deviceId, String deviceName,
      String status, String title, String content) {
    showDialog(
        context: context,
        builder: (context) => AlertDialogWidget(
              icon: const Icon(
                Icons.info,
                size: 40,
                color: Colors.red,
              ),
              text: title,
              content: content,
              button1Text: 'Cancel',
              button2Text: 'View Sensor Info',
              onPressed1: () {
                Navigator.pop(context);
              },
              onPressed2: () {
                Navigator.pop(context);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ViewSensor(
                              deviceID: deviceId,
                              deviceName: deviceName,
                              status: status,
                            ))).then(onGoBack);
              },
            ));
  }
}
