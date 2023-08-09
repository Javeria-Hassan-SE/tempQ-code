import 'dart:async';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:tempq_admin/screens/sensors/sensors_summary.dart';
import '../components/showScaffoldClass.dart';
import '../components/welcomeBar.dart';
import '../constants/constants.dart';
import '../services/notification_services.dart';
import 'notifications/send_notification.dart';


class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {

  NotificationServices notificationServices = NotificationServices();
  bool loading = false;
  bool visibility = false;
  SendUserNotification notify = SendUserNotification();
  Timer? _timer;

  /// Update records for every 10 seconds
  void _startFetchingData() {
    // Fetch data every 10 seconds using Timer.periodic
    _timer = Timer.periodic(const Duration(seconds: 30), (timer) {
      if(mounted){
        setState(() {
          getData();
        });
      }
    });
  }

  @override
  initState() {
    super.initState();
    dropDownCategoryList.clear();
    _startFetchingData();

  }
  /// Show Toast Messages
  showMessage(String message, Color color){
    ShowScaffoldClass().showScaffoldMessage(context, message,color);
  }

  /// Get API Call
  getData() async {
    var connectivity = await checkInternetConnectivity();
    if(connectivity){
      listenNotifications();
    }else{
      showMessage('Check your internet connectivity',Colors.red);
    }
  }

  /// Dispose API Call

  @override
  void dispose() {
    // Cancel the timer when the screen is disposed (navigated away)
    _timer?.cancel();
    super.dispose();
  }

  /// Listen Notifications
  listenNotifications(){
    notificationServices.requestNotificationPermission();
    notificationServices.forgroundMessage();
    notificationServices.firebaseInit(context);
    notificationServices.setupInteractMessage(context);
    notificationServices.isTokenRefresh();
    notificationServices.getDeviceToken().then((value){
      if (kDebugMode) {
        print('device token');
        print(value);
      }
    });
  }


  /// Dashboard UI
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
        body: Padding(
          padding: EdgeInsets.all(defaultPadding),
          child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                WelcomeBar(),
                SensorsSummary(),
              ],
            ),
        ),
        );
  }
  @override
  void setState(VoidCallback fn) {
    // TODO: implement setState
    super.setState(fn);
  }

  /// Check Internet Connection
  Future<bool> checkInternetConnectivity() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      return false;
    } else {
      return true;
    }
  }
}
