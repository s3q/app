import 'package:app/helpers/adHelper.dart';
import 'package:app/helpers/appHelper.dart';
import 'package:app/helpers/colorsHelper.dart';
import 'package:app/widgets/SafeScreen.dart';
import 'package:app/widgets/appBarWidget.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactUsScreen extends StatefulWidget {
  static String router = "contact_us";
  const ContactUsScreen({super.key});

  @override
  State<ContactUsScreen> createState() => _ContactUsScreenState();
}

class _ContactUsScreenState extends State<ContactUsScreen> {
  BannerAd? _bannerAd;

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
          AppBarWidget(title: AppHelper.returnText(context, "Contact Us", "اتصل بنا")),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView(children: [
                SizedBox(
                  height: 30,
                ),
                Text(AppHelper.returnText(context, "Follow Us", "تابعنا")),
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    IconButton(
                        style: IconButton.styleFrom(backgroundColor: Colors.pink),
                        onPressed: () async {
                          final Uri _url =
                              Uri.parse('https://instagram.com/s3q.x');
                          if (await canLaunchUrl(_url)) {
                            await launchUrl(_url,
                                mode: LaunchMode.externalNonBrowserApplication);
                          } else {
                            throw 'Could not launch $_url';
                          }
                        },
                        icon: Icon(FontAwesomeIcons.instagram)),
                    IconButton(
                        style: IconButton.styleFrom(backgroundColor: Colors.blue),
                        onPressed: () {},
                        icon: Icon(FontAwesomeIcons.facebook)),
                    IconButton(
                        style: IconButton.styleFrom(backgroundColor: Colors.blue),
                        onPressed: () {},
                        icon: Icon(FontAwesomeIcons.twitter)),
                  ],
                ),
                //^---------------------- adverticment -----------------------

                if (_bannerAd != null)
                  Container(
                    width: _bannerAd!.size.width.toDouble(),
                    height: _bannerAd!.size.height.toDouble(),
                    child: AdWidget(ad: _bannerAd!),
                  ),

                //^----------------------------------------------------------
                Divider(
                  thickness: 1,
                ),
                SizedBox(
                  height: 20,
                ),
                ListTile(
                  onTap: () {},
                  title: Text(AppHelper.returnText(context, "Customers service", "خدمة العملاء")),
                  trailing: Icon(FontAwesomeIcons.whatsapp),
                ),
                ListTile(
                  onTap: () {},
                  title: Text(AppHelper.returnText(context, "Technical support", "دعم فني")),
                  trailing: Icon(FontAwesomeIcons.whatsapp),
                ),
                ListTile(
                  onTap: () {},
                  title: Text(AppHelper.returnText(context, "Complaints and suggestions", "الشكاوى والاقتراحات")),
                  trailing: Icon(FontAwesomeIcons.whatsapp),
                ),
                SizedBox(
                  height: 20,
                ),
                Divider(
                  thickness: 1,
                ),
                SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  onPressed: () async {
                    final Uri _url = Uri.parse("https://wa.me/79377174");
                    // ' https://wa.me/${activitySchema.phoneNumberWhatsapp}?text=Hello');
                    launchUrl(_url,
                        mode: LaunchMode.externalNonBrowserApplication);
//                 WhatsApp whatsapp = WhatsApp();

//                 whatsapp.messagesTemplate(
// 	to: int.tryParse(activitySchema.phoneNumberWhatsapp.toString()) ?? 0,
// 	templateName: "Hey,",

// );
                  },
                  style: ElevatedButton.styleFrom(
                    // primary: ColorsHelper.yellow,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50)),
                  ),
                  child: SizedBox(
                    //   width: 200,
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.whatsapp_rounded,
                            color: Colors.white,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            AppHelper.returnText(context, " Whatsapp ", "  واتساب "),
                            style: TextStyle(color: Colors.white),
                          ),
                        ]),
                  ),
                ),
              ]),
            ),
          )
        ]));
  }
}
