class ActivitySchema {
  double latitude;
  double longitude;
  String address;
  String description;
  String imagePath;
  int? price;

  ActivitySchema({
    required this.latitude,
    required this.longitude,
    required this.address,
    required this.description,
    required this.imagePath,
     this.price,
  });
}
