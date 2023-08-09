import 'dart:async';
import 'package:flutter/material.dart';
import '../../../network/GetNetworkCalls.dart';
import '../../components/defaultAppBar.dart';
import '../../constants/constants.dart';
import '../../models/userModel.dart';
import '../../utils/format_date.dart';
import 'changePlan.dart';

class InvoiceDetails extends StatefulWidget {
  final String invoiceId;

  const InvoiceDetails( {Key? key, required this.invoiceId}) : super(key: key);

  @override
  State<InvoiceDetails> createState() => _InvoiceDetailsState();
}

class _InvoiceDetailsState extends State<InvoiceDetails> {
  final user = UserModel.myUser;
  bool loading = false;
  late String status;

  // Function to get the data from the database
  var networkCall = GetNetworkCalls();

  /// get data from database
  getNetworkCalls() {
    networkCall.getSpecificInvoices(widget.invoiceId);
  }
  @override
  initState() {
    super.initState();
    getNetworkCalls();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: defaultAppBar(context, "Invoice Details"),
      body: invoices.isEmpty
      // Show a loading spinner while the data is being retrieved
          ? const Center(child: Text('No Record Found'))
      // Build the DataTable widget with the retrieved data
          : Padding(
        padding: const EdgeInsets.all(defaultPadding),
        child: Container(
          padding: const EdgeInsets.all(defaultPadding),
          decoration: const BoxDecoration(
            borderRadius:  BorderRadius.all(Radius.circular(10)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(' Device ID: ${invoices[0].deviceId}'),
              const SizedBox(
                height: defaultPadding,
              ),
              Text(' Invoice Number: ${invoices[0].invId}'),
              const SizedBox(
                height: defaultPadding,
              ),
              Text(' Subscription Type: ${invoices[0].planType}'),
              const SizedBox(
                height: defaultPadding,
              ),
              Text(' Issue Date: ${FormatDate.formatDateTime(invoices[0].dateOfIssue)}'),
              const SizedBox(
                height: defaultPadding,
              ),
              Text(' Expiry Date: ${FormatDate.formatDateTime(invoices[0].validTill)} '),
              const SizedBox(
                height: defaultPadding,
              ),

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
                        Navigator.push(context,
                          MaterialPageRoute(builder: (context) =>
                           ChangePlanScreen(deviceId: invoices[0].deviceId, planType: invoices[0].planType,),
                          ),
                        ).then((onGoBack));
                      },
                      child: const Text('Change Subscription'),
                    ),
                    const SizedBox(
                      width: defaultPadding,
                    ),

                  ],
                ),

              ),
              !loading
                  ? const Text("")
                  : const Center(
                child: Padding(
                  padding: EdgeInsets.all(defaultPadding),
                  child: CircularProgressIndicator(
                    color: Colors.green,
                  ),
                ),
              )
            ],
          ),
        ),
      ),

    );
  }

  FutureOr onGoBack(dynamic value) {
    setState(() {
      getNetworkCalls();
    });
  }

}
