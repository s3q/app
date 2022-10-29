import 'dart:io';
import 'package:app/constants/constants.dart';
import 'package:app/providers/userProvider.dart';
import 'package:app/schemas/chatSchema.dart';
import 'package:app/schemas/massageSchema.dart';
import 'package:app/schemas/userSchema.dart';
import 'package:app/screens/getStartedScreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class ChatProvider with ChangeNotifier {
  List<ChatSchema> chats = [];
  ChatSchema? chat;
//   List? usersDataChats;
//   List<MassageSchema>? massages;

  static final store = FirebaseFirestore.instance;
  static final auth = FirebaseAuth.instance;
  static String collection = CollectionsConstants.chat;

  Future getChats(
      {required QuerySnapshot<Map<String, dynamic>> query,
      required BuildContext context}) async {
    // List users = e["users"]
    Map<String, dynamic> users = {};
    UserProvider userProvider =
        Provider.of<UserProvider>(context, listen: false);

    List<QueryDocumentSnapshot<Map<String, dynamic>>> docs =
        query.docs.toList();
    print(docs.length);
    print("LLLLLLL");

    // chats.map((c) {
    //   if (c.storeId == docs.id) {
    //     return true;
    //   }
    // });

    for (int i = 0; i <= docs.length; i += 1) {
      //   users[docs[i].id] = [];
      print(i);

      String userId2 = (docs[i].data()["users"] as List)
          .singleWhere((id) => id != userProvider.currentUser!.Id);
      //   for (int ii = 0; ii < usersIdList.length; ii++) {
      //   if (!usersHelperProvider.users.containsKey(userId2)) {
      //     if (usersHelperProvider.users[userId2] == null) {
      //       QuerySnapshot<Map<String, dynamic>> u = await store
      //           .collection(UserProvider.collection)
      //           .where("Id", isEqualTo: userId2)
      //           .get();
      //       Map<String, dynamic> user = u.docs.single.data();
      //       usersHelperProvider.users[userId2] = UserSchema(
      //         name: user["name"],
      //         Id: user["Id"],
      //         ip: user["ip"],
      //         profileColor: user["profileColor"],
      //       );
      //     }
      //     // }

      //   }

      await userProvider.fetchUserData(userId: userId2);
      //   users[docs[i].id] = [usersHelperProvider.users[userId2]];

      //   print(users[docs[i].id]);

      QuerySnapshot<Map<String, dynamic>> lastMassagesQuery = await store
          .collection(ChatProvider.collection)
          .doc(docs[i].id)
          .collection(CollectionsConstants.massages)
          .where("readedAt", isEqualTo: 0)
          .orderBy("createdAt")
          .get();

      MassageSchema? lastMassage;

      if (lastMassagesQuery.docs.isNotEmpty) {
        lastMassage = MassageSchema(
          Id: lastMassagesQuery.docs[0].data()["Id"],
          imagePath: lastMassagesQuery.docs[0].data()["imagePath"],
          type: lastMassagesQuery.docs[0].data()["type"],
          audioPath: lastMassagesQuery.docs[0].data()["audioPath"],
          chatId: lastMassagesQuery.docs[0].data()["chatId"],
          massage: lastMassagesQuery.docs[0].data()["massage"],
          createdAt: lastMassagesQuery.docs[0].data()["createdAt"],
          readedAt: lastMassagesQuery.docs[0].data()["readedAt"],
          from: lastMassagesQuery.docs[0].data()["from"],
        );
      }

      ChatSchema chatData = ChatSchema(
        storeId: docs[i].id,
        activityId: docs[i].data()["activityId"],
        createdAt: docs[i].data()["createdAt"],
        publicKey: docs[i].data()["publicKey"],
        users: [userId2],
        massages: lastMassage != null
            ? [
                lastMassage,
              ]
            : [],
        Id: docs[i].data()["Id"],
      );

      if (chats
          .where((element) => element.storeId == chatData.storeId)
          .isEmpty) {
        chats.add(chatData);
      }
    }

    return chats;

    // chats = query.docs.toList().map((e) {
    //   return ChatSchema(
    //     storeId: e.id,
    //     createdAt: e["createdAt"],
    //     publicKey: e["publicKey"],
    //     users: users[e.id]!,
    //     Id: e["Id"],
    //   );
    // }).toList();
  }

  Future fetchUserChats() async {
    // QuerySnapshot<Map<String, dynamic>> query1 = await store
    //     .collection(UserProvider.collection)
    //     .where("Id", isEqualTo: auth.currentUser!.uid)
    //     .get();

    // List chatList = query1.docs.single.data()["chatList"];

    QuerySnapshot<Map<String, dynamic>> query2 = await store
        .collection(ChatProvider.collection)
        .where("users", arrayContains: auth.currentUser!.uid)
        .get();

    print(query2.docChanges[0].doc.data());
    chats = query2.docs
        .map((e) => ChatSchema(
              storeId: e.id,
              activityId: e["activityId"],
              createdAt: e["createdAt"],
              publicKey: e["publicKey"],
              users: e["users"],
              Id: e["Id"],
            ))
        .toList();
  }

  Future<ChatSchema?> fetchSingleChat(ChatSchema chat) async {
    try {
      if (chat.users.contains(auth.currentUser!.uid)) {
        QuerySnapshot<Map<String, dynamic>> query1 = await store
            .collection(ChatProvider.collection)
            .doc(chat.storeId!)
            .collection(CollectionsConstants.massages)
            .get();

        chat.massages = query1.docs
            .map(
              (e) => MassageSchema(
                Id: e["Id"],
                type: e["type"],
                imagePath: e["imagePath"],
                audioPath: e["audioPath"],
                chatId: e["chatId"],
                massage: e["massage"],
                createdAt: e["createdAt"],
                readedAt: e["readedAt"],
                from: e["from"],
              ),
            )
            .toList();
        //   massages = chat.massages;

        print(chat.massages);

        chat = chat;

        return chat;
      }
    } catch (err) {
      return null;
    }

    return null;
  }

  Future<MassageSchema?> sendImageMessage({required String imagePath}) async {
    try {
      assert(chat != null);
      assert(chat!.storeId != null);
      assert(imagePath.trim() != "");

      print(chat!.storeId);
      //   QuerySnapshot<Map<String, dynamic>> query1 =
      CollectionReference<Map<String, dynamic>> query1 = store
          .collection(ChatProvider.collection)
          .doc(chat!.storeId!)
          .collection(CollectionsConstants.massages);
      String storePath =
          "${ChatProvider.collection}/${auth.currentUser!.uid}/uploadedImages/${Uuid().v4()}.jpg";
      final storageRef = FirebaseStorage.instance.ref(storePath);
      File file = File(imagePath);
      storageRef.putFile(file);

      String downloadPath =
          await FirebaseStorage.instance.ref(storePath).getDownloadURL();

      MassageSchema massage = MassageSchema(
        Id: Uuid().v4(),
        type: "image",
        from: auth.currentUser!.uid,
        imagePath: downloadPath.trim(),
        createdAt: DateTime.now().millisecondsSinceEpoch,
        readedAt: 0,
        chatId: chat!.Id,
      );

      //   DocumentReference<Map<String, dynamic>> docRef =
      await query1.add(massage.toMap());
      print("done");

      return massage;
    } catch (err) {
      return null;
    }
  }

  Future<MassageSchema?> sendMassage({required String text}) async {
    try {
      assert(chat != null);
      assert(chat!.storeId != null);
      assert(text.trim() != "");

      print(chat!.storeId);
      //   QuerySnapshot<Map<String, dynamic>> query1 =
      CollectionReference<Map<String, dynamic>> query1 = store
          .collection(ChatProvider.collection)
          .doc(chat!.storeId!)
          .collection(CollectionsConstants.massages);

      print(auth.currentUser!.uid);
      print(chat?.Id);
      print(text);

      MassageSchema massage = MassageSchema(
        Id: Uuid().v4(),
        type: "text",
        from: auth.currentUser!.uid,
        massage: text.trim(),
        createdAt: DateTime.now().millisecondsSinceEpoch,
        readedAt: 0,
        chatId: chat!.Id,
      );

      //   DocumentReference<Map<String, dynamic>> docRef =
      await query1.add(massage.toMap());
      print("done");

      return massage;
    } catch (err) {
      return null;
    }
  }

  Future<bool> deleteChat({
    required String chatId,
    required String credentialUserId,
  }) async {
    try {
      await store.collection(ChatProvider.collection).doc(chatId).delete();
    } catch (err) {
      return false;
    }
    return true;
  }

  Future<String> deleteChatOneSide({
    required String chatId,
    // required String credentialUserId,
  }) async {
    try {
      //   await store.collection(ChatProvider.collection).doc("/$chatId").delete();
      QuerySnapshot<Map<String, dynamic>> query = await store
          .collection(UserProvider.collection)
          .where("Id", isEqualTo: auth.currentUser!.uid)
          .get();
      query.docs.single.reference.update({
        "chatList": (query.docs.single.data()["chaId"] as List)
            .map((e) => e != chatId)
            .toList(),
      });

      return chatId;
    } catch (err) {
      return "";
    }
  }

  Future<String> addChat({
    // required String credentialUserId,
    required BuildContext context,
    required String userId,
    required String activityId,
  }) async {
    try {
      if (auth.currentUser == null) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          //   backgroundColor: Theme.of(context).errorColor,
          content: const Text("you havn't logned "),
          action: SnackBarAction(
            onPressed: () async {
              await Navigator.of(context).pushNamed(GetStartedScreen.router);
            },
            label: "login",
          ),
        ));
        return "";
      }
      assert(auth.currentUser!.uid != userId);
      QuerySnapshot<Map<String, dynamic>> checkingQuery = await store
          .collection(ChatProvider.collection)
          .where("users", isEqualTo: [auth.currentUser!.uid, userId]).get();

      /* ####################  add users to temporary storage #################### */
      print([auth.currentUser!.uid, userId]);
      print(checkingQuery.docs.toList());

      UserProvider userProvider =
          Provider.of<UserProvider>(context, listen: false);

      // if (!usersHelperProvider.users.containsKey(userId)) {
      //   QuerySnapshot<Map<String, dynamic>> u = await store
      //       .collection(UserProvider.collection)
      //       .where("Id", isEqualTo: userId)
      //       .get();
      //   Map<String, dynamic> user = u.docs.single.data();
      //   usersHelperProvider.users[userId] = UserSchema(
      //     name: user["name"],
      //     Id: user["Id"],
      //     ip: user["ip"],
      //     profileColor: user["profileColor"],
      //   );
      // }

      userProvider.fetchUserData(userId: userId);
      /* #################### */

      if (checkingQuery.docs.isEmpty) {
        print("create a new chat ");
        String chatId = Uuid().v4();
        //   String storeId = Uuid().v4();
        chat = ChatSchema(
          activityId: activityId,
          createdAt: DateTime.now().millisecondsSinceEpoch,
          publicKey: Uuid().v1(),
          users: [
            //   usersHelperProvider.users[userId],
            userProvider.currentUser!.Id,
            userId,
          ],
          Id: chatId,
        );
        await store.collection(ChatProvider.collection).add(chat!.toMap());

        QuerySnapshot<Map<String, dynamic>> query1 = await store
            .collection(UserProvider.collection)
            .where("Id", isEqualTo: auth.currentUser!.uid)
            .get();
        await query1.docs.single.reference.update({
          "chatList": [...query1.docs.single.data()["chaId"] ?? [], chatId],
        });

        QuerySnapshot<Map<String, dynamic>> query2 = await store
            .collection(UserProvider.collection)
            .where("Id", isEqualTo: userId)
            .get();
        await query2.docs.single.reference.update({
          "chatList": [...query2.docs.single.data()["chaId"] ?? [], chatId],
        });

        QuerySnapshot<Map<String, dynamic>> newChatQuery = await store
            .collection(ChatProvider.collection)
            .where("Id", isEqualTo: chatId)
            .get();

        chat?.storeId = newChatQuery.docs[0].id;

        return chatId;

      } else if (checkingQuery.docs.length == 1) {

        Map chatDataAsMap = checkingQuery.docs.single.data();
        
        chat = ChatSchema(
            activityId: chatDataAsMap["activityId"],
            createdAt: chatDataAsMap["createdAt"],
            publicKey: chatDataAsMap["publicKey"],
            users: chatDataAsMap["users"],
            Id: chatDataAsMap["Id"],
            storeId: checkingQuery.docs.single.id);

        await checkingQuery.docs.single.reference.update({
            "activityId": activityId,
        });
      }
    } catch (err) {
      print("ERRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRR");
      print(err);
      return "";
    }
    return "";
  }
}
