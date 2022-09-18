import 'dart:async';

import 'package:app/helpers/geolocateHelper.dart';
import 'package:app/schemas/activitySchema.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:maps_launcher/maps_launcher.dart';
import 'package:searchfield/searchfield.dart';
import 'package:uuid/uuid.dart';

class PickLocationSceen extends StatefulWidget {
  static String router = "pick_location";
  const PickLocationSceen({super.key});

  @override
  State<PickLocationSceen> createState() => _PickLocationSceenState();
}

class _PickLocationSceenState extends State<PickLocationSceen> {
  final Completer<GoogleMapController> _controller = Completer();

  bool _selected = false;
  List _places = [];
  LatLng? latlan;

  Set _markers = {};

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
    CameraPosition _initialCameraPosition = CameraPosition(
      target: LatLng(23.601010, 58.313955),
      zoom: 20,
    );

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _getCurrentLocation();
        },
        child:  ClipOval(
          child: Container(
            width: 60,
            height: 60,
            color: Colors.white,
            child: Icon(
              Icons.my_location,
              size: 35,
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: Stack(
          children: [
            GoogleMap(
              initialCameraPosition: _initialCameraPosition,
              onMapCreated: (controller) {
                _controller.complete(controller);
              },
              myLocationEnabled: true,
              myLocationButtonEnabled: true,
              mapType: MapType.normal,
              markers: {..._markers},
              onTap: (_latlng) {
                // FocusScope.of(context).unfocus();
                print(_latlng);

                setState(() {
                  latlan = _latlng;

                  _markers = {
                    Marker(
                      markerId: MarkerId(Uuid().v4()),
                      position: _latlng,
                    )
                  };
                });
              },
            ),
            Positioned(
              top: 0,
              child: Container(
                width: MediaQuery.of(context).size.width,
                color: Colors.white,
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
                                SearchField(
                                  suggestions: _places
                                      .map((e) => SearchFieldListItem(e))
                                      .toList(),
                                  suggestionState: Suggestion.expand,
                                  textInputAction: TextInputAction.next,
                                  hint: 'search for places',
                                  hasOverlay: true,
                                  searchStyle: const TextStyle(
                                    fontSize: 18,
                                    color: Colors.black,
                                  ),
                                  validator: (x) {},
                                  onSubmit: (p0) {
                                    print(p0);
                                  },
                                  searchInputDecoration: InputDecoration(
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.black45,
                                      ),
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    border: OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.black45),
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                  ),
                                  maxSuggestionsInViewPort: 6,
                                  itemHeight: 40,
                                  onSuggestionTap: (x) {},
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            if (latlan != null)
              Align(
                alignment: AlignmentDirectional(0, .7),
                child: Container(
                    height: 120,
                    width: MediaQuery.of(context).size.width,
                    child: ElevatedButton(
                      child: Text("save"),
                      onPressed: () {
                        Navigator.pop(context, latlan);
                      },
                    )),
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

        latlan = LatLng(position.latitude, position.longitude);
      });
    }).catchError((error, stackTrace) => null);
  }

  List<String> _getSearchResults() {
    return [
      _textEditingController.text,
    ];
  }
}
