import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class GenerateInvoiceModel{
  static late SharedPreferences _preferences;
  static const _keyUser = 'invoice';
  int user_id, plan_id, qty;
  String inv_id;
  String  issue_by;
  DateTime date_of_issue, due_date;
  double total, discount, unit_price;
  List device_id;

  // this makes it singleton-like
  // factory UserModel.withA() => UserModel._internal();
  // UserModel._internal();

  GenerateInvoiceModel({
    required this.inv_id,required this.user_id,
    required this.issue_by,required this.plan_id, required this.due_date,
    required this.total,required this.qty,required this.date_of_issue,
    required this.discount,required this.unit_price, required this.device_id
  });
  GenerateInvoiceModel copy({
    String? inv_id,
    int? user_id,
    String? issue_by,
    int? plan_id,
    DateTime? due_date,
    double? total,
    double? discount,
    double? unit_price,
    int? qty,
    DateTime? date_of_issue,
    List? device_id
  }) =>
      GenerateInvoiceModel(
        inv_id: inv_id ?? this.inv_id,
        user_id: user_id ?? this.user_id,
        issue_by: issue_by ?? this.issue_by,
        plan_id: plan_id ?? this.plan_id,
        due_date: due_date ?? this.due_date,
        total: total ?? this.total,
        qty: qty ?? this.qty,
        date_of_issue: date_of_issue ?? this.date_of_issue,
        unit_price: unit_price ?? this.unit_price,
        discount: discount ?? this.discount,
        device_id: device_id ?? this.device_id,

      );

  factory GenerateInvoiceModel.fromJson(Map<String, dynamic> json) {
    return GenerateInvoiceModel(
        // inv_id: json['inv_id'],
        // user_id: int.parse(json['user_id']),
        // issue_by: json['issue_by'],
        // plan_id: int.parse(json['plan_id']) ,
        // due_date: DateTime.parse(json['due_date']),
        // total: double.parse(json['total']),
        // qty: int.parse(json['qty']),
        // date_of_issue: DateTime.parse(json['date_of_issue']),
        // unit_price: double.parse(json['unit_price']),
        // discount: double.parse(json['discount']),
        // device_id: json['device_id']);
        inv_id: json['inv_id'],
        user_id: json['user_id'],
        issue_by: json['issue_by'],
        plan_id: json['plan_id'] ,
        due_date: json['due_date'],
        total: json['total'],
        qty: json['qty'],
        date_of_issue: json['date_of_issue'],
        unit_price: json['unit_price'],
        discount: json['discount'],
        device_id: json['device_id']);
  }
  static GenerateInvoiceModel myUser = GenerateInvoiceModel(
      inv_id: "Default",
      user_id: 1,
      issue_by: 'System Generated',
      due_date: DateTime.now().add(const Duration(days: 7)),
      total:0,
      qty: 0,
      date_of_issue: DateTime.now(),
      discount: 0, plan_id: 1, unit_price: 0, device_id: []
  );
  Map<String, dynamic> toJson() => {
    'inv_id':inv_id,
    'user_id': user_id,
    'issue_by': issue_by,
    'plan_id': plan_id,
    'due_date': due_date,
    'total': total,
    'qty': qty,
    'date_of_issue': date_of_issue,
    'discount':discount,
    'unit_price':unit_price,
    'device_id':device_id
  };

  static Future init() async =>
      _preferences = await SharedPreferences.getInstance();

  static Future setUser(GenerateInvoiceModel user) async {
    final json = jsonEncode(user.toJson());

    await _preferences.setString(_keyUser, json);
  }

  static GenerateInvoiceModel getUser() {
    final json = _preferences.getString(_keyUser);

    return json == null ? myUser : GenerateInvoiceModel.fromJson(jsonDecode(json));
  }
}