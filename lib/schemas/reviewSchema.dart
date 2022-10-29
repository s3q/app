class ReviewSchecma {
  String userId;
  String Id;
  String review;
  double rating;
  int createdAt;

  ReviewSchecma({
    required this.userId,
    required this.Id,
    required this.createdAt,
    required this.rating,
    required this.review,
  });

  Map<String, dynamic> toMap() {
    return {
      "userId": userId,
      "Id": Id,
      "createdAt": createdAt,
      "rating": rating,
      "review": review,
    };
  }
}
