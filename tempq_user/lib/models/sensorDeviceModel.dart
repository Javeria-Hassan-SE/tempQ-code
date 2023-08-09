import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserSensorDeviceModel {
  static late SharedPreferences _preferences;
  static const _keyDevice = 'device';
  int id, sensorPercentage;
  String  deviceId;
  var timeStamp, readingDate;
  DateTime   readingDateTime;
  double  sensTempF , sensTempC, sensVoltageValue;

  // this makes it singleton-like
  // factory UserSensorDeviceModel.withA() => UserSensorDeviceModel._internal();
  // UserSensorDeviceModel._internal();

  UserSensorDeviceModel({
    required this.deviceId, required this.sensTempF, required this.sensTempC,
    required this.readingDate,required this.timeStamp,required  this.sensVoltageValue,
    required this.sensorPercentage,required this.id, required this.readingDateTime
  });
  UserSensorDeviceModel copy({
    int? id,
    String?  deviceId,
    double?  sensTempF,
    double?  sensTempC,
    double?  sensVoltageValue,
    int?  sensorPercentage,
    DateTime ?  readingDateTime,
    var timeStamp, readingDate
  }) =>
      UserSensorDeviceModel(
        id: id  ??  this.id,
        deviceId: deviceId  ??  this.deviceId,
        sensTempF: sensTempF ??   this.sensTempF,
        sensTempC: sensTempC  ??  this.sensTempC,
        sensVoltageValue: sensVoltageValue  ??  this.sensVoltageValue,
        sensorPercentage: sensorPercentage ??   this.sensorPercentage,
        readingDate: readingDate  ??  this.readingDate,
        timeStamp: timeStamp  ??  this.timeStamp,
        readingDateTime: readingDateTime ?? this.readingDateTime,
      );

  factory UserSensorDeviceModel.fromJson(Map<String, dynamic> json) {
    return UserSensorDeviceModel(
        id: int.parse(json['id']),
        deviceId: json['deviceId'],
        sensTempF: double.parse(json['sensTempFValue']),
        sensTempC: double.parse(json['sensTempCValue']),
        sensVoltageValue: double.parse(json['sensVoltageValue']),
        sensorPercentage: int.parse(json['sensPerc']),
        readingDate:json['reading_date'],
        timeStamp: json['time_stamp'],
        readingDateTime: DateTime.parse(json['reading_date_time']));
  }
  static UserSensorDeviceModel myDevice = UserSensorDeviceModel(
      deviceId: "1",
      sensTempF: 0.0,
      sensTempC: 0.0,
      readingDate: DateTime.now(),
      timeStamp: DateTime.now(),
      sensVoltageValue: 0.0,
      sensorPercentage: 0, id: 0,readingDateTime: DateTime.now()
  );
  Map<String, dynamic> toJson() => {
    'id':id,
    'deviceId':deviceId,
    'sensTempF': sensTempF,
    'sensTempC': sensTempC,
    'readingDate': readingDate,
    'timeStamp': timeStamp,
    'sensorPercentage':sensorPercentage,
    'sensVoltageValue':sensVoltageValue,
    'reading_date_time': readingDateTime
  };

  static Future init() async =>
      _preferences = await SharedPreferences.getInstance();

  static Future setUser(UserSensorDeviceModel user) async {
    final json = jsonEncode(user.toJson());

    await _preferences.setString(_keyDevice, json);
  }

  static UserSensorDeviceModel getUser() {
    final json = _preferences.getString(_keyDevice);

    return json == null ?   myDevice : UserSensorDeviceModel.fromJson(jsonDecode(json));
  }
}