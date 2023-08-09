import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class AdminSensorsDevice {
  static late SharedPreferences _preferences;
  static const _keyDevice = 'device';
  final int id, addedBy, catId;
  final String deviceName, deviceId, status;
  final DateTime addedOn;

  AdminSensorsDevice( {
    required this.deviceName, required this.deviceId, required this.catId,
    required this.addedOn, required this.addedBy, required this.id,required this.status
  });
  AdminSensorsDevice copy({
    int? id,
    int? addedBy,
    String? deviceId,
    String? deviceName,
    int? catId,
    DateTime? addedOn,
    String? status
  }) =>
      AdminSensorsDevice(
          id: id ?? this.id,
          deviceName: deviceName ?? this.deviceName,
          deviceId: deviceId ?? this.deviceId,
          addedBy: addedBy ?? this.addedBy,
        status: status ?? this.status,
          addedOn: addedOn ?? this.addedOn, catId: catId ?? this.catId,
      );
  static AdminSensorsDevice myDevice = AdminSensorsDevice(
      deviceName: "Not Defined",
      deviceId: "Not Defined",
      catId: 0,
      addedOn: DateTime.now(),
      addedBy: 0, id: 0, status: 'Not Activated',

  );

  factory AdminSensorsDevice.fromJson(Map<String, dynamic> json) {
    return AdminSensorsDevice(
        id: int.parse(json['id']),
        deviceName: json['device_name'],
        deviceId: json['device_id'],
        catId: int.parse(json['cat_id']),
        addedBy: int.parse(json['added_by']),
        addedOn: DateTime.parse(json['added_on']),
        status: json['status']);
  }

  Map<String, dynamic> toJson() => {
    'id':id,
    'device_name':deviceName,
    'device_id': deviceId,
    'cat_id': catId,
    'added_on': addedOn,
    'added_by':addedBy,
    'status': status
  };

  static Future init() async =>
      _preferences = await SharedPreferences.getInstance();

  static Future setUser(AdminSensorsDevice user) async {
    final json = jsonEncode(user.toJson());
    await _preferences.setString(_keyDevice, json);
  }

  static AdminSensorsDevice getDevice() {
    final json = _preferences.getString(_keyDevice);
    return json == null ? myDevice : AdminSensorsDevice.fromJson(jsonDecode(json));
  }
}