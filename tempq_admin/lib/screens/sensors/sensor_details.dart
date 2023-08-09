import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:tempq_admin/http/post_request.dart';

import '../../components/alert_dialog_widget.dart';
import '../../components/defaultAppBar.dart';
import '../../constants/constants.dart';
import '../../models/userModel.dart';

class SensorDetails extends StatefulWidget {
  final String deviceId;

  const SensorDetails({Key? key, required this.deviceId}) : super(key: key);

  @override
  State<SensorDetails> createState() => _SensorDetailsState();
}

class _SensorDetailsState extends State<SensorDetails> {
  final user = UserModel.myUser;
  late List data = [];
  bool loading = false;
  late String status;

  // Function to get the data from the database
  Future<String> getData() async {
    // Make a HTTP GET request to the PHP script
    var url = Uri.parse(
        'http://tempq.frostcarusa.com/tempQ/get_sensor_info.php');
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

      appBar: defaultAppBar(context, "Sensor Details"),
      body: data == []
      // Show a loading spinner while the data is being retrieved
          ? const Text('No Details Found')
      // Build the DataTable widget with the retrieved data
          : Padding(
        padding: const EdgeInsets.all(defaultPadding),
        child:  Container(
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.all(defaultPadding),
            decoration: const BoxDecoration(
              color: secondaryColor,
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Text("Device Details", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),),
            const SizedBox(
              height: defaultPadding,
            ),
            Text(' Device ID: ${data[0]['device_id']}'),
            const SizedBox(
              height: defaultPadding,
            ),
            Text(' Device Name: ${data[0]['device_name']}'),
            const SizedBox(
              height: defaultPadding,
            ),
            Text(' Device Category: ${data[0]['device_cat']}'),
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
            Text(' Device Registration: ${data[0]['added_on']}'),
            const SizedBox(
              height: defaultPadding,
            ),
            Text('Status: ${data[0]['status']}'),
            const SizedBox(
              height: defaultPadding,
            ),
            const Text("Payment Details", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),),
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
            const SizedBox(
              height: defaultPadding,
            ),
            Text(' Invoice Number: ${data[0]['inv_id']}'),
            const SizedBox(
              height: defaultPadding,
            ),
            // FutureBuilder(
            //   builder: (context, snapshot) {
            //     // Checking if future is resolved or not
            //     if (snapshot.connectionState == ConnectionState.done) {
            //       // If we got an error
            //       if (snapshot.hasError) {
            //         return const Center(
            //           child: Text(
            //             'Currently user have no invoice',
            //             style: TextStyle(fontSize: 16),
            //           ),
            //         );
            //
            //         // if we got our data
            //       } else if (snapshot.hasData) {
            //         // Extracting data from snapshot object
            //         final data = snapshot.data;
            //         if (data != null) {
            //           return Expanded(
            //             child: ListView.builder(
            //                 itemCount: data.length,
            //                 itemBuilder: (BuildContext context, int index) {
            //                   return InkWell(
            //                     child: Card(
            //                       color: Colors.white,
            //                       child: ListTile(
            //                         leading: IconButton(
            //                             icon:const Icon(Icons.picture_as_pdf_outlined),
            //                             color: Colors.red,
            //                             onPressed: (){
            //
            //                             }
            //
            //                         ),
            //                         trailing: IconButton(
            //                           color: Colors.grey,
            //                           onPressed: ()  {
            //
            //                           },
            //
            //                           icon:const Icon(Icons.download),
            //                         ),
            //                         title: Text(data[index]['inv_id']),
            //                         // subtitle: Text("${data[index].deviceId}\n${data[index].status}",
            //                         //   style: const TextStyle(color: Colors.grey),
            //                         // ),
            //                       ),
            //                     ),
            //                     onTap: () async {
            //
            //
            //                     },
            //                   );
            //                 }),
            //           );
            //         }
            //       }
            //     }
            //     // Displaying LoadingSpinner to indicate waiting state
            //     return const Center(
            //       child: CircularProgressIndicator(),
            //     );
            //   },
            //
            //   // Future that needs to be resolved
            //   // inorder to display something on the Canvas
            //   future: data[0]['inv_id'],
            // ),
            Center(
              child: Row(
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green
                    ),
                    onPressed: () async {
                      showDialog(
                          context: context,
                          builder: (context) => AlertDialogWidget(
                            icon: const Icon(
                              Icons.info,
                              size: 40,
                              color: Colors.red,
                            ),
                            text: 'Do you want to Enable this Device?',
                            content:
                            'After Disable, you will be unable to see device history',
                            button1Text: 'Cancel',
                            button2Text: 'Ok',
                            onPressed1: () {
                              Navigator.pop(context);
                            },
                            onPressed2: () async {
                              var msg = await SendPostRequest
                                  .callEnableDeviceFunction(
                                  data[0]['device_id']);
                              if (msg == 'Success') {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(const SnackBar(
                                    content: Text(
                                      'Device Enabled',
                                      style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.green),
                                    )));
                                Navigator.pop(context);
                              } else {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(const SnackBar(
                                    content: Text(
                                      'Something went wrong',
                                      style: TextStyle(
                                          fontSize: 16, color: Colors.red),
                                    )));
                              }
                            },
                          ));

                    },
                    child: const Text('Enable'),
                  ),
                  const SizedBox(
                    width: defaultPadding,
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red
                    ),
                    onPressed: () async {
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
                            'After Disable, user will be unable to see device history',
                            button1Text: 'Cancel',
                            button2Text: 'Ok',
                            onPressed1: () {
                              Navigator.pop(context);
                            },
                            onPressed2: () async {
                              var msg = await SendPostRequest
                                  .callDisableDeviceFunction(
                                  data[0]['device_id']);
                              if (msg == 'Success') {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(const SnackBar(
                                    content: Text(
                                      'Device has been Disabled',
                                      style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.green),
                                    )));
                                Navigator.pop(context);
                              } else {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(const SnackBar(
                                    content: Text(
                                      'Something went wrong',
                                      style: TextStyle(
                                          fontSize: 16, color: Colors.red),
                                    )));
                              }
                            },
                          ));

                      // Perform some action
                    },
                    child: const Text('Disable'),
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
        )
        ),
      ),

    );
  }


  FutureOr onGoBack(dynamic value) {
    setState(() {
      getInfo();
    });
  }
}
