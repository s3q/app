
import 'package:app/providers/userProvider.dart';
import 'package:app/schemas/userSchema.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';
import "package:firebase_auth/firebase_auth.dart";
import 'package:cloud_firestore/cloud_firestore.dart';

class UsersHelperProvider with ChangeNotifier {
  Map<String, UserSchema> users = {};
  final store = FirebaseFirestore.instance;
//   static final auth = FirebaseAuth.instance;
//   static final store = FirebaseFirestore.instance;

//   static Future<UserCredential> signInWithGoogle() async {
//     final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

//     final GoogleSignInAuthentication? googleAuth =
//         await googleUser?.authentication;

//     final credential = GoogleAuthProvider.credential(
//       idToken: googleAuth?.idToken,
//       accessToken: googleAuth?.accessToken,
//     );

//     return await auth.signInWithCredential(credential);
//   }

//   static void saveSignInUserData(Map userData) {
//     CollectionReference usersCollection = store.collection(UserProvider.collection);
//     usersCollection.where();
//   }

  Future fetchUserData({required String userId}) async {
    if (users[userId] == null) {
      QuerySnapshot<Map<String, dynamic>> u = await store
          .collection(UserProvider.collection)
          .where("Id", isEqualTo: userId)
          .get();
      Map<String, dynamic> user = u.docs.single.data();
      users[userId] = UserSchema(
        name: user["name"],
        Id: user["Id"],
        ip: user["ip"],
        profileColor: user["profileColor"],
      );
    }
    return users[userId];
  }
}
