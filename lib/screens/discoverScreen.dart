import 'package:app/helpers/adHelper.dart';
import 'package:app/helpers/appHelper.dart';
import 'package:app/helpers/colorsHelper.dart';
import 'package:app/providers/activityProvider.dart';
import 'package:app/providers/userProvider.dart';
import 'package:app/schemas/activitySchema.dart';
import 'package:app/screens/activityDetailsScreen.dart';
import 'package:app/screens/addActivityScreen.dart';
import 'package:app/screens/overViewScreen.dart';
import 'package:app/screens/searchScreen.dart';
import 'package:app/widgets/DiologsWidgets.dart';
import 'package:app/widgets/activityCardWidget.dart';
import 'package:app/widgets/categoryCardWidget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import "package:flutter/material.dart";
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:url_launcher/url_launcher.dart';

class DiscoverScreen extends StatefulWidget {
  static String router = "/discover";
  const DiscoverScreen({Key? key}) : super(key: key);

  @override
  State<DiscoverScreen> createState() => _DiscoverScreenState();
}

class _DiscoverScreenState extends State<DiscoverScreen> {
  final functions = FirebaseFunctions.instance;
  PageController pageViewController = PageController(initialPage: 0);
  TextEditingController textController = TextEditingController();

  List<Widget> activitesCards = [
    SizedBox(),
  ];
  List newsList = [];
  Map<int, BannerAd> _bannersAd = {};

  Future loadActivites() async {
    ActivityProvider activityProvider =
        Provider.of<ActivityProvider>(context, listen: false);

    await activityProvider.topActivitesFillter().then((snapshot) {
      List<ActivitySchema> data = snapshot as List<ActivitySchema>;

      setState(() {
        activitesCards.addAll(data.map((d) {
          return ActivityCardWidget(
              activity: d,
              onPressed: () {
                Navigator.pushNamed(
                  context,
                  ActivityDetailsScreen.router,
                  arguments: d,
                );
              });
        }).toList());
      });
    });
  }

  @override
  void initState() {
    // TODO: implement initState<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION"/>

    super.initState();
    Future.delayed(Duration.zero, () async {
      loadActivites();
    });
    Future.delayed(Duration.zero, () async {
      QuerySnapshot<Map<String, dynamic>> query1 =
          await FirebaseFirestore.instance.collection("news").get();
      for (var doc in query1.docs) {
        newsList.add({
          "image": doc["image"],
          "url": doc["url"],
        });
      }
    });

    BannerAd(
      adUnitId: AdHelper.bannerAdUnitId,
      request: AdRequest(),
      size: AdSize.fullBanner,
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          setState(() {
            _bannersAd[0] = ad as BannerAd;
          });
        },
        onAdFailedToLoad: (ad, err) {
          print('Failed to load a banner ad: ${err.message}');
          ad.dispose();
        },
      ),
    ).load();

    BannerAd(
      adUnitId: AdHelper.bannerAdUnitId,
      request: AdRequest(),
size: AdSize.fullBanner,
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          setState(() {
            _bannersAd[1] = (ad as BannerAd);
          });
        },
        onAdFailedToLoad: (ad, err) {
          print('Failed to load a banner ad: ${err.message}');
          ad.dispose();
        },
      ),
    ).load();
    // Banner1.load();

//  WidgetsBinding.instance
//         .addPostFrameCallback((_) => loadActivites());

    // await loadActivites();

    // loadActivites();
    // FirebaseFunctions.instance
    //     .httpsCallable("topActivitesFillter")
    //     .call()
    //     .then((value) => print((value.data as List)[0]));
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();

    _bannersAd[0]?.dispose();
    _bannersAd[1]?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    UserProvider userProvider = Provider.of<UserProvider>(context);
    ActivityProvider activityProvider = Provider.of<ActivityProvider>(context);

    // final AdWidget adWidget = AdWidget(ad: Banner1);

//     final Container adContainer = Container(
//   alignment: Alignment.center,
//   child: adWidget,
//   width: Banner1.size.width.toDouble(),
//   height: Banner1.size.height.toDouble(),
// );

    return ListView(
      children: [
        //   Text(userProvider.currentUser["email"]),
        //   Text(userProvider.currentUser["name"]),
        //   Text(DateTime.fromMillisecondsSinceEpoch(
        //           (userProvider.currentUser["lastLogin"] as int))
        //       .toString()),

        Container(
          width: MediaQuery.of(context).size.width,
          height: 250,
          child: Stack(
            alignment: Alignment.topCenter,
            children: [
              Container(
                padding: EdgeInsets.only(bottom: 30),
                decoration: BoxDecoration(
                  color: Colors.white,
                  //   boxShadow: const [
                  //     BoxShadow(
                  //       blurRadius: 4,
                  //       color: Color(0x33000000),
                  //       offset: Offset(0, 2),
                  //     )
                  //   ],
                  borderRadius: BorderRadius.circular(0),
                ),
                child: Stack(
                  children: [
                    PageView(
                      controller: pageViewController,
                      scrollDirection: Axis.horizontal,
                      children: [
                        Image.asset(
                          'assets/images/categories/discover_all.jpg',
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                        ),
                        ...newsList
                            .map((e) => InkWell(
                                  onTap: () {
                                    final Uri _url = Uri.parse(e["url"]);
                                    // ' https://wa.me/${activitySchema.phoneNumberWhatsapp}?text=Hello');
                                    launchUrl(_url,
                                        mode: LaunchMode
                                            .externalNonBrowserApplication);
                                  },
                                  child: Image.asset(
                                    e["image"],
                                    width: 100,
                                    height: 100,
                                    fit: BoxFit.cover,
                                  ),
                                ))
                            .toList(),
                        // Image.network(
                        //   'https://picsum.photos/seed/248/600',
                        //   width: 100,
                        //   height: 100,
                        //   fit: BoxFit.cover,
                        // ),
                        // Image.network(
                        //   'https://picsum.photos/seed/656/600',
                        //   width: 100,
                        //   height: 100,
                        //   fit: BoxFit.cover,
                        // ),
                      ],
                    ),
                    Align(
                      alignment: AlignmentDirectional(0, -.7),
                      child: Container(
                        height: 120,
                        width: MediaQuery.of(context).size.width,
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 30),
                                child: Text(
                                  "Explore",
                                  style: Theme.of(context).textTheme.titleLarge,
                                ),
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  ElevatedButton.icon(
                                      onPressed: () {
                                        Navigator.pushNamed(
                                            context, SearchScreen.router);
                                      },
                                      icon: Icon(Icons.local_activity_rounded),
                                      label: Text("Activity")),
                                  ElevatedButton.icon(
                                      onPressed: () {},
                                      icon: Icon(Icons.home_filled),
                                      label: Text("Chalets")),
                                ],
                              )
                            ]),
                      ),
                    ),
                    Align(
                      alignment: AlignmentDirectional(.8, -.9),
                      child: SmoothPageIndicator(
                        controller: pageViewController,
                        count: 3,
                        axisDirection: Axis.horizontal,
                        onDotClicked: (i) {
                          pageViewController.animateToPage(
                            i,
                            duration: const Duration(milliseconds: 500),
                            curve: Curves.ease,
                          );
                        },
                        effect: const ExpandingDotsEffect(
                          expansionFactor: 1.5,
                          spacing: 6,
                          radius: 16,
                          dotWidth: 12,
                          dotHeight: 12,
                          dotColor: Color(0xFF9E9E9E),
                          activeDotColor: Colors.black54,
                          paintStyle: PaintingStyle.fill,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Align(
                alignment: AlignmentDirectional(0, 1),
                child: Container(
                  width: 300,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: const [
                      BoxShadow(
                        blurRadius: 6,
                        color: Color(0x33000000),
                        offset: Offset(1, 1),
                      )
                    ],
                  ),
                  child: InkWell(
                    onTap: () async {
                      await Navigator.pushNamed(context, SearchScreen.router,
                          );
                    },
                    focusColor: Colors.white12,
                    child: Hero(
                      tag: "search_box1",
                      child: Container(
                        // height: 50,
                        padding:
                            EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black45, width: 1),
                          borderRadius: BorderRadius.circular(16),
                          color: Colors.white,
                        ),
                        child: Row(children: [
                          Icon(
                            Icons.search_rounded,
                            size: 30,
                            color: Colors.black45,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text("Where to go?",
                              style: TextStyle(
                                  fontSize: Theme.of(context)
                                      .textTheme
                                      .titleMedium!
                                      .fontSize,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black54)),
                        ]),
                      ),
                    ),
                  ),
                  // child: TextFormField(
                  //   controller: textController,
                  //   obscureText: false,
                  //   decoration: InputDecoration(
                  //     hintText: 'Where to go?',
                  //     fillColor: Colors.white,
                  //     enabledBorder: UnderlineInputBorder(
                  //       borderSide: BorderSide(
                  //         color: Colors.black45,
                  //         width: 1,
                  //       ),
                  //       borderRadius: BorderRadius.circular(24),
                  //     ),
                  //     focusedBorder: UnderlineInputBorder(
                  //       borderSide: BorderSide(
                  //         color: Colors.black45,
                  //         width: 1,
                  //       ),
                  //       borderRadius: BorderRadius.circular(24),
                  //     ),
                  //     filled: true,
                  //     prefixIcon: Icon(
                  //       size: 30,
                  //       Icons.search,
                  //     ),
                  //   ),
                  // ),
                ),
              ),
            ],
          ),
        ),

        // ElevatedButton(
        //     onPressed: () {
        //       signout(userProvider);
        //     },
        //     child: Text("sign out")),
        // ElevatedButton(
        //     onPressed: () {
        //       Navigator.pushNamedAndRemoveUntil(
        //           context, OverviewScreen.router, (route) => false);
        //     },
        //     child: Text("sign in")),

        //^---------------------- adverticment -----------------------

        if (_bannersAd[0] != null)
          Container(
            margin: EdgeInsets.symmetric(vertical: 20),
            width: _bannersAd[0]!.size.width.toDouble(),
            height: _bannersAd[0]!.size.height.toDouble(),
            child: AdWidget(ad: _bannersAd[0]!),
          ),

        //^----------------------------------------------------------
        SizedBox(
          height: 10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: OutlinedButton.icon(
                icon: const Icon(Icons.add_rounded),
                label: const Text("Add Activity"),
                onPressed: () async {
                  if (!userProvider.islogin()) {
                    DialogWidgets.mustSginin(context);
                    return;
                  }
                  if (userProvider.islogin() &&
                      userProvider.currentUser!.isProAccount == true) {
                    Navigator.pushNamed(context, AddActivityScreen.router);
                  } else {
                    DialogWidgets.mustSwitchtoPro(context);
                  }
                },
              ),
            ),
          ],
        ),
        SizedBox(
          height: 10,
        ),

        Padding(
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 5),
          child: Text(
            'catogry'.tr(),
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Container(
            margin: EdgeInsets.symmetric(vertical: 10),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: AppHelper.categories.map((e) {
                return CategoryCardWidget(
                    imagePath: e["imagepath"],
                    title: e["title"],
                    onPressed: () async {
                      EasyLoading.show();
                      try {
                        HttpsCallableResult r = await FirebaseFunctions.instance
                            .httpsCallable("SearchForActivity")
                            .call(e["title"]);

                        List<ActivitySchema> activitiesList = [];
                        for (var activityMap in r.data) {
                          activitiesList
                              .add(ActivitySchema.toSchema(activityMap));
                        }

                        Navigator.pushNamed(context, SearchScreen.router,
                            arguments: activitiesList);
                      } catch (err) {
                        print(err);
                      }
                      EasyLoading.dismiss();
                    });
              }).toList(),
            ),
          ),
        ),
        // adContainer,
        SizedBox(
          height: 30,
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 5),
          child: Text(
            'Top things to do',
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),

        ...activitesCards,

        // ActivityCardWidget(
        //     activity: AppHelper.Activities[0],
        //     onPressed: () {
        //       Navigator.pushNamed(
        //         context,
        //         ActivityDetailsScreen.router,
        //         arguments: AppHelper.Activities[0],
        //       );
        //     }),

        SizedBox(
          height: 20,
        ),

        //^---------------------- adverticment -----------------------

        if (_bannersAd[1] != null)
          Container(
            width: _bannersAd[1]!.size.width.toDouble(),
            height: _bannersAd[1]!.size.height.toDouble(),
            child: AdWidget(ad: _bannersAd[1]!),
          ),

        //^----------------------------------------------------------

        SizedBox(
          height: 30,
        ),
      ],
    );
  }
}
