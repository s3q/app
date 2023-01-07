import 'dart:io';

import 'package:app/constants/constants.dart';
import 'package:app/helpers/errorsHelper.dart';
import 'package:app/providers/activityProvider.dart';
import 'package:app/schemas/notificationPieceSchema.dart';
import 'package:app/schemas/proUserSchema.dart';
import 'package:app/schemas/userSchema.dart';
import 'package:app/screens/accountCreatedScreen.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import "package:firebase_auth/firebase_auth.dart";
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dart_ipify/dart_ipify.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class UserProvider with ChangeNotifier {
  User? credentialUser;
  UserSchema? currentUser;
  Map<String, UserSchema> users = {};
  Map<String, List<NotificationPieceSchema>> notificationMap = {};

  ProUserSchema? proCurrentUser;
  static String collection = CollectionsConstants.users;
  static final auth = FirebaseAuth.instance;
  static final store = FirebaseFirestore.instance;
  static final storage = FirebaseStorage.instance;

  final googleSignin = GoogleSignIn();

  static List fields = [
    "email",
    "name",
    "lastLogin",
    "createdAt",
    "Id",
    "phoneNumber",
    "deviceInfo",
    "displaySizes",
    "age",
    "gender",
    "ip",
  ];

  bool islogin() {
    try {
      assert(credentialUser != null);
      assert(currentUser != null);
      assert(credentialUser!.uid != null);
      assert(currentUser!.Id != null);
      return true;
    } catch (err) {
      return false;
    }
  }

  Future<UserSchema?> fetchUserData({required String userId}) async {
    if (users[userId] == null) {
      QuerySnapshot<Map<String, dynamic>> u = await store
          .collection(UserProvider.collection)
          .where("Id", isEqualTo: userId.trim())
          .get();

      Map<String, dynamic> user = u.docs.single.data();

      Map? proAccount = user["proAccount"];
      ProUserSchema? proUserSchema;

      if (proAccount != null && user["isProAccount"]) {
        proUserSchema = ProUserSchema(
          createdAt: proAccount["createdAt"],
          userId: proAccount["userId"],
          publicPhoneNumber: proAccount["publicPhoneNumber"],
          instagram: proAccount["instagram"],
          publicEmail: proAccount["publicEmail"],
        );
      }
      print(proUserSchema?.toMap());
      users[userId] = UserSchema(
        // wishlist: ,
        proAccount: proUserSchema != null ? proUserSchema.toMap() : {},
        name: user["name"],
        Id: user["Id"],
        ip: user["ip"],
        profileColor: user["profileColor"],
        profileImagePath: user["profileImagePath"],
      );
    }

    return users[userId];
  }

  Future<bool> checkEmailNotused(String email) async {
    QuerySnapshot<Map<String, dynamic>> query = await store
        .collection(collection)
        .where("email", isEqualTo: email.trim())
        .get();

    if (query.docs.isNotEmpty) {
      return false;
    }

    return true;
  }

  Future<bool> signInWithGoogle(BuildContext context) async {
    try {
      final GoogleSignInAccount? googleUser = await googleSignin.signIn();

      if (googleUser != null) {
        // bool _usedEmail = await checkEmailNotused(googleUser.email);

        // if (_usedEmail) {
        final GoogleSignInAuthentication googleAuth =
            await googleUser.authentication;

        final credential = GoogleAuthProvider.credential(
          idToken: googleAuth.idToken,
          accessToken: googleAuth.accessToken,
        );

        UserCredential _credentialUser =
            await auth.signInWithCredential(credential);
        credentialUser = _credentialUser.user;

        if (_credentialUser.user != null) {
          await saveSignInUserData(
            context,
            _credentialUser.user!,
            sginup: false,
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: Theme.of(context).errorColor,
            content: const Text("You have problem when sign in, try agian"),
          ));
        }

        return true;

        // }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Theme.of(context).errorColor,
          content: const Text("You haven't signed in google"),
        ));
        return false;
      }
    } catch (err) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Theme.of(context).errorColor,
        content: Text(err.toString()),
      ));
      return false;
    }
  }

  Future switchToProAccount({
    required BuildContext context,
    required ProUserSchema proUserData,
    required String city,
    required int dateOfBirth,
    required String name,
  }) async {
    if (currentUser != null && credentialUser != null && islogin()) {
      try {
        assert(currentUser!.Id != null);
        // CollectionReference pro_usersCollection =
        //     store.collection(CollectionsConstants.pro_users);
        CollectionReference usersCollection =
            store.collection(CollectionsConstants.users);

        // pro_usersCollection.add(proUserData.toMap());

        QuerySnapshot<Object?> query =
            await usersCollection.where("Id", isEqualTo: currentUser!.Id).get();

        Map<String, Object?> userData = {
          "dateOfBirth": dateOfBirth,
          "name": name,
          "isProAccount": true,
          "city": city,
          "proAccount": proUserData.toMap(),
        };

        assert(query.docs.length == 1);

        await query.docs.single.reference.update(userData);

        currentUser!.isProAccount = true;
        proCurrentUser = proUserData;

        notifyListeners();

        return true;
      } catch (err) {
        print(err);
        return false;
      }
    }
  }

  Future<bool> addToWishlist(
      activityStoreId, activityId, ActivityProvider activityProvider) async {
    if (currentUser!.wishlist != null) {
      await store.collection(collection).doc(currentUser!.storeId).update({
        "wishlist": [...currentUser!.wishlist!, activityId]
      });

      await activityProvider.likeActivity(activityStoreId, activityId);

      // await query.reference.update({
      //   "wishlist": [...query.data()?["wishlist"], activityId]
      // });

      currentUser?.wishlist = [...currentUser!.wishlist!, activityId];

      return true;
    }
    return false; // !!!!!!
  }

  Future removeFromWishlist(activityId) async {
    if (currentUser!.wishlist != null) {
      await store.collection(collection).doc(currentUser!.storeId).update({
        "wishlist": [
          ...currentUser!.wishlist!.where((e) => e != activityId).toList()
        ]
      });

      // await query.reference.update({
      //   "wishlist": [...query.data()?["wishlist"], activityId]
      // });

      currentUser?.wishlist =
          currentUser!.wishlist!.where((e) => e != activityId).toList();
    }
  }

  Future saveSignInUserData(
    BuildContext context,
    User userData, {
    bool sginup = true,
    String name = "",
    bool signinWithPhoneNumber = false,
  }) async {
    CollectionReference usersCollection =
        store.collection(UserProvider.collection);
    QuerySnapshot<Object?> query;
    if (signinWithPhoneNumber) {
      query = await usersCollection
          .where("phoneNumber", isEqualTo: userData.phoneNumber)
          .get();
    } else {
      query =
          await usersCollection.where("email", isEqualTo: userData.email).get();
    }

    if (query.docs.isEmpty || sginup) {
      final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
      BaseDeviceInfo deviceInfo = await deviceInfoPlugin.deviceInfo;

      final ipv4 = await Ipify.ipv4();

      currentUser = UserSchema(
          // storeId: ,
          wishlist: [],
          email: userData.email,
          name: userData.displayName ?? name,
          lastLogin: DateTime.now().millisecondsSinceEpoch,
          createdAt: DateTime.now().millisecondsSinceEpoch,
          Id: userData.uid,
          providerId: userData.providerData[0].providerId,
          phoneNumber: userData.phoneNumber,
          deviceInfo: deviceInfo.toMap(),
          proAccount: null,
          displaySizes:
              "${MediaQuery.of(context).size.width} ${MediaQuery.of(context).size.height}",
          dateOfBirth: null,
          gender: null,
          chatList: [],
          ip: ipv4,
          profileImagePath: userData.photoURL);

      DocumentReference<Object?> queryCurrentUserDoc =
          await usersCollection.add(currentUser!.toMap());

      currentUser?.storeId = queryCurrentUserDoc.id;
      notifyListeners();
    } else if (query.docs.length > 1) {
      print("ERROR");
      CollectionReference errorCollection = store.collection("errors");
      await errorCollection.add({
        "error":
            "${ErrorsHelper.errMultiEmailes} multi users with same email or phone number",
        "page": this.toString(),
        "collections": query.docs.asMap(),
        "date": DateTime.now().microsecondsSinceEpoch,
      });
    } else if ((query.docs[0]["email"] == userData.email ||
            query.docs[0]["phoneNumber"] == userData.phoneNumber) &&
        query.docs[0]["Id"] == userData.uid &&
        !sginup) {
      await query.docs.single.reference
          .update({"lastLogin": DateTime.now().millisecondsSinceEpoch});

      Map userQueryData = query.docs.single.data() as Map;

      /// ! check user id equal for it in authntication.

      currentUser = UserSchema(
        wishlist: userQueryData["wishlist"],
        storeId: query.docs.single.reference.id,
        email: userQueryData["email"],
        name: userQueryData["name"],
        lastLogin: userQueryData["lastLogin"],
        createdAt: userQueryData["createdAt"],
        Id: userQueryData["Id"],
        providerId: userQueryData["providerId"],
        phoneNumber: userQueryData["phoneNumber"],
        deviceInfo: userQueryData["deviceInfo"],
        displaySizes: userQueryData["displaySizes"],
        dateOfBirth: userQueryData["dateOfBirth"],
        proAccount: userQueryData["proAccount"],
        isProAccount: userQueryData["isProAccount"],
        gender: userQueryData["gender"],
        chatList: userQueryData["chatList"],
        ip: userQueryData["ip"],
        profileColor: userQueryData["profileColor"],
        profileImagePath: userQueryData["profileImagePath"],
      );

      if (currentUser!.isProAccount == true &&
          currentUser!.proAccount != null) {
        Map proUserQueryData = currentUser!.proAccount!;
        proCurrentUser = ProUserSchema(
          likes: proUserQueryData["likes"],
          createdAt: proUserQueryData["createdAt"],
          userId: proUserQueryData["userId"],
          publicPhoneNumber: proUserQueryData["publicPhoneNumber"],
          publicEmail: proUserQueryData["publicEmail"],
          activationStatus: proUserQueryData["activationStatus"],
          verified: proUserQueryData["verified"],
        );
      }

      currentUser!.lastLogin = DateTime.now().millisecondsSinceEpoch;
      notifyListeners();
    }
  }

  Future<bool> deleteAccount(
    BuildContext context,
  ) async {
    try {
      UserProvider userProvider =
          Provider.of<UserProvider>(context, listen: false);

      QuerySnapshot<Map<String, dynamic>> querySnapshot = await store
          .collection(collection)
          .where("Id", isEqualTo: currentUser!.Id)
          .get();

      if (querySnapshot.docs.length > 1) {
        // !!!!!!!!!!
        return false;
      }

      if (querySnapshot.docs.length == 1) {
        querySnapshot.docs[0].reference.delete();
      }

      if (userProvider.currentUser!.providerId == "google.com") {
        // await googleSignin.currentUser!.clearAuthCache();

        final GoogleSignInAccount? googleUser = await googleSignin.signIn();

        if (googleUser != null) {
          bool _usedEmail = await checkEmailNotused(googleUser.email);

          if (_usedEmail) {
            final GoogleSignInAuthentication googleAuth =
                await googleUser.authentication;

            final credential = GoogleAuthProvider.credential(
              idToken: googleAuth.idToken,
              accessToken: googleAuth.accessToken,
            );

            UserCredential _credentialUser =
                await auth.signInWithCredential(credential);
            credentialUser = _credentialUser.user;

            if (_credentialUser.user != null) {
              ///
              print("login ");
            } else {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                backgroundColor: Theme.of(context).errorColor,
                content: const Text("You have problem when sign in, try agian"),
              ));
            }
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: Theme.of(context).errorColor,
            content: const Text("You haven't signed in google"),
          ));
        }
      }

      await auth.currentUser!.delete();

      await signout();
      return true;
    } catch (err) {
      print(err);
      return false;
    }
  }

  // signUp
  Future signup(BuildContext context, {email, password, name}) async {
    // currentUser
    try {
      UserCredential _credentialUser = await auth
          .createUserWithEmailAndPassword(email: email, password: password);

      credentialUser = _credentialUser.user;

      if (_credentialUser.user != null) {
        await saveSignInUserData(
          context,
          _credentialUser.user!,
          sginup: true,
          name: name,
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Theme.of(context).errorColor,
          content:
              const Text("You have problem when create account, try agian"),
        ));
        return false;
      }
    } on FirebaseAuthException catch (err) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Theme.of(context).errorColor,
        content: Text(err.message.toString()),
      ));
      return false;
    } catch (err) {
      print(err);
      return false;
    }
    return true;
  }

  Future signout() async {
    try {
      credentialUser = null;
      currentUser = null;
      await googleSignin.disconnect();
      print("disconnect");
      await googleSignin.signOut();
      await auth.signOut();
      print("signout");

      notifyListeners();
    } catch (err) {
      return false;
    }
    return true;
  }

  // signUp
  Future login(BuildContext context, {email, password}) async {
    // currentUser
    try {
      UserCredential _credentialUser = await auth.signInWithEmailAndPassword(
          email: email, password: password);

      credentialUser = _credentialUser.user;

      if (_credentialUser.user != null) {
        await saveSignInUserData(
          context,
          _credentialUser.user!,
          sginup: false,
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Theme.of(context).errorColor,
          content:
              const Text("You have problem when login to account, try agian"),
        ));
        return false;
      }
    } on FirebaseAuthException catch (err) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Theme.of(context).errorColor,
        content: Text(err.message.toString()),
      ));
      return false;
    } catch (err) {
      return false;
    }
    return true;
  }

//   Future verifyPhoneNumber(String phoneNumber) async {
//   }

//    // signUp
//   Future sgininWithPhoneNumber(BuildContext context, {email, password}) async {
//     // currentUser
//     try {
//       UserCredential _credentialUser = await auth.signInWithPhoneNumber(
//           email: email, password: password);

//       credentialUser = _credentialUser.user;

//       if (_credentialUser.user != null) {
//         await saveSignInUserData(context, _credentialUser.user!, sginup: false,);
//       } else {
//         ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//           backgroundColor: Theme.of(context).errorColor,
//           content:
//               const Text("You have problem when login to account, try agian"),
//         ));
//         return false;
//       }
//     } on FirebaseAuthException catch (err) {
//       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//         backgroundColor: Theme.of(context).errorColor,
//         content: Text(err.message.toString()),
//       ));
//       return false;
//     } catch (err) {
//       return false;
//     }
//     return true;
//   }

  Future<bool> updateEmail(String newEmail) async {
    await credentialUser!.updateEmail(newEmail);
    await store.collection(collection).doc(currentUser!.storeId).update({
      "email": newEmail,
    });
    return true;
  }

  Future<bool> updateUserInfo(
      BuildContext context, Map<String, dynamic> data) async {
    Map<String, dynamic> updatedData = {};

    data.map((key, value) {
      if (["name", "phoneNumber"].contains(key.trim())) {
        updatedData[key] = value;
      }
      return MapEntry(key, value);
    });

    await store
        .collection(collection)
        .doc(currentUser?.storeId)
        .update(updatedData);
    return true;
  }

  Future<bool> forgotPassword(
      {required BuildContext context, required String email}) async {
    try {
      await auth.sendPasswordResetEmail(email: email);
      return true;
    } on FirebaseAuthException catch (err) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Theme.of(context).errorColor,
        content: Text(err.message.toString()),
      ));
      return false;
    } catch (err) {
      return false;
    }
  }

  Future<bool> changeProfileImage(String filePath) async {
    File file = File(filePath);

    Reference ref =
        storage.ref("users/${currentUser!.Id}/profileImage/${Uuid().v4()}.jpg");
    ref.putFile(file).then((taskSnapshot) async {
      String imageDownloadPath = await taskSnapshot.ref.getDownloadURL();

      await store.collection(collection).doc(currentUser!.storeId).update({
        "profileImagePath": imageDownloadPath,
      });

      currentUser!.profileImagePath = imageDownloadPath;
    });
    return true;
  }

  Future<bool> removeProfileImage() async {
    String imageName = currentUser!.profileImagePath!
        .split("users/${currentUser!.Id}/profileImage/")[1]
        .split(".jpg")[0];
    Reference ref =
        storage.ref("users/${currentUser!.Id}/profileImage/${imageName}.jpg");

    await store.collection(collection).doc(currentUser!.storeId!).update({
      "profileImagePath": null,
    });
    currentUser!.profileImagePath = null;

    await ref.delete();

    notifyListeners();

    await store
        .collection(collection)
        .doc(currentUser?.storeId)
        .update({"profileImagePath": ""});

    return true;
  }

  Future fetchNotifications() async {
    try {
      assert(currentUser?.Id != null);
      QuerySnapshot<Map<String, dynamic>> query1 = await store
          .collection(CollectionsConstants.notifications)
          .doc(currentUser!.Id)
          .collection("chat")
          .get();

      notificationMap["chat"] == null ? notificationMap["chat"] = [] : null;
      for (var doc in query1.docs) {
        notificationMap["chat"]
            ?.add(NotificationPieceSchema.toSchema(doc.data()));
      }

      return notificationMap["chat"];
    } catch (err) {
      return [];
    }
  }
}
