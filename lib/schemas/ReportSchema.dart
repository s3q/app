class ReportSchema {
  String Id;
  String userId;
  String phoneNumber;
  String? activityId;
  String report;
  int createdAt;
  String reportFor;

  ReportSchema({
    required this.Id,
    required this.userId,
    required this.phoneNumber,
    this.activityId,
    required this.report,
    required this.reportFor,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      "Id": Id,
      "userId": userId,
      "phoneNumber": phoneNumber,
      "activityId": activityId,
      "report": report,
      "createdAt": createdAt,
      "reportFor": reportFor,
    };
  }
}
