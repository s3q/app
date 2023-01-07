import 'package:app/helpers/colorsHelper.dart';
import 'package:app/providers/userProvider.dart';
import 'package:app/schemas/notificationPieceSchema.dart';
import 'package:app/widgets/SafeScreen.dart';
import 'package:app/widgets/appBarWidget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_launcher_icons/xml_templates.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class NotificationScreen extends StatefulWidget {
  static String router = "/notification";
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  List notificationList = [];

  Future getNofitication() async {
    UserProvider userProvider = Provider.of<UserProvider>(context, listen: false);

    await userProvider.fetchNotifications().then((value) => setState(() {
          notificationList = value;
        }));
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    Future.delayed(Duration.zero, () => getNofitication());
  }

  @override
  Widget build(BuildContext context) {
    UserProvider userProvider = Provider.of<UserProvider>(context);
    final auth = FirebaseAuth.instance;
    bool _isLogin = userProvider.islogin();

    return SafeScreen(
      padding: 0,
      child: Column(
        children: [
          AppBarWidget(title: "Notification"),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView.builder(
                  itemCount: notificationList.length + 1,
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      return const SizedBox(
                        height: 30,
                      );
                    }

                    return Container(
                      margin: EdgeInsets.symmetric(vertical: 10),
                      child: Column(
                        children: [
                          Text(notificationList[index].text),
                          Align(
                            alignment: Alignment.bottomRight,
                            child: Text(
                              DateFormat('MM/dd/yyyy, hh:mm a').format(
                                DateTime.fromMillisecondsSinceEpoch(
                                    notificationList[index].createdAt),
                              ),
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(color: ColorsHelper.grey),
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
            ),
          ),
        ],
      ),
    );
  }
}
