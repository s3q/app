import 'dart:async';
import 'dart:math';
import 'dart:typed_data';

import 'package:app/helpers/appHelper.dart';
import 'package:app/helpers/colorsHelper.dart';
import 'package:app/helpers/geolocateHelper.dart';
import 'package:app/providers/activityProvider.dart';
import 'package:app/schemas/activitySchema.dart';
import 'package:app/screens/activityDetailsScreen.dart';
import 'package:app/screens/searchScreen.dart';
import 'package:app/widgets/activityCardMap.dart';
import 'package:custom_marker/marker_icon.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:maps_launcher/maps_launcher.dart';
import 'package:provider/provider.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:uuid/uuid.dart';

class MapScreen extends StatefulWidget {
  static String router = "/mapScreen";
  const MapScreen({Key? key}) : super(key: key);

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final Completer<GoogleMapController> _controller = Completer();
//   GoogleMapController? _controller;
  int page = 0;
  PageController pageController =
      PageController(initialPage: 0, viewportFraction: 0.8);

  Position? _currentPosition;
  TextEditingController _textEditingController = TextEditingController();
  bool openSearchAutocomplete = false;
  FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _focusNode.addListener(() {
      openSearchAutocomplete = _focusNode.hasFocus;
    });
  }

  @override
  Widget build(BuildContext context) {
    ActivityProvider activityProvider = Provider.of<ActivityProvider>(context);
    ActivitySchema args =
        ModalRoute.of(context)?.settings.arguments as ActivitySchema;

    List<ActivitySchema> activityList = [if (args != null) args];

    CameraPosition _initialCameraPosition = CameraPosition(
      target: LatLng(args.lat, args.lng),
      zoom: 10,
    );

    Marker _marker = Marker(
      markerId: MarkerId(Uuid().v4()),
      position: LatLng(args.lat, args.lng),
      infoWindow: InfoWindow(title: args.address, snippet: args.description),
    );

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            GoogleMap(
              initialCameraPosition: _initialCameraPosition,
              onMapCreated: (controller) {
                // setState(() {
                //   GoogleMapController _controller;
                // });

                _controller.complete(controller);
              },
              myLocationEnabled: true,
              myLocationButtonEnabled: true,
              mapType: MapType.normal,
              markers: {
                _marker,
              },
              onTap: (latLng) {
                FocusScope.of(context).unfocus();
              },
            ),
            Align(
              alignment: const AlignmentDirectional(-.9, .9),
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
            Positioned(
              top: 0,
              child: Container(
                width: MediaQuery.of(context).size.width,
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(top: 10, left: 10),
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50),
                                color: Colors.white),
                            child: IconButton(
                              // color: Colors.b,
                              icon: const Icon(Icons.arrow_back, size: 28),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            ),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                InkWell(
                                  onTap: () {
                                    Navigator.pushNamed(
                                        context, SearchScreen.router,
                                        arguments: [
                                          ...activityProvider
                                              .topActivitiesList.values,
                                          args
                                        ]);
                                  },
                                  focusColor: Colors.white12,
                                  child: Hero(
                                    tag: "search_box1",
                                    child: Container(
                                      // height: 50,
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 15, horizontal: 10),
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                            color: Colors.black45, width: 1),
                                        borderRadius: BorderRadius.circular(16),
                                        color: Colors.white,
                                      ),
                                      child: Row(children: [
                                        const Icon(
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
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),

                    // ToggleSwitch(
                    //   inactiveBgColor: Colors.white.withOpacity(.8),
                    //   activeBgColor: [Colors.grey.withOpacity(.8)],
                    //   initialLabelIndex: 0,
                    //   totalSwitches: 3,
                    //   labels: const ['America', 'Canada', 'Mexico'],
                    //   onToggle: (index) {
                    //     print('switched to: $index');
                    //   },
                    // ),

                    //   ..._getSearchResults().map((e) {
                    //     return GestureDetector(
                    //       onTap: () {
                    //         print("sss");
                    //       },
                    //       child: Container(
                    //         padding: EdgeInsets.all(10),
                    //         child: Text(e ?? "tttt"),
                    //       ),
                    //     );
                    //   }).toList(),

                    //    Container(
                    //       width: MediaQuery.of(context).size.width,
                    //       color: Colors.white,
                    //           padding: EdgeInsets.all(10),
                    //           child: Text("results ......"),
                    //         ),
                  ],
                ),
              ),
            ),
            Align(
              alignment: AlignmentDirectional(0, .7),
              child: Container(
                height: 120,
                width: MediaQuery.of(context).size.width,
                child: PageView.builder(
                  physics: BouncingScrollPhysics(),
                  //   dragStartBehavior: DragStartBehavior.down,
                  itemCount: activityList.length,
                  controller: pageController,
                  onPageChanged: (p) async {
                    // GoogleMapController con = _controller!;
                    GoogleMapController con = await _controller.future;
                    con.showMarkerInfoWindow(_marker.markerId);

                    con.animateCamera(CameraUpdate.newCameraPosition(
                        CameraPosition(target: _marker.position, zoom: 18)));
                  },
                  itemBuilder: (context, index) {
                    return ActivityCardMap(
                      activitySchema: activityList[index],
                      onClicked: () {
                        Navigator.pop(context);
                      },
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _carouselBuilder(
      int index, PageController controller, Widget customCardWidget) {
    return AnimatedBuilder(
      animation: controller,
      child: customCardWidget,
      builder: (context, child) {
        double value = 1.0;
        if (controller.position.haveDimensions) {
          value = controller.page! - index;
          value = (1 - (value.abs() * .30)).clamp(0.0, 1.0);
        }
        return Center(
          child: SizedBox(
            height: Curves.easeOut.transform(value) * 100,
            width: 200,
            child: child,
          ),
        );
      },
    );
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
                  zoom: 18.0,
                ),
              ),
            ));

        // _controller!.animateCamera(
        //   CameraUpdate.newCameraPosition(
        //     CameraPosition(
        //       target: LatLng(position.latitude, position.longitude),
        //       zoom: 18.0,
        //     ),
        //   ),
        // );
      });
    }).catchError((error, stackTrace) => null);
  }

  List<String> _getSearchResults() {
    return [
      _textEditingController.text,
    ];
  }
}
