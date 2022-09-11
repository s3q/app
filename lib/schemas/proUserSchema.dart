class ProUserSchema {
  int createdAt;
  String userId;
  String publicPhoneNumber;
  bool activationStatus;
  bool verified;
  int likes;
  String? publicEmail;

  ProUserSchema({
    required this.createdAt,
    required this.userId,

    required this.publicPhoneNumber,
    this.activationStatus = false,
    this.verified = false,
    this.likes = 0,
    this.publicEmail,
  });

  Map<String, dynamic> toMap() {
    return {
      "createdAt": createdAt,
      "userId": userId,

      "verified": verified,
      "likes": likes,
      "publicPhoneNumber": publicPhoneNumber,
      "publicEmail": publicEmail,
      "activationStatus": activationStatus,
    };
  }
}
