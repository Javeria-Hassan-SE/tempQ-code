
import 'package:flutter/material.dart';

class SensorsSummaryModel {
  IconData? iconSrc;
  String? title;
  int? total, count;
  double? percentage;
  Color? color;

  SensorsSummaryModel({
    this.iconSrc,
    this.title,
    this.total,
    this.count,
    this.percentage,
    this.color,
  });

  static SensorsSummaryModel activeDevices = SensorsSummaryModel(
      iconSrc: Icons.sensors,
      title: "Active Sensors",
      total: 0,
      count: 0,
      percentage: 0,
      color: Colors.green
  );
  static SensorsSummaryModel disableDevices = SensorsSummaryModel(
      iconSrc: Icons.sensors,
      title: "Disable Sensors",
      total: 0,
      count: 0,
      percentage: 0,
      color: Colors.red
  );


// List summaryDemoData = [
//   SensorsSummaryModel(
//     title: "Active Sensors",
//     count: 0,
//     iconSrc: Icons.sensors,
//     total: 0,
//     color: Colors.green,
//     percentage: 0,
//   ),
//   SensorsSummaryModel(
//     title: "Disable Sensors",
//     count: 0,
//     iconSrc: Icons.sensors,
//     total: 0,
//     color: Colors.red,
//     percentage: 0,
//   ),
// ];
  static List summaryDemoData = [
    activeDevices,
    disableDevices
  ];
}
