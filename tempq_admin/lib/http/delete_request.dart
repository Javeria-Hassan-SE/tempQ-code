
import 'dart:convert';

import 'package:http/http.dart' as http;
class DeleteRequest{


  /// Delete sensor category
  static Future callDeleteFunction(String catName) async{
    var url = Uri.parse('http://tempq.frostcarusa.com/tempQ/admin/delete_category.php');
    var response = await http.post(url, headers: {"Accept": "application/json"},
        body:{
          "cat_name": catName
        });
    var list = json.decode(response.body);
    if (response.statusCode == 200) {
      return list;
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
  /// Delete Request
  static Future callDeleteDeviceFunction(String deviceId) async{
    var url = Uri.parse('http://tempq.frostcarusa.com/tempQ/admin/delete_sensors.php');
    var response = await http.post(url, headers: {"Accept": "application/json"},
        body:{
          "deviceId": deviceId
        });
    var jsonResponse = json.decode(response.body);
    if (response.statusCode == 200) {
      return jsonResponse;
    }
  }
}