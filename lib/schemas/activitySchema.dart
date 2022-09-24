import 'package:google_maps_flutter/google_maps_flutter.dart';

class ActivitySchema {
//   LatLng latlng;
  double lat;
  double lng;
  List<String> images;
  String title;
  String Id;
  String category;
  int viewCount;
  int likeCount;
  String userId;
  String pricesDescription;
  String phoneNumberCall;
  String? phoneNumberWhatsapp;
  String description;
  String importantInformation;
  String address;
  int? priceStartFrom;
//   bool cTrippointChat;
//   bool cWhatsapp;
//   bool cCall;
  String? instagramAccount;
  bool op_SFC;
  bool op_GOA;
  bool op_SCT;

  ActivitySchema({
    required this.userId,
    this.viewCount = 0,
    this.likeCount = 0,
    required this.Id,
    required this.lat,
    required this.lng,
    required this.address,
     this.phoneNumberWhatsapp,
    required this.phoneNumberCall,
    required this.description,
    required this.images,
    required this.importantInformation,
     this.instagramAccount,
    // required this.cCall,
    // required this.cTrippointChat,
    // required this.cWhatsapp,
    required this.category,
    required this.priceStartFrom,
    required this.pricesDescription,
    required this.op_GOA,
    required this.op_SCT,
    required this.op_SFC,
    required this.title,
  });

  Map<String, dynamic> toMap() {
    return {
      "Id": Id,
      "viewCount": viewCount,
      "likeCount": likeCount,
      "userId": userId,
      "lat": lat,
      "lng": lng,
      "address": address,
      "phoneNumberCall": phoneNumberCall,
      "phoneNumberWhatsapp": phoneNumberWhatsapp,
      "description": description,
      "images": images,
      "importantInformation": importantInformation,
      "instagramAccount": instagramAccount,
    //   "cCall": this.cCall,
    //   "cTrippointChat": this.cTrippointChat,
    //   "cWhatsapp": this.cWhatsapp,
      "category": category,
      "priceStartFrom": priceStartFrom,
      "pricesDescription": pricesDescription,
      "op_GOA": op_GOA,
      "op_SCT": op_SCT,
      "op_SFC": op_SFC,
      "title": title,
    };
  }
}
