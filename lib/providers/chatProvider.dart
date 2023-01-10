import 'dart:io';
import 'package:app/constants/constants.dart';
import 'package:app/providers/userProvider.dart';
import 'package:app/schemas/chatSchema.dart';
import 'package:app/schemas/massageSchema.dart';
import 'package:app/schemas/notificationPieceSchema.dart';
import 'package:app/schemas/notificationsSchema.dart';
import 'package:app/schemas/userSchema.dart';
import 'package:app/screens/getStartedScreen.dart';
import 'package:app/widgets/DiologsWidgets.dart';
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

  Future<List> getChats(
      {required QuerySnapshot<Map<String, dynamic>> query,
      required BuildContext context}) async {
    // List users = e["users"]
    Map<String, dynamic> users = {};
    UserProvider userProvider =
        Provider.of<UserProvider>(context, listen: false);

    List<QueryDocumentSnapshot<Map<String, dynamic>>> docs =
        query.docs.toList();

    print("FFFF");

    // chats.map((c) {
    //   if (c.storeId == docs.id) {
    //     return true;
    //   }
    // });

    List doooocs = docs;

    for (var doc in docs) {
      //   users[docs[i].id] = [];

      String userId2 = (doc.data()["users"] as List)
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
          .doc(doc.id)
          .collection(CollectionsConstants.massages)
          .where("readedAt", isEqualTo: 0)
          .orderBy("createdAt")
          .get();

      MassageSchema? lastMassage;

      int lastMassageIndex = lastMassagesQuery.docs.length - 1;

      print("last index");
      print(lastMassageIndex);
      if (lastMassagesQuery.docs.isNotEmpty) {
        lastMassage = MassageSchema(
          Id: lastMassagesQuery.docs[lastMassageIndex].data()["Id"],
          url: lastMassagesQuery.docs[lastMassageIndex].data()["url"],
          imagePath:
              lastMassagesQuery.docs[lastMassageIndex].data()["imagePath"],
          type: lastMassagesQuery.docs[lastMassageIndex].data()["type"],
          audioPath:
              lastMassagesQuery.docs[lastMassageIndex].data()["audioPath"],
          chatId: lastMassagesQuery.docs[lastMassageIndex].data()["chatId"],
          massage: lastMassagesQuery.docs[lastMassageIndex].data()["massage"],
          createdAt:
              lastMassagesQuery.docs[lastMassageIndex].data()["createdAt"],
          readedAt: lastMassagesQuery.docs[lastMassageIndex].data()["readedAt"],
          from: lastMassagesQuery.docs[lastMassageIndex].data()["from"],
        );
      }
      print("Done 1");

      ChatSchema chatData = ChatSchema(
        storeId: doc.id,
        activityId: doc.data()["activityId"],
        createdAt: doc.data()["createdAt"],
        publicKey: doc.data()["publicKey"],
        users: [userId2],
        unread: doc.data()["unread"],
        massages: lastMassage != null
            ? [
                lastMassage,
              ]
            : [],
        Id: doc.data()["Id"],
      );

      print("Done 2");

      int chatIndex =
          chats.indexWhere((element) => element.storeId == chatData.storeId);

      if (chatIndex == -1) {
        if (chats
            .where((element) => element.storeId == chatData.storeId)
            .isEmpty) {
          chats.add(chatData);
          // chats.add(chatData);
        }
      } else {
        chats[chatIndex] = chatData;
      }
    }

    sortChats();

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

  Future storeWChat(BuildContext context,
      QueryDocumentSnapshot<Map<String, dynamic>> doc) async {
    UserProvider userProvider =
        Provider.of<UserProvider>(context, listen: false);

    String userId2 = (doc.data()["users"] as List)
        .singleWhere((id) => id != userProvider.currentUser!.Id);

    await userProvider.fetchUserData(userId: userId2);

    QuerySnapshot<Map<String, dynamic>> lastMassagesQuery = await store
        .collection(ChatProvider.collection)
        .doc(doc.id)
        .collection(CollectionsConstants.massages)
        .where("readedAt", isEqualTo: 0)
        .orderBy("createdAt")
        .get();

    MassageSchema? lastMassage;

    int lastMassageIndex = lastMassagesQuery.docs.length - 1;

    print("last index");
    print(lastMassageIndex);
    if (lastMassagesQuery.docs.isNotEmpty) {
      lastMassage = MassageSchema(
        url: lastMassagesQuery.docs[lastMassageIndex].data()["url"],
        Id: lastMassagesQuery.docs[lastMassageIndex].data()["Id"],
        imagePath: lastMassagesQuery.docs[lastMassageIndex].data()["imagePath"],
        type: lastMassagesQuery.docs[lastMassageIndex].data()["type"],
        audioPath: lastMassagesQuery.docs[lastMassageIndex].data()["audioPath"],
        chatId: lastMassagesQuery.docs[lastMassageIndex].data()["chatId"],
        massage: lastMassagesQuery.docs[lastMassageIndex].data()["massage"],
        createdAt: lastMassagesQuery.docs[lastMassageIndex].data()["createdAt"],
        readedAt: lastMassagesQuery.docs[lastMassageIndex].data()["readedAt"],
        from: lastMassagesQuery.docs[lastMassageIndex].data()["from"],
      );
    }
    print("Done 1");

    ChatSchema chatData = ChatSchema(
      storeId: doc.id,
      activityId: doc.data()["activityId"],
      createdAt: doc.data()["createdAt"],
      publicKey: doc.data()["publicKey"],
      users: [userId2],
      unread: doc.data()["unread"],
      massages: lastMassage != null
          ? [
              lastMassage,
            ]
          : [],
      Id: doc.data()["Id"],
    );

    print("Done 2");

    int chatIndex =
        chats.indexWhere((element) => element.storeId == chatData.storeId);

    if (chatIndex == -1) {
      if (chats
          .where((element) => element.storeId == chatData.storeId)
          .isEmpty) {
        chats.add(chatData);
        // chats.add(chatData);
      }
    } else {
      chats[chatIndex] = chatData;
    }
    sortChats();
  }

  List<ChatSchema> sortChats() {
    Map<int, ChatSchema> topChats = {};

    for (var value in chats) {
      // Rest of your code
      topChats[value.massages?.reversed.toList()[0].createdAt ??
          value.createdAt] = value;
    }

    List topChatsKeys = topChats.keys.toList();

    topChatsKeys.sort();
    chats = [];

    for (var ckey in topChatsKeys.reversed) {
      if (topChats[ckey] != null) {
        chats.add(topChats[ckey]!);
      }
    }
    print("Sort Done");
    print(chats);

    return chats;
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

    chats = query2.docs
        .map((e) => ChatSchema(
              storeId: e.id,
              activityId: e["activityId"],
              createdAt: e["createdAt"],
              publicKey: e["publicKey"],
              users: e["users"],
              Id: e["Id"],
              unread: e["unread"],
            ))
        .toList();
  }

  Future<ChatSchema?> fetchChat(String chatId) async {}

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
                url: e["url"],
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

        chat = chat;

        return chat;
      }
    } catch (err) {
      print("ERRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRROOOOORRRRRRRRR 97483");

      return null;
    }

    return null;
  }

  Future<MassageSchema?> sendImageMessage({required String imagePath}) async {
    try {
      assert(chat != null);
      assert(chat!.storeId != null);
      assert(imagePath.trim() != "");

      //   QuerySnapshot<Map<String, dynamic>> query1 =
      CollectionReference<Map<String, dynamic>> query1 = store
          .collection(ChatProvider.collection)
          .doc(chat!.storeId!)
          .collection(CollectionsConstants.massages);
      String storePath =
          "${ChatProvider.collection}/${auth.currentUser!.uid}/uploadedImages/${Uuid().v4()}.jpg";
      final storageRef = FirebaseStorage.instance.ref(storePath);
      File file = File(imagePath);
      return await storageRef
          .putFile(file)
          .then<MassageSchema>((taskSnapshot) async {
        String downloadPath = await taskSnapshot.ref.getDownloadURL();

        MassageSchema massage = MassageSchema(
          Id: Uuid().v4(),
          type: "image",
          from: auth.currentUser!.uid,
          imagePath: downloadPath.trim(),
          createdAt: DateTime.now().millisecondsSinceEpoch,
          readedAt: 0,
          chatId: chat!.Id,
          url: "",
        );

        //   DocumentReference<Map<String, dynamic>> docRef =
        await query1.add(massage.toMap());

        return massage;
      });
    } catch (err) {
      return null;
    }
  }

  Future newMassage({required context, required String toUserId}) async {
    UserProvider userProvider = Provider.of(context, listen: false);

    DocumentSnapshot<Map<String, dynamic>> query1 = await store
        .collection(ChatProvider.collection)
        .doc(chat!.storeId!)
        .get();

    if (!query1.data()?["unread"].contains(toUserId)) {
      await query1.reference.update({
        "unread": [...query1.data()?["unread"], toUserId],
      });

      chat?.unread.add(toUserId);
    }
  }

  Future readMessages({
    required context,
  }) async {
    UserProvider userProvider = Provider.of(context, listen: false);
    ChatProvider chatProvider =
        Provider.of<ChatProvider>(context, listen: false);

    DocumentSnapshot<Map<String, dynamic>> query1 = await store
        .collection(ChatProvider.collection)
        .doc(chat!.storeId!)
        .get();
    List unread = query1.data()?["unread"] as List;
    if (unread.contains(userProvider.currentUser?.Id)) {
      await query1.reference.update({
        "unread": unread.map((e) => e != userProvider.currentUser?.Id).toList(),
      });

      chat?.unread =
          unread.map((e) => e != userProvider.currentUser?.Id).toList();
    }
  }

  Future<MassageSchema?> sendMassage({
    required context,
    required String text,
  }) async {
    try {
      assert(chat != null);
      assert(chat!.storeId != null);
      assert(text.trim() != "");

      UserProvider userProvider = Provider.of(context, listen: false);
      ChatProvider chatProvider =
          Provider.of<ChatProvider>(context, listen: false);

      String? toUserId = chatProvider.chat?.users
          .singleWhere((e) => e != userProvider.currentUser!.Id);

      //   QuerySnapshot<Map<String, dynamic>> query1 =
      CollectionReference<Map<String, dynamic>> query1 = store
          .collection(ChatProvider.collection)
          .doc(chat!.storeId!)
          .collection(CollectionsConstants.massages);

      MassageSchema massage = MassageSchema(
        Id: Uuid().v4(),
        type: "text",
        url: "",
        from: auth.currentUser!.uid,
        massage: text.trim(),
        createdAt: DateTime.now().millisecondsSinceEpoch,
        readedAt: 0,
        chatId: chat!.Id,
      );

      //   DocumentReference<Map<String, dynamic>> docRef =
      await query1.add(massage.toMap());

      //   DocumentSnapshot<Map<String, dynamic>> query3 = await store
      //       .collection(ChatProvider.collection)
      //       .doc(chat!.storeId!)
      //       .get();

      //   chats[chats.indexWhere((element) => element.Id == query3.data()?["Id"])] = ChatSchema(createdAt: createdAt, publicKey: publicKey, users: users, Id: Id, activityId: activityId, unread: unread);
      if (toUserId != null && toUserId != "") {
        print("STAGE 1");
        CollectionReference<Map<String, dynamic>> query2 = store
            .collection(CollectionsConstants.notifications)
            .doc(toUserId)
            .collection("chat");
        print("STAGE 2");

        print(toUserId);

        NotificationPieceSchema notificationSchema = NotificationPieceSchema(
          notificationId: Uuid().v4(),
          data: {
            "chatId": chat?.Id,
            "userId": toUserId,
          },
          createdAt: DateTime.now().millisecondsSinceEpoch,
          title: userProvider.currentUser!.name.toString(),
          text:
              "${text.trim().length <= 40 ? text.trim() : text.trim().substring(0, 40).toString()}",
        );

        //   if (query2.data() == null) {
        //     await query2.reference.set(NotificationsSchema(
        //         important: [notificationSchema], medium: [], low: []).asMap());
        //   } else {
        //     await query2.reference.update({
        //       "important": [...query2.data()?["important"]]
        //     });
        //   }

        print(notificationSchema.toMap());

        query2.add(notificationSchema.toMap());
        print("STAGE 3");

        await newMassage(context: context, toUserId: toUserId);
      }

      return massage;
    } catch (err) {
      return null;
    }
  }

  
  Future<MassageSchema?> sendMassageNewActivitySelected({
    required context,
    required String text,
    required String activityTitle,
  }) async {
    try {
      assert(chat != null);
      assert(chat!.storeId != null);
      assert(text.trim() != "");

      UserProvider userProvider = Provider.of(context, listen: false);
      ChatProvider chatProvider =
          Provider.of<ChatProvider>(context, listen: false);

      String? toUserId = chatProvider.chat?.users
          .singleWhere((e) => e != userProvider.currentUser!.Id);

      //   QuerySnapshot<Map<String, dynamic>> query1 =
      CollectionReference<Map<String, dynamic>> query1 = store
          .collection(ChatProvider.collection)
          .doc(chat!.storeId!)
          .collection(CollectionsConstants.massages);

      MassageSchema massage = MassageSchema(
        Id: Uuid().v4(),
        type: "activity",
        url: activityTitle,
        from: auth.currentUser!.uid,
        massage: text.trim(),
        createdAt: DateTime.now().millisecondsSinceEpoch,
        readedAt: 0,
        chatId: chat!.Id,
      );

      //   DocumentReference<Map<String, dynamic>> docRef =
      await query1.add(massage.toMap());

      //   DocumentSnapshot<Map<String, dynamic>> query3 = await store
      //       .collection(ChatProvider.collection)
      //       .doc(chat!.storeId!)
      //       .get();

      //   chats[chats.indexWhere((element) => element.Id == query3.data()?["Id"])] = ChatSchema(createdAt: createdAt, publicKey: publicKey, users: users, Id: Id, activityId: activityId, unread: unread);
      if (toUserId != null && toUserId != "") {
        print("STAGE 1");
        CollectionReference<Map<String, dynamic>> query2 = store
            .collection(CollectionsConstants.notifications)
            .doc(toUserId)
            .collection("chat");
        print("STAGE 2");

        print(toUserId);

        NotificationPieceSchema notificationSchema = NotificationPieceSchema(
          notificationId: Uuid().v4(),
          data: {
            "chatId": chat?.Id,
            "userId": toUserId,
          },
          createdAt: DateTime.now().millisecondsSinceEpoch,
          title: userProvider.currentUser!.name.toString(),
          text:
              "${text.trim().length <= 40 ? text.trim() : text.trim().substring(0, 40).toString()}",
        );

        //   if (query2.data() == null) {
        //     await query2.reference.set(NotificationsSchema(
        //         important: [notificationSchema], medium: [], low: []).asMap());
        //   } else {
        //     await query2.reference.update({
        //       "important": [...query2.data()?["important"]]
        //     });
        //   }

        print(notificationSchema.toMap());

        query2.add(notificationSchema.toMap());
        print("STAGE 3");

        await newMassage(context: context, toUserId: toUserId);
      }

      return massage;
    } catch (err) {
      return null;
    }
  }

  Future<bool> deleteChat({
    required context,
    required String chatId,
    required String credentialUserId,
  }) async {
    try {
      await store.collection(ChatProvider.collection).doc(chatId).delete();

      UserProvider userProvider =
          Provider.of<UserProvider>(context, listen: false);

      DocumentSnapshot<Map<String, dynamic>> query = await store
          .collection(UserProvider.collection)
          .doc(userProvider.currentUser?.storeId)
          .get();

      query.reference.update({
        "chatList":
            (query.data()?["chaId"] as List).map((e) => e != chatId).toList(),
      });
    } catch (err) {
      return false;
    }
    return true;
  }

  Future<bool> deleteChatOneSide({
    required BuildContext context,
    required String chatId,
    required String chatStoreId,

    // required String credentialUserId,
  }) async {
    try {
      UserProvider userProvider =
          Provider.of<UserProvider>(context, listen: false);
      //   await store.collection(ChatProvider.collection).doc("/$chatId").delete();
      DocumentSnapshot<Map<String, dynamic>> query = await store
          .collection(UserProvider.collection)
          .doc(userProvider.currentUser?.storeId)
          .get();

      DocumentSnapshot<Map<String, dynamic>> query2 = await store
          .collection(ChatProvider.collection)
          .doc(chatStoreId)
          .get();
      List chatList = query.data()?["chatList"];
      List users = query2.data()?["users"];
      //   await store.collection(ChatProvider.collection).doc(chatId).delete();
      chatList.removeWhere((e) => e == chatId);

      await query.reference.update({
        "chatList": chatList,
      });

      users.removeWhere((e) => e == userProvider.currentUser?.Id);

      await query2.reference.update({
        "users": users,
      });

      if (chat?.Id == chatId) {
        // chat?.users = (query.data()?["users"] as List).map((e) {
        //   if (e != userProvider.currentUser?.Id) {
        //     return e;
        //   }
        // }).toList();
        chat = null;
      }
      chats.removeWhere((e) => e.Id == chatId);

      userProvider.currentUser?.chatList = chatList;

      return true;
    } catch (err) {
      print(err);
      return false;
    }
  }

  Future<bool> addChat({
    // required String credentialUserId,
    required BuildContext context,
    required String userId,
    required String activityId,
  }) async {
    try {
      if (auth.currentUser == null) {
        // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        //   //   backgroundColor: Theme.of(context).errorColor,
        //   content: const Text("you havn't logned "),
        //   action: SnackBarAction(
        //     onPressed: () async {
        //       await Navigator.of(context).pushNamed(GetStartedScreen.router);
        //     },
        //     label: "login",
        //   ),
        // ));
        // return "";
        DialogWidgets.mustSginin(context);
        return false;
      }
      assert(auth.currentUser!.uid != userId);

      List checkChat = chats
          .where((e) =>
              e.users.contains(auth.currentUser!.uid) &&
              e.users.contains(userId))
          .toList();

      if (checkChat.length > 1) {
// ! error
      }
      if (checkChat.length == 1) {
        chat = checkChat[0];
        checkChat[0].activityId = activityId;
        chat?.activityId = activityId;
        await store
            .collection(ChatProvider.collection)
            .doc(chat?.storeId)
            .update({
          "activityId": activityId,
        });

        return true;
      }
      QuerySnapshot<Map<String, dynamic>> query0 = await store
          .collection(ChatProvider.collection)
          .where("users", arrayContains: [auth.currentUser!.uid]).get();

      await getChats(query: query0, context: context);

      QuerySnapshot<Map<String, dynamic>> checkingQuery = await store
          .collection(ChatProvider.collection)
          .where("users", isEqualTo: [auth.currentUser!.uid, userId]).get();
      if (checkingQuery.docs.isEmpty) {
        checkingQuery = await store
            .collection(ChatProvider.collection)
            .where("users", isEqualTo: [userId, auth.currentUser!.uid]).get();
      }
      /* ####################  add users to temporary storage #################### */

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
      print(checkingQuery.docs);
      print(".....");
      if (checkingQuery.docs.isEmpty) {
        String chatId = Uuid().v4();
        //   String storeId = Uuid().v4();
        chat = ChatSchema(
          unread: [],
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

        return true;
      } else if (checkingQuery.docs.length == 1) {
        Map chatDataAsMap = checkingQuery.docs.single.data();

        chat = ChatSchema(
            unread: chatDataAsMap["unread"],
            activityId: activityId,
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
      return false;
    }
    return true;
  }
}
