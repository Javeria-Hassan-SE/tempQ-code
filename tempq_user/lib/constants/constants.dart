import 'package:flutter/material.dart';

import '../models/invoiceModel.dart';

const primaryColor = Color(0xff0482b9);
const secondaryColor = Colors.white;
const bgColor = Color(0xFFd4e5ee);
const whiteColor = Colors.white;
const headingColor = Color(0xff2da5d1);
const greyColor = Colors.grey;
const blackColor = Colors.black;
const redColor = Colors.red;
const greenColor = Colors.green;
List <String> deviceValues = [];
const yellowColor = Colors.yellow;
const purpleColor = Colors.purple;
const defaultPadding = 16.0;
List<String> dropDownCategoryList = <String>['Fridge', 'Deep Freezer', 'Room', 'Other'];
const List<String> filterBy = <String>['Weekly', 'Monthly',];
List<String> paymentInfo = <String>[
  '1 Sensor | \$10 Monthly',
  '6 Sensors | \$ 50 Monthly'
];

//List<String> paymentInfo = <String>['1 Sensor | \$10 Monthly','6 Sensors | \$ 50 Monthly'];
List<String> userUnpaidDevices = <String>['--Your Device Name--'];
List<String> userActiveDevices = <String>['--Your Device Name--'];
List<String> userPaidDevices = <String>['--Your Device Name--'];
List<String> devicesToBePaid = <String>['--Your Device Name--'];
const String appName = "Temp Q";
const String titleDashboard = "Dashboard";
List selectedAlarmDevice = ['No Device'];
List<InvoiceModel> invoices = [];
bool isDarkTheme = false;
double unit_price=0;
const String titleUsers = "Users";
const String titleSensor = "Sensors";
const String titlePaymentBilling = "Billing & Payment";
const String titleNotifications = "Notifications";
const String titleActive = "Active Sensors";
const String titleNonActive = "Non-Active Sensors";
const String titleTempMonitoring = "Temperature Monitoring";
const String titleBatteryMonitoring = "Battery Monitoring";
const String disabled= "Disabled";
const String active = "Active";
const String status = "Status";
int isInvoiceGenerated = 0;
int payment = 0;
const List <String>dropDown =<String> ['10 mins', '1 hour','1 day'];
const String deviceName = "Device Name";
const String type = "Type";
const String battery = "Battery";
const String voltage = "Voltage";
const String email = "Email";
const String userName = "User Name";
const String temperature = "Temperature";
const String privacyPolicy = "Privacy Policy";
const String appModeDark = "Dark Mode";
const String appModeLight = "Light Mode";
const String defaultValue = "Default";
const String titleLogin = "LOGIN";
const String titleSearch = "Search";
const String titleWelcome = "Welcome";
const String titleSetting = "Settings";
const String learnMore = "Learn more about Temp Q App";
const String sNo = "S.No";
const double bodyFontSize = 14.0;
const splashColor = Color(0xff7b9bab);
const double subHeadingFontSize = 16.0;
const double titleFontSize = 20.0;
const double headingFontSize = 24.0;
const double displayFontSize = 34.0;
int userSelectedSensorsForPayment = 0;




