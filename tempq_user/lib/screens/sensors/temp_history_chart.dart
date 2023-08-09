import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../../constants/constants.dart';

class TempHistoryChart extends StatefulWidget {
  final List<ChartSampleData> chartData1;

  const TempHistoryChart({
    Key? key,
    required this.chartData1,
  }) : super(key: key);

  @override
  State<TempHistoryChart> createState() => _TempHistoryChartState();
}

class _TempHistoryChartState extends State<TempHistoryChart> {
  late List<ChartSampleData> _series;
  String dropdownValue = dropDown.first;
  var dataMode = '10 mins';
  String tempStatus = 'Temperature during last 10 minutes';
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _series = widget.chartData1;
    List<DateTime> currentDateTimeArray = generateDateTimeArray(_series.length); // Specify the desired count of DateTime values
  }
  List<DateTime> generateDateTimeArray(int count) {
    List<DateTime> dateTimeArray = [];

    for (int i = 0; i < count; i++) {
      DateTime now = DateTime.now();
      DateTime dateTimeWithoutMilliseconds = DateTime.fromMillisecondsSinceEpoch(now.millisecondsSinceEpoch - (now.millisecondsSinceEpoch % 1000));
      dateTimeArray.add(dateTimeWithoutMilliseconds);
    }

    return dateTimeArray;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(defaultPadding),
        decoration: const BoxDecoration(
          color: secondaryColor,
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(tempStatus,
                style: const TextStyle(
                  color: primaryColor,
                  fontWeight: FontWeight.bold,
                )),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: DropdownButton<String>(
              hint: const Text("--Filter By--",
                  style: TextStyle(color: blackColor, fontSize: 14)),
              icon: const Icon(Icons.arrow_drop_down_outlined),
              elevation: 16,
              isExpanded: true,
              style: const TextStyle(color: blackColor),
              underline: Container(
                height: 1.5,
                color: greyColor,
              ),
              items: dropDown.map<DropdownMenuItem<String>>((String items) {
                return DropdownMenuItem<String>(
                  value: items,
                  child: Text(items),
                );
              }).toList(),
              onChanged: (String? newValue) {
                // This is called when the user selects an item.
                setState(() {
                  _series = widget.chartData1;
                  dropdownValue = newValue!;
                  if (dropdownValue == '10 mins') {
                    dataMode = 'Minutes';
                    tempStatus = 'Temperature during last 10 minutes';
                  } else if (dropdownValue == '1 hour') {
                    dataMode = 'Hourly';
                    tempStatus = 'Temperature during last hour';
                  } else if (dropdownValue == '1 day') {
                    dataMode = 'daily';
                    tempStatus = 'Temperature during last day';
                  } else {
                    dataMode = 'Minutes';
                    tempStatus = 'Temperature during last 10 minutes';
                  }
                });
              },
              value: dropdownValue,
            ),
          ),
          SfCartesianChart(
            backgroundColor: Colors.white,
            enableAxisAnimation: true,
            primaryYAxis: NumericAxis(
              // minimum: -40,
              //   maximum: 40,
                // '°C' will be append to all the labels in Y axis
                labelFormat: '{value}°C'),
            //Specifying date time interval type as hours
            primaryXAxis: DateTimeAxis(
                intervalType: (dataMode == 'Minutes')
                    ? DateTimeIntervalType.minutes
                    : (dataMode == 'Hourly')
                        ? DateTimeIntervalType.hours
                        : (dataMode == 'daily')
                            ? DateTimeIntervalType.days
                            : DateTimeIntervalType.minutes

                ),


            series: <ChartSeries>[
              LineSeries<ChartSampleData, DateTime>(
                  dataSource: _series,
                  xValueMapper: (ChartSampleData sales, _) => sales.x,
                  yValueMapper: (ChartSampleData sales, _) => sales.yValue,

              ) ],
          )
        ]));
  }
}

class ChartSampleData {
  ChartSampleData({required this.x, this.yValue});
  final DateTime x;
  final double? yValue;
}
