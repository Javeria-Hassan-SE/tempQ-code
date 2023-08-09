import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class UserModel {
  static late SharedPreferences _preferences;
  static const _keyUser = 'user';
  int userId;
  String userFullName, userEmail,  userCompany, userType, userContact;
  DateTime createdOn;
  String? userLocation, userImage, userAge, userGender;

  // this makes it singleton-like
  // factory UserModel.withA() => UserModel._internal();
  // UserModel._internal();

  UserModel({
    required this.userId,required this.userFullName,
    required this.userEmail,required this.userCompany, this.userLocation,
     this.userImage,required this.userContact,required this.createdOn,
    required this.userType,
     this.userAge, this.userGender
  });
  UserModel copy({
    int? userId,
    String? userFullName,
    String? userEmail,
    String? userCompany,
    String? userLocation,
    String? userImage,
    String? userAge,
    String? userGender,
    String? userContact,
    DateTime? createdOn,
    String? userType
  }) =>
      UserModel(
        userId: userId ?? this.userId,
        userFullName: userFullName ?? this.userFullName,
        userEmail: userEmail ?? this.userEmail,
        userCompany: userCompany ?? this.userCompany,
        userLocation: userLocation ?? this.userLocation,
        userImage: userImage ?? this.userImage,
        userContact: userContact ?? this.userContact,
        createdOn: createdOn ?? this.createdOn,
        userGender: userGender ?? this.userGender,
        userAge: userAge ?? this.userAge,
        userType: userType ?? this.userType,

      );

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
        userId: int.parse(json['user_id']),
        userFullName: json['user_full_name'] ,
        userEmail: json['user_email'],
        userCompany: json['user_company'] ,
        userLocation: json['user_location'],
        userImage: json['user_image'],
        userContact: json['user_contact'],
        createdOn: DateTime.parse(json['user_created_on']),
        userType: json['user_type'],
        userGender: json['user_gender'],
        userAge: json['user_age']);
  }
  static UserModel myUser = UserModel(
    userId: 1,
    userFullName: 'Test User',
    userEmail: 'test@gmail.com',
    userLocation: 'Not Provided',
    userImage: 'https://static.vecteezy.com/system/resources/previews/005/544/718/original/profile-icon-design-free-vector.jpg',
    userContact: "021456789",
    createdOn: DateTime.now(),
    userType: 'user',
    userAge: 'Not Define', userCompany: 'Not Defined', userGender: 'Not Defined'
  );
  Map<String, dynamic> toJson() => {
    'user_id':userId,
    'user_full_name': userFullName,
    'user_email': userEmail,
    'user_company': userCompany,
    'user_location': userLocation,
    'user_image': userImage,
    'user_contact': userContact,
    'user_created_on': createdOn,
    'user_age':userAge,
    'user_gender':userGender,
    'user_type':'user'
  };

  static Future init() async =>
      _preferences = await SharedPreferences.getInstance();

  static Future setUser(UserModel user) async {
    final json = jsonEncode(user.toJson());

    await _preferences.setString(_keyUser, json);
  }

  static UserModel getUser() {
    final json = _preferences.getString(_keyUser);

    return json == null ? myUser : UserModel.fromJson(jsonDecode(json));
  }
}