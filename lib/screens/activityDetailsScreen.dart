import 'dart:async';

import 'package:app/constants/constants.dart';
import 'package:app/helpers/colorsHelper.dart';
import 'package:app/providers/chatProvider.dart';
import 'package:app/providers/userProvider.dart';
import 'package:app/schemas/activitySchema.dart';
import 'package:app/screens/mapScreen.dart';
import 'package:app/screens/massagesScreen.dart';
import 'package:app/widgets/ratingBarWidget.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:badges/badges.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/cupertino.dart';
import "package:flutter/material.dart";
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
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
  PageController pageViewController = PageController(initialPage: 0);

  void _gotoChat({
    required BuildContext context,
    required UserProvider userProvider,
    required String userId,
  }) async {
    if (userProvider.islogin()) {
      final chatProvider = Provider.of<ChatProvider>(context, listen: false);

      // final userProvider = Provider.of<UserProvider>(context, listen: false);

      String s = await chatProvider.addChat(context: context, userId: userId);
      if (chatProvider.chat != null) {
        if (chatProvider.chat!.users.contains(userId) &&
            chatProvider.chat!.users.contains(userProvider.currentUser!.Id)) {
          await Navigator.pushNamed(context, MassagesScreen.router,
              arguments: chatProvider.chat);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final args = ModalRoute.of(context)?.settings.arguments as ActivitySchema;
    print(args);

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
                  height: 200,
                  width: MediaQuery.of(context).size.width,
                  child: Stack(
                    children: [
                      Hero(
                        tag: args.imagePath,
                        child: PageView(
                          controller: pageViewController,
                          children: [
                            Image.asset(
                              args.imagePath,
                              height: 200,
                              fit: BoxFit.cover,
                            ),
                            Image.asset(
                              args.imagePath,
                              height: 200,
                              fit: BoxFit.cover,
                            ),
                            Image.asset(
                              args.imagePath,
                              height: 200,
                              fit: BoxFit.cover,
                            ),
                          ],
                        ),
                      ),
                      Align(
                        alignment: const AlignmentDirectional(.7, .9),
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
                            activeDotColor: Color(0xFF3F51B5),
                            paintStyle: PaintingStyle.fill,
                          ),
                        ),
                      ),
                      Align(
                        alignment: const AlignmentDirectional(-.96, -.9),
                        child: Container(
                          decoration: BoxDecoration(
                              boxShadow: const [
                                BoxShadow(
                                  blurRadius: 4,
                                  color: Color(0x33000000),
                                  offset: Offset(0, 2),
                                )
                              ],
                              borderRadius: BorderRadius.circular(50),
                              color: Colors.white),
                          child: IconButton(
                        
                            icon: const Icon(Icons.arrow_back, size: 28),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.all(10),
                child: Column(
                  children: [
                    Text(
                      "Dolphin watching and snorking Muscat ",
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Text(
                          'From',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(5, 0, 0, 0),
                          child: Text(
                            '20',
                            style: Theme.of(context)
                                .textTheme
                                .copyWith(
                                  titleLarge: TextStyle(
                                    fontSize: Theme.of(context)
                                        .textTheme
                                        .titleLarge
                                        ?.fontSize,
                                    color: ColorsHelper.red.shade600,
                                  ),
                                )
                                .titleLarge,
                          ),
                        ),
                        Text('OMR',
                            style: Theme.of(context).textTheme.titleSmall),
                      ],
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    P_TextCard(
                      text: 'book through abb or contact owner',
                    ),
                    P_TextCard(
                      text: 'Free cancellation up to 24 hours in',
                      icon: Icons.date_range,
                    ),
                    P_TextCard(
                      text: 'Booking confirmed in 24 hours ',
                      icon: Icons.bookmark,
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    P_TextInfo(text: "Location", icon: Icons.location_on),
                    P_TextInfo(text: "3 Hours", icon: Icons.timelapse),
                  ],
                ),
              ),
              Divider(
                thickness: 2,
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
                          'Location:',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(5, 0, 0, 0),
                          child: Text(
                            'smail, adldakilia',
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
              Stack(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: 250,
                    child: MapSample(
                      latitude: 23.58448526857199,
                      longitude: 58.138527790149006,
                      address: "وحدة أمن السلطاني",
                      description: "وحدة أمن السلطاني",
                    ),
                  ),
                  CupertinoButton(
                    color: ColorsHelper.red,
                    padding: EdgeInsets.all(10),
                    borderRadius: BorderRadius.zero,
                    onPressed: () {
                      Navigator.pushNamed(context, MapScreen.router,
                          arguments: args);
                    },
                    child: Icon(
                      Icons.open_in_full_rounded,
                      size: 30,
                    ),
                  ),
                ],
              ),
              // Image.asset(
              //   'assets/images/categories/discover_all.jpg',
              //   width: MediaQuery.of(context).size.width,
              //   height: 250,
              //   fit: BoxFit.cover,
              // ),
              SizedBox(
                height: 10,
              ),
              Divider(
                thickness: 2,
                color: ColorsHelper.blue.shade400,
              ),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 10),
                child: Column(
                  children: [
                    P_ExpandableView(
                      title: "description",
                      text: s,
                    ),
                    P_ExpandableView(
                      title: "What\'s include",
                      text: s,
                    ),
                    P_ExpandableView(
                      title: "Important information",
                      text: s,
                    ),
                  ],
                ),
              ),
              Divider(
                thickness: 2,
                color: ColorsHelper.blue.shade400,
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
                          'Reviews',
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(0, 20, 0, 0),
                          child: Text(
                            '4.5',
                            style: Theme.of(context).textTheme.displaySmall,
                          ),
                        ),
                        RatingBarWidget(
                          onRated: (val) {
                            print(val);
                          },
                          size: 30,
                        ),
                        //   Row(
                        //     mainAxisSize: MainAxisSize.max,
                        //     mainAxisAlignment: MainAxisAlignment.center,
                        //     children: [],
                        //   ),
                        Text(
                          '35 reviews',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(5, 5, 5, 5),
                      child: OutlinedButton(
                        onPressed: () {
                          print('Button pressed ...');
                        },
                        style: OutlinedButton.styleFrom(
                            primary: ColorsHelper.green,
                            padding: EdgeInsets.symmetric(
                                vertical: 10, horizontal: 30),
                            side:
                                BorderSide(width: 3, color: ColorsHelper.green),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            )),
                        child: const Text('see reviews'),
                      ),
                    ),
                  ],
                ),
              ),
              Divider(
                thickness: 2,
                color: ColorsHelper.blue.shade400,
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 10),
                padding: EdgeInsetsDirectional.fromSTEB(10, 10, 10, 10),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Text(
                      'Orginized by',
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Container(
                        //   width: 80,
                        //   height: 80,
                        //   clipBehavior: Clip.antiAlias,
                        //   decoration: BoxDecoration(
                        //     shape: BoxShape.circle,
                        //   ),
                        //   child: Image.asset(
                        //     'assets/images/user.png',
                        //   ),
                        // ),
                        Row(
                          children: [
                            CircleAvatar(
                              maxRadius: 40,
                            ),
                            Padding(
                              padding:
                                  EdgeInsetsDirectional.fromSTEB(5, 0, 0, 0),
                              child: Text(
                                'Ahmed',
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            ),
                          ],
                        ),

                        ElevatedButton(
                          onPressed: () {
                            _gotoChat(
                              context: context,
                              userProvider: userProvider,
                              userId: "mw1nzK98cHUm14emdFoWsoRlVPD2",
                            );
                          },
                          child: Text("Contact Owner"),
                          style: ElevatedButton.styleFrom(
                            primary: ColorsHelper.pink,
                            // padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                            shape: RoundedRectangleBorder(
                              side: BorderSide(
                                color: Colors.transparent,
                                width: 1,
                              ),
                              borderRadius: BorderRadius.circular(24),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
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
            onPressed: () {},
            child: Text("Book now"),
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

class P_TextInfo extends StatelessWidget {
  IconData icon;
  String text;
  P_TextInfo({Key? key, required this.text, required this.icon})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          Icon(
            icon,
            color: Theme.of(context).textTheme.bodyMedium?.color,
            size: 18,
          ),
          Padding(
            padding: EdgeInsetsDirectional.fromSTEB(5, 0, 0, 0),
            child: Text(
              text,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }
}

class P_TextCard extends StatelessWidget {
  IconData? icon;
  String text;
  P_TextCard({Key? key, required this.text, this.icon}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5),
      decoration: BoxDecoration(
        //   color: ColorsHelper.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: ColorsHelper.pink,
        ),
      ),
      child: Padding(
        padding: EdgeInsetsDirectional.fromSTEB(5, 5, 5, 5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            icon != null
                ? Icon(
                    icon,
                    color: Colors.black,
                    size: 20,
                  )
                : Icon(
                    Icons.arrow_forward_ios_rounded,
                    color: Colors.black,
                    size: 20,
                  ),
            SizedBox(
              width: 10,
            ),
            AutoSizeText(
              text,
              maxLines: 1,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }
}
