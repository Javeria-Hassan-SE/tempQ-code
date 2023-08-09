import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class AlarmModel {
  static late SharedPreferences _preferences;
  static const _keyAlarm = 'alarm';
  int minvalue, maximumValue;


  AlarmModel({
    required this.minvalue,required this.maximumValue,

  });
  AlarmModel copy({
    int? minvalue,
    int? maximumValue,
  }) =>
      AlarmModel(
        minvalue: minvalue ?? this.minvalue,
        maximumValue: maximumValue ?? this.maximumValue,

      );

  factory AlarmModel.fromJson(Map<String, dynamic> json) {
    return AlarmModel(
        minvalue: int.parse(json['minValue']),
        maximumValue: int.parse(json['maximumValue']));
  }
  static AlarmModel myUser = AlarmModel(
      minvalue: 0,
      maximumValue: 0,

  );
  Map<String, dynamic> toJson() => {
    'minValue':minvalue,
    'maximumValue': maximumValue,
  };

  static Future init() async =>
      _preferences = await SharedPreferences.getInstance();

  static Future setUser(AlarmModel user) async {
    final json = jsonEncode(user.toJson());

    await _preferences.setString(_keyAlarm, json);
  }

  static AlarmModel getUser() {
    final json = _preferences.getString(_keyAlarm);

    return json == null ? myUser : AlarmModel.fromJson(jsonDecode(json));
  }
}