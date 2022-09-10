class ProUserSchema {
  String createdAt;
  String userId;
  String lat;
  String lan;
  String publicPhoneNumber;
  bool activationStatus;
  String? publicEmail;

  ProUserSchema({
    required this.createdAt,
    required this.userId,
    required this.lat,
    required this.lan,
    required this.publicPhoneNumber,
    this.activationStatus = false,
    this.publicEmail,
  });

  Map<String, dynamic> toMap() {
    return {
      "createdAt": createdAt,
      "userId": userId,
      "lat": lat,
      "lan": lan,
      "publicPhoneNumber": publicPhoneNumber,
      "publicEmail": publicEmail,
      "activationStatus": activationStatus,
    };
  }
}
