import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../constants/constants.dart';
import '../models/invoiceModel.dart';
import '../models/sensorDeviceModel.dart';
import '../models/userDeviceModel.dart';
import '../models/userModel.dart';
import 'package:intl/intl.dart';

import '../screens/notifications/send_notification.dart';

class GetNetworkCalls{
  final user = UserModel.myUser;
  DateTime now = DateTime.now();
  SendUserNotification notifyAdmin = SendUserNotification();
  /// Get Sensor Categories from database and save in list
  Future getSensorCategory() async {
    dropDownCategoryList.clear();
    var url = Uri.parse('http://tempq.frostcarusa.com/tempQ/sensor_data/getCategories.php');
    var response = await http.get(url, headers: {"Accept": "application/json"});
    var msg = json.decode(response.body);
    if(msg=="Error"){
      dropDownCategoryList = <String>['Deep Freezer'];
    }
    else{
      List<dynamic> jsonResponse = json.decode(response.body);
      List categoryNames = jsonResponse.map((item) => item['cat_name']).toList();
      for(var i=0; i<categoryNames.length;i++){
        dropDownCategoryList.add(categoryNames[i]);
      }
    }
  }

  Future<List<dynamic>> getSensorAlarmList(String userId) async {
    var url = Uri.parse('http://tempq.frostcarusa.com/tempQ/sensor_data/get_sensor_alarms.php');
    var response = await http.post(url, headers: {"Accept": "application/json"},
        body: {'userId': userId});
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data == "Error"){
        throw Exception('No data Found');
      }
      else{
        return data;
      }

    } else {
      throw Exception('No data Found');
    }
  }
  /// Set Sensor Alarm
  setAlarm(String min, String max, String deviceId) async {
    var url = Uri.parse('http://tempq.frostcarusa.com/tempQ/sensor_data/set_alarm.php');
    var response = await http.post(url, headers: {"Accept": "application/json"},
        body: {
          "user_id": user.userId.toString(),
          "deviceId": deviceId,
          "min": min,
          "max": max
        });
    var list = json.decode(response.body);
    if (response.statusCode == 200) {
      return list;
    }
  }
  /// Change Subscription
  Future<String> changePlan(String deviceId, String planType) async {
    // Make a HTTP GET request to the PHP script
    var url = Uri.parse(
        'http://tempq.frostcarusa.com/tempQ/invoices/change_subscription.php');
    var response = await http.post(url, headers: {"Accept": "application/json"},
        body: {
          "deviceId": deviceId,
          "planType": planType,
          "userId": user.userId.toString()
        });
    var msg = json.decode(response.body);
    if (msg == "Error") {
      return "Error";
    } else {
      // Return a response
      return "Success";
    }
  }
  /// Get User Device Subscription details in Billing and Payment Screen
  Future<List<dynamic>> getInvoices() async {
    var url = Uri.parse(
        'http://tempq.frostcarusa.com/tempQ/invoices/get_my_invoices.php');
    var response = await http.post(url, headers: {"Accept": "application/json"},
        body:{
          "userId": user.userId.toString()
        });
    var msg = json.decode(response.body);
    if (msg == "Error") {
      throw Exception('No data Found');
    } else {
      return msg;
    }
  }

  /// Call when user click on specific subscription
  Future <List<dynamic>> getSpecificInvoices(String invoiceId) async {
    var url = Uri.parse(
        'http://tempq.frostcarusa.com/tempQ/invoices/get_specific_subscription_details.php');
    var response = await http.post(url, headers: {"Accept": "application/json"},
        body:{
          "userId": user.userId.toString(),
          "inv_id": invoiceId
        });
    final msg = json.decode(response.body);
    if (msg == "Error") {
      throw Exception('No data Found');
    } else {
      invoices.clear();
      for (var item in msg) {
        invoices.add(InvoiceModel.fromJson(item));
      }
      return msg;
    }
  }

  /// Get All notifications for notification Screen
  Future<List<dynamic>> getSensorNotifications(String userId) async {
    var url = Uri.parse('http://tempq.frostcarusa.com/tempQ/notifications/get_notifications.php');
    var response = await http.post(url, headers: {"Accept": "application/json"},
        body: {'userId': userId});
    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      if (response.body.startsWith('Error')) {
        throw Exception('Error: ${response.body}');
      } else {
        List<dynamic> data= jsonDecode(response.body);
        return data;
      }
    } else {
      throw Exception('No data Found');
    }
  }

  /// Delete Sensor Notification
  static Future callDeleteAlarmFunction(String deviceId) async{
    var url = Uri.parse('http://tempq.frostcarusa.com/tempQ/sensor_data/delete_alarm.php');
    var response = await http.post(url, headers: {"Accept": "application/json"},
        body:{
          "deviceId": deviceId
        });
    var jsonResponse = json.decode(response.body);
    if (response.statusCode == 200) {
      return jsonResponse;
    }
  }

  /// Get last invoice id from database and create a new one
   Future getInvoiceNumber() async {
    var url = Uri.parse('http://tempq.frostcarusa.com/tempQ/invoices/get_invoice_id.php');
    var response = await http.get(url, headers: {"Accept": "application/json"});
    var msg = json.decode(response.body);
    return msg;
  }


  /// Get User Registered Devices from database to show in List or Card Summary
  Future<List<UserDeviceModel>> getUserDevicesData() async {
    var url = Uri.parse('http://tempq.frostcarusa.com/tempQ/sensor_data/get_user_registered_sensors.php');
    var response = await http.post(url, headers: {"Accept": "application/json"},
        body: {
          "user_id": user.userId.toString()
        });
    var list = json.decode(response.body);
    if (response.statusCode == 200) {
      if (list == 'Error') {
        throw Exception('You have currently no sensor device');
      } else {
        List<UserDeviceModel> deviceInfo = await list.map<UserDeviceModel>((
            json) =>
            UserDeviceModel.fromJson(json)).toList();
        userUnpaidDevices.clear();
        devicesToBePaid.clear();
        userPaidDevices.clear();
        userActiveDevices.clear();
        for(var i=0; i<deviceInfo.length;i++){
          if(deviceInfo[i].isPaid == 'false' && deviceInfo[i].isInvoiceGenerated=="No" )
            {
              userUnpaidDevices.add(deviceInfo[i].deviceId);
              devicesToBePaid.add(deviceInfo[i].deviceId);

            }
          else if (deviceInfo[i].isPaid == 'Yes' && deviceInfo[i].isInvoiceGenerated=="Yes" && deviceInfo[i].status=="Activated"){
            userActiveDevices.add(deviceInfo[i].deviceId);
          }
          else{
            userPaidDevices.add(deviceInfo[i].deviceId);
          }

        }
        return deviceInfo;
      }
    } else {
      throw Exception('You have currently no sensor device');
    }
  }
  /// User Login
  Future login(String email, String password, String fcmToken) async {
    String formattedDateTime = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);
    var url = Uri.parse('http://tempq.frostcarusa.com/tempQ/user_registration/login.php');
    var response = await http.post(url,
        headers: {"Accept":"application/json"},
        body: {
          "user_name": email,
          "password": password,
          "token": fcmToken,
          "currentLogin": formattedDateTime
        });
    var jsonList = json.decode(response.body);
    if (response.statusCode == 200) {
      if (jsonList == 'OTP Send') {
        return 'OTP Send';
      }else if (jsonList == 'Error') {
        return 'Error';
      } else {
        List<UserModel> userInfo = await jsonList.map<UserModel>((
            json) =>
            UserModel.fromJson(json)).toList();
        user.userId = userInfo[0].userId;
        user.userFullName = userInfo[0].userFullName;
        user.userEmail = userInfo[0].userEmail;
        user.userContact = userInfo[0].userContact;
        user.userCompany = userInfo[0].userCompany;
        user.userGender = userInfo[0].userGender;
        user.userAge = userInfo[0].userAge;
        user.userLocation = userInfo[0].userLocation;
        user.userImage = userInfo[0].userImage;
        user.userType = userInfo[0].userType;
        user.createdOn = userInfo[0].createdOn;
        saveLoginSession(email, password);
        return 'Success';
      }
    } else {
      return 'Network Error';
    }
  }

  /// Add Sensor Device
  Future addDevice({required String category, required String deviceName,
    required String deviceId, required String securityCode,
      required String userId}) async {
    String formattedDateTime = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);
    var url = Uri.parse('http://tempq.frostcarusa.com/tempQ/sensor_data/add_device.php');
    var response = await http.post(url,
        headers: {"Accept":"application/json"},
        body: {
          "deviceCategory": category,
          "deviceName": deviceName,
          "deviceId": deviceId,
          "securityCode":securityCode,
          "user_Name":userId,
          "addedOn": formattedDateTime,
          "userId": userId
        });

    var msg = json.decode(response.body);
    return msg;
  }

  /// Save Login Info
  void saveLoginSession(String email, String password) async {
    const storage = FlutterSecureStorage();

    await storage.write(key: 'tempQUserEmail', value: email);
    await storage.write(key: 'tempQUserPassword', value: password);
  }

  /// Fetch Sensor data for View Sensor Screen
  Future<List<UserSensorDeviceModel>> fetchSensorData(String deviceID) async {
    var url = Uri.parse('http://tempq.frostcarusa.com/tempQ/sensor_data/get_sensor_data.php');
    var response = await http.post(url,
        headers: {"Accept": "application/json"},
        body: {"deviceId": deviceID});
    var list = json.decode(response.body);
    if (response.statusCode == 200) {
      if (list=="Error"){

        throw Exception('No records found');
      }else{
        List<UserSensorDeviceModel> deviceInfo = await list
            .map<UserSensorDeviceModel>(
                (json) => UserSensorDeviceModel.fromJson(json))
            .toList();
        return deviceInfo;
      }
    } else {
      throw Exception('No records found');
    }
  }
  /// Send Notifications to user's to update about the sensor temperature
  Future getDevicesToTriggerForAlarm() async {
    var url = Uri.parse('http://tempq.frostcarusa.com/tempQ/sensor_data/get_list_of_devices_to_trigger_alarm.php');
    var response = await http.post(url, headers: {
      "Accept": "application/json"
    }, body: {
      "user_id": user.userId.toString(),
    });
    if (response.statusCode == 200) {
      var jsonList = json.decode(response.body);
      if (jsonList == "Error") {
        print("No Notification for sensor alarm");
      } else {
        List<dynamic> decodedList = json.decode(response.body);
        for (var value in decodedList) {
          /// Send Notification to User
          notifyAdmin.sendNotificationToUserForAlarmNotification(
              subject: "Alert: Sensor Temperature Notification - Temp Q Application",
              emailMessage:
              "Your current temperature deviates from the set temperature on your alarm for device ID: $value"
                  ". Please check and adjust accordingly.",
              messageType: "Temperature Alert",
              messageTitle: "Temperature Alert",
              message:
              "Your current temperature deviates from the set temperature on your alarm for device ID: $value"
                  ". Please check and adjust accordingly.", deviceId: value);

          /// Send Notification to Admin
          notifyAdmin.sendNotificationToAdminAboutSensorAlarm(
              subject: "Alert: Sensor Temperature Notification - Temp Q Application",
              emailMessage:
              "The temperature of user: ${user.userEmail} device: $value. deviates from the range he set to notify.",
              messageType: "Temperature Alert",
              messageTitle: "Temperature Alert",
              message:
              "The temperature of user: ${user.userEmail} device: $value. deviates from the range he set to notify.", deviceId: value);
        }
      }
    }
  }

  /// Send Notifications to user's to update about the sensor temperature
  Future getInvoiceExpiry() async {
    String formattedDate = DateFormat('y-MM-dd').format(now);
    var url = Uri.parse('http://tempq.frostcarusa.com/tempQ/nootifications/invoice_expire_notification.php');
    var response = await http.post(url, headers: {
      "Accept": "application/json"
    }, body: {
      "user_id": user.userId.toString(),
      "current_date": formattedDate
    });
    if (response.statusCode == 200) {
      var jsonList = json.decode(response.body);
      if (jsonList == "No devices Found") {
        print("No Notification for sensor alarm");
      } else {
        List<Map<String, dynamic>> decodedData = jsonDecode(jsonList);
        for (var device in decodedData) {
          /// Send Notification to User
          notifyAdmin.sendNotificationToAdmin(
              subject: "Alert: Subscription Expired - Temp Q Application",
              emailMessage:
              "It is to notify that user ${device['user_email']}, subscription for device Id: ${device['device_id']} will be expired on ${device['valid_till']}."
                  "Kindly take the action accordingly.",
              messageType: "Subscription Expired",
              messageTitle: "Subscription Expired",
              message:
              "It is to notify that user ${device['user_email']}, subscription for device Id: ${device['device_id']} will be expired on ${device['valid_till']}."
                  "Kindly take the action accordingly.");

          /// Send Notification to Admin
          notifyAdmin.sendNotification(
              subject: "Alert: Subscription Expired - Temp Q Application",
              emailMessage:
              "It is to notify that your subscription for device Id: ${device['device_id']} will be expired on ${device['valid_till']}."
                  "Kindly renew your subscription.",
              messageType: "Subscription Expired",
              messageTitle: "Subscription Expired",
              message:
              "It is to notify that user ${device['user_email']}, subscription for device Id: ${device['device_id']} will be expired on ${device['valid_till']}."
              "Kindly take the action accordingly.");
        }
      }
    }
  }

  /// send Device Enable Request
  static Future sendEnableRequest(String deviceId) async{
    var url = Uri.parse('http://tempq.frostcarusa.com/tempQ/sensor_data/send_enable_request.php');
    var response = await http.post(url, headers: {"Accept": "application/json"},
        body:{
          "deviceId": deviceId
        });
    var jsonResponse = json.decode(response.body);
    if (response.statusCode == 200) {
      return jsonResponse;
    }
  }

  static Future callDisableDeviceFunction(String deviceId) async{
    var url = Uri.parse('http://tempq.frostcarusa.com/tempQ/admin/disable_user_sensors.php');
    var response = await http.post(url, headers: {"Accept": "application/json"},
        body:{
          "deviceId": deviceId
        });
    var jsonResponse = json.decode(response.body);
    if (response.statusCode == 200) {
      return jsonResponse;
    }
  }
  /// Delete Notification
  static Future deleteNotification(String id) async{
    var url = Uri.parse('http://tempq.frostcarusa.com/tempQ/admin/delete_notification.php');
    var response = await http.post(url, headers: {"Accept": "application/json"},
        body:{
          "id": id
        });
    var jsonResponse = json.decode(response.body);
    if (response.statusCode == 200) {
      return jsonResponse;
    }
  }
  /// User Email Verification
  static Future verify(String userEmail, String otp) async {
    var url = Uri.parse('http://tempq.frostcarusa.com/tempQ/user_registration/verify_email.php');
    var response = await http.post(url,
        headers: {"Accept": "application/json"},
        body: {"userEmail": userEmail, "otp": otp});
    var response1 = json.decode(response.body);
    return response1;
  }

  /// Register User
   Future register(String userEmail, String userFullName, String userCompany, String contact, String password,
      String location, String fcmToken) async {
    String formattedDateTime = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);
    var url = Uri.parse('http://tempq.frostcarusa.com/tempQ/user_registration/register_user.php');
    var response = await http.post(url,
        headers: {"Accept":"application/json"},
        body: {
          "userFullName": userFullName,
          "userEmail": userEmail,
          "userCompany": userCompany,
          "userContact": contact,
          "userType": "user",
          "userPassword": password,
          "userLocation": location,
          "isVerified":"false",
          "token": fcmToken,
          "user_created_on": formattedDateTime
        });
    var msg = json.decode(response.body);
    return msg;
  }
}