import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:uuid/uuid.dart';

class GooglemapDescWidget extends StatefulWidget {
  Function() onChanged;
  LatLng latlan;
  GooglemapDescWidget(
      {super.key, required this.onChanged, required this.latlan});

  @override
  State<GooglemapDescWidget> createState() => _GooglemapDescWidgetState();
}

class _GooglemapDescWidgetState extends State<GooglemapDescWidget> {
  final Completer<GoogleMapController> _controller = Completer();

  late CameraPosition initialCameraPosition;

  late Marker _marker;
  @override
  Widget build(BuildContext context) {
    initialCameraPosition = CameraPosition(target: widget.latlan, zoom: 30);

    _marker = Marker(
      markerId: MarkerId(Uuid().v4()),
      position: widget.latlan,
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
    );

    return Material(
      color: Colors.white,
      child: InkWell(
        splashColor: Colors.white12, // inkwell color

        child: GoogleMap(
            onTap: (_latlng) {
                
            },
          mapType: MapType.normal,
          initialCameraPosition: initialCameraPosition,
          onMapCreated: (controller) {
            _controller.complete(controller);
          },
          markers: {
            _marker,
          },
        ),
      ),
    );
  }
}