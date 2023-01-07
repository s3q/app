import 'package:app/helpers/colorsHelper.dart';
import 'package:app/providers/userProvider.dart';
import 'package:app/screens/accountCreatedScreen.dart';
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
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 30,
        ),
        Align(
          alignment: Alignment.center,
          child: Container(
            height: 200,
            width: 300,
            decoration: const BoxDecoration(
              //   color: Colors.grey,
              image: DecorationImage(
                image: AssetImage(
                  "assets/images/categories/final logo 2.png",
                ),
                fit: BoxFit.fitWidth,
              ),
            ),
          ),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(20),
                child: Text(
                  "welcome".tr(),
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "getStartedText1".tr(),
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          LinkWidget(
                            color: ColorsHelper.purple,
                            onPressed: () {
                              Navigator.pushNamed(
                                  context, TermsAndConditionsScreen.router);
                            },
                            text: "Terms and condition".tr(),
                          ),
                          Text(
                            "and",
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                          LinkWidget(
                              color: ColorsHelper.purple,
                              onPressed: () {
                                Navigator.pushNamed(
                                    context, PolicyAndPrivacyScreen.router);
                              },
                              text: "Policy Privacy".tr())
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          children: [
                            ElevatedButton(
                              onPressed: () async {
                                EasyLoading.show(maskType: EasyLoadingMaskType.black);
                                try {
                                  var validation = await userProvider
                                      .signInWithGoogle(context);
                                  assert(validation != false);

                                  EasyLoading.showSuccess("");

                                  Navigator.pushNamedAndRemoveUntil(
                                      context, HomeScreen.router, (route) {
                                    return false;
                                  });
                                } catch (err) {
                                  print(err);
                                  EasyLoading.showError("");
                                }
                                // await Navigator.pushReplacementNamed(
                                //     context, HomeScreen.router);
                                    await Future.delayed(Duration(milliseconds: 500));


                                EasyLoading.dismiss();
                              },
                              style: ElevatedButton.styleFrom(
                                primary: ColorsHelper.green,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 40, vertical: 15),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(50)),
                              ),
                              child: SizedBox(
                                //   width: 200,
                                child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: const [
                                      Icon(
                                        FontAwesomeIcons.google,
                                        color: Colors.white,
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Text(
                                        " Continue With Google ",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ]),
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.pushNamed(
                                    context, SigninScreen.router);
                              },
                              style: ElevatedButton.styleFrom(
                                primary: ColorsHelper.green,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 40, vertical: 15),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(50)),
                              ),
                              child: SizedBox(
                                //   width: 200,
                                child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: const [
                                      Icon(
                                        Icons.email,
                                        color: Colors.white,
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Text(
                                        " Continue With Email ",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ]),
                              ),
                            ),
                          ],
                        ),
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
              ),
            ],
          ),
        ),
        LinkWidget(
            text: "Join as Guest",
            onPressed: () {
              Navigator.pushNamedAndRemoveUntil(context, HomeScreen.router,
                  (route) {
                return false;
              });
            }),
      ],
    ));
  }
}
