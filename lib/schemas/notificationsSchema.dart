import 'package:app/schemas/notificationPieceSchema.dart';

class NotificationsSchema {
  List<Map> important;
  List<Map> medium;
  List<Map> low;

  NotificationsSchema(
      {required this.important, required this.medium, required this.low});

  static NotificationsSchema toSchema(Map data) {
    return NotificationsSchema(important: data["important"], medium: data["medium"], low: data["low"]);
  }

  Map<String, dynamic> asMap() {
    return {
      "important": important,
      "medium": medium,
      "low": low,
    };
  }
}
