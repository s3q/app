import 'package:app/providers/userProvider.dart';
import 'package:app/screens/homeScreen.dart';
import 'package:app/screens/policyAndPrivacyScreen.dart';
import 'package:app/screens/signinPhoneNumberScreen.dart';
import 'package:app/screens/signinScreen.dart';
import 'package:app/screens/termsAndConditionsScreen.dart';
import 'package:app/widgets/LinkWidget.dart';
import 'package:app/widgets/SafeScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import "package:flutter/material.dart";
import "package:easy_localization/easy_localization.dart";
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';

class GetStartedScreen extends StatelessWidget {
  static String router = "/getStarted";
  const GetStartedScreen({Key? key}) : super(key: key);

//   void loginWithGoogle() async {
//     final UserCredential googleUser = await signInWithGoogle();
//     print(googleUser.user);
//   }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);

    return SafeScreen(
        child: Column(
      children: [
        Text(
          "welcome".tr(),
          style: Theme.of(context).textTheme.headlineLarge,
        ),
        const SizedBox(
          height: 20,
        ),
        Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Text(
                "getStartedText1".tr(),
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            /*Row(
                children: [
                  LinkWidget(
                      onPressed: () {
                         Navigator.pushNamed(
                            context, TermsAndConditionsScreen.router);
                      }, text: "Terms and condition".tr()),
                  const SizedBox(
                    width: 10,
                  ),
                  Text(
                    "and",
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  LinkWidget(
                      onPressed: () {
                        Navigator.pushNamed(
                            context, PolicyAndPrivacyScreen.router);
                      },
                      text: "Policy Privacy".tr())
                ],
              ),*/
              const SizedBox(
                height: 20,
              ),
              OutlinedButton(
                onPressed: () async {
                  await userProvider.signInWithGoogle(context);
                  await Navigator.pushReplacementNamed(context, HomeScreen.router);
                },
                style: OutlinedButton.styleFrom(
                  primary: Colors.black87,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  side: const BorderSide(width: 2),
                ),
                child: const Text("Continue with Google"),
              ),
              const SizedBox(
                height: 10,
              ),
              OutlinedButton(
                onPressed: () {
                  Navigator.pushNamed(context, SigninScreen.router);
                },
                style: OutlinedButton.styleFrom(
                  primary: Colors.black87,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  side: const BorderSide(width: 2),
                ),
                child: const Text(" Continue With Email "),
              ),
          const SizedBox(
                height: 10,
              ),

              
            //   OutlinedButton(
            //     onPressed: () {
            //       Navigator.pushNamed(context, SigninPhoneNumberScreen.router);
            //     },
            //     style: OutlinedButton.styleFrom(
            //       primary: Colors.black87,
            //       padding:
            //           const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
            //       side: const BorderSide(width: 2),
            //     ),
            //     child: const Text("Continue With Phone Number"),
            //   ),
            ],
          ),
        ),
      ],
    ));
  }
}
