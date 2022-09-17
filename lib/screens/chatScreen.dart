import 'package:app/providers/chatProvider.dart';
import 'package:app/providers/userProvider.dart';
import 'package:app/schemas/userSchema.dart';
import 'package:app/widgets/chatBoxWidget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import "package:flutter/material.dart";
import 'package:provider/provider.dart';

class ChatScreen extends StatelessWidget {
  static String router = "/chat";
  static final store = FirebaseFirestore.instance;
  static final auth = FirebaseAuth.instance;

  const ChatScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ChatProvider chatProvider =
        Provider.of<ChatProvider>(context, listen: false);

    return Builder(builder: (context) {
      if (auth.currentUser == null) {
        return const Center(
          child: Text("You haven't login "),
        );
      }
      return StreamBuilder(
          stream: store
              .collection(ChatProvider.collection)
              .where(UserProvider.collection,
                  arrayContains: auth.currentUser!.uid)
              .snapshots(),
          builder: (BuildContext context,
              AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            return FutureBuilder(
                future: chatProvider.getChats(
                    query: snapshot.data!, context: context),
                builder: (BuildContext ctx, AsyncSnapshot<dynamic> snap) {
                  if (snap.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  if (chatProvider.chats == null) {
                    return const Center(
                      child: Text("No chats"),
                    );
                  }

                  return Padding(
                    padding: const EdgeInsets.all(10),
                    child: ListView(
                      children: [
                        Text(
                          "Chat ... ",
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        Column(
                          children: [
                            ...chatProvider.chats.map((e) {
                              print("dddddddddddddddddddddd");
                              print(e.users);
                              print(auth.currentUser);
                              String userId = e.users.singleWhere(
                                  (id) => id != auth.currentUser!.uid);

                              print(userId);

                              if (userId != null) {
                                return ChatBoxWidget(
                                  chat: e,
                                  key: Key(e.Id),
                                );
                              }
                              return const SizedBox();
                            }).toList(),
                          ],
                        ),
                      ],
                    ),
                  );
                });
          });
    });
  }
}
