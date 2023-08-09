import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class UserInvoices {
  static late SharedPreferences _preferences;
  static const _keyUser = 'user';
  int userId;
  String invId, invoicePDF;
  DateTime generatedOn;

  // this makes it singleton-like
  // factory UserInvoices.withA() => UserInvoices._internal();
  // UserInvoices._internal();

  UserInvoices({
    required this.userId,required this.invId,
    required this.invoicePDF, required this.generatedOn
  });
  UserInvoices copy({
    int? userId,
    String? invId,
    String? invoicePDF,
    DateTime? generatedOn
  }) =>
      UserInvoices(
        userId: userId ?? this.userId,
        invId: invId ?? this.invId,
        invoicePDF: invoicePDF ?? this.invoicePDF,
        generatedOn: generatedOn ?? this.generatedOn

      );

  factory UserInvoices.fromJson(Map<String, dynamic> json) {
    return UserInvoices(
        userId: int.parse(json['user_id']),
        invId: json['inv_id'] ,
        invoicePDF: json['invoice_pdf'],
        generatedOn: DateTime.parse(json['generated_on']));
  }
  static UserInvoices myInvoices = UserInvoices(
      userId: 1,
      invId: 'No Invoice Found',
      invoicePDF: 'No Invoice Found',
      generatedOn: DateTime.now(),
      );
  Map<String, dynamic> toJson() => {
    'user_id':userId,
    'inv_id': invId,
    'invoice_pdf': invoicePDF,
    'generated_on': generatedOn,
  };

  static Future init() async =>
      _preferences = await SharedPreferences.getInstance();

  static Future setUser(UserInvoices user) async {
    final json = jsonEncode(user.toJson());

    await _preferences.setString(_keyUser, json);
  }

  static UserInvoices getUser() {
    final json = _preferences.getString(_keyUser);

    return json == null ? myInvoices : UserInvoices.fromJson(jsonDecode(json));
  }
}