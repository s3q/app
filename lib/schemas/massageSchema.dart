class MassageSchema {
  String from;
  String massage;
  int createdAt;
  int readedAt;
  String chatId;

  MassageSchema({
    required this.from,
    required this.massage,
    required this.createdAt,
    required this.readedAt,
    required this.chatId,
  });

  Map<String, dynamic> toMap() {
    return {
      "from": from,
      "massage": massage,
      "createdAt": createdAt,
      "readedAt": readedAt,
      "chatId": chatId,
    };
  }
}
