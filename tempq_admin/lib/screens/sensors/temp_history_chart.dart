import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:intl/intl.dart';

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
  String dropdownValue = dropDown.first;
  var dataMode = 'Hourly';
  String tempStatus = 'Temperature during last 24 hrs';

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
                  dropdownValue = newValue!;
                  if (dropdownValue == 'Hourly') {
                    dataMode = 'Hourly';
                    tempStatus = 'Temperature during last 24 hrs';
                  } else if (dropdownValue == 'Weekly') {
                    dataMode = 'Weekly';
                    tempStatus = 'Temperature during last Weeks';
                  } else if (dropdownValue == 'Monthly') {
                    dataMode = 'Monthly';
                    tempStatus = 'Temperature during last Months';
                  } else {
                    dataMode = 'Hourly';
                    tempStatus = 'Temperature during last 24 hrs';
                  }
                });
              },
              value: dropdownValue,
            ),
          ),
          SfCartesianChart(
            backgroundColor: Colors.white,
            enableAxisAnimation: true,
            onTooltipRender: (TooltipArgs args) {
              if (args.pointIndex == 0) {
                //Tooltip without header
                args.header = '';
              }
              if (args.pointIndex == 1) {
                //Tooltip with customized header
                args.header = 'Sold';
              }
              if (args.pointIndex == 2) {
                //Tooltip with X and Y positions of data points
                args.header = 'x : y';
                args.text =
                    '${args.locationX!.floor()} : ${args.locationY!.floor()}';
              }
              if (args.pointIndex == 3) {
                //Tooltip with formatted DateTime values
                List<dynamic>? chartdata = args.dataPoints;
                args.header = DateFormat('d MMM yyyy').format(chartdata![3].x);
                args.text = '${chartdata[3].y}';
              }
            },
            primaryYAxis: NumericAxis(
                // '°C' will be append to all the labels in Y axis
                labelFormat: '{value}°C'),
            //Specifying date time interval type as hours
            primaryXAxis: DateTimeAxis(
                // dateFormat: (dataMode == 'Hourly')
                //     ? DateFormat.Hm()
                //     : (dataMode == 'Weekly')
                //         ? DateFormat.d()
                //         : (dataMode == 'Monthly')
                //             ? DateFormat.m()
                //             : DateFormat.Hm(),
                //interval: 0.5,
                minorTicksPerInterval: 4,
                //labelFormat: '{value}',
                majorGridLines: const MajorGridLines(width: 0),
                minorTickLines: const MinorTickLines(
                    size: 4, width: 2, color: Colors.blue),
                majorTickLines: const MajorTickLines(
                    size: 6, width: 2, color: Colors.red),
                intervalType: (dataMode == 'Hourly')
                    ? DateTimeIntervalType.minutes
                    : (dataMode == 'Weekly')
                        ? DateTimeIntervalType.days
                        : (dataMode == 'Monthly')
                            ? DateTimeIntervalType.months
                            : DateTimeIntervalType.minutes),
            //edgeLabelPlacement: EdgeLabelPlacement.shift,
            //intervalType: DateTimeIntervalType.minutes),

            series: <ChartSeries<ChartSampleData, DateTime>>[
              LineSeries<ChartSampleData, DateTime>(
                  dataSource: widget.chartData1,
                  xValueMapper: (ChartSampleData sales, _) => sales.x,
                  yValueMapper: (ChartSampleData sales, _) => sales.yValue,
                  name: 'Temperature',
                  dataLabelSettings: const DataLabelSettings(isVisible: true))
            ],
          )
        ]));
  }
}

class ChartSampleData {
  ChartSampleData({required this.x, required this.yValue});

  final DateTime x;
  final double yValue;
}
