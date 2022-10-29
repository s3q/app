class ActivityStatisticsSchema {
  int createdAt;
  String Id;
  String? storeId;
  String activityId;
  int viewsCount;
  int callsCount;
  int chatsCount;
  int whatsappCount;
  int instsgramCount;
  int likesCount;
  int sharesCount;

  ActivityStatisticsSchema({
    required this.createdAt,
    required this.Id,
    required this.activityId,
    required this.callsCount,
    required this.sharesCount,
    this.storeId,
    required this.chatsCount,
    required this.instsgramCount,
    required this.likesCount,
    required this.viewsCount,
    required this.whatsappCount,
  });

  Map<String, dynamic> toMap() {
    return {
      "createdAt": createdAt,
      "Id": Id,
      "storeId": storeId,
      "activityId": activityId,
      "viewsCount": viewsCount,
      "sharesCount": sharesCount,
      "callsCount": callsCount,
      "chatsCount": chatsCount,
      "whatsappCount": whatsappCount,
      "instsgramCount": instsgramCount,
      "likesCount": likesCount,
    };
  }
}
