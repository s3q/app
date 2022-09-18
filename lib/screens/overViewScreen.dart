import 'dart:ui';

import 'package:app/helpers/colorsHelper.dart';
import 'package:app/providers/settingsProvider.dart';
import 'package:app/screens/getStartedScreen.dart';
import 'package:app/screens/signinScreen.dart';
import 'package:app/widgets/LinkWidget.dart';
import 'package:app/widgets/SafeScreen.dart';
import "package:flutter/material.dart";
import "package:localization/localization.dart";
import 'package:provider/provider.dart';
import "package:easy_localization/easy_localization.dart";

class OverviewScreen extends StatefulWidget {
  static String router = "/overview";
  const OverviewScreen({Key? key}) : super(key: key);

  @override
  State<OverviewScreen> createState() => _OverviewScreenState();
}

class _OverviewScreenState extends State<OverviewScreen> {
  int indexOverView = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final settingsProvider = Provider.of<SettingsProvider>(context);
    List overViewDescription = [
      // 1
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "overviewHeader1".tr(),
            style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                  color: Colors.white,
                ),
          ),
          SizedBox(
            height: 100,
          ),
          Text(
            "overviewText1".tr(),
            style: TextStyle(
              color: Colors.white,
              fontSize: Theme.of(context).textTheme.headlineMedium!.fontSize,
            ),
          ),
        ],
      ),

      //2
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 20,
          ),
          Text(
            "overviewHeader2".tr(),
            style: TextStyle(
              color: Colors.white,
              fontSize: Theme.of(context).textTheme.headlineMedium!.fontSize,
            ),
          ),
        ],
      ),
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 20,
          ),
          Text(
            "overviewHeader3".tr(),
            style: TextStyle(
              color: Colors.white,
              fontSize: Theme.of(context).textTheme.headlineMedium!.fontSize,
            ),
          ),
        ],
      ),
    ];

    List imagesPath = [
      "assets/images/overview1.jpeg",
      "assets/images/overview2.jpeg",
      "assets/images/overview3.jpeg",
    ];

    print("build");

    return SafeScreen(
      padding: 0,
      child: Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.black38,
          image: DecorationImage(
            // opacity: 0.6,
            colorFilter: ColorFilter.mode(Colors.black45, BlendMode.color),
            image: AssetImage(imagesPath[indexOverView]),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                children: [
                  Row(
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          settingsProvider.update(
                              "language", const Locale("en"));
                          context.setLocale(const Locale("en"));
                        },
                        style: ElevatedButton.styleFrom(
                          shape: context.locale.toString() == "en"
                              ? const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(24),
                                    bottomRight: Radius.circular(0),
                                    topLeft: Radius.circular(24),
                                    topRight: Radius.circular(0),
                                  ),
                                )
                              : const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(0),
                                    bottomRight: Radius.circular(24),
                                    topLeft: Radius.circular(0),
                                    topRight: Radius.circular(24),
                                  ),
                                ),
                        ),
                        child: const Text("English"),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          settingsProvider.update("language", Locale("ar"));
                          context.setLocale(Locale("ar"));
                        },
                        style: ElevatedButton.styleFrom(
                          primary: ColorsHelper.red,
                          shape: context.locale.toString() == "ar"
                              ? const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(24),
                                    bottomRight: Radius.circular(0),
                                    topLeft: Radius.circular(24),
                                    topRight: Radius.circular(0),
                                  ),
                                )
                              : const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(0),
                                    bottomRight: Radius.circular(24),
                                    topLeft: Radius.circular(0),
                                    topRight: Radius.circular(24),
                                  ),
                                ),
                        ),
                        child: const Text("Arabic"),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 100,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: AnimatedOpacity(
                        opacity: 1,
                        duration: const Duration(microseconds: 1000),
                        child: overViewDescription[indexOverView]),
                  )
                ],
              ),
            ),
            Column(
              children: [
                ElevatedButton(
                  onPressed: () {
                    if (indexOverView != 2) {
                      setState(() {
                        indexOverView += 1;
                      });
                    } else {
                      Navigator.of(context)
                          .pushReplacementNamed(GetStartedScreen.router);
                    }
                  },
                  style: ButtonStyle(
                    padding: MaterialStateProperty.all(
                      const EdgeInsets.symmetric(horizontal: 80, vertical: 20),
                    ),
                  ),
                  child: indexOverView == 2

                      /// !!!!!!!!!!!!!!!!!!!
                      ? const Text(
                          "Get Started",
                          style: TextStyle(fontSize: 18),
                        )
                      : Text(
                          "Next",
                          style: TextStyle(fontSize: 18),
                        ),
                ),
                LinkWidget(
                    color: Colors.white,
                    text: "sign up or login",
                    onPressed: () {
                      Navigator.pushNamed(context, GetStartedScreen.router);
                    }),
              ],
            ),
            SizedBox(
              height: 30,
            ),
          ],
        ),
      ),
    );
  }
}
