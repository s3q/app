import 'dart:async';

import 'package:app/constants/constants.dart';
import 'package:app/helpers/adHelper.dart';
import 'package:app/helpers/appHelper.dart';
import 'package:app/helpers/colorsHelper.dart';
import 'package:app/providers/activityProvider.dart';
import 'package:app/providers/chatProvider.dart';
import 'package:app/providers/userProvider.dart';
import 'package:app/schemas/activitySchema.dart';
import 'package:app/schemas/userSchema.dart';
import 'package:app/screens/ContactOwnerScreen.dart';
import 'package:app/screens/massagesScreen.dart';
import 'package:app/screens/reportActivityScreen.dart';
import 'package:app/screens/sendReviewScreen.dart';
import 'package:app/screens/viewReviewsScreen.dart';
import 'package:app/widgets/DiologsWidgets.dart';
import 'package:app/widgets/LinkWidget.dart';
import 'package:app/widgets/dividerWidget.dart';
import 'package:app/widgets/googlemapDescWidget.dart';
import 'package:app/widgets/orginizerActivityBoxWidget.dart';
import 'package:app/widgets/ratingBarWidget.dart';
import 'package:app/widgets/textBoxActWidget.dart';
import 'package:app/widgets/textCardWidget.dart';
import 'package:app/widgets/textIocnActWidget.dart';
import 'package:app/widgets/wishlistIconButtonWidget.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:badges/badges.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expandable/expandable.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import "package:flutter/material.dart";
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

const s =
    "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.";

class ActivityDetailsScreen extends StatefulWidget {
  static String router = "/activity_details";
  ActivityDetailsScreen({Key? key}) : super(key: key);

  @override
  State<ActivityDetailsScreen> createState() => _ActivityDetailsScreenState();
}

class _ActivityDetailsScreenState extends State<ActivityDetailsScreen> {
  final store = FirebaseStorage.instance;
  bool init = false;
  PageController pageViewController = PageController(initialPage: 0);

  void _gotoChat({
    required BuildContext context,
    required UserProvider userProvider,
    required String userId,
    required String activityId,
  }) async {
    if (userProvider.islogin()) {
      final chatProvider = Provider.of<ChatProvider>(context, listen: false);

      // final userProvider = Provider.of<UserProvider>(context, listen: false);

      await chatProvider.addChat(
          context: context, userId: userId, activityId: activityId);
      if (chatProvider.chat != null) {
        if (chatProvider.chat!.users.contains(userId) &&
            chatProvider.chat!.users.contains(userProvider.currentUser!.Id)) {
          await Navigator.pushNamed(context, MassagesScreen.router,
              arguments: chatProvider.chat);
        }
      }
    }
  }

  Map<int, BannerAd> _bannersAd = {};

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
            _bannersAd[0] = ad as BannerAd;
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
    _bannersAd[0]?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    ActivityProvider activityProvider = Provider.of<ActivityProvider>(context);
    ActivitySchema args =
        ModalRoute.of(context)?.settings.arguments as ActivitySchema;
    print(args.storeId);

    Future.delayed(Duration.zero,
        () async => await activityProvider.openActivity(args.storeId, args.Id));

    List images = [...args.images];
    List dates = [...args.dates];
    images.removeWhere((e) => e == null || e.toString().trim() == "");
    dates.removeWhere((e) => e != null || e != "" || e.runtimeType != String);

    //  dates = args.dates
    //     .map((e) => e != null && e != "" && e.runtimeType != String)
    //     .toList();
    return Scaffold(
      //   appBar: AppBar(
      //     // automaticallyImplyLeading: false,
      //     backgroundColor: Colors.white,

      //     // title: Text(
      //     //   "Trippoint oo",
      //     //   style: Theme.of(context).textTheme.headlineSmall,
      //     // ),
      //     // actions: [
      //     //   TextButton.icon(
      //     //     label: Text(""),
      //     //     icon: const Icon(
      //     //       Icons.person,
      //     //       color: Colors.black,
      //     //       size: 30,
      //     //     ),
      //     //     onPressed: () {
      //     //       print('IconButton pressed ...');
      //     //     },
      //     //   ),
      //     // ],
      //     // centerTitle: true,
      //     elevation: 0,
      //   ),
      body: SafeArea(
        child: Container(
          color: Colors.white,
          child: ListView(
            children: [
              Container(
                decoration: BoxDecoration(
                  boxShadow: const [
                    BoxShadow(
                      blurRadius: 4,
                      color: Color(0x33000000),
                      offset: Offset(0, 2),
                    )
                  ],
                  borderRadius: BorderRadius.circular(0),
                ),
                child: Container(
                  height: 300,
                  width: MediaQuery.of(context).size.width,
                  child: Stack(
                    children: [
                      Hero(
                        tag: images,
                        child: PageView(
                          controller: pageViewController,
                          children: images.map((e) {
                            return Image.network(
                              e,
                              height: 300,
                              fit: BoxFit.cover,
                            );
                          }).toList(),
                        ),
                      ),
                      Align(
                        alignment: const AlignmentDirectional(.7, .9),
                        child: SmoothPageIndicator(
                          controller: pageViewController,
                          count: images.length,
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
                            activeDotColor: Color(0xFF3F51B5),
                            paintStyle: PaintingStyle.fill,
                          ),
                        ),
                      ),
                      Align(
                        alignment: const AlignmentDirectional(-1, -.9),
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          //   padding: EdgeInsets.all(5),
                          decoration: BoxDecoration(
                              boxShadow: const [
                                BoxShadow(
                                  blurRadius: 4,
                                  color: Color(0x33000000),
                                  offset: Offset(0, 2),
                                )
                              ],
                              borderRadius: BorderRadius.circular(50),
                              color: Colors.white60),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.arrow_back, size: 28),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                              ),
                              Row(
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.share, size: 28),
                                    onPressed: () async {
                                      //   Navigator.pop(context);share
                                      EasyLoading.show();
                                      String url =
                                          await AppHelper.buildDynamicLink(
                                              title: args.title, Id: args.Id);
                                      await FlutterShare.share(
                                        title: 'Trippoint Oman || عمان',
                                        text: args.title,
                                        linkUrl: url,
                                      );
                                      activityProvider.addSharesCountActivity(
                                          args.storeId, args.Id);

                                      EasyLoading.dismiss();
                                    },
                                  ),
                                  WishlistIconButtonWidget(
                                    activityId: args.Id,
                                    activityStoreId: args.storeId!,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      args.title,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                TextIconInfoActWidget(
                                  icon: Icons.star_rounded,
                                  color: ColorsHelper.yellow,
                                  text: activityProvider
                                          .previewMark(args.reviews)
                                          .toString() +
                                      "/5",
                                ),
                                // Icon(
                                //   Icons.star_rounded,
                                //   color: ColorsHelper.yellow,
                                // ),
                                // SizedBox(
                                //   width: 5,
                                // ),
                                // Text(
                                //   activityProvider
                                //           .previewMark(args.previews)
                                //           .toString() +
                                //       "/5",
                                //   style: Theme.of(context).textTheme.bodySmall,
                                // ),
                                SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  args.reviews.length.toString() +
                                      AppHelper.returnText(
                                          context, " reviews", "مراجعات"),
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall
                                      ?.copyWith(fontSize: 12),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            TextIconInfoActWidget(
                              text: args.address,
                              icon: Icons.location_on_rounded,
                              //  style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ],
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Text(
                              AppHelper.returnText(context, 'From', 'من'),
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                            Padding(
                              padding:
                                  EdgeInsetsDirectional.fromSTEB(5, 0, 0, 0),
                              child: Text(
                                activityProvider
                                    .startFromPrice(args.prices)
                                    .toString(),
                                style: Theme.of(context)
                                    .textTheme
                                    .titleLarge!
                                    .copyWith(
                                      color: ColorsHelper.red.shade600,
                                    ),
                              ),
                            ),
                            Text('OMR',
                                style: Theme.of(context).textTheme.titleSmall),
                          ],
                        ),
                      ],
                    ),

                    // TextBoxActWidget(
                    //   text: 'book through abb or contact owner',
                    // ),
                    // TextBoxActWidget(
                    //   text: 'Free cancellation up to 24 hours in',
                    //   icon: Icons.date_range,
                    // ),
                    // TextBoxActWidget(
                    //   text: 'Booking confirmed in 24 hours ',
                    //   icon: Icons.bookmark,
                    // ),
                    // const SizedBox(
                    //   height: 15,
                    // ),
                    // P_TextInfo(text: "Location", icon: Icons.location_on),
                    // P_TextInfo(text: "3 Hours", icon: Icons.timelapse),
                  ],
                ),
              ),

              const SizedBox(
                height: 10,
              ),
              SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      if (args.genderSuitability["woman"] == true &&
                          (args.genderSuitability["man"] == false ||
                              args.genderSuitability["man"] == null))
                        TextBoxActWidget(
                          text:  AppHelper.returnText(context, "Women only", "للنساء فقط"),
                        ),
                      if (args.suitableAges["min"] != null &&
                          args.suitableAges["min"].toString().trim() != "")
                        TextBoxActWidget(
                          text: "Above " + args.suitableAges["min"].toString(),
                        ),
                      if (args.op_GOA == true)
                        TextBoxActWidget(
                          text: AppHelper.returnText(context, "Private group", "متاح للعوائل"),
                        ),
                    ],
                  ),
                ),
              ),

              SizedBox(
                height: 10,
              ),
              Container(
                  padding: EdgeInsets.all(10),
                  child: Column(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                  
                        Text(AppHelper.returnText(context, "Avaliable Dates : ", "التواريخ المتاحة:")),
                        Column(
                          children: [
                            Column(
                              children: dates.map((e) {
                                if (e != null &&
                                    e != "" &&
                                    e.runtimeType != String) {
                                  return Container(
                                    margin:
                                        EdgeInsets.symmetric(horizontal: 10),
                                    child: OutlinedButton(
                                      onPressed: () {},
                                      style: OutlinedButton.styleFrom(
                                        primary: Colors.black87,
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10, vertical: 8),
                                        side: const BorderSide(width: 1),
                                      ),
                                      child: Text(
                                        DateFormat('MM/dd/yyyy, hh:mm a')
                                            .format(DateTime
                                                .fromMillisecondsSinceEpoch(e)),
                                        style: TextStyle(fontSize: 14),
                                      ),
                                    ),
                                  );
                                }
                                return SizedBox();
                              }).toList(),
                            ),
                            if (dates.isEmpty)
                                Text(AppHelper.returnText(context, "Avaliable days : ", "الأيام المتوفرة:")),

                            if (dates.isEmpty)
                              Row(
                                children: [
                                  //   if (args.availableDays.contains(String))
                                  ...args.availableDays.map((e) {
                                    if (e != null) {
                                      return Container(
                                        margin: EdgeInsets.symmetric(
                                            horizontal: 10),
                                        child: OutlinedButton(
                                          onPressed: () {},
                                          style: OutlinedButton.styleFrom(
                                            primary: Colors.black87,
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 10, vertical: 8),
                                            side: const BorderSide(width: 1),
                                          ),
                                          child: Text(
                                            e,
                                            style: TextStyle(fontSize: 14),
                                          ),
                                        ),
                                      );
                                    }
                                    return SizedBox();
                                  }).toList(),
                                ],
                              ),
                          ],
                        ),
                      ])),

              SizedBox(
                height: 20,
              ),

              //^---------------------- adverticment -----------------------

              if (_bannersAd[0] != null)
                Container(
                  width: _bannersAd[0]!.size.width.toDouble(),
                  height: _bannersAd[0]!.size.height.toDouble(),
                  child: AdWidget(ad: _bannersAd[0]!),
                ),

              //^----------------------------------------------------------

              SizedBox(
                height: 20,
              ),

              Divider(
                thickness: 2,
                color: ColorsHelper.blue.shade400,
              ),
              OriginizerActivityBoxWidget(
                activitySchema: args,
              ),
              Divider(
                thickness: 1,
                color: ColorsHelper.blue.shade400,
              ),

              Container(
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.all(10),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      AppHelper.returnText(context, 'Prices', "الأسعار"),
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    ...args.prices
                        .asMap()
                        .map((k, e) {
                          if (e["price"] != null &&
                              e["price"].toString().trim() != "") {
                            return MapEntry(
                                k,
                                Column(
                                  children: [
                                    Row(
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Expanded(
                                          flex: 1,
                                          child: Container(
                                            padding: EdgeInsets.all(5),
                                            margin: EdgeInsets.symmetric(
                                                horizontal: 10),
                                            decoration: BoxDecoration(
                                                border: Border.all(
                                                    color: ColorsHelper.grey,
                                                    width: 1),
                                                borderRadius:
                                                    BorderRadius.circular(10)),
                                            child: Row(
                                              children: [
                                                Text(e["price"].toString()),
                                                Text(
                                                  " OMR",
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodySmall
                                                      ?.copyWith(fontSize: 10),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                        // Icon(Icons.arrow_forward, size: 35, color:ColorsHelper.grey ,),

                                        Expanded(
                                          flex: 3,
                                          child: Container(
                                            padding: EdgeInsets.all(10),
                                            margin: EdgeInsets.symmetric(
                                                horizontal: 10),
                                            decoration: BoxDecoration(
                                                border: Border.all(
                                                    color: ColorsHelper.grey,
                                                    width: 1),
                                                borderRadius:
                                                    BorderRadius.circular(10)),
                                            child: Text(
                                              e["des"].toString(),
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodySmall,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    if (k != args.prices.length - 1 &&
                                        (args.prices[k + 1]["price"] != "" &&
                                            args.prices[k + 1]["price"] !=
                                                null))
                                      DividerWidget(),
                                  ],
                                ));
                          }
                          return MapEntry(k, SizedBox());
                        })
                        .values
                        .toList(),
                    //   Text(args.prices),

                    SizedBox(
                      height: 15,
                    ),
                    TextCardWidget(
                      title: AppHelper.returnText(context, "Activity description", "وصف النشاط"),
                      text: args.description,
                    ),
                    TextCardWidget(
                      title: AppHelper.returnText(context, "Important information", "معلومات مهمة"),
                      text: args.importantInformation,
                    ),
                  ],
                ),
              ),

              Divider(
                thickness: 1,
                color: ColorsHelper.blue.shade400,
              ),
              Container(
                padding: EdgeInsets.all(10),
                child: Column(
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          AppHelper.returnText(context, 'Location', 'الموقع'),
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(5, 0, 0, 0),
                          child: Text(
                            args.address,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
              //   Stack(
              //     children: [
              Container(
                  width: MediaQuery.of(context).size.width,
                  height: 250,
                  child: GooglemapDescWidget(
                    latlan: LatLng(args.lat, args.lng),
                    activitySchema: args,
                    onChanged: () {},
                  )),
              //   CupertinoButton(
              //     color: ColorsHelper.red,
              //     padding: EdgeInsets.all(10),
              //     borderRadius: BorderRadius.zero,
              //     onPressed: () {
              //       //   Navigator.pushNamed(context, MapScreen.router,
              //       //       arguments: args);

              //       // !!!!!!!!!!!!!!!!!!!!!!!!
              //     },
              //     child: Icon(
              //       Icons.open_in_full_rounded,
              //       size: 30,
              //     ),
              //   ),
              // ],
              //   ),
              // Image.asset(
              //   'assets/images/categories/discover_all.jpg',
              //   width: MediaQuery.of(context).size.width,
              //   height: 250,
              //   fit: BoxFit.cover,
              // ),

              //   SizedBox(
              //     height: 10,
              //   ),
              //   Divider(
              //     thickness: 2,
              //     color: ColorsHelper.blue.shade400,
              //   ),
              //   Container(
              //     margin: const EdgeInsets.symmetric(vertical: 10),
              //     child: Column(
              //       children: [
              //         P_ExpandableView(
              //           title: "description",
              //           text: s,
              //         ),
              //         P_ExpandableView(
              //           title: "What\'s include",
              //           text: s,
              //         ),
              //         P_ExpandableView(
              //           title: "Important information",
              //           text: s,
              //         ),
              //       ],
              //     ),
              //   ),
              Divider(
                thickness: 1,
                // color: ColorsHelper.blue.shade400,
              ),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 10),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          AppHelper.returnText(context, 'Reviews', "التعليقات"),
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(0, 20, 0, 0),
                          child: Text(
                            activityProvider
                                .previewMark(args.reviews)
                                .toString(),
                            style: Theme.of(context).textTheme.displaySmall,
                          ),
                        ),
                        RatingBarWidget(
                          onRated: (val) {
                            print(val);
                            if (userProvider.islogin()) {
                              Navigator.pushNamed(
                                  context, SendReviewScreen.router,
                                  arguments: args);
                            } else {
                              DialogWidgets.mustSginin(context);
                            }
                          },
                          size: 30,
                        ),
                        //   Row(
                        //     mainAxisSize: MainAxisSize.max,
                        //     mainAxisAlignment: MainAxisAlignment.center,
                        //     children: [],
                        //   ),
                        Text(
                          args.reviews.length.toString() + AppHelper.returnText(context, ' reviews', "تقييمات"),
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(5, 5, 5, 5),
                      child: OutlinedButton(
                        onPressed: () {
                          print('Button pressed ...');
                          Navigator.pushNamed(context, ViewReviewScreen.router,
                              arguments: args);
                        },
                        style: OutlinedButton.styleFrom(
                            // primary: ColorsHelper.green,
                            // padding: EdgeInsets.symmetric(
                            //     vertical: 10, horizontal: 30),
                            // side:
                            //     BorderSide(width: 3, color: ColorsHelper.green),
                            // shape: RoundedRectangleBorder(
                            //   borderRadius: BorderRadius.circular(8),
                            // ),
                            ),
                        child: Text(AppHelper.returnText(context, 'see reviews', "التقيمات")),
                      ),
                    ),
                  ],
                ),
              ),
              Divider(
                thickness: 1,
                // color: ColorsHelper.blue.shade400,
              ),

              LinkWidget(
                  text: AppHelper.returnText(context, "! Report this listing ", "! أبلاغ عن هذه القائمة"),
                  onPressed: () {
                    Navigator.pushNamed(context, ReportActivityScreen.router,
                        arguments: args.Id);
                  }),

              const SizedBox(
                height: 80,
              ),
            ],
          ),
        ),
      ),
      bottomSheet: Container(
        width: MediaQuery.of(context).size.width,
        color: Colors.white38,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(context, ContactOwnerScreen.router,
                  arguments: args);
            },
            child: Text(AppHelper.returnText(context, "Contact", "تواصل مع المالك")),
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            ),
          ),
        ),
      ),
    );
  }
}

class MapSample extends StatefulWidget {
  double latitude;
  double longitude;
  String address;
  String description;

  MapSample(
      {Key? key,
      required this.address,
      required this.description,
      required this.latitude,
      required this.longitude})
      : super(key: key);

  @override
  State<MapSample> createState() => MapSampleState();
}

class MapSampleState extends State<MapSample> {
  final Completer<GoogleMapController> _controller = Completer();

  CameraPosition initialCameraPosition =
      CameraPosition(target: LatLng(22.665964, 59.403076), zoom: 30);

  final Marker _marker = Marker(
    markerId: MarkerId("smail"),
    infoWindow: InfoWindow(
      title: "samli lo",
      snippet:
          "New York City is a global cultural, financial, and media center with a significant",
    ),
    position: LatLng(22.665964, 59.403076),
    icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
  );
  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      mapType: MapType.normal,
      initialCameraPosition: initialCameraPosition,
      onMapCreated: (controller) {
        _controller.complete(controller);
      },
      markers: {
        _marker,
      },
    );
  }
}

class P_ExpandableView extends StatelessWidget {
  String title;
  String text;
  int? maxLines = 2;
  P_ExpandableView(
      {Key? key, required this.title, required this.text, this.maxLines})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ExpandableNotifier(
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 10),
        child: ScrollOnExpand(
          child: ExpandablePanel(
            header: Padding(
                padding: EdgeInsets.all(10),
                child: Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium,
                )),
            collapsed: Text(
              text,
              softWrap: true,
              maxLines: maxLines,
              overflow: TextOverflow.ellipsis,
            ),
            expanded: Text(
              text,
              softWrap: true,
              overflow: TextOverflow.fade,
            ),
            builder: (_, collapsed, expanded) {
              return Padding(
                padding: const EdgeInsets.all(10),
                child: Expandable(
                  collapsed: collapsed,
                  expanded: expanded,
                  theme: const ExpandableThemeData(crossFadePoint: 0),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
