import 'dart:async';

import 'package:app/helpers/appHelper.dart';
import 'package:app/helpers/colorsHelper.dart';
import 'package:app/helpers/geolocateHelper.dart';
import 'package:app/schemas/activitySchema.dart';
import 'package:app/widgets/SafeScreen.dart';
import 'package:app/widgets/loadingWidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:maps_launcher/maps_launcher.dart';
import 'package:uuid/uuid.dart';

class SearchScreen extends StatefulWidget {
  static String router = "/search";

  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen>
    with TickerProviderStateMixin {
  late TabController _tabController = TabController(length: 2, vsync: this);
  int _currentTab = 0;
  bool _isLoading = true;

  List<ActivitySchema> activitiesList = AppHelper.Activities;

  final _initialCameraPosition = const CameraPosition(
    target: LatLng(23.244037241974922, 58.091192746314015),
    zoom: 20,
  );

  int page = 0;
  PageController pageController =
      PageController(initialPage: 0, viewportFraction: 0.8);
  FocusNode _focusNode = FocusNode();

  final Completer<GoogleMapController> _controller = Completer();
  Position? _currentPosition;

  _getCurrentLocation() async {
    GeolocateHelper.determinePosition(context).then((position) {
      setState(() {
        // Store the position in the variable
        _currentPosition = position;

        print('CURRENT POS: $_currentPosition');

        // For moving the camera to current location
        _controller.future.then((value) => value.animateCamera(
              CameraUpdate.newCameraPosition(
                CameraPosition(
                  target: LatLng(position.latitude, position.longitude),
                  zoom: 18.0,
                ),
              ),
            ));
      });
    }).catchError((error, stackTrace) => null);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _tabController = TabController(length: 2, vsync: this);

    Future.delayed(Duration(milliseconds: 1000), () {
      setState(() {
        _isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments as ActivitySchema;

    if (args != null) activitiesList.add(args);

    Marker _marker = Marker(
      markerId: MarkerId(Uuid().v4()),
      position: LatLng(activitiesList[0].lat, activitiesList[0].lng),
      infoWindow: InfoWindow(
        title: activitiesList[0].address,
      ),
    );

    List<Marker> _markers = activitiesList
        .asMap()
        .map((i, e) {
          return MapEntry(
              i,
              Marker(
                flat: true,
                markerId: MarkerId(Uuid().v4()),
                position: LatLng(activitiesList[0].lat, activitiesList[0].lng),
                infoWindow: InfoWindow(
                  title: e.address,
                  snippet: (e.priceStartFrom.toString() + "\$"),
                ),
                icon: BitmapDescriptor.defaultMarkerWithHue(
                    BitmapDescriptor.hueRose),
                onTap: () {
                  pageController.animateToPage(i,
                      duration: Duration(milliseconds: 400),
                      curve: Curves.easeInOut);
                },
              ));
        })
        .values
        .toList();

    if (_isLoading) {
      return const LoadingWidget();
    }

    return SafeScreen(
      padding: 0,
      child: Stack(children: [
        GoogleMap(
          initialCameraPosition: _initialCameraPosition,
          onMapCreated: (controller) {
            _controller.complete(controller);
          },
          myLocationEnabled: true,
          myLocationButtonEnabled: true,
          mapType: MapType.normal,
          markers: {
            ..._markers,
          },
          onTap: (latLng) {
            FocusScope.of(context).unfocus();
          },
        ),
        Align(
          alignment: AlignmentDirectional(-.9, .5),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              boxShadow: const [
                BoxShadow(
                  blurRadius: 8,
                  color: Colors.black38,
                  spreadRadius: .6,
                  offset: Offset(0, 0),
                )
              ],
            ),
            child: ClipOval(
              child: Material(
                color: Colors.white, // button color
                child: InkWell(
                  splashColor: Colors.white12, // inkwell color
                  child: SizedBox(
                    width: 60,
                    height: 60,
                    child: Icon(
                      Icons.my_location,
                      size: 35,
                    ),
                  ),
                  onTap: () {
                    // TODO: Add the operation to be performed
                    // on button tap
                    _getCurrentLocation();
                  },
                ),
              ),
            ),
          ),
        ),
        Align(
          alignment: AlignmentDirectional(0, .8),
          child: Container(
            height: 120,
            width: MediaQuery.of(context).size.width,
            child: PageView.builder(
              physics: BouncingScrollPhysics(),
              //   dragStartBehavior: DragStartBehavior.down,
              itemCount: activitiesList.length,
              controller: pageController,
              onPageChanged: (p) async {
                GoogleMapController con = await _controller.future;
                con.showMarkerInfoWindow(_markers[p].markerId);

                con.animateCamera(CameraUpdate.newCameraPosition(
                    CameraPosition(target: _markers[p].position, zoom: 18)));
              },
              itemBuilder: (context, index) {
                return Align(
                  alignment: Alignment.topCenter,
                  child: Container(
                    margin: EdgeInsets.all(8),
                    height: 100,
                    // height: PAGER_HEIGHT * scale,
                    // width: MediaQuery.of(context).size.width,
                    child: Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Image.asset(
                                  activitiesList[index].images[0],
                                  fit: BoxFit.cover,
                                  height: 100,
                                  width: 100,
                                ),
                                Container(
                                  margin: EdgeInsets.all(10),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        activitiesList[index].address,
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleSmall,
                                        softWrap: true,
                                      ),

                                      Column(
                                        children: [
                                          RatingBarIndicator(
                                            itemBuilder: (context, index) {
                                              return Icon(
                                                Icons.star_rate_rounded,
                                                color: Colors.amber,
                                              );
                                            },
                                            rating: 2,
                                            itemSize: 20,
                                          ),
                                          Row(
                                            mainAxisSize: MainAxisSize.max,
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Icon(
                                                Icons.location_on_sharp,
                                                size: 14,
                                              ),
                                              Padding(
                                                padding: EdgeInsetsDirectional
                                                    .fromSTEB(5, 0, 0, 0),
                                                child: Text(
                                                  activitiesList[index].address,
                                                  style: TextStyle(
                                                      fontSize:
                                                          Theme.of(context)
                                                                  .textTheme
                                                                  .bodySmall!
                                                                  .fontSize! -
                                                              3),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      //   Padding(
                                      //     padding: EdgeInsetsDirectional.fromSTEB(
                                      //         4, 0, 0, 0),
                                      //     child: Text(
                                      //       '10 reviews',
                                      //       style: Theme.of(context)
                                      //           .textTheme
                                      //           .bodySmall,
                                      //     ),
                                      //   ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                IconButton(
                                  onPressed: () async {
                                    await MapsLauncher.launchCoordinates(
                                      _markers[index].position.latitude,
                                      _markers[index].position.longitude,
                                    );
                                  },
                                  icon: Icon(Icons.assistant_navigation),
                                ),
                                Text(
                                  activitiesList[index]
                                          .priceStartFrom
                                          .toString() +
                                      " \$",
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
        DraggableScrollableSheet(
            initialChildSize: 0.85,
            maxChildSize: 0.85,
            minChildSize: 0.1,
            snapSizes: [0.1, 0.85],
            snap: true,
            builder: (context, scrollController) {
              return ListView(controller: scrollController, children: [
                Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16),
                    ),
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 8,
                        color: Colors.black12,
                        spreadRadius: .6,
                        offset: Offset(0, -8),
                      )
                    ],
                  ),
                  margin: EdgeInsets.only(top: 30),
                  padding: EdgeInsets.only(top: 20, bottom: 20),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                    ),
                    child: Center(
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 20),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            color: ColorsHelper.grey),
                        width: 70,
                        height: 6,
                      ),
                    ),
                  ),
                ),
                Container(
                  color: Colors.white,
                  child: SingleChildScrollView(
                    child: Container(
                      height: MediaQuery.of(context).size.height,
                      child: Column(
                        children: [
                          Container(
                            padding: EdgeInsets.all(10),
                            child: ResultActivituBoxWidget(),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ]);
            }),
        Container(
          color: Colors.white,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(
                        Icons.arrow_back_rounded,
                        size: 28,
                      ),
                    ),
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.all(10),
                        child: TextFormField(
                          obscureText: false,
                          decoration: const InputDecoration(
                            hintText: "Where to go?",
                            filled: true,
                            fillColor: Colors.white,
                            prefixIcon: Icon(
                              Icons.search_rounded,
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.black45,
                                width: 1,
                              ),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(16)),
                            ),
                            border: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.black45,
                                width: 1,
                              ),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(16)),
                            ),
                          ),
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(Icons.filter_list_rounded, size: 28),
                    ),
                  ],
                ),
              ),
              TabBar(
                controller: _tabController,
                labelPadding: EdgeInsets.all(0),
                padding: EdgeInsets.all(0),
                tabs: const [
                  Tab(
                    child: Text("Activities"),
                  ),
                  Tab(
                    child: Text("Chalets"),
                  ),
                ],
                labelColor: Colors.black,
                indicatorColor: Colors.black87,
              ),
              SizedBox(
                height: 10,
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    ...AppHelper.categories.map((e) {
                      return Container(
                        margin: EdgeInsets.symmetric(horizontal: 10),
                        child: OutlinedButton(
                          onPressed: () {},
                          style: OutlinedButton.styleFrom(
                            primary: Colors.black87,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 8),
                            side: const BorderSide(width: 1),
                          ),
                          child: Text(
                            e["title"],
                            style: TextStyle(fontSize: 14),
                          ),
                        ),
                      );
                    }).toList(),
                  ],
                ),
              ),
              const SizedBox(
                height: 10,
              ),
            ],
          ),
        ),
      ]),
    );
  }
}

class ResultActivituBoxWidget extends StatefulWidget {
  const ResultActivituBoxWidget({super.key});

  @override
  State<ResultActivituBoxWidget> createState() =>
      _ResultActivituBoxWidgetState();
}

class _ResultActivituBoxWidgetState extends State<ResultActivituBoxWidget> {
  List<bool> isSelected = [
    false,
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 20),
      height: 240,
      child: Card(
        clipBehavior: Clip.antiAliasWithSaveLayer,
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            Image.network(
              'https://picsum.photos/seed/248/600',
              width: 100,
              height: 240,
              fit: BoxFit.cover,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                    //   mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Title",
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    //   Text(
                    //     'promotion 5% for children',
                    //     // style:
                    //   ),
                      Text(
                        'discribtion ,Flutter is an open-source UI software development kit',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),

                      Column(
                        // mainAxisSize: MainAxisSize.max,
                        // crossAxisAlignment: CrossAxisAlignment.end,
                        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding:
                                EdgeInsetsDirectional.fromSTEB(0, 20, 20, 0),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Text(
                                  '50',
                                  style: Theme.of(context).textTheme.bodyLarge,
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Text('OMR'),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              const Icon(
                                Icons.star_rounded,
                                color: Color(0xFFFFA130),
                                size: 20,
                              ),
                              Padding(
                                padding:
                                    EdgeInsetsDirectional.fromSTEB(2, 0, 0, 0),
                                child: Text(
                                  '4/5',
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                              ),
                              Padding(
                                padding:
                                    EdgeInsetsDirectional.fromSTEB(4, 0, 0, 0),
                                child: Text(
                                  '10 reviews',
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    
                      SizedBox(
                        height: 5,
                      ),

                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Icon(
                                Icons.location_on,
                                size: 20,
                              ),
                              Padding(
                                padding:
                                    EdgeInsetsDirectional.fromSTEB(5, 0, 0, 0),
                                child: Text(
                                  'Location',
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                              ),
                            ],
                          ),
                          //   Container(
                          //     margin: EdgeInsets.symmetric(horizontal: 5),
                          //     child: ToggleButtons(
                          //       selectedColor: Colors.black87,
                          //       selectedBorderColor: Colors.transparent,
                          //       borderColor: Colors.transparent,
                          //       splashColor: Colors.transparent,
                          //       fillColor: Colors.transparent,
                          //       children: [
                          //         isSelected[0]
                          //             ? Icon(
                          //                 Icons.bookmark,
                          //                 size: 30,
                          //               )
                          //             : Icon(
                          //                 Icons.bookmark_border,
                          //                 size: 30,
                          //               ),
                          //       ],
                          //       onPressed: (int index) {
                          //         print(index);
                          //         setState(() {
                          //           isSelected[index] = !isSelected[index];
                          //         });
                          //       },
                          //       isSelected: isSelected,
                          //     ),
                          //   ),
                          Container(
                            margin: EdgeInsets.symmetric(horizontal: 5),
                            child: TextButton(
                              style: TextButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  elevation: 0,
                                  side: const BorderSide(
                                    color: Colors.black,
                                    width: 1,
                                  ),
                                  shadowColor: Colors.transparent,
                                  onSurface: Colors.white),
                              onPressed: () {},
                              child: Text("On Map"),
                            ),
                          ),
                        ],
                      ),
                    ]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
