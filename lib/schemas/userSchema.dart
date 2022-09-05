import 'dart:math';

import 'package:flutter/material.dart';

class UserSchema {
  String? email;
  String name;
  int? lastLogin;
  int? createdAt;
  String Id;
  String? providerId;
  String? phoneNumber;
  Map<String, dynamic>? deviceInfo;
  String? displaySizes;
  int? age;
  String? gender;
  String ip;
  List? chatList;

  int? profileColor;
  static List colors = [
    0xFFFFE082,
    0xFF90CAF9,
    0xFFB39DDB,
    0xFFEF9A9A,
    0xFF18FFFF,
    0xFFEEEEEE
  ];

  UserSchema({
    this.email,
    required this.name,
    this.lastLogin,
    this.createdAt,
    required this.Id,
    this.providerId,
    this.phoneNumber,
    this.deviceInfo,
    this.displaySizes,
    this.age,
    this.gender,
    this.chatList,
    required this.ip,
    this.profileColor,
  });

  Map<String, dynamic> toMap() {
    return {
      "email": email,
      "name": name,
      "lastLogin": lastLogin,
      "createdAt": createdAt,
      "Id": Id,
      "providerId": providerId,
      "phoneNumber": phoneNumber,
      "deviceInfo": deviceInfo,
      "displaySizes": displaySizes,
      "age": age,
      "gender": gender,
      "chatList": chatList,
      "ip": ip,
      "profileColor": colors[Random().nextInt(colors.length)]
    };
  }
}
