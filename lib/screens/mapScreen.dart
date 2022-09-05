import 'dart:async';
import 'dart:math';
import 'dart:typed_data';

import 'package:app/helpers/colorsHelper.dart';
import 'package:app/helpers/geolocateHelper.dart';
import 'package:app/schemas/activitySchema.dart';
import 'package:custom_marker/marker_icon.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:maps_launcher/maps_launcher.dart';
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
    final args = ModalRoute.of(context)?.settings.arguments as ActivitySchema;

    List<ActivitySchema> activityList = [
      ActivitySchema(
        latitude: args.latitude,
        longitude: args.longitude,
        address: args.address,
        description: args.description,
        imagePath: args.imagePath,
      ),
      ActivitySchema(
        latitude: 22.995735366806212,
        longitude: 58.13756972877766,
        address: args.address,
        description: args.description,
        imagePath: args.imagePath,
      ),
      ActivitySchema(
        latitude: 23.244037241974922,
        longitude: 58.091192746314015,
        address: args.address,
        description: args.description,
        imagePath: args.imagePath,
      ),
    ];

    CameraPosition _initialCameraPosition = CameraPosition(
      target: LatLng(args.latitude, args.longitude),
      zoom: 20,
    );

    Marker _marker = Marker(
      markerId: MarkerId(Uuid().v4()),
      position: LatLng(args.latitude, args.longitude),
      infoWindow: InfoWindow(title: args.address, snippet: args.description),
    );

    List<Marker> _markers = activityList.map((e) {
      return Marker(
        flat: true,
        markerId: MarkerId(Uuid().v4()),
        position: LatLng(e.latitude, e.longitude),
        infoWindow: InfoWindow(title: e.address, snippet: e.description),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRose),
      );
    }).toList();



    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            GoogleMap(
              initialCameraPosition: _initialCameraPosition,
              onMapCreated: ((controller) {
                _controller.complete(controller);
              }),
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
              alignment: AlignmentDirectional(-.9, .9),
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
                          margin: EdgeInsets.only(top: 10, left: 10),
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50),
                                color: Colors.white),
                            child: IconButton(
                              // color: Colors.b,
                              icon: Icon(Icons.arrow_back, size: 28),
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
                                TextFormField(
                                  controller: _textEditingController,
                                  obscureText: false,
                                  focusNode: _focusNode,
                                  decoration: InputDecoration(
                                    hintText: 'Where to go?',
                                    fillColor: Color(0xFFECF6FF),
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Color(0x00000000),
                                        width: 1,
                                      ),
                                      borderRadius: BorderRadius.circular(24),
                                    ),
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Color(0x00000000),
                                        width: 0,
                                      ),
                                      borderRadius: BorderRadius.circular(24),
                                    ),
                                    filled: true,
                                    prefixIcon: Icon(
                                      size: 30,
                                      Icons.search,
                                    ),
                                  ),
                                ),
                                Container(
                                  height: openSearchAutocomplete ? null : 0,
                                  margin: EdgeInsets.symmetric(vertical: 10),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(.8),
                                    borderRadius: BorderRadius.circular(24),
                                  ),
                                  child: Column(
                                    children: const [
                                      Padding(
                                        padding: EdgeInsets.all(8.0),
                                        child: Text("results ......"),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.all(8.0),
                                        child: Text("results ......"),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.all(8.0),
                                        child: Text("results ......"),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),

                    ToggleSwitch(
                      inactiveBgColor: Colors.white.withOpacity(.8),
                      activeBgColor: [Colors.grey.withOpacity(.8)],
                      initialLabelIndex: 0,
                      totalSwitches: 3,
                      labels: ['America', 'Canada', 'Mexico'],
                      onToggle: (index) {
                        print('switched to: $index');
                      },
                    ),

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
                    GoogleMapController con = await _controller.future;
                    con.showMarkerInfoWindow(_markers[p].markerId);

                    con.animateCamera(CameraUpdate.newCameraPosition(
                        CameraPosition(
                            target: _markers[p].position, zoom: 18)));
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
                              children: [
                                Image.asset(
                                  activityList[index].imagePath,
                                  fit: BoxFit.cover,
                                  height: 100,
                                  width: 100,
                                ),
                                Container(
                                  margin: EdgeInsets.all(10),
                                  child: Column(
                                    children: [
                                      Text(
                                        activityList[index].address,
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleMedium,
                                        softWrap: true,
                                      ),
                                      Text(
                                        activityList[index].address,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium,
                                        overflow: TextOverflow.fade,
                                      ),
                                    ],
                                  ),
                                ),
                                IconButton(
                                  onPressed: () async {
                                    await MapsLauncher.launchCoordinates(
                                      _markers[index].position.latitude,
                                      _markers[index].position.longitude,
                                    );
                                  },
                                  icon: Icon(Icons.assistant_navigation),
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
      });
    }).catchError((error, stackTrace) => null);
  }

  List<String> _getSearchResults() {
    return [
      _textEditingController.text,
    ];
  }
}
