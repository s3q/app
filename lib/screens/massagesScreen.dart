import 'package:app/constants/constants.dart';
import 'package:app/helpers/colorsHelper.dart';
import 'package:app/providers/activityProvider.dart';
import 'package:app/providers/chatProvider.dart';
import 'package:app/providers/userProvider.dart';
import 'package:app/schemas/chatSchema.dart';
import 'package:app/schemas/massageSchema.dart';
import 'package:app/schemas/userSchema.dart';
import 'package:app/screens/activityDetailsScreen.dart';
import 'package:app/widgets/massageBoxWidget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:image_picker/image_picker.dart';
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
  ItemScrollController _scrollController = ItemScrollController();
  final ImagePicker _picker = ImagePicker();
  List<int> massegesDateIndex = [];

  List<String> _uploadedImagesPath = [];

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

  Future fetchUserAndActivityData({
    required String userId,
    required String activityId,
  }) async {
    UserProvider userProvider =
        Provider.of<UserProvider>(context, listen: false);
    ActivityProvider activityProvider =
        Provider.of<ActivityProvider>(context, listen: false);
    await userProvider.fetchUserData(userId: userId);
    await activityProvider.fetchActivityWStore(activityId);
  }

  Future _uploadImages() async {
    ChatProvider chatProvider =
        Provider.of<ChatProvider>(context, listen: false);
    final List<XFile>? images = await _picker.pickMultiImage();
    if (images != null) {
      _uploadedImagesPath.addAll(images.map((e) => e.path));

      await _uploadedImagesPath.map((e) async {
        await chatProvider.sendImageMessage(imagePath: e);
      });
    }
  }

  void _sortMessages(List<QueryDocumentSnapshot<Map<String, dynamic>>> docs) {
    int previousVarCreatedAt = 0;

    docs.asMap().forEach((i, m) {
      int createdAt = m.data()["createdAt"];

      // print(createdAt);
      if (createdAt != previousVarCreatedAt) {
        previousVarCreatedAt = createdAt;
        massegesDateIndex.add(i);
      }
    });
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
    ActivityProvider activityProvider = Provider.of<ActivityProvider>(context);

    args.users.remove(userProvider.credentialUser?.uid);
    String userId = args.users[0];
    String activityId = args.activityId;
    UserSchema user = userProvider.users[userId]!;


    return FutureBuilder(
        future:
            fetchUserAndActivityData(userId: userId, activityId: activityId),
        builder: (BuildContext context, AsyncSnapshot<Object?> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting ||
              activityProvider.activities[activityId] == null ||
              userProvider.users[userId] == null) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (userProvider.users[userId] == null) {
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
                if (snapshot.connectionState == ConnectionState.waiting ||
                    snapshot.hasData == false ||
                    snapshot.data == null) {
                  return const SizedBox();
                }

                _sortMessages(snapshot.data!.docs);
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
                        Container(
                            child: ListTile(
                          onTap: () {
                            Navigator.pushNamed(
                                context, ActivityDetailsScreen.router,
                                arguments:
                                    activityProvider.activities[activityId]);
                          },
                          leading: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: ColorsHelper.grey),
                            width: 100,
                            height: 100,
                            child: Image.network(activityProvider
                                .activities[activityId]?.images
                                .where((i) => i.toString().contains("main"))
                                .toList()[0]),
                          ),
                          title: Text(
                            activityProvider.activities[activityId]!.title,
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                        )),
                        Expanded(
                            child: ScrollablePositionedList.builder(
                          // !!!!!!!!!!!! PROBLEM !!!!!!!!!!!!!!!!

                          padding: const EdgeInsets.symmetric(
                              vertical: 20, horizontal: 10),
                          itemScrollController: _scrollController,
                          itemCount: snapshot.data!.docs.length,
                          initialScrollIndex: snapshot.data!.docs.length - 1,
                          itemBuilder: (context, index) {
                            QueryDocumentSnapshot<Map<String, dynamic>>
                                massageData = snapshot.data!.docs[index];
                            MassageSchema massage = MassageSchema(
                              type: massageData.data()["type"],
                              Id: massageData.data()["Id"],
                              audioPath: massageData.data()["audioPath"],
                              imagePath: massageData.data()["imagePath"],
                              from: massageData.data()["from"],
                              massage: massageData.data()["massage"],
                              createdAt: massageData.data()["createdAt"],
                              readedAt: massageData.data()["readedAt"],
                              chatId: massageData.data()["chatId"],
                            );

                            if (massegesDateIndex.contains(index)) {
                              return Column(
                                // !!!!!!!!!!!! PROBLEM !!!!!!!!!!!!!!!!
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
                                      decoration: InputDecoration(
                                        contentPadding:
                                            EdgeInsets.only(right: 50, left: 8),

                                        hintText: " Message ...",
                                        filled: true,
                                        fillColor: ColorsHelper.whiteBlue,
                                        //   prefixIcon: Icon(
                                        //     Icons.person,
                                        //   ),
                                        focusedBorder: const OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Colors.black45,
                                            width: 1,
                                          ),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(16)),
                                        ),

                                        border: const OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Colors.black45,
                                            width: 1,
                                          ),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(16)),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    right: 0.4,
                                    child: Padding(
                                      padding: const EdgeInsets.all(4),
                                      child: Row(
                                        children: [
                                          Container(
                                            height: 40,
                                            margin: const EdgeInsets.symmetric(
                                                horizontal: 5),
                                            decoration: BoxDecoration(
                                                color: ColorsHelper.grey,
                                                borderRadius:
                                                    const BorderRadius.all(
                                                        Radius.circular(50))),
                                            child: Row(
                                              children: [
                                                IconButton(
                                                    onPressed: () async {
                                                      // _scrollController.scrollTo(index: snapshot.data!.docs.length-1, duration: Duration(seconds: 1));
                                                    },
                                                    icon: const Icon(
                                                      Icons
                                                          .keyboard_voice_rounded,
                                                      size: 18,
                                                    )),
                                                IconButton(
                                                    onPressed: () async {
                                                      await _uploadImages();
                                                      // _scrollController.scrollTo(index: snapshot.data!.docs.length-1, duration: Duration(seconds: 1));
                                                    },
                                                    icon: const Icon(
                                                      Icons.camera_alt_rounded,
                                                      size: 18,
                                                    )),
                                              ],
                                            ),
                                          ),
                                          Container(
                                            height: 40,
                                            margin: const EdgeInsets.symmetric(
                                                horizontal: 5),
                                            decoration: BoxDecoration(
                                                color: ColorsHelper.yellow,
                                                borderRadius:
                                                    const BorderRadius.all(
                                                        Radius.circular(50))),
                                            child: IconButton(
                                                onPressed: () async {
                                                  await sendMassage(context);
                                                  // _scrollController.scrollTo(index: snapshot.data!.docs.length-1, duration: Duration(seconds: 1));
                                                },
                                                icon: const Icon(
                                                  Icons.send,
                                                  size: 18,
                                                )),
                                          ),
                                        ],
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
