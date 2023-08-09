import 'dart:async';

import 'package:flutter/material.dart';
import '../../constants/constants.dart';
import '../../models/sensors_summary_model.dart';
import '../../models/userDeviceModel.dart';
import '../../network/GetNetworkCalls.dart';
import '../../responsive/responsive.dart';
import 'sensors_summary_card_info.dart';

class SensorsSummary extends StatefulWidget {
  const SensorsSummary({Key? key}) : super(key: key);

  @override
  State<SensorsSummary> createState() => _SensorsSummaryState();
}

class _SensorsSummaryState extends State<SensorsSummary> {
  late Future<List<UserDeviceModel>> futureSensor;
  var data = GetNetworkCalls();
  var activeDeviceSummary = SensorsSummaryModel.activeDevices;
  var disableDeviceSummary = SensorsSummaryModel.disableDevices;
  Timer? _timer;
  @override
  initState() {
    super.initState();
    futureSensor = data.getUserDevicesData();
    _startFetchingData();
  }
  /// Update records for every 10 seconds
  void _startFetchingData() {
    // Fetch data every 10 seconds using Timer.periodic
    _timer = Timer.periodic(const Duration(seconds: 30), (timer) {
      if(mounted){
        setState(() {
          futureSensor = data.getUserDevicesData();
        });
      }
    });
  }
  /// Dispose API call
  @override
  void dispose() {
    // Cancel the timer when the screen is disposed (navigated away)
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return listTile(context);
  }
  Widget listTile(BuildContext context) {
    return FutureBuilder(
      builder: (context,AsyncSnapshot snapshot) {
        // Checking if future is resolved or not
        if (snapshot.connectionState == ConnectionState.done) {
          // If we got an error
          if (snapshot.hasError) {
            return box(context);
            // if we got our data
          } else if (snapshot.hasData) {
            // Extracting data from snapshot object
            final data = snapshot.data;
            if (data != null) {
              return Container(
                height: 150,
                width: double.infinity,
                padding: const EdgeInsets.all(0),
                margin: const EdgeInsets.all(0),
                child: ListView.builder(
                    itemCount: 1,
                    itemBuilder: (BuildContext context, int index) {
                      activeDeviceSummary.total = data!.length;
                      disableDeviceSummary.total = data!.length;
                      int activeCount = 0;
                      int disableCount = 0;
                      userUnpaidDevices.clear();
                      userPaidDevices.clear();
                      for (var i = 0; i < data.length; i++) {
                        if (data[i].status == 'Not Activated' || data[i].status == 'Disabled') {
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
                      return box(context);
                    }),
              );
            }
          }
        }
        // Displaying LoadingSpinner to indicate waiting state
        return const Center(
          child: Text(''),
        );
      },

      // Future that needs to be resolved
      // inorder to display something on the Canvas
      future: data.getUserDevicesData(),
    );
  }
  Widget box(BuildContext context){
    final Size size = MediaQuery.of(context).size;
    return  Column(
      mainAxisSize: MainAxisSize.min,
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
      itemCount: SensorsSummaryModel.summaryDemoData.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: defaultPadding,
        mainAxisSpacing: defaultPadding,
        childAspectRatio: childAspectRatio,
      ),
      itemBuilder: (context, index) => SensorsSummaryCardInfo(info: SensorsSummaryModel.summaryDemoData[index]),
    );
  }
}
