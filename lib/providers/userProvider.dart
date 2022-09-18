import 'package:app/constants/constants.dart';
import 'package:app/helpers/errorsHelper.dart';
import 'package:app/schemas/proUserSchema.dart';
import 'package:app/schemas/userSchema.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import "package:firebase_auth/firebase_auth.dart";
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dart_ipify/dart_ipify.dart';

class UserProvider with ChangeNotifier {
  User? credentialUser;
  UserSchema? currentUser;
    Map<String, UserSchema> users = {};

  ProUserSchema? proCurrentUser;
  static String collection = CollectionsConstants.users;
  static final auth = FirebaseAuth.instance;
  static final store = FirebaseFirestore.instance;
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

  Future<UserCredential?> signInWithGoogle(BuildContext context) async {
    try {
      print("DDDone 00");
      final GoogleSignInAccount? googleUser = await googleSignin.signIn();
      print("DDDone 11");
      if (googleUser != null) {
        final GoogleSignInAuthentication googleAuth =
            await googleUser.authentication;
        print("DDDone 22");
        final credential = GoogleAuthProvider.credential(
          idToken: googleAuth.idToken,
          accessToken: googleAuth.accessToken,
        );
        print(credential.providerId);

        UserCredential _credentialUser =
            await auth.signInWithCredential(credential);
        credentialUser = _credentialUser.user;

        print(credentialUser);
        print("DDDDone");

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

        return _credentialUser;
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Theme.of(context).errorColor,
          content: const Text("You haven't signed in google"),
        ));
        return null;
      }
    } catch (err) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Theme.of(context).errorColor,
        content: Text(err.toString()),
      ));
      return null;
    }
  }

  Future switchToProAccount({
    required BuildContext context,
    required ProUserSchema proUserData,
    required String email,
    required String city,
    required String phoneNumber,
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
          "email": email,
          "phoneNumber": phoneNumber,
          "dateOfBirth": dateOfBirth,
          "name": name,
          "isProAccount": true,
          "city": city,
          "proAccount": proUserData.toMap(),
        };

        assert(query.docs.length == 1);

        await query.docs.single.reference.update(userData);

        proCurrentUser = proUserData;
      } catch (err) {
        print(err);
      }
    }
  }

  Future saveSignInUserData(
    BuildContext context,
    User userData, {
    bool sginup = true,
    String name = "",
        bool signinWithPhoneNumber = false,
  }) async {
    print(userData);
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

    print(query.docs.asMap());
    if (query.docs.isEmpty || sginup) {
      final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
      BaseDeviceInfo deviceInfo = await deviceInfoPlugin.deviceInfo;
      print(deviceInfo.toMap());
      print(this.toString());
      final ipv4 = await Ipify.ipv4();

      currentUser = UserSchema(
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
      );

      await usersCollection.add(currentUser!.toMap());

      notifyListeners();
    } else if (query.docs.length > 1) {
      print("ERROR");
      CollectionReference errorCollection = store.collection("errors");
      await errorCollection.add({
        "error":
            "${ErrorsHelper.errMultiEmailes} multi users with same email or phone number",
        "page": this.toString(),
        "collections": query.docs.asMap(),
        "time": DateTime.now().microsecondsSinceEpoch,
      });
    } else if ((query.docs[0]["email"] == userData.email ||
            query.docs[0]["phoneNumber"] == userData.phoneNumber) &&
        query.docs[0]["Id"] == userData.uid &&
        !sginup) {
      await query.docs.single.reference
          .update({"lastLogin": DateTime.now().millisecondsSinceEpoch});

      Map userQueryData = query.docs.single.data() as Map;
      print(userQueryData);

      currentUser = UserSchema(
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
            createdAt: proUserQueryData["createdAt"],
            userId: proUserQueryData["userId"],
            publicPhoneNumber: proUserQueryData["publicPhoneNumber"],
            publicEmail: proUserQueryData["publicEmail"]);
      }

      currentUser!.lastLogin = DateTime.now().millisecondsSinceEpoch;
      notifyListeners();
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
      await auth.signOut();
      await googleSignin.signOut();
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
}
