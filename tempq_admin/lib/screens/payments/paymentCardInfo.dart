import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:tempq_admin/screens/payments/payment_plan_card_info.dart';

import '../../components/defaultAppBar.dart';
import '../../constants/constants.dart';
import '../../models/paymentPlanModel.dart';
import '../../responsive/responsive.dart';

class PaymentSummary extends StatefulWidget {
  const PaymentSummary({Key? key}) : super(key: key);

  @override
  State<PaymentSummary> createState() => _PaymentSummaryState();
}

class _PaymentSummaryState extends State<PaymentSummary> {
  var activeDeviceSummary = PaymentInfo.activeDevices;
  var disableDeviceSummary = PaymentInfo.disableDevices;
  late List data = [];
  late List data1 = [];
  bool loading = false;

  @override
  initState() {
    super.initState();
    getPlans();
  }

  getPlans() async {
    await getData();

  }

  /// Get Payment Plans
  Future <String> getData() async {
    var url = Uri.parse(
        'http://tempq.frostcarusa.com/tempQ/admin/get_payment_plans.php');
    var response = await http.get(url, headers: {"Accept": "application/json"});
    var msg = json.decode(response.body);
    if (msg == "Error") {
      return "Error";
    } else {
      setState(() {
        data = json.decode(response.body);

        activeDeviceSummary.limit = data[0]['sensor_qty'];
        activeDeviceSummary.charges = data[0]['unit_price'];
        disableDeviceSummary.limit = data[0]['sensor_qty_2'];
        disableDeviceSummary.charges = data[0]['total_price'];
      });
      // Return a response
      return "Success";
    }
  }
  Future getData2() async {
    var url = Uri.parse(
        'http://tempq.frostcarusa.com/tempQ/get_invoices.php');
    var response = await http.get(url, headers: {"Accept": "application/json"});
    var msg = json.decode(response.body);
    if (msg == "Error") {
      return "Error";
    } else {
      setState(() {
        data1 = json.decode(response.body);
      });
      // Return a response
      return "Success";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: defaultAppBar(context, "Payment "),
    body:data == []
    // Show a loading spinner while the data is being retrieved
    ? const Text('No Payment Plans Found')
    // Build the DataTable widget with the retrieved data
        :SingleChildScrollView(
          child: Padding(
    padding: const EdgeInsets.all(defaultPadding),
    child: Column(
      children: [
          box(context),
          Padding(
            padding: const EdgeInsets.all(defaultPadding),
            child: ElevatedButton(
                onPressed: () async {
                  setState(() {
                    loading=true;
                  });
                  await getData2();
                  setState(() {
                    loading=false;
                  });
                  }, child: const Text('Show Invoices')),
          ),
          !loading
              ?table(context)
              :const CircularProgressIndicator(
            color: Colors.green,
          )
      ],
    ),
      
    ),
        ));
  }
  Widget table(BuildContext context){
    return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: data1 == []
        // Show a loading spinner while the data is being retrieved
            ? const Center(child: Text('No Invoices Found'))
        // Build the DataTable widget with the retrieved data
            : Padding(
          padding: const EdgeInsets.all(0),
          child: DataTable(
            decoration: const BoxDecoration(
              color: Colors.white
            ),
            headingRowColor:
            MaterialStateColor.resolveWith((states) => Colors.grey.shade400),
            columns: const [
              DataColumn(label: Text("Invoice Number")),
              DataColumn(label: Text("Device ID")),
              DataColumn(label: Text("Qty")),
              DataColumn(label: Text("User")),
              DataColumn(label: Text("Issue Date")),
              DataColumn(label: Text("Valid Till")),
            ],
            rows: data1
                .map((item) => DataRow(
              cells: [
                DataCell(Text(item["inv_id"])),
                DataCell(Text(item["device_id"])),
                DataCell(Text(item["qty"])),
                DataCell(Text(item["user_email"])),
                DataCell(Text(item["date_of_issue"])),
                DataCell(Text(item["valid_till"])),
              ],
            ))
                .toList(),
          ),
        ));
  }

  Widget box(BuildContext context) {
    final Size size = MediaQuery
        .of(context)
        .size;
    return Column(
      children: [
        Responsive(
          mobile: CardGridView(
            crossAxisCount: size.width < 650 ? 2 : 4,
            childAspectRatio: size.width < 650 ? 1.3 : 1,
          ),
          tablet: const CardGridView(),
          desktop: CardGridView(
            childAspectRatio: size.width < 1400 ? 1.1 : 1.4,
          ),
        ),
      ],
    );
  }

}

class CardGridView extends StatelessWidget {
  const CardGridView({
    Key? key,
    this.crossAxisCount = 4,
    this.childAspectRatio = 1,
  }) : super(key: key);

  final int crossAxisCount;
  final double childAspectRatio;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: PaymentInfo.paymentInfoData.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: defaultPadding,
        mainAxisSpacing: defaultPadding,
        childAspectRatio: childAspectRatio,
      ),
      itemBuilder: (context, index) =>
          PaymentPlanCardInfo(info: PaymentInfo.paymentInfoData[index]),
    );
  }
}
