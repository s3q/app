import 'dart:ui';

import 'package:app/helpers/colorsHelper.dart';
import 'package:app/providers/settingsProvider.dart';
import 'package:app/screens/getStartedScreen.dart';
import 'package:app/screens/signinScreen.dart';
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
            style: Theme.of(context).textTheme.displayMedium,
          ),
          SizedBox(
            height: 20,
          ),
          Text(
            "overviewText1".tr(),
            style: Theme.of(context).textTheme.displaySmall,
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
            style: Theme.of(context).textTheme.displayMedium,
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
            style: Theme.of(context).textTheme.displaySmall,
          ),
        ],
      ),
    ];

    print("build");

    return SafeScreen(
      child: Stack(
        alignment: AlignmentDirectional.centerStart,
        children: [
          Column(
            children: [
              Row(
                children: [
                  ElevatedButton(
                    onPressed: () {
                      settingsProvider.update("language", const Locale("en"));
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
          Positioned(
            bottom: 10,
            right: 50,
            child: Column(
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
                      const EdgeInsets.symmetric(horizontal: 60, vertical: 20),
                    ),
                  ),
                  child: indexOverView == 2
                      ? const Text("Get Started")
                      : const Text("Next"),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, GetStartedScreen.router);
                  },
                  style: TextButton.styleFrom(primary: Colors.blueGrey),
                  child: const Text("sign up or login"),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
