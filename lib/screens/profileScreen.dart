import 'package:app/providers/userProvider.dart';
import 'package:app/screens/editProfileScreen.dart';
import 'package:app/screens/getStartedScreen.dart';
import 'package:app/screens/proAccount/switchToProAccountScreen.dart';
import 'package:app/widgets/LinkWidget.dart';
import 'package:app/widgets/SafeScreen.dart';
import 'package:app/widgets/listTitleWidget.dart';
import "package:flutter/material.dart";
import 'package:provider/provider.dart';

class ProfileScreen extends StatelessWidget {
  static String router = "/profile";
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    UserProvider userProvider = Provider.of<UserProvider>(context);
    bool _isLogin = userProvider.islogin();
    return SafeScreen(
        padding: 0,
        child: SizedBox.expand(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                  child: Row(
                    children: [
                      IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: const Icon(
                            Icons.arrow_back_rounded,
                            size: 28,
                          )),
                      Text(
                        "Profile",
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                Padding(
                  padding: const EdgeInsets.all(18),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CircleAvatar(
                            child: Icon(
                              Icons.person,
                              size: 50,
                            ),
                            backgroundColor: Color(
                                userProvider.currentUser?.profileColor ??
                                    0xFFFFE082),
                            radius: 40,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          _isLogin
                              ? Text(
                                  userProvider.currentUser?.name ?? "",
                                  style: Theme.of(context).textTheme.titleSmall,
                                )
                              : SizedBox(),
                        ],
                      ),
                      _isLogin
                          ? LinkWidget(
                              text: "Edit profile",
                              onPressed: () {
                                Navigator.pushNamed(
                                    context, EditProfileScreen.router);
                              })
                          : ElevatedButton(
                              onPressed: () {
                                Navigator.pushNamed(
                                    context, GetStartedScreen.router);
                              },
                              child: Text("Login"))
                    ],
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Text(
                    "Account Settings",
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                _isLogin
                    ? ListTitleWidget(
                        title: "Switch to Professional Account",
                        icon: Icons.local_police_rounded,
                        onTap: () {
                          Navigator.pushNamed(
                              context, SwitchToProAccountScreen.router);
                        },
                      )
                    : SizedBox(),
                ListTitleWidget(
                  title: "Language",
                  icon: Icons.language,
                  onTap: () {},
                ),
                ListTitleWidget(
                    title: "Notification",
                    icon: Icons.notifications_active_outlined,
                    onTap: () {}),
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Text(
                    "Support",
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                ListTitleWidget(
                    title: "How Oman Trippoint works",
                    icon: Icons.work_outline_rounded,
                    onTap: () {}),
                ListTitleWidget(
                    title: "Get Help",
                    icon: Icons.help_outline_rounded,
                    onTap: () {}),
                ListTitleWidget(
                    title: "Contact us",
                    icon: Icons.contact_support_outlined,
                    onTap: () {}),
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Text(
                    "Legal",
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                ListTitleWidget(
                    title: "Privacy Policy",
                    icon: Icons.help_outline_rounded,
                    onTap: () {}),
                ListTitleWidget(
                    title: "Terms of Service",
                    icon: Icons.contact_support_outlined,
                    onTap: () {}),
                SizedBox(
                  height: 40,
                ),
                LinkWidget(text: "Log out", onPressed: () {})
              ],
            ),
          ),
        ));
  }
}
