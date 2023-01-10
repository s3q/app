class MassageSchema {
  String from;
  String? massage;
  String? imagePath;
  String? audioPath;
  int createdAt;
  int readedAt;
  String type;
  String url;
  String chatId;
  String Id;

  MassageSchema({
    required this.Id,
    required this.from,
    this.massage,
    this.audioPath,
    this.imagePath,
    required this.createdAt,
    required this.readedAt,
    required this.type,
    required this.url,
    required this.chatId,
  });

  Map<String, dynamic> toMap() {
    return {
      "Id": Id,
      "from": from,
      "massage": massage,
      "createdAt": createdAt,
      "readedAt": readedAt,
      "chatId": chatId,
      "audioPath": audioPath,
      "url": url,
      "imagePath": imagePath,
      "type": type,
    };
  }
}
