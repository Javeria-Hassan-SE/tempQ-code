import 'dart:convert';

import 'package:http/http.dart' as http;

import '../constants/constants.dart';
import '../models/sensorsModel.dart';
import '../models/userDeviceModel.dart';

class GetRequest{
  ///Get Sensor categories for Sensor Screen


  /// fetch all devices info
  Future<List<AdminSensorsDevice>> fetchData() async {
    var url = Uri.parse('http://tempq.frostcarusa.com/tempQ/admin/admin_getAllDevices.php');
    var response = await http.get(url, headers: {"Accept": "application/json"},);
    var list = json.decode(response.body);
    if (response.statusCode == 200) {
      if (list == 'Error') {
        throw Exception('No user has add his device yet');
      } else {
        List<AdminSensorsDevice> deviceInfo = await list.map<AdminSensorsDevice>((
            json) =>
            AdminSensorsDevice.fromJson(json)).toList();
        return deviceInfo;
      }
    } else {
      throw Exception('No user has add this device yet');
    }
  }

  Future checkIsUserDevice(String deviceId) async {
    var url = Uri.parse('http://tempq.frostcarusa.com/tempQ/admin_get_user_devices.php');
    var response = await http.post(url, headers: {"Accept": "application/json"},
        body:{
          "deviceId":deviceId
        });
    var list = json.decode(response.body);
    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      if (list == 'Error') {
        return "Error";
      } else {
        List<UserDeviceModel> deviceInfo = await list.map<UserDeviceModel>((
            json) =>
            UserDeviceModel.fromJson(json)).toList();
        // return UserDeviceModel.fromJson(jsonDecode(response.body));
        if(deviceInfo[0].isInvoiceGenerated=="No"){
          return "User has Not paid yet";
        }else if(deviceInfo[0].isPaid=="false" && deviceInfo[0].status=="Disabled"){
          return "Require Admin Approval";
        }else{
          return 'Success';
        }
      }
    } else {
      return "Error";
    }
  }

}