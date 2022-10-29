import 'package:app/providers/userProvider.dart';
import 'package:app/screens/VertifyEmailScreen.dart';
import 'package:app/screens/deleteAccountScreen.dart';
import 'package:app/screens/editProfileScreen.dart';
import 'package:app/screens/getStartedScreen.dart';
import 'package:app/screens/proAccount/switchToProAccountScreen.dart';
import 'package:app/widgets/LinkWidget.dart';
import 'package:app/widgets/SafeScreen.dart';
import 'package:app/widgets/appBarWidget.dart';
import 'package:app/widgets/listTitleWidget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import "package:flutter/material.dart";
import 'package:provider/provider.dart';

class ProfileScreen extends StatelessWidget {
  static String router = "/profile";
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    UserProvider userProvider = Provider.of<UserProvider>(context);
    final auth = FirebaseAuth.instance;
    bool _isLogin = userProvider.islogin();

    print(auth.currentUser?.emailVerified);
    return SafeScreen(
        padding: 0,
        child: Column(
          children: [
            AppBarWidget(title: "Profile"),
            Expanded(
              child: ListView(
                children: [
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
                                    style:
                                        Theme.of(context).textTheme.titleSmall,
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
                                child: const Text("Login")),
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
                  if (_isLogin && auth.currentUser?.emailVerified == false)
                    ListTitleWidget(
                      title: "Verify Email",
                      icon: Icons.verified,
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          VertifyEmailScreen.router,
                        );
                      },
                    ),
                  if (_isLogin)
                    (userProvider.currentUser?.isProAccount == false &&
                            userProvider.proCurrentUser == null
                        ? ListTitleWidget(
                            title: "Switch to Professional Account",
                            icon: Icons.local_police_rounded,
                            onTap: () {
                              Navigator.pushNamed(
                                  context, SwitchToProAccountScreen.router);
                            },
                          )
                        : ListTitleWidget(
                            title: "Edit Your Professional Account",
                            icon: Icons.local_police_rounded,
                            onTap: () {},
                          )),
                  ListTitleWidget(
                    title: "Language",
                    icon: Icons.language,
                    onTap: () {},
                  ),
                  ListTitleWidget(
                    title: "Notification",
                    icon: Icons.notifications_active_outlined,
                    onTap: () {},
                  ),
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
                  const SizedBox(
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
                  const SizedBox(
                    height: 40,
                  ),
                  if (_isLogin)
                    ListTitleWidget(
                      title: "Delete Account",
                      icon: Icons.delete_forever_rounded,
                      dang: true,
                      onTap: () {
                        Navigator.pushNamed(
                            context, DeleteAccountScreen.router);
                      },
                    ),
                  SizedBox(
                    height: 40,
                  ),
                  LinkWidget(
                    text: "Log out",
                    onPressed: () {},
                  ),
                ],
              ),
            ),
          ],
        ));
  }
}
