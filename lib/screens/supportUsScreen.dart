import 'package:app/helpers/adHelper.dart';
import 'package:app/helpers/appHelper.dart';
import 'package:app/widgets/SafeScreen.dart';
import 'package:app/widgets/appBarWidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class SupportUsScreen extends StatefulWidget {
  static String router = "/support_us";

  const SupportUsScreen({super.key});

  @override
  State<SupportUsScreen> createState() => _SupportUsScreenState();
}

class _SupportUsScreenState extends State<SupportUsScreen> {
  BannerAd? _bannerAd;
  RewardedAd? _rewardedAd;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    BannerAd(
      adUnitId: AdHelper.bannerAdUnitId,
      request: AdRequest(),
 size: AdSize.fullBanner,
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          setState(() {
            _bannerAd = ad as BannerAd;
          });
        },
        onAdFailedToLoad: (ad, err) {
          print('Failed to load a banner ad: ${err.message}');
          ad.dispose();
        },
      ),
    ).load();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _bannerAd?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeScreen(
        padding: 0,
        child: Column(children: [
          AppBarWidget(title: "Support Us"),
          Expanded(
              child: ListView(children: [
            SizedBox(
              height: 30,
            ),
            Padding(
                padding: const EdgeInsets.all(18),
                child: Column(
                  children: [
                    Text(
                        "You can support us by share our apps in deffrent social media platforms and then we appreciate Your foce"),
                    SizedBox(
                      height: 20,
                    ),
                    ElevatedButton.icon(
                        onPressed: () async {
                          EasyLoading.show();
                          String url = await AppHelper.buildDynamicLink(
                              title: 'Trippoint Oman || عمان', Id: "app");
                          await FlutterShare.share(
                            title: 'Trippoint Oman || عمان',
                            // text: args.title,
                            linkUrl: url,
                          );

                          EasyLoading.dismiss();
                        },
                        icon: Icon(Icons.emoji_events),
                        label: Text("Share our app")),
                    SizedBox(
                      height: 20,
                    ),
                    //^---------------------- adverticment -----------------------

                    if (_bannerAd != null)
                      Container(
                        width: _bannerAd!.size.width.toDouble(),
                        height: _bannerAd!.size.height.toDouble(),
                        child: AdWidget(ad: _bannerAd!),
                      ),

                    //^----------------------------------------------------------
                  ],
                ))
          ]))
        ]));
  }
}
