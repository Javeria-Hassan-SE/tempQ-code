import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../constants/constants.dart';
import '../models/sensorDeviceModel.dart';
import '../models/userModel.dart';
import 'package:http/http.dart' as http;

class SendPostRequest {
  final user = UserModel.myUser;


  /// Login Request
  Future loginRequest(String email, String password,  String fcmToken) async {
    var url = Uri.parse('http://tempq.frostcarusa.com/tempQ/user_registration/admin_login.php');
    var response = await http.post(url,
        headers: {"Accept":"application/json"},
        body: {
          "user_name": email,
          "password": password,
          "token": fcmToken
        });
    var jsonList = json.decode(response.body);
    if (response.statusCode == 200) {
      if (jsonList == 'OTP Send') {
        return 'OTP Send';
      }else if (jsonList == 'Error') {
        return 'Error';
      } else {
        List<UserModel> adminInfo = await jsonList.map<UserModel>((
            json) =>
            UserModel.fromJson(json)).toList();
        user.userId = adminInfo[0].userId;
        user.userFullName = adminInfo[0].userFullName;
        user.userEmail = adminInfo[0].userEmail;
        user.userContact = adminInfo[0].userContact;
        user.userCompany = adminInfo[0].userCompany;
        user.userGender = adminInfo[0].userGender;
        user.userAge = adminInfo[0].userAge;
        user.userLocation = adminInfo[0].userLocation;
        user.userImage = adminInfo[0].userImage;
        user.userType = adminInfo[0].userType;
        user.createdOn = adminInfo[0].createdOn;
        saveLoginSession(email, password);
        return 'Success';
      }
    } else {
      return 'Network Error';
    }
  }

  /// Get Categories
  Future <List<dynamic>>getSensorCategory() async {
    var url = Uri.parse('http://tempq.frostcarusa.com/tempQ/sensor_data/getCategories.php');
    var response = await http.get(url, headers: {"Accept": "application/json"});
    var msg = json.decode(response.body);
    if (msg == "Error") {
      dropDownCategoryList.clear();
      dropDownCategoryList = <String>['Deep Freezer'];
      throw Exception('No Category Found');
    }
    else {
      dropDownCategoryList.clear();
      List<dynamic> jsonResponse = json.decode(response.body);
      List categoryNames = jsonResponse.map((item) => item['cat_name'])
          .toList();
      for (var i = 0; i < categoryNames.length; i++) {
        dropDownCategoryList.add(categoryNames[i]);
      }
      return categoryNames;
    }
  }

  /// Get Notifications
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

  /// Disable Device
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

  /// Enable Device
  static Future callEnableDeviceFunction(String deviceId) async{
    var url = Uri.parse('http://tempq.frostcarusa.com/tempQ/admin/enable_user_sensors.php');
    var response = await http.post(url, headers: {"Accept": "application/json"},
        body:{
          "deviceId": deviceId
        });
    var jsonResponse = json.decode(response.body);
    if (response.statusCode == 200) {
      return jsonResponse;
    }
  }

  /// Fetch Specific Sensor Data
  Future<List<UserSensorDeviceModel>> fetchSensorData(String deviceID) async {
    var url = Uri.parse('http://tempq.frostcarusa.com/tempQ/sensor_data/get_sensor_data.php');
    var response = await http.post(url,
        headers: {"Accept": "application/json"},
        body: {"deviceId": deviceID});
    var list = json.decode(response.body);
    if (response.statusCode == 200) {
      if(list=="Error"){
        throw Exception('Failed to load album');
      }else{
        List<UserSensorDeviceModel> deviceInfo = await list
            .map<UserSensorDeviceModel>(
                (json) => UserSensorDeviceModel.fromJson(json))
            .toList();

        return deviceInfo;
      }

    } else {
      throw Exception('Failed to load album');
    }
  }
  Future<List<UserSensorDeviceModel>> fetchUserData(String deviceID) async {
    var url = Uri.parse('http://tempq.frostcarusa.com/tempQ/admin/fetch_user_data_for_sensor.php');
    var response = await http.post(url,
        headers: {"Accept": "application/json"},
        body: {"deviceId": deviceID});
    var list = json.decode(response.body);
    if (response.statusCode == 200) {
      if(list=="Error"){
        throw Exception('Failed to load album');
      }else{
        List<UserSensorDeviceModel> deviceInfo = await list
            .map<UserSensorDeviceModel>(
                (json) => UserSensorDeviceModel.fromJson(json))
            .toList();

        return deviceInfo;
      }

    } else {
      throw Exception('Failed to load album');
    }
  }

  /// Save User Login Info in Shared Preferences
  void saveLoginSession(String email, String password) async {
    const storage = FlutterSecureStorage();
    await storage.write(key: 'tempQEmail', value: email);
    await storage.write(key: 'tempQPassword', value: password);
  }
}