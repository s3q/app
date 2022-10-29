import 'package:app/constants/constants.dart';
import 'package:app/providers/userProvider.dart';
import 'package:app/schemas/activitySchema.dart';
import 'package:app/schemas/activityStatisticsSchema.dart';
import 'package:app/schemas/reviewSchema.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'dart:math' show cos, sqrt, asin;

class ActivityProvider with ChangeNotifier {
  Map<String, ActivitySchema> activities = {};
  Map<String, ActivitySchema> topActivitiesList = {};
  static String collection = CollectionsConstants.activities;
  static final auth = FirebaseAuth.instance;
  static final store = FirebaseFirestore.instance;
  static final storage = FirebaseStorage.instance;

  Future<List<ActivitySchema>> topActivitesFillter() async {
    if (topActivitiesList.length < 10) {
      QuerySnapshot<Map<String, dynamic>> activitesListSnapshot = await store
          .collection("activites")
          .where("isActive", isEqualTo: true)
          .limit(10)
          .get();

      print(activitesListSnapshot.docs);

      activitesListSnapshot.docs.forEach((d) {
        // a.data()["viewCounter"];
        // a.data()["createdAt"];
        // a.data()["availableDays"];
        // a.data()["lat"];
        // a.data()["lng"];
        ActivitySchema a = ActivitySchema(
          storeId: d.id,
          createdAt: d.data()["createdAt"],
          reviews: d.data()["reviews"],
          isActive: d.data()["isActive"],
          lastUpdate: d.data()["lastUpdate"],
          userId: d.data()["userId"],
          dates: d.data()["dates"],
          Id: d.data()["Id"],
          lat: d.data()["lat"],
          lng: d.data()["lng"],
          address: d.data()["address"],
          availableDays: d.data()["availableDays"],
          phoneNumberCall: d.data()["phoneNumberCall"],
          description: d.data()["description"],
          images: d.data()["images"],
          importantInformation: d.data()["importantInformation"],
          cTrippointChat: d.data()["cTrippointChat"],
          category: d.data()["category"],
          priceNote: d.data()["priceNote"],
          prices: d.data()["prices"],
          op_GOA: d.data()["op_GOA"],
          title: d.data()["title"],
          genderSuitability: d.data()["genderSuitability"],
          suitableAges: d.data()["suitableAges"],
          chatsCount: d.data()["chatsCount"],
          callsCount: d.data()["callsCount"],
          viewsCount: d.data()["viewsCount"],
          likesCount: d.data()["likesCount"],
          sharesCount: d.data()["sharesCount"],
        );

        a.images.remove(null);
        a.images.remove(null);
        a.images.remove(null);
        a.images.remove(null);
        a.images.remove(null);
        a.images.remove(null);
        a.images.remove(null);
        a.images.remove(null);
        a.images.remove(null);
        a.images.remove(null);
        a.images.remove(null);

        topActivitiesList[a.Id] = a;
      });

      //  activitesList.forEach((e) async {
      //   e.images = await e.images.map((i) async {
      //     print(i);
      //     return await storage.ref(i).getDownloadURL();
      //   }).toList();
      // });

      return topActivitiesList.values.toList();
    }
    return [];
  }

  Future<ActivityStatisticsSchema?> fetchActivityStatistics(activityId) async {
    QuerySnapshot<Map<String, dynamic>> activityStatisticsQuery = await store
        .collection(CollectionsConstants.activityStatistics)
        .where("activityId", isEqualTo: activityId)
        .get();

    if (activityStatisticsQuery.docs.isNotEmpty) {
      Map<String, dynamic> activityStatisticsAsMap =
          activityStatisticsQuery.docs.single.data();
      ActivityStatisticsSchema activityStatisticsSchema =
          ActivityStatisticsSchema(
        sharesCount: activityStatisticsAsMap["sharesCount"],
        createdAt: activityStatisticsAsMap["createdAt"],
        Id: activityStatisticsAsMap["Id"],
        activityId: activityStatisticsAsMap["activityId"],
        callsCount: activityStatisticsAsMap["callsCount"],
        chatsCount: activityStatisticsAsMap["chatsCount"],
        instsgramCount: activityStatisticsAsMap["instsgramCount"],
        likesCount: activityStatisticsAsMap["likesCount"],
        viewsCount: activityStatisticsAsMap["viewsCount"],
        whatsappCount: activityStatisticsAsMap["whatsappCount"],
      );

      return activityStatisticsSchema;
    }
  }

  Future openActivity(activityId) async {
    QuerySnapshot<Map<String, dynamic>> activityQuery = await store
        .collection(collection)
        .where("ActivityId", isEqualTo: activityId)
        .get();

    if (activityQuery.docs.isNotEmpty) {
      await activityQuery.docs.single.reference.update({
        "viewsCount":
            int.parse(activityQuery.docs.single.data()["viewCount"]) + 1,
      });
      activities[activityId]!.viewsCount =
          int.parse(activityQuery.docs.single.data()["viewCount"]) + 1;
    }
  }

  Future<bool> likeActivity(activityId) async {
    QuerySnapshot<Map<String, dynamic>> activityQuery = await store
        .collection(collection)
        .where("ActivityId", isEqualTo: activityId)
        .get();

    if (activityQuery.docs.isNotEmpty) {
      await activityQuery.docs.single.reference.update({
        "likesCount":
            int.parse(activityQuery.docs.single.data()["likesCount"]) + 1,
      });
      activities[activityId]!.viewsCount =
          int.parse(activityQuery.docs.single.data()["likesCount"]) + 1;
    }

    return false;
  }

  Future<bool> addCallsCountActivity(activityId) async {
    QuerySnapshot<Map<String, dynamic>> activityQuery = await store
        .collection(collection)
        .where("ActivityId", isEqualTo: activityId)
        .get();

    if (activityQuery.docs.isNotEmpty) {
      await activityQuery.docs.single.reference.update({
        "callsCount":
            int.parse(activityQuery.docs.single.data()["callsCount"]) + 1,
      });
      activities[activityId]!.viewsCount =
          int.parse(activityQuery.docs.single.data()["callsCount"]) + 1;
    }

    return false;
  }

  Future<bool> addChatsCountActivity(activityId) async {
    QuerySnapshot<Map<String, dynamic>> activityQuery = await store
        .collection(collection)
        .where("ActivityId", isEqualTo: activityId)
        .get();

    if (activityQuery.docs.isNotEmpty) {
      await activityQuery.docs.single.reference.update({
        "chatsCount":
            int.parse(activityQuery.docs.single.data()["chatsCount"]) + 1,
      });
      activities[activityId]!.viewsCount =
          int.parse(activityQuery.docs.single.data()["chatsCount"]) + 1;
    }

    return false;
  }

  Future<bool> addSharesCountActivity(activityId) async {
    QuerySnapshot<Map<String, dynamic>> activityQuery = await store
        .collection(collection)
        .where("ActivityId", isEqualTo: activityId)
        .get();

    if (activityQuery.docs.isNotEmpty) {
      await activityQuery.docs.single.reference.update({
        "shareCount":
            int.parse(activityQuery.docs.single.data()["shareCount"]) + 1,
      });
      activities[activityId]!.viewsCount =
          int.parse(activityQuery.docs.single.data()["shareCount"]) + 1;
    }

    return false;
  }

  Future<bool> addWhatsappCountActivity(activityId) async {
    QuerySnapshot<Map<String, dynamic>> activityQuery = await store
        .collection(collection)
        .where("ActivityId", isEqualTo: activityId)
        .get();

    if (activityQuery.docs.isNotEmpty) {
      await activityQuery.docs.single.reference.update({
        "whatsappCount":
            int.parse(activityQuery.docs.single.data()["whatsappCount"]) + 1,
      });
    }

    return true;
  }

  Future<bool> addInstagramCountActivity(activityId) async {
    QuerySnapshot<Map<String, dynamic>> activityQuery = await store
        .collection(collection)
        .where("ActivityId", isEqualTo: activityId)
        .get();

    if (activityQuery.docs.isNotEmpty) {
      await activityQuery.docs.single.reference.update({
        "InstagramCount":
            int.parse(activityQuery.docs.single.data()["InstagramCount"]) + 1,
      });
    }

    return true;
  }

  int? startFromPrice(List prices) {
    int? lessPrice;
    int i = 0;
    prices.forEach((e) {
      print(e);
      if (e["price"] != null && e["price"].toString().trim() != "") {
        int n = int.parse(e["price"]);

        if (lessPrice != null) {
          if (lessPrice! > n) {
            lessPrice = n;
          }

          //   if (i == prices.length - 1 && lessPrice! < n) {
          //     return lessPrice;
          //   } else if (i == prices.length - 1 && lessPrice! > n) {
          //     return n;
          //   }
        } else {
          lessPrice = n;
        }
      }
      i += 1;
    });

    return lessPrice;
  }

  Future<String?> imageUrl(String path) async {
    // Points to the root reference

    // Reference storageRef = FirebaseStorage.instance.ref(path);
    //   print(await storageRef.getDownloadURL());
    return await storage.ref(path).getDownloadURL();
  }

  double previewMark(List previews) {
    double total = 0;
    if (previews.length != 0) {
      previews.forEach((e) {
        if (e["rating"] != null && e["rating"].toString().trim() != "") {
          total += e["rating"];
        }
      });

      double d = total / previews.length;
      String inString = d.toStringAsFixed(1);
      double inDouble = double.parse(inString);
      return inDouble;
    } else {
      return 0.0;
    }
  }

  Future<ActivitySchema> fetchActivityWStore(String activityId) async {
    if (activities[activityId] != null) {
      return activities[activityId]!;
    }
    if (topActivitiesList[activityId] != null) {
      return topActivitiesList[activityId]!;
    }

    QuerySnapshot<Map<String, dynamic>> queryActivity = await store
        .collection(collection)
        .where("Id", isEqualTo: activityId)
        .get();

    Map<String, dynamic> act = queryActivity.docs.single.data();
    activities[activityId] = ActivitySchema(
      storeId: queryActivity.docs.single.reference.id,
      isActive: act["isActive"],
      createdAt: act["createdAt"],
      lastUpdate: act["lastUpdate"],
      userId: act["userId"],
      likesCount: act["likeCount"],
      viewsCount: act["viewCount"],
      callsCount: act["callsCount"],
      sharesCount: act["sharesCount"],
      chatsCount: act["chatsCount"],
      Id: act["Id"],
      lat: act["lat"],
      lng: act["lng"],
      address: act["address"],
      phoneNumberWhatsapp: act["phoneNumberWhatsapp"],
      phoneNumberCall: act["phoneNumberCall"],
      description: act["description"],
      images: act["images"],
      importantInformation: act["importantInformation"],
      availableDays: act["availableDays"],
      cTrippointChat: act["cTrippointChat"],
      category: act["category"],
      priceNote: act["priceNote"],
      prices: act["price"],
      op_GOA: act["op_GOA"],
      dates: act["dates"],
      reviews: act["reviews"],
      suitableAges: act["suitableAges"],
      genderSuitability: act["genderSuitability"],
      title: act["title"],
    );

    return activities[activityId]!;
  }

  Future<List<ActivitySchema>?> fetchUserActivities(
      BuildContext context, userId) async {
    try {
      UserProvider userProvider =
          Provider.of<UserProvider>(context, listen: false);
      QuerySnapshot<Map<String, dynamic>> userActivitiesQuery = await store
          .collection(CollectionsConstants.activities)
          .where("userId", isEqualTo: userId)
          .get();

      List<ActivitySchema> activityList = [];

      userProvider.fetchUserData(userId: userId);

      userActivitiesQuery.docs.forEach((element) {
        Map act = element.data();
        // assert(act )
        activities[act["Id"]] = ActivitySchema(
          storeId: element.id,
          isActive: act["isActive"],
          createdAt: act["createdAt"],
          lastUpdate: act["lastUpdate"],
          userId: act["userId"],
          likesCount: act["likeCount"],
          viewsCount: act["viewCount"],
          callsCount: act["callsCount"],
          sharesCount: act["sharesCount"],
          chatsCount: act["chatsCount"],
          Id: act["Id"],
          lat: act["lat"],
          lng: act["lng"],
          address: act["address"],
          phoneNumberWhatsapp: act["phoneNumberWhatsapp"],
          phoneNumberCall: act["phoneNumberCall"],
          description: act["description"],
          images: act["images"],
          importantInformation: act["importantInformation"],
          availableDays: act["availableDays"],
          cTrippointChat: act["cTrippointChat"],
          category: act["category"],
          priceNote: act["priceNote"],
          prices: act["price"],
          op_GOA: act["op_GOA"],
          dates: act["dates"],
          reviews: act["reviews"],
          suitableAges: act["suitableAges"],
          genderSuitability: act["genderSuitability"],
          title: act["title"],
        );

        if (activities[act["Id"]] != null) {
          activityList.add(activities[act["Id"]]!);
        }
      });
      return activityList;
    } catch (err) {}
  }

  Future sendReview(
      ReviewSchecma reviewSchecma, String storeId, String activityId) async {
    DocumentSnapshot<Map<String, dynamic>> activityQuery =
        await store.collection(collection).doc(storeId).get();

    await activityQuery.reference.update({
      "reviews": [
        ...activityQuery.data()?["reviews"],
        reviewSchecma.toMap(),
      ]
    });

    topActivitiesList[activityId]?.reviews.add(reviewSchecma.toMap());
    activities[activityId]?.reviews.add(reviewSchecma.toMap());
    print(topActivitiesList[activityId]?.reviews);
  }

  double calculateDistance(lat1, lon1, lat2, lon2) {
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 -
        c((lat2 - lat1) * p) / 2 +
        c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a));
  }

  Future<List<ActivitySchema>> fetchActivitiesNearLocation(
      LatLng latLng) async {
    List<ActivitySchema> activitiesList = [];

    double lessKmY = ((110.574 * latLng.latitude) - 30) / 110.574;
    double greaterKmY = ((110.574 * latLng.latitude) + 30) / 110.574;
    double lessKmX =
        ((111.320 * cos(latLng.latitude) * latLng.longitude) + 30) /
            111.320 *
            cos(latLng.latitude);
    double greaterKmX =
        ((111.320 * cos(latLng.latitude) * latLng.longitude) + 30) /
            111.320 *
            cos(latLng.latitude);
    print([lessKmY, greaterKmY]);
    print([lessKmX, greaterKmX]);
    QuerySnapshot<Map<String, dynamic>> activitiesQuery = await store
        .collection(collection)
        .where("lat",
            isLessThanOrEqualTo: lessKmY, isGreaterThanOrEqualTo: greaterKmY)
        .where(
          "lng",
          isLessThanOrEqualTo: lessKmX,
          isGreaterThanOrEqualTo: greaterKmX,
        )
        .get();

    activitiesQuery.docs.map((act) {
      activitiesList.add(ActivitySchema(
        storeId: act.reference.id,
        isActive: act["isActive"],
        createdAt: act["createdAt"],
        lastUpdate: act["lastUpdate"],
        userId: act["userId"],
        likesCount: act["likeCount"],
        viewsCount: act["viewCount"],
        callsCount: act["callsCount"],
        sharesCount: act["sharesCount"],
        chatsCount: act["chatsCount"],
        Id: act["Id"],
        lat: act["lat"],
        lng: act["lng"],
        address: act["address"],
        phoneNumberWhatsapp: act["phoneNumberWhatsapp"],
        phoneNumberCall: act["phoneNumberCall"],
        description: act["description"],
        images: act["images"],
        importantInformation: act["importantInformation"],
        availableDays: act["availableDays"],
        cTrippointChat: act["cTrippointChat"],
        category: act["category"],
        priceNote: act["priceNote"],
        prices: act["price"],
        op_GOA: act["op_GOA"],
        dates: act["dates"],
        reviews: act["reviews"],
        suitableAges: act["suitableAges"],
        genderSuitability: act["genderSuitability"],
        title: act["title"],
      ));
    });

    return activitiesList;
    // print(activitiesQuery);
    // double distance = calculateDistance(latLng.)
  }

  Future createActivity(
      BuildContext context, ActivitySchema activityData) async {
    try {
      UserProvider userProvider =
          Provider.of<UserProvider>(context, listen: false);

      assert(userProvider.islogin());
      assert(userProvider.currentUser!.isProAccount == true);
      assert(userProvider.proCurrentUser != null);
      assert(userProvider.proCurrentUser!.activationStatus == true);

      CollectionReference activityCollection = store.collection(collection);
      print(activityData.toMap());
      await activityCollection.add(activityData.toMap());

      ActivityStatisticsSchema activityStatisticsSchema =
          ActivityStatisticsSchema(
              createdAt: DateTime.now().millisecondsSinceEpoch,
              Id: Uuid().v4(),
              activityId: activityData.Id,
              callsCount: 0,
              chatsCount: 0,
              sharesCount: 0,
              instsgramCount: 0,
              likesCount: 0,
              viewsCount: 1,
              whatsappCount: 0);

      store
          .collection(CollectionsConstants.activityStatistics)
          .add(activityStatisticsSchema.toMap());
    } catch (err) {
      print(err);
    }
  }
}
