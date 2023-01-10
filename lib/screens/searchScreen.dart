import 'dart:async';

import 'package:app/helpers/adHelper.dart';
import 'package:app/helpers/appHelper.dart';
import 'package:app/helpers/colorsHelper.dart';
import 'package:app/helpers/geolocateHelper.dart';
import 'package:app/providers/activityProvider.dart';
import 'package:app/providers/userProvider.dart';
import 'package:app/schemas/activitySchema.dart';
import 'package:app/screens/activityDetailsScreen.dart';
import 'package:app/widgets/SafeScreen.dart';
import 'package:app/widgets/activityCardMap.dart';
import 'package:app/widgets/loadingWidget.dart';
import 'package:app/widgets/resultActivituBoxWidget.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:maps_launcher/maps_launcher.dart';
import 'package:provider/provider.dart';
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
  DraggableScrollableController draggableScrollableController =
      DraggableScrollableController();

  List<ActivitySchema> activitiesList = [];
  List<ActivitySchema> activitiesResultList = [];
  List<Marker>? markersList;

  final _initialCameraPosition = const CameraPosition(
    target: LatLng(23.244037241974922, 58.091192746314015),
    zoom: 10,
  );

  int page = 0;
  PageController pageController =
      PageController(initialPage: 0, viewportFraction: 0.8);
  FocusNode _focusNode = FocusNode();

  final Completer<GoogleMapController> _controller = Completer();
  Position? _currentPosition;

  fetchAllActivities() {
    Future.delayed(Duration(milliseconds: 1000), () async {
      try {
        ActivityProvider activityProvider =
            Provider.of<ActivityProvider>(context, listen: false);

        activitiesList = await activityProvider.fetchAllActivites();
        print("DDUUUUUUUU");
        print(activitiesList.length);
        setState(() {
          activitiesList = activitiesList;

          _isLoading = false;
        });
        print(_isLoading);
      } catch (err) {
        print(err);
      }
    });
  }

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
                  zoom: 10,
                ),
              ),
            ));
      });
    }).catchError((error, stackTrace) => null);
  }

  Future _getActivityNearYourPoint() async {
    ActivityProvider activityProvider =
        Provider.of<ActivityProvider>(context, listen: false);
    await _getCurrentLocation();
    activitiesList = await activityProvider.fetchActivitiesNearLocation(
        LatLng(_currentPosition!.latitude, _currentPosition!.latitude));
    setState(() {
      activitiesList = activitiesList;
    });
  }

//   Map _appCatogeriesSelected =
//       AppHelper.categories.asMap().map((k, v) => MapEntry(v["title"], false));
  String categorySelected = "discover_all";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _tabController = TabController(length: 2, vsync: this);

    Future.delayed(Duration(milliseconds: 1000), () async {
      setState(() {
        _isLoading = false;
      });
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  int onceCheck = 0;

  @override
  Widget build(BuildContext context) {
    print("build serach page");
    UserProvider userProvider = Provider.of<UserProvider>(context);
    ActivityProvider activityProvider = Provider.of<ActivityProvider>(context);

    if (onceCheck == 0) {
      final args = ModalRoute.of(context)?.settings.arguments != null
          ? ModalRoute.of(context)?.settings.arguments as List<ActivitySchema>
          : ModalRoute.of(context)?.settings.arguments;

      if (args == null) {
        fetchAllActivities();
      } else {
        setState(() {
          activitiesList = args as List<ActivitySchema>;
        
          categorySelected = AppHelper.categories
              .where((e) => e["title"] == activitiesList[0].category)
              .toList()[0]["key"];
        });
      }

      onceCheck = 1;
    }

    print(categorySelected);
    // if (args != null) activitiesList.add(args);

    // Marker _marker = Marker(
    //   markerId: MarkerId(Uuid().v4()),
    //   position: LatLng(activitiesList[0].lat, activitiesList[0].lng),
    //   infoWindow: InfoWindow(
    //     title: activitiesList[0].address,
    //   ),
    // );

    List<Marker> markersList = activitiesList
        .asMap()
        .map((i, e) {
          return MapEntry(
              i,
              Marker(
                flat: true,
                markerId: MarkerId(e.Id),
                position: LatLng(e.lat, e.lng),
                infoWindow: InfoWindow(
                  title: e.address,
                  // !  snippet: (e.priceStartFrom.toString() + "\$"),
                ),
                icon: BitmapDescriptor.defaultMarkerWithHue(
                    BitmapDescriptor.hueRose),
                onTap: () {
                  pageController.animateToPage(i,
                      duration: const Duration(milliseconds: 400),
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
          markers: markersList != null ? {...markersList!} : {},
          onTap: (latLng) {
            print("Clicked on map");
            FocusScope.of(context).unfocus();
          },
        ),
        Align(
          alignment: const AlignmentDirectional(-.9, .5),
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
                  child: const SizedBox(
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

        // if (activitiesList != null)
        Align(
          alignment: const AlignmentDirectional(0, .8),
          child: Container(
            height: 120,
            width: MediaQuery.of(context).size.width,
            child: PageView.builder(
              physics: const BouncingScrollPhysics(),
              //   dragStartBehavior: DragStartBehavior.down,
              itemCount: activitiesList.length,
              controller: pageController,
              onPageChanged: (p) async {
                if (markersList != null) {
                  GoogleMapController con = await _controller.future;

                  con.showMarkerInfoWindow(markersList[p].markerId);

                  con.animateCamera(CameraUpdate.newCameraPosition(
                      CameraPosition(
                          target: markersList[p].position, zoom: 18)));
                }
              },
              itemBuilder: (context, index) {
                return Align(
                  key: Key(Uuid().v4()),
                  alignment: Alignment.topCenter,
                  child: ActivityCardMap(
                    onClicked: () async {
                      EasyLoading.show();

                      Navigator.pushNamed(context, ActivityDetailsScreen.router,
                          arguments: activitiesList[index]);
                      await Future.delayed(Duration(milliseconds: 1000));
                      EasyLoading.dismiss();
                    },
                    activitySchema: activitiesList[index],
                  ),
                );
              },
            ),
          ),
        ),
        DraggableScrollableSheet(
            controller: draggableScrollableController,
            initialChildSize: 0.75,
            maxChildSize: 0.75,
            minChildSize: 0.12,
            snapSizes: [0.12, 0.75],
            snap: true,
            builder: (context, scrollController) {
              return Container(
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
                child: ListView.builder(
                  controller: scrollController,
                  itemCount: activitiesList.length,
                  itemBuilder: (context, index) {
                    ActivitySchema a = activitiesList[index];
                    return Column(
                      children: [
                        if (index == 0)
                          Container(
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
                        if (index == 0)
                          SizedBox(
                            height: 20,
                          ),
                        Container(
                          key: Key(Uuid().v4()),
                          padding: EdgeInsets.all(10),
                          child: ResultActivituBoxWidget(
                            onClicked: () async {
                              EasyLoading.show();

                              Navigator.pushNamed(
                                  context, ActivityDetailsScreen.router,
                                  arguments: a);
                              await Future.delayed(
                                  Duration(milliseconds: 1000));

                              EasyLoading.dismiss();
                            },
                            activitySchema: a,
                            showOnMap: () async {
                              draggableScrollableController.animateTo(0.1,
                                  duration: Duration(milliseconds: 500),
                                  curve: Curves.easeInOut);

                              GoogleMapController con =
                                  await _controller.future;
                              Marker __markerA = markersList
                                  .where((element) =>
                                      element.markerId == MarkerId(a.Id))
                                  .toList()[0];
                              con.showMarkerInfoWindow(__markerA.markerId);

                              con.animateCamera(CameraUpdate.newCameraPosition(
                                  CameraPosition(
                                      target: __markerA.position, zoom: 18)));
                            },
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                      ],
                    );
                  },
                ),
                // Container(
                //   decoration: BoxDecoration(
                //     color: Colors.white,
                //   ),
                //   child: Center(
                //     child: Container(
                //       padding: EdgeInsets.symmetric(vertical: 20),
                //       decoration: BoxDecoration(
                //           borderRadius: BorderRadius.circular(50),
                //           color: ColorsHelper.grey),
                //       width: 70,
                //       height: 6,
                //     ),
                //   ),
                // ),
              );
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
                      icon: const Icon(
                        Icons.arrow_back_rounded,
                        size: 28,
                      ),
                    ),
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.all(10),
                        // child: Stack(
                        //   children: [
                        //     Positioned(
                        //         bottom: -10,
                        //       child: Column(
                        //           children: const [
                        //               ListTile(
                        //                 title: Text(""),
                        //               ),
                        //                ListTile(
                        //                 title: Text(""),
                        //               ),
                        //                ListTile(
                        //                 title: Text(""),
                        //               ),
                        //           ],
                        //       ),
                        //     ),
                        child: GestureDetector(
                          onTap: () async {
                            try {
                              //   activitiesList =
                              //       await Navigator.push(context, "")
                              //           as List<ActivitySchema>;
                            } catch (err) {}
                          },
                          child: TextFormField(
                            onFieldSubmitted: (v) async {
                              EasyLoading.show();

                              HttpsCallableResult r = await FirebaseFunctions
                                  .instance
                                  .httpsCallable("SearchForActivity")
                                  .call(v);

                              List<ActivitySchema> acl = [];
                              for (var activityMap in r.data) {
                                print(ActivitySchema.toSchema(activityMap));
                                acl.add(ActivitySchema.toSchema(activityMap));
                              }
                              setState(() {
                                activitiesList = acl;
                              });
                              EasyLoading.dismiss();
                            },
                            onChanged: (v) async {
                              EasyLoading.show();

                              HttpsCallableResult r = await FirebaseFunctions
                                  .instance
                                  .httpsCallable("SearchForActivityDirectly")
                                  .call(v);
                              // (_createTime, _fieldsProto, _ref, _serializer, _readTime, _updateTime)
                              //   print(r.data);

                              print(r.data.length);

                              List<ActivitySchema> acl = [];
                              for (var activityMap in r.data) {
                                print(ActivitySchema.toSchema(activityMap));
                                acl.add(ActivitySchema.toSchema(activityMap));
                              }
                              setState(() {
                                activitiesList = acl;
                              });
                              EasyLoading.dismiss();
                            },
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
                        //   ],
                        // ),
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
              const SizedBox(
                height: 10,
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    ...AppHelper.categories.map((e) {
                      print(categorySelected);
                      print(categorySelected == e["key"]);
                      return Container(
                        margin: EdgeInsets.symmetric(horizontal: 10),
                        child: OutlinedButton(
                          onPressed: () async {
                            EasyLoading.show();

                            HttpsCallableResult r = await FirebaseFunctions
                                .instance
                                .httpsCallable("SearchForActivity")
                                .call(e["title"]);

                            activitiesList = [];
                            for (var activityMap in r.data) {
                              print(activityMap);
                              activitiesList
                                  .add(ActivitySchema.toSchema(activityMap));
                            }

                            setState(() {
                              activitiesList = activitiesList;
                              categorySelected = e["key"];
                            });
                            EasyLoading.dismiss();
                          },
                          style: OutlinedButton.styleFrom(
                            primary: Colors.black87,
                            backgroundColor: categorySelected == e["key"]
                                ? ColorsHelper.yellow.withOpacity(0.4)
                                : null,
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
        Container(
            //   child: Expanded(
            // child: ListView.builder(
            //     itemCount: activitiesResultList.length,
            //     itemBuilder: (context, index) {
            //           ActivitySchema e = activitiesResultList[index];
            //           return GestureDetector(
            //             key: Key(e.Id),
            //             onTap: () async {
            //               activitiesList.add(e);
            //               setState(() {
            //                 activitiesList;
            //               });

            //               draggableScrollableController.animateTo(0.1,
            //                   duration: const Duration(milliseconds: 500),
            //                   curve: Curves.easeInOut);

            //               GoogleMapController con = await _controller.future;
            //               Marker __markerA = markersList
            //                   .where((element) =>
            //                       element.markerId == MarkerId(e.Id))
            //                   .toList()[0];
            //               con.showMarkerInfoWindow(__markerA.markerId);

            //               con.animateCamera(CameraUpdate.newCameraPosition(
            //                   CameraPosition(
            //                       target: __markerA.position, zoom: 30)));
            //             },
            //             child: Container(
            //               margin: EdgeInsets.symmetric(vertical: 10),
            //               child: Column(children: [
            //                 Text(
            //                   e.title,
            //                   overflow: TextOverflow.ellipsis,
            //                 ),
            //                 SizedBox(
            //                   height: 5,
            //                 ),
            //                 Text(
            //                   e.address,
            //                   style: Theme.of(context).textTheme.bodySmall,
            //                 )
            //               ]),
            //             ),
            //           );
            //         }),
            //   ),

            //   Column(children: [

            //     ...activitiesResultList.map(
            //       (e) {

            //       },
            //     ).toList()
            //   ]),
            ),
      ]),
    );
  }
}
