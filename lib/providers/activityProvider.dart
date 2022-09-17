import 'package:app/constants/constants.dart';
import 'package:app/providers/userProvider.dart';
import 'package:app/schemas/activitySchema.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

class ActivityProvider with ChangeNotifier {
  Map<String, ActivitySchema> activities = {};
  static String collection = CollectionsConstants.activities;
  static final auth = FirebaseAuth.instance;
  static final store = FirebaseFirestore.instance;



  Future fetchUserActivities(BuildContext context, userId) async {
    try {
      UserProvider userProvider = Provider.of<UserProvider>(context, listen: false);
      QuerySnapshot<Map<String, dynamic>> userActivitiesQuery = await store
          .collection(CollectionsConstants.activities)
          .where("userId", isEqualTo: userId)
          .get();


          userProvider.fetchUserData(userId: userId);

      userActivitiesQuery.docs.forEach((element) {
        Map act = element.data();
        // assert(act )
        activities[act["Id"]] = ActivitySchema(
            userId: act["userId"],
            likeCount: act["likeCount"],
            viewCount: act["viewCount"],
            Id: act["Id"],
            lat: act["lat"],
            lng: act["lng"],
            address: act["address"],
            phoneNumberWhatsapp: act["phoneNumberWhatsapp"],
            phoneNumberCall: act["phoneNumberCall"],
            description: act["description"],
            images: act["images"],
            importantInformation: act["importantInformation"],
            instagramAccount: act["instagramAccount"],
            cCall: act["cCall"],
            cTrippointChat: act["cTrippointChat"],
            cWhatsapp: act["cWhatsapp"],
            category: act["category"],
            priceStartFrom: act["priceStartFrom"],
            pricesDescription: act["pricesDescription"],
            op_GOA: act["op_GOA"],
            op_SCT: act["op_SCT"],
            op_SFC: act["op_SFC"],
            title: act["title"]);
      });
    } catch (err) {}
  }

  Future createActivity(
      BuildContext context, ActivitySchema activityData) async {
    try {
      UserProvider userProvider =
          Provider.of<UserProvider>(context, listen: false);

      assert(userProvider.islogin());
      assert(userProvider.currentUser!.isProAccount == true);
      assert(userProvider.currentUser!.proAccount != null);

      CollectionReference activityCollection = store.collection(collection);
      await activityCollection.add(activityData.toMap());
    } catch (err) {}
  }
}
