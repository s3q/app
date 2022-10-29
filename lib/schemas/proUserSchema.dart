class ProUserSchema {
  int createdAt;
  String userId;
  String publicPhoneNumber;
  bool activationStatus;
  bool verified;
  int likes;
  String? publicEmail;
  String? instagram;

  ProUserSchema({
    required this.createdAt,
    required this.userId,
    required this.publicPhoneNumber,
    this.activationStatus = false,
    this.verified = false,
    this.likes = 0,
    this.publicEmail,
    this.instagram,
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
      "instagram": instagram,
    };
  }
}
