import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class UserDeviceModel {
  static late SharedPreferences _preferences;
  static const _keyDevice = 'device';
  final int userDeviceID, userId;
  final String deviceName, deviceId, deviceCat, securityCode;
  final DateTime addedOn;
  final String isPaid, status, isInvoiceGenerated;

  UserDeviceModel({
    required this.deviceName, required this.deviceId, required this.deviceCat,
    required this.addedOn, required this.securityCode, required this.userId, required this.userDeviceID,
    required this.isPaid, required this.status, required this.isInvoiceGenerated
  });
  UserDeviceModel copy({
    int? userDeviceID,
    int? userId,
    String? deviceId,
    String? deviceName,
    String? deviceCat,
    String? securityCode,
    DateTime? addedOn,
    String? isPaid,
    String? status,
    String? isInvoiceGenerated
  }) =>
      UserDeviceModel(
        userDeviceID: userDeviceID ?? this.userDeviceID,
        deviceName: deviceName ?? this.deviceName,
        deviceId: deviceId ?? this.deviceId,
        deviceCat: deviceCat ?? this.deviceCat,
        securityCode: securityCode ?? this.securityCode,
        userId: userId ?? this.userId,
        addedOn: addedOn ?? this.addedOn,
        isPaid: isPaid ?? this.isPaid,
        status: status ?? this.status,
          isInvoiceGenerated: isInvoiceGenerated ?? this.isInvoiceGenerated
      );
  static UserDeviceModel myDevice = UserDeviceModel(
    deviceName: "Not Defined",
    deviceId: "Not Defined",
    deviceCat: "Not Defined",
    addedOn: DateTime.now(),
    securityCode: "Not Defined",
    userId: 0, userDeviceID: 0, isPaid: 'false', status: 'Not Activated',
      isInvoiceGenerated: 'No'
  );

  factory UserDeviceModel.fromJson(Map<String, dynamic> json) {
    return UserDeviceModel(
        userDeviceID: int.parse(json['user_device_id']),
        deviceName: json['device_name'],
        deviceId: json['device_id'],
        deviceCat: json['device_cat'],
        securityCode: json['security_code'],
        userId: int.parse(json['user_id']),
        isPaid: json['is_paid'],
        isInvoiceGenerated: json['is_invoice_generated'],
        status: json['status'],
        addedOn: DateTime.parse(json['added_on']));
  }

  Map<String, dynamic> toJson() => {
    'user_device_id':userDeviceID,
    'device_name':deviceName,
    'device_id': deviceId,
    'device_cat': deviceCat,
    'addedOn': addedOn,
    'user_id':userId,
    'security_code':securityCode,
    'is_paid':isPaid,
    'status': status,
    'isInvoiceGenerated':isInvoiceGenerated
  };

  static Future init() async =>
      _preferences = await SharedPreferences.getInstance();

  static Future setUser(UserDeviceModel user) async {
    final json = jsonEncode(user.toJson());
    await _preferences.setString(_keyDevice, json);
  }

  static UserDeviceModel getDevice() {
    final json = _preferences.getString(_keyDevice);
    return json == null ? myDevice : UserDeviceModel.fromJson(jsonDecode(json));
  }
}