import 'package:app/schemas/massageSchema.dart';

class ChatSchema {
  int createdAt;
  String publicKey;
  List users;
  String Id;
  String? storeId;
  String activityId;
  List<MassageSchema>? massages;

  ChatSchema({
    required this.createdAt,
    required this.publicKey,
    required this.users,
    required this.Id,
    required this.activityId,
    this.massages,
    this.storeId,
  });

  Map<String, dynamic> toMap() {
    return {
        "activityId": activityId,
      "createdAt": createdAt,
      "publicKey": publicKey,
      "users": users,
      "Id": Id,
    };
  }
}
