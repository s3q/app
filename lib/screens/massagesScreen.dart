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
      if (massage != "") {
        await chatProvider.sendMassage(context: context, text: massage!);
      }
    }
  }

  List scrollTo(int index) {
    Future.delayed(Duration.zero, () {
      _scrollController.scrollTo(
          index: index, duration: const Duration(seconds: 1));
    });
    // }
    //   if (_scrollController.isAttached) {
    // Future.delayed(Duration(seconds: 4), () {
    //   scrollTo(index);
    // });
    //   }

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

      _uploadedImagesPath.forEach((e) async {
        await chatProvider.sendImageMessage(imagePath: e);
      });
    }
  }

  void _sortMessages(BuildContext context,
      List<QueryDocumentSnapshot<Map<String, dynamic>>> docs) {
    ChatProvider chatProvider = Provider.of(context, listen: false);

    chatProvider.readMessages(context: context);
    String previousVarCreatedAtDay = "";

    docs.asMap().forEach((i, m) {
      String createdAtDay = DateFormat('dd/MM/yyyy')
          .format(DateTime.fromMillisecondsSinceEpoch(m.data()["createdAt"]));

      // print(createdAt);
      if (createdAtDay != previousVarCreatedAtDay) {
        previousVarCreatedAtDay = createdAtDay;
        massegesDateIndex.add(i);
      }
    });
  }

  Future deleteChat(String chatId) async {
    UserProvider userProvider = Provider.of<UserProvider>(context, listen: false);

    ChatProvider chatProvider = Provider.of<ChatProvider>(context , listen: false);
    await chatProvider.deleteChatOneSide( context: context,
        chatId: chatId);
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

                _sortMessages(context, snapshot.data!.docs);
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
                              chatProvider.sortChats();
                            },
                            icon: Icon(Icons.arrow_back_rounded)),
                      ],
                    ),
                    actions: [
                      DropdownButton(
                        // Initial Value
                        //   value: dropdownvalue,

                        // Down Arrow Icon
                        icon: const Icon(Icons.keyboard_arrow_down),

                        // Array list of items
                        //   items: items.map((String items) {
                        //     return DropdownMenuItem(
                        //       value: items,
                        //       child: Text(items),
                        //     );
                        //   }).toList(),
                        items: [
                          DropdownMenuItem(
                            value: 1,
                            child: TextButton.icon(
                                onPressed: () {
                                  showDialog<void>(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return SimpleDialog(
                                        title: const Text(''),
                                        children: <Widget>[
                                          SimpleDialogOption(
                                            onPressed: () async {
                                              await deleteChat(activityId);
                                            },
                                            child: const Text("Delete Chat"),
                                          ),
                                          SimpleDialogOption(
                                            onPressed: () {},
                                            //   child: const Text('Option 2'),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                                label: Text("Delete"),
                                icon: const Icon(Icons.delete_rounded)),
                          )
                        ],
                        // After selecting the desired option,it will
                        // change button value to selected value
                        onChanged: (newValue) {
                          // setState(() {
                          //   dropdownvalue = newValue!;
                          // });
                        },
                      ),
                    ],
                  ),
                  body: Container(
                    color: Colors.white,
                    child: Column(
                      children: [
                        Container(
                            color: Colors.grey[100],
                            child: ListTile(
                              onTap: () {
                                Navigator.pushNamed(
                                    context, ActivityDetailsScreen.router,
                                    arguments: activityProvider
                                        .activities[activityId]);
                              },
                              leading: Container(
                                clipBehavior: Clip.antiAliasWithSaveLayer,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: ColorsHelper.grey),
                                width: 100,
                                height: 100,
                                child: Image.network(
                                  activityProvider.mainDisplayImage(activityProvider.activities[activityId]?.images ?? [])
                                    ,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              title: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    activityProvider
                                        .activities[activityId]!.title,
                                    style:
                                        Theme.of(context).textTheme.titleMedium,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Text(
                                    activityProvider
                                        .activities[activityId]!.category,
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleSmall!
                                        .copyWith(color: ColorsHelper.grey),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            )),
                        Expanded(
                            child: ScrollablePositionedList.builder(
                          // !!!!!!!!!!!! PROBLEM !!!!!!!!!!!!!!!!

                          padding: const EdgeInsets.symmetric(
                              vertical: 20, horizontal: 10),
                          itemScrollController: _scrollController,
                          itemCount: snapshot.data!.docs.length,
                          initialScrollIndex: snapshot.data!.docs.length - 1 < 0
                              ? snapshot.data!.docs.length - 1
                              : 0,
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
                                  SizedBox(
                                    height: 15,
                                  ),
                                  Center(
                                    child: Text(DateFormat('dd/MM/yyyy').format(
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
                                    height: 60,
                                    child: SizedBox.expand(
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
                                          contentPadding: EdgeInsets.only(
                                              right: 50, left: 8),

                                          hintText: " Message ...",
                                          filled: true,
                                          fillColor: ColorsHelper.whiteBlue,
                                          //   prefixIcon: Icon(
                                          //     Icons.person,
                                          //   ),
                                          enabledBorder:
                                              const OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Colors.white,
                                              width: 1,
                                            ),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(16)),
                                          ),
                                          focusedBorder:
                                              const OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Colors.white,
                                              width: 1,
                                            ),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(16)),
                                          ),
                                          border: const OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Colors.white,
                                              width: 1,
                                            ),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(16)),
                                          ),
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
                                            // margin: const EdgeInsets.symmetric(
                                            //     horizontal: 5),
                                            decoration: BoxDecoration(
                                                color: ColorsHelper.grey,
                                                borderRadius:
                                                    const BorderRadius.only(
                                                        topLeft:
                                                            Radius.circular(16),
                                                        bottomLeft:
                                                            Radius.circular(
                                                                16))),
                                            child: Row(
                                              children: [
                                                // IconButton(
                                                //     onPressed: () async {
                                                //       // _scrollController.scrollTo(index: snapshot.data!.docs.length-1, duration: Duration(seconds: 1));
                                                //     },
                                                //     icon: const Icon(
                                                //       Icons
                                                //           .keyboard_voice_rounded,
                                                //       size: 18,
                                                //     )),
                                                IconButton(
                                                    onPressed: () async {
                                                      await _uploadImages();
                                                      //   _scrollController.scrollTo(index: snapshot.data!.docs.length-1, duration: Duration(seconds: 1));
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
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 5),
                                            margin:
                                                const EdgeInsets.only(right: 5),
                                            decoration: BoxDecoration(
                                                color: ColorsHelper.yellow,
                                                borderRadius:
                                                    const BorderRadius.only(
                                                        topRight:
                                                            Radius.circular(16),
                                                        bottomRight:
                                                            Radius.circular(
                                                                16))),
                                            child: IconButton(
                                                onPressed: () async {
                                                  await sendMassage(context);
                                                  //   await _scrollController.scrollTo(index: snapshot.data!.docs.length-1, duration: Duration(seconds: 1));
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
