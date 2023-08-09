import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../components/defaultAppBar.dart';
import '../../components/showScaffoldClass.dart';
import '../../constants/constants.dart';
import '../../models/userModel.dart';

class ApproveSensor extends StatefulWidget {
  final String deviceId;

  const ApproveSensor({Key? key, required this.deviceId}) : super(key: key);

  @override
  State<ApproveSensor> createState() => _ApproveSensorState();
}

class _ApproveSensorState extends State<ApproveSensor> {
  final user = UserModel.myUser;
  late List data = [];
  bool loading = false;
  late String status;

  // Function to get the data from the database
  Future<String> getData() async {
    // Make a HTTP GET request to the PHP script
    var url = Uri.parse(
        'http://tempq.frostcarusa.com/tempQ/admin/get_user_devices_for_approval.php');
    var response = await http.post(url, headers: {"Accept": "application/json"},
        body: {
          "deviceId": widget.deviceId
        });
    var msg = json.decode(response.body);
    if (msg == "Error") {
      return "Error";
    } else {
      setState(() {
        data = json.decode(response.body);
      });
      // Return a response
      return "Success";
    }
  }

  @override
  void initState() {
    super.initState();
    // Call the getData function when the app starts
    getInfo();
  }
  getInfo() async{
    await getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: defaultAppBar(context, "Approve Request"),
      body: data == []
      // Show a loading spinner while the data is being retrieved
          ? Text('No User Found')
      // Build the DataTable widget with the retrieved data
          : Padding(
        padding: const EdgeInsets.all(defaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(' Device ID: ${data[0]['device_id']}'),
            const SizedBox(
              height: defaultPadding,
            ),
            Text(' Device Name: ${data[0]['device_name']}'),
            const SizedBox(
              height: defaultPadding,
            ),
            Text(' User Name: ${data[0]['user_full_name']}'),
            const SizedBox(
              height: defaultPadding,
            ),
            Text(' User Email: ${data[0]['user_email']}'),
            const SizedBox(
              height: defaultPadding,
            ),
            Text(' Verified Email:  ${data[0]['is_verified']}'),
            const SizedBox(
              height: defaultPadding,
            ),
            Text(' Has the user pay for the device?:  ${data[0]['is_paid']}'),
            const SizedBox(
              height: defaultPadding,
            ),
            Text(
                ' Has the user generated the voucher?: ${data[0]['is_invoice_generated']}'),
            const SizedBox(
              height: defaultPadding,
            ),
            Text(' Device Category: ${data[0]['device_cat']}'),
            const SizedBox(
              height: defaultPadding,
            ),
            const SizedBox(
              height: defaultPadding,
            ),
            Text(' Invoice Number: ${data[0]['inv_id']}'),
            const SizedBox(
              height: defaultPadding,
            ),
            Center(
              child: Row(
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green
                    ),
                    onPressed: () async {
                      setState(() {
                        loading = true;
                        status = 'Approved';
                      });
                      var msg = await changeDeviceStatusRequest(
                          data[0]['device_id'], status);
                      if (msg == 'Success') {
                        sendNotification(data[0]['device_id'], data[0]['user_id']);
                        ShowScaffoldClass().showScaffoldMessage(
                            context, 'Status Approved', Colors.green);
                        Navigator.pop(context);
                      }
                      else if (msg == 'Error') {
                        ShowScaffoldClass().showScaffoldMessage(
                            context, 'Error Occurred', Colors.red);
                      }
                      setState(() {
                        loading = false;
                      });
                    },
                    child: Text('Approve'),
                  ),
                  const SizedBox(
                    width: defaultPadding,
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red
                    ),
                    onPressed: () async {
                      setState(() {
                        loading = true;
                        status = 'Rejected';
                      });
                      var msg = await changeDeviceStatusRequest(
                          data[0]['device_id'], status);
                      if (msg == 'Success') {
                        ShowScaffoldClass().showScaffoldMessage(
                            context, 'Status Approved', Colors.green);
                        Navigator.pop(context);
                      }
                      else if (msg == 'Error') {
                        ShowScaffoldClass().showScaffoldMessage(
                            context, 'Error Occurred', Colors.red);
                      }
                      setState(() {
                        loading = false;
                      });

                      // Perform some action
                    },
                    child: Text('Reject'),
                  ),


                ],
              ),

            ),
            !loading
                ? const Text("")
                : Center(
                  child: Padding(
                    padding: const EdgeInsets.all(defaultPadding),
                    child: const CircularProgressIndicator(
              color: Colors.green,
            ),
                  ),
                )
          ],
        ),
      ),

    );
  }

  FutureOr onGoBack(dynamic value) {
    setState(() {
      getInfo();
    });
  }

  Future<String> changeDeviceStatusRequest(String Id, String status) async {
    // Make a HTTP GET request to the PHP script
    var url = Uri.parse(
        'http://tempq.frostcarusa.com/tempQ/changeDeviceStatus.php');
    var response = await http.post(url, headers: {"Accept": "application/json"},
        body: {
          "deviceId": Id,
          "status": status,
          "userId": user.userId.toString()
        });
    var msg = json.decode(response.body);
    if (msg == "Error") {
      return "Error";
    } else {
      // Return a response
      return "Success";
    }
  }
  Future sendNotification(String deviceId, String userId) async {
    var url = Uri.parse('http://tempq.frostcarusa.com/tempQ/send_approve_notification.php');
    var response = await http.post(url,
        headers: {"Accept": "application/json"},
        body: {
          "deviceId": deviceId,
          "userId": userId
        });
    var jsonList = json.decode(response.body);
    if (response.statusCode == 200) {
      return 'success';
    }
  }
}
