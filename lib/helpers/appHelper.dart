import 'dart:js';

import 'package:app/schemas/activitySchema.dart';
import 'package:app/widgets/loadingWidget.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:localization/colored_print/print_color.dart';
import 'package:phone_number/phone_number.dart';
import 'package:uuid/uuid.dart';
import "package:easy_localization/easy_localization.dart";
import "package:localization/localization.dart";

class AppHelper {
  static List categories = [
    {
      "imagepath": "assets/images/categories/discover_all.jpg",
      "title": "Discover all",
      "key": "discover_all",
    },
    {
      "imagepath": "assets/images/categories/water_advanture.jpg",
      "title": "Water activity",
      "key": "water_activity",
    },
    {
      "imagepath": "assets/images/categories/outdoor_advanture.jpg",
      "title": "Outdoor advanture",
      "key": "outdoor_advanture",
    },
    {
      "imagepath": "assets/images/categories/sky_advanture.jpg",
      "title": "Sky advanture",
      "key": "sky_advanture",
    },
    {
      "imagepath": "assets/images/categories/animal_experience.jpg",
      "title": "Animal experience",
      "key": "animal_experience",
    },
    {
      "imagepath": "assets/images/categories/indoor_activity.jpg",
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

//   static List<ActivitySchema> Activities = [
//     ActivitySchema(
//         Id: Uuid().v4(),
//         reviews: [],
//         lat: 23.244037241974922,
//         lng: 58.091192746314015,
//         tags: [],
//         userId: "mw1nzK98cHUm14emdFoWsoRlVPD2",
//         address: "smail, adldakilia",
//         phoneNumberWhatsapp: "7937714",
//         phoneNumberCall: "79377174",
//         description:
//             "new activity, for drop from sky with beutifil view you havn't seen before",
//         images: ["assets/images/categories/discover_all.jpg"],
//         importantInformation: "this is importaint information to read",
//         cTrippointChat: true,
//         availableDays: ["thursday",],
//         category: categories[1]["title"],
//         priceNote: "price description 1\$ for every children",
//         prices: [],
//         op_GOA: true,
//         genderSuitability: {},
//         suitableAges: {},
//         dates: [],
//         isActive: true,
//         lastUpdate: DateTime.now().millisecondsSinceEpoch,
//         createdAt: DateTime.now().millisecondsSinceEpoch,
//     //  likesCount: act["likeCount"],
//     //   viewsCount: act["viewCount"],
//     //   callsCount: act["callsCount"],
//     //   sharesCount: act["sharesCount"],
//         title: "Dolphin watching and snorking Muscat",
//         ),
//   ];

  static final PhoneNumberUtil phoneNumber = PhoneNumberUtil();
  static RegionInfo region =
      const RegionInfo(name: "Oman", code: "OM", prefix: 968);

  static checkPhoneValidation(BuildContext context, val) async {
    bool isValid = await phoneNumber.validate(val, region.code);

    if (!isValid) {
      print("invalid phone number");
    }
  }

  static List showOverlay(BuildContext context, Widget widget) {
    OverlayState? overlayState = Overlay.of(context);

    OverlayEntry overlayEntry = OverlayEntry(
        opaque: true,
        builder: (context) {
          return widget;
        });

    overlayState?.insert(overlayEntry);

    return [overlayState, overlayEntry];
  }

  static Future<String> buildDynamicLink(
      {required String title, required String Id}) async {
    String uriPrefix = "https://omantrippoint.page.link";
    final dynamicLinkParams = DynamicLinkParameters(
      link: Uri.parse("${uriPrefix}/post${Id}"),
      uriPrefix: uriPrefix,
      androidParameters: const AndroidParameters(
        packageName: "com.example.app",
        minimumVersion: 0,
      ),
      iosParameters: const IOSParameters(
        bundleId: "com.example.app",
        appStoreId: "123456789",
        minimumVersion: "1.0.1",
      ),
//   googleAnalyticsParameters: const GoogleAnalyticsParameters(
//     source: "twitter",
//     medium: "social",
//     campaign: "example-promo",
//   ),
      socialMetaTagParameters: SocialMetaTagParameters(
        title: title,
        imageUrl: Uri.parse(
            "https://raw.githubusercontent.com/s3q/app/main/assets/icons/launch_image.png"),
        // !!!!!!!!!!!!!
      ),
    );
    ShortDynamicLink dynamicLink =
        await FirebaseDynamicLinks.instance.buildShortLink(dynamicLinkParams);
    return dynamicLink.shortUrl.toString();
  }

  static String returnText(BuildContext context, String en, String ar) {
    if (context.locale.languageCode.toString() == "en") {
      return en;
    }
    
    return ar;
  }
}
