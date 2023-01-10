import 'package:flutter/cupertino.dart';

class EventsNotificationPieceSchema {
  int createdAt;
  String title;
  String text;
  String url;
  Map data;

  EventsNotificationPieceSchema(
      {required this.createdAt,
      required this.title,
      required this.text,
      required this.url,
      required this.data});

  static EventsNotificationPieceSchema toSchema(Map data) {
    return EventsNotificationPieceSchema(
        createdAt: data["createdAt"],
        title: data["title"],
        text: data["text"],
        url: data["url"],
        data: data["data"]);
  }

  Map<String, dynamic> toMap() {
    return {
      "createdAt": createdAt,
      "title": title,
      "text": text,
      "url": url,
      "data": data,
    };
  }
}
