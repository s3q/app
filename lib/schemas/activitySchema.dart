class ActivitySchema {
  double latitude;
  double longitude;
  String address;
  String description;
  String imagePath;

  ActivitySchema({
    required this.latitude,
    required this.longitude,
    required this.address,
    required this.description,
    required this.imagePath,
  });
}
