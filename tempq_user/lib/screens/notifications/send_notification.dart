import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:tempq_user/models/userModel.dart';
import 'package:intl/intl.dart';

class SendUserNotification{
  UserModel user = UserModel.myUser;
  DateTime now = DateTime.now();


  /// Send Notification to user for his account Confirmation
  Future sendAccountVerificationNotification({required String userEmail,required String messageType,
    required String messageTitle,required String message}) async{
    String formattedDateTime = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);
    var url = Uri.parse('http://tempq.frostcarusa.com/tempQ/notifications/account_verification_notification.php');
    var response = await http.post(url,
        headers: {"Accept": "application/json"},
        body: {
          "userEmail": userEmail,
          "messageType": messageType,
          "messageTitle": messageTitle,
          "msg": message,
          "timestamp": formattedDateTime
        });
    var jsonList = json.decode(response.body);
    if (response.statusCode == 200) {
      if(jsonList =='Success'){
        return 'success';
      }else{
        return 'error';
      }
    }
  }


  /// Send Notification to User about Device add/Subscription plan and other
  Future sendNotification({required String subject, required String emailMessage,
    String? deviceId,required String messageType,required String messageTitle,
    int? senTemp=0,required String message}) async{
    deviceId ??= "";
    String formattedDateTime = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);
    var url = Uri.parse('http://tempq.frostcarusa.com/tempQ/notifications/send_notification_to_user.php');
    var response = await http.post(url,
        headers: {"Accept": "application/json"},
        body: {
          "deviceId": deviceId,
          "userId": user.userId.toString(),
          "userEmail": user.userEmail,
          "messageType": messageType,
          "messageTitle": messageTitle,
          "senTemp":senTemp.toString(),
          "msg": message,
          "timestamp": formattedDateTime,
          "subject": subject,
          "emailMessage": emailMessage
        });
    var jsonList = json.decode(response.body);
    if (response.statusCode == 200) {
      if(jsonList =='Success'){
        return 'success';
      }else{
        return 'error';
      }
    }
  }

  /// Send Notification to User about sensor alarm
  Future sendNotificationToUserForAlarmNotification({required String subject, required String emailMessage,
    required String deviceId,required String messageType,required String messageTitle,
    int? senTemp=0,required String message}) async{
    String formattedDateTime = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);
    var url = Uri.parse('http://tempq.frostcarusa.com/tempQ/notifications/send_notification_to_user_about_alarm.php');
    var response = await http.post(url,
        headers: {"Accept": "application/json"},
        body: {
          "deviceId": deviceId,
          "userId": user.userId.toString(),
          "userEmail": user.userEmail,
          "messageType": messageType,
          "messageTitle": messageTitle,
          "senTemp":senTemp.toString(),
          "msg": message,
          "timestamp": formattedDateTime,
          "subject": subject,
          "emailMessage": emailMessage
        });
    var jsonList = json.decode(response.body);
    if (response.statusCode == 200) {
      if(jsonList =='Success'){
        return 'success';
      }else{
        return 'error';
      }
    }
  }

  /// Send Notification to Admin
  Future sendNotificationToAdmin({required String subject, required String emailMessage,
    String? deviceId="",required String messageType,required String messageTitle,
    int? senTemp=0,required String message}) async{
    String formattedDateTime = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);
    var url = Uri.parse('http://tempq.frostcarusa.com/tempQ/notifications/send_notification_to_admin.php');
    var response = await http.post(url,
        headers: {"Accept": "application/json"},
        body: {
          "deviceId": deviceId,
          "messageType": messageType,
          "messageTitle": messageTitle,
          "senTemp":senTemp.toString(),
          "msg": message,
          "timestamp": formattedDateTime,
          "subject": subject,
          "emailMessage": emailMessage
        });
    var jsonList = json.decode(response.body);
    if (response.statusCode == 200) {
      if(jsonList =='Success'){
        return 'success';
      }else{
        return 'error';
      }
    }
  }

  /// Send Notification to Admin about sensor Alarm
  Future sendNotificationToAdminAboutSensorAlarm({required String subject, required String emailMessage,
    required String deviceId,required String messageType,required String messageTitle,
    int? senTemp=0,required String message}) async{
    String formattedDateTime = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);
    var url = Uri.parse('http://tempq.frostcarusa.com/tempQ/notifications/send_notification_to_admin_about_alarm.php');
    var response = await http.post(url,
        headers: {"Accept": "application/json"},
        body: {
          "deviceId": deviceId,
          "messageType": messageType,
          "messageTitle": messageTitle,
          "senTemp":senTemp.toString(),
          "msg": message,
          "timestamp": formattedDateTime,
          "subject": subject,
          "emailMessage": emailMessage
        });
    var jsonList = json.decode(response.body);
    if (response.statusCode == 200) {
      if(jsonList =='Success'){
        return 'success';
      }else{
        return 'error';
      }
    }
  }

}
