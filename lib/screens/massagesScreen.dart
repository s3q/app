import 'package:app/constants/constants.dart';
import 'package:app/helpers/colorsHelper.dart';
import 'package:app/helpers/userHelper.dart';
import 'package:app/providers/chatProvider.dart';
import 'package:app/providers/userProvider.dart';
import 'package:app/schemas/chatSchema.dart';
import 'package:app/schemas/massageSchema.dart';
import 'package:app/schemas/userSchema.dart';
import 'package:app/widgets/massageBoxWidget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class MassagesScreen extends StatefulWidget {
  static String router = "/massages_screen";
  const MassagesScreen({Key? key}) : super(key: key);

  @override
  State<MassagesScreen> createState() => _MassagesScreenState();
}

class _MassagesScreenState extends State<MassagesScreen> {
  final store = FirebaseFirestore.instance;
  String? massage;
  final formKey = GlobalKey<FormState>();
  final textController = TextEditingController();
  int previousVarDays = 0;
  ItemScrollController _scrollController = ItemScrollController();

  Future sendMassage(BuildContext context) async {
    ChatProvider chatProvider =
        Provider.of<ChatProvider>(context, listen: false);

    bool validate = formKey.currentState!.validate();
    if (validate) {
      formKey.currentState!.save();
      print(massage);
      print(massage != "");
      print(massage == "");
      if (massage != "") {
        await chatProvider.sendMassage(text: massage!);
      }
    }
  }

  List scrollTo(int index) {

    if (_scrollController.isAttached) {
      _scrollController.scrollTo(
          index: index, duration: const Duration(seconds: 1));
    } else {
      if (_scrollController.isAttached) {
        Future.delayed(Duration(seconds: 4), () {
          scrollTo(index);
        });
      }
    }
    return [];
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments as ChatSchema;
    UserProvider userProvider = Provider.of<UserProvider>(context);
    ChatProvider chatProvider = Provider.of<ChatProvider>(context);
    UsersHelperProvider usersHelperProvider =
        Provider.of<UsersHelperProvider>(context);

    args.users.remove(userProvider.credentialUser?.uid);
    String userId = args.users[0];
    UserSchema user = usersHelperProvider.users[userId]!;

    return FutureBuilder(
        future: usersHelperProvider.fetchUserData(userId: userId),
        builder: (BuildContext context, AsyncSnapshot<Object?> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (usersHelperProvider.users[userId] == null) {
            Navigator.pop(context);
          }

          return StreamBuilder(
              stream: store
                  .collection(ChatProvider.collection)
                  .doc(args.storeId)
                  .collection(CollectionsConstants.massages)
                  .orderBy("createdAt")
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
                if (snapshot.hasData == false) {
                  return const SizedBox();
                }
                return Scaffold(
                  appBar: AppBar(
                    backgroundColor: Colors.white,
                    elevation: 0,
                    title: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: CircleAvatar(
                            backgroundColor: Color(user.profileColor!),
                          ),
                        ),
                        Text(user.name.toString()),
                      ],
                    ),
                    leading: Row(
                      children: [
                        IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: Icon(Icons.arrow_back_rounded)),
                      ],
                    ),
                    actions: [
                      IconButton(
                          onPressed: () {},
                          icon: const Icon(Icons.mode_standby_outlined)),
                    ],
                  ),
                  body: Container(
                    color: Colors.white,
                    child: Column(
                      children: [
                        Expanded(
                            child: ScrollablePositionedList.builder( // !!!!!!!!!!!! PROBLEM !!!!!!!!!!!!!!!!
                          padding: EdgeInsets.symmetric(
                              vertical: 20, horizontal: 10),
                          itemScrollController: _scrollController,
                          itemCount: snapshot.data!.docs.length,
                          initialScrollIndex: snapshot.data!.docs.length - 1,
                          itemBuilder: (context, index) {
                            QueryDocumentSnapshot<Map<String, dynamic>>
                                massageData = snapshot.data!.docs[index];
                            MassageSchema massage = MassageSchema(
                                from: massageData.data()["from"],
                                massage: massageData.data()["massage"],
                                createdAt: massageData.data()["createdAt"],
                                readedAt: massageData.data()["readedAt"],
                                chatId: massageData.data()["chatId"]);

                            int days = DateTime.fromMillisecondsSinceEpoch(
                                    massage.createdAt)
                                .day;

                            print(days);
                            if (days != previousVarDays) {
                              previousVarDays = days;
                              print("PREEEEEEEEEEEEEEEE");
                              print(previousVarDays);

                              return Column( // !!!!!!!!!!!! PROBLEM !!!!!!!!!!!!!!!!
                                key: Key(massageData.id),
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Center(
                                    child: Text(DateFormat('dd MM yyyy').format(
                                        DateTime.fromMillisecondsSinceEpoch(
                                            massage.createdAt))),
                                  ),
                                  MassageBoxWidget(massage: massage)
                                ],
                              );
                            }

                            return MassageBoxWidget(
                                key: Key(massageData.id), massage: massage);
                          },
                        )

                            //   ListView(
                            //     controller: listViewController,
                            //     padding: EdgeInsets.symmetric(
                            //         vertical: 20, horizontal: 10),
                            //     children: [
                            //       // Text("no messages"),
                            //   ...snapshot.data?.docs
                            //           .asMap()
                            //           .map((i, e) {
                            //             MassageSchema massage = MassageSchema(
                            //                 from: e.data()["from"],
                            //                 massage: e.data()["massage"],
                            //                 createdAt: e.data()["createdAt"],
                            //                 readedAt: e.data()["readedAt"],
                            //                 chatId: e.data()["chatId"]);

                            //             int days =
                            //                 DateTime.fromMillisecondsSinceEpoch(
                            //                         massage.createdAt)
                            //                     .day;

                            //             if (days != previousVarDays) {
                            //               previousVarDays = days;

                            //               return MapEntry(
                            //                   i,
                            //                   Column(
                            //                     key: lastMassageKey,
                            //                     crossAxisAlignment:
                            //                         CrossAxisAlignment.stretch,
                            //                     children: [
                            //                       Center(
                            //                         child: Text(DateFormat(
                            //                                 'dd MM yyyy')
                            //                             .format(DateTime
                            //                                 .fromMillisecondsSinceEpoch(
                            //                                     massage
                            //                                         .createdAt))),
                            //                       ),
                            //                       MassageBoxWidget(
                            //                           massage: massage)
                            //                     ],
                            //                   ));
                            //             }

                            //             return MapEntry(1,
                            //                 MassageBoxWidget(key: lastMassageKey,massage: massage));
                            //           })
                            //           .values
                            //           .toList() ??
                            //       [],
                            //     ],
                            //   ),
                            ),
                        ...scrollTo(snapshot.data!.docs.length - 1),
                        Form(
                            key: formKey,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Stack(
                                children: [
                                  Container(
                                    width: double.infinity,
                                    height: 58,
                                    child: TextFormField(
                                      scrollPadding: EdgeInsets.all(0),
                                      controller: textController,
                                      onSaved: (t) {
                                        // setState(() {
                                        if (t?.trim() != "") {
                                          massage = t?.trim();
                                        }
                                        textController.text = "";
                                        // });
                                      },
                                      keyboardType: TextInputType.name,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium,
                                      decoration:  InputDecoration(
                                        contentPadding:
                                            EdgeInsets.only(right: 50, left: 8),

                                        hintText: " Message ...",
                                        filled: true,
                                        fillColor: ColorsHelper.whiteBlue,
                                        //   prefixIcon: Icon(
                                        //     Icons.person,
                                        //   ),
                                        focusedBorder:const OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Colors.transparent,
                                            width: 1,
                                          ),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(50)),
                                        ),
                                        enabledBorder: const OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Colors.transparent,
                                            width: 1,
                                          ),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(50)),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    right: 0.4,
                                    child: Padding(
                                      padding: const EdgeInsets.all(4),
                                      child: Container(
                                        height: 40,
                            
                                        decoration: BoxDecoration(
                                          color: ColorsHelper.yellow,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(50))
                                        ),
                                        child: IconButton(
                                    
                                            onPressed: () async {
                                              await sendMassage(context);
                                              // _scrollController.scrollTo(index: snapshot.data!.docs.length-1, duration: Duration(seconds: 1));
                                            },
                                            icon: Icon(Icons.send, size: 18,)),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ))
                      ],
                    ),
                  ),
                );
              });
        });
  }
}
