import 'package:flutter/cupertino.dart';

class NotificationPieceSchema {
  int createdAt;
  String? description;
  String text;
  String notificationId;

  NotificationPieceSchema(
      {required this.createdAt, required this.description, required this.text, required this.notificationId});



  static NotificationPieceSchema toSchema(Map data) {
    return NotificationPieceSchema(createdAt: data["createdAt"], description: data["description"], text: data["text"], notificationId: data["notificationId"]);
  }

  Map<String, dynamic> asMap() {
    return {
      "createdAt": createdAt,
      "description": description,
      "text": text,
      "notificationId": notificationId
    };
  }
}
