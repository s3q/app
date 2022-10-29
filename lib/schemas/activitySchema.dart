import 'package:google_maps_flutter/google_maps_flutter.dart';

class ActivitySchema {
//   LatLng latlng;
  int createdAt;
  int lastUpdate;
  bool isActive;
  double lat;
  double lng;
  List images;
  String title;
  String Id;
  String category;
  int viewsCount;
  int likesCount;
  String userId;
//   String pricesDescription;
  String priceNote;
  List prices;
  String phoneNumberCall;
  List dates;
  String? phoneNumberWhatsapp;
  String description;
  String importantInformation;
  String address;
  List availableDays;
  bool cTrippointChat;
  List reviews;
  String? storeId;
  int callsCount;
  int sharesCount;
  int chatsCount;

//   Map<String, int> suitableAges;
  Map suitableAges;
  Map genderSuitability;
//   Map<String, bool> genderSuitability;
  bool op_GOA;

  ActivitySchema({
    this.storeId,
    required this.createdAt,
    required this.isActive,
    required this.lastUpdate,
    required this.userId,
    this.viewsCount = 0,
    this.likesCount = 0,
    this.callsCount = 0,
    this.sharesCount = 0,
    this.chatsCount = 0,
    required this.dates,
    required this.Id,
    required this.lat,
    required this.lng,
    required this.address,
    required this.availableDays,
    this.phoneNumberWhatsapp,
    required this.phoneNumberCall,
    required this.description,
    required this.images,
    required this.importantInformation,
    required this.cTrippointChat,
    required this.category,
    required this.priceNote,
    required this.prices,
    required this.op_GOA,
    required this.title,
    required this.reviews,
    required this.suitableAges,
    required this.genderSuitability,
  });

  Map<String, dynamic> toMap() {
    return {
      "Id": Id,
      "createdAt": createdAt,
      "isActive": isActive,
      "lastUpdate": lastUpdate,
      "availableDays": availableDays,
      "viewCount": viewsCount,
      "likeCount": likesCount,
      "callsCount": callsCount,
      "sharesCount": sharesCount,
      "chatsCount": chatsCount,
      "userId": userId,
      "dates": dates,
      "lat": lat,
      "lng": lng,
      "address": address,
      "phoneNumberCall": phoneNumberCall,
      "phoneNumberWhatsapp": phoneNumberWhatsapp,
      "description": description,
      "images": images,
      "importantInformation": importantInformation,
      "cTrippointChat": cTrippointChat,
      "category": category,
      "priceNote": priceNote,
      "prices": prices,
      "op_GOA": op_GOA,
      "suitableAges": suitableAges,
      "genderSuitability": genderSuitability,
      "reviews": reviews,
      "title": title,
    };
  }
}
