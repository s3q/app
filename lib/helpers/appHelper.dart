import 'package:app/schemas/activitySchema.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:localization/colored_print/print_color.dart';
import 'package:phone_number/phone_number.dart';
import 'package:uuid/uuid.dart';

class AppHelper {
  static List categories = [
    {
      "imagepath": "assets/images/categories/discover_all.jpg",
      "title": "Discover all",
      "key": "discover_all",
    },
    {
      "imagepath": "assets/images/categories/discover_all.jpg",
      "title": "Water activity",
      "key": "water_activity",
    },
    {
      "imagepath": "assets/images/categories/discover_all.jpg",
      "title": "Outdoor advanture",
      "key": "outdoor_advanture",
    },
    {
      "imagepath": "assets/images/categories/discover_all.jpg",
      "title": "Sky advanture",
      "key": "sky_advanture",
    },
    {
      "imagepath": "assets/images/categories/discover_all.jpg",
      "title": "Animal experience",
      "key": "animal_experience",
    },
    {
      "imagepath": "assets/images/categories/discover_all.jpg",
      "title": "Indoor Activity",
      "key": "indoor_activity",
    }
  ];

  static Map activityMapData = {
    "chatT": "Trippoint Oman",
    "chatW": "Whatsapp",
    "chatC": "Call",
    "op_SFC": "the activity suitable for children",
    "op_GOA": "private group option available",
    "op_SCT": "activity requires some skills",
  };

  static List<ActivitySchema> Activities = [
    ActivitySchema(
        Id: Uuid().v4(),
        lat: 23.244037241974922,
        lng: 58.091192746314015,
        userId: "mw1nzK98cHUm14emdFoWsoRlVPD2",
        address: "smail, adldakilia",
        phoneNumberWhatsapp: "7937714",
        phoneNumberCall: "79377174",
        description:
            "new activity, for drop from sky with beutifil view you havn't seen before",
        images: ["assets/images/categories/discover_all.jpg"],
        importantInformation: "this is importaint information to read",
        instagramAccount: "s3q.x",
        // cCall: true,
        // cTrippointChat: true,
        // cWhatsapp: true,
        category: categories[1]["title"],
        priceStartFrom: 43,
        pricesDescription: "price description 1\$ for every children",
        op_GOA: true,
        op_SCT: true,
        op_SFC: true,
        title: "Dolphin watching and snorking Muscat"),
  ];

  static final PhoneNumberUtil phoneNumber = PhoneNumberUtil();
  static RegionInfo region =
      const RegionInfo(name: "Oman", code: "OM", prefix: 968);

  static checkPhoneValidation(BuildContext context, val) async {
    bool isValid = await phoneNumber.validate(val, region.code);

    if (!isValid) {
      print("invalid phone number");
    }
  }
}
