import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class DeviceCategory {
   static late SharedPreferences _preferences;
   static const _keyDevice = 'category';
   List <String> categories;
   DeviceCategory({
      required this.categories
      });
   DeviceCategory copy({
      List <String>? categories,
   }) =>
       DeviceCategory(
          categories: categories ?? this.categories,
       );   factory DeviceCategory.fromJson(Map<String, dynamic> json) {
      return DeviceCategory(
          categories: json['device_cat']);
   }
   static DeviceCategory myDevice = DeviceCategory(
      categories: ['Fridge', 'Deep Freezer', 'Room', 'Other'],
   );
   Map<String, dynamic> toJson() => {
      'device_cat':categories,
   };

   static Future init() async =>
       _preferences = await SharedPreferences.getInstance();

   static Future setUser(DeviceCategory device) async {
      final json = jsonEncode(device.toJson());
      await _preferences.setString(_keyDevice, json);
   }

   static DeviceCategory getDevice() {
      final json = _preferences.getString(_keyDevice);
      return json == null ? myDevice : DeviceCategory.fromJson(jsonDecode(json));
   }
}

