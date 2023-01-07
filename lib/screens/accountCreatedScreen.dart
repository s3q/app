import 'package:app/providers/userProvider.dart';
import 'package:app/screens/getStartedScreen.dart';
import 'package:app/screens/homeScreen.dart';
import 'package:app/widgets/SafeScreen.dart';
import 'package:app/widgets/appBarWidget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AccountCreatedScreen extends StatelessWidget {
  const AccountCreatedScreen ({super.key});

  static String router = "account_created";

  @override
  Widget build(BuildContext context) {
    UserProvider userProvider = Provider.of<UserProvider>(context);

    return SafeScreen(
        padding: 0,
        child: Column(children: [
          AppBarWidget(title: "Account Created"),
          Expanded(
              child: ListView(children: [
            const SizedBox(
              height: 30,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  "assets/images/success.png",
                  width: 100,
                  height: 100,
                ),
                SizedBox(
                  height: 20,
                ),
                Text("Your Account has been created successflly .."),
                SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamedAndRemoveUntil(
                          context, HomeScreen.router, (route) => false);
                    },
                    child: Text("Next"))
              ],
            )
          ])),
        ]));
  }
}
