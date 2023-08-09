import 'dart:async';

import 'package:flutter/material.dart';
import 'package:tempq_user/screens/payments/payment_screen.dart';
import '../../../network/GetNetworkCalls.dart';
import '../../components/defaultAppBar.dart';
import '../../constants/constants.dart';
import '../../utils/format_date.dart';
import 'invoiceDetails.dart';

class BillingPayments extends StatefulWidget {
  const BillingPayments({Key? key}) : super(key: key);

  @override
  State<BillingPayments> createState() => _BillingPaymentsState();
}

class _BillingPaymentsState extends State<BillingPayments> {
  var networkCall = GetNetworkCalls();
  late Future<List<dynamic>> futureSensor;

  /// Get Subscriptions from database
  getNetworkCalls() async {
    futureSensor = networkCall.getInvoices();
  }
  @override
  initState() {
    super.initState();
    getNetworkCalls();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: defaultAppBar(context, 'My Subscriptions'),
        body:
        Padding(
          padding: const EdgeInsets.all(defaultPadding),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "My Subscriptions",
                style: TextStyle(
                    color: primaryColor,
                    fontWeight: FontWeight.bold,
                    fontSize: subHeadingFontSize),
              ),
              const SizedBox(height: defaultPadding),
              listTile(context),

            ],
          ),
        ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: greenColor,
        onPressed: () {
          Navigator.push(context,
            MaterialPageRoute(builder: (context) =>
            const PaymentScreen(),
            ),
          ).then((onGoBack));
        },
        child: const Icon(Icons.add, color: secondaryColor,),
      ),
    );
  }
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
                  'Currently You have no Subscriptions',
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
                      return InkWell(
                        child:  Card(
                          color: Colors.white,
                          child: ListTile(
                            isThreeLine: false,
                            leading:  const Icon(
                              Icons.sensors,
                              color: Colors.green,
                            ),
                            trailing: const Icon(Icons.arrow_forward_outlined,
                                color: primaryColor),
                            title: Text(data[index]['device_id']),
                            subtitle: Text(
                              'Subscription Type: ${data[index]['plan_type']}\nExpiry:${FormatDate.formatDateTime(data[index]['valid_till'])}',
                              style:const TextStyle(color: Colors.grey),
                            ),
                          ),
                        ),
                        onTap: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) =>  InvoiceDetails(invoiceId: data[index]['inv_id'])))
                              .then(onGoBack);

                          }
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
      // inorder to display something on the Canvas0
        future: networkCall.getInvoices(),
       // future: networkCall.getUserDevicesData(),
    );
  }
  FutureOr onGoBack(dynamic value) {
    setState(() {
      getNetworkCalls();
    });
  }
}
