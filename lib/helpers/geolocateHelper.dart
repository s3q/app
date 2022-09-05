import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class GeolocateHelper {
  static Future<Position> determinePosition(BuildContext context) async {
    bool serviceEnabled;
    LocationPermission permission;

    permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        // Test if location services are enabled.
        await showDialog(
          barrierDismissible: false,
          context: context,
          builder: (BuildContext context) {
            return Expanded(
              child: AlertDialog(
                title: const Text('Location permissions'),
                content: const Text(
                    'We can\'t continue without location permissions'),
                actions: [
                  TextButton(
                    style: TextButton.styleFrom(primary: Colors.red[400]),
                    onPressed: () async {
                      Navigator.pop(context);
                    },
                    child: Text('Close'),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      permission = await Geolocator.requestPermission();
                      if (permission != LocationPermission.denied) {
                         Navigator.pop(context);
                      }
                    },
                    child: Text('Try again'),
                  ),
                ],
              ),
            );
          },
        ).then((value) => print(value));

        if (permission == LocationPermission.denied) {
          return Future.error('Location permissions are denied');
        }
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      await showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return Expanded(
            child: AlertDialog(
              title: const Text('Location permissions'),
              content:
                  const Text('We can\'t continue without location permissions'),
              actions: [
                TextButton(
                  style: TextButton.styleFrom(primary: Colors.red[400]),
                  onPressed: () async {
                    Navigator.pop(context);
                  },
                  child: Text('Close'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    permission = await Geolocator.requestPermission();
                                          if (permission != LocationPermission.denied && permission != LocationPermission.deniedForever) {
                         Navigator.pop(context);
                      }
                  },
                  child: Text('Try again'),
                ),
              ],
            ),
          );
        },
      );
      if (permission == LocationPermission.deniedForever) {
        return Future.error(
            'Location permissions are permanently denied, we cannot request permissions.');
      }
    }

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      print("localtion service Error");
      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (BuildContext context) {
            return Expanded(
              child: AlertDialog(
                title: const Text('Location services'),
                content: const Text(
                    'Location services are disabled!, enable it, and try again'),
                actions: [
                  TextButton(
                    style: TextButton.styleFrom(primary: Colors.red[400]),
                    onPressed: () async {
                      Navigator.pop(context);
                    },
                    child: Text('Close'),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      serviceEnabled = await Geolocator.openLocationSettings();
                      if (serviceEnabled) {
                         Navigator.pop(context);
                      }
                    },
                    child: Text('Try'),
                  ),
                ],
              ),
            );
          });
      if (!serviceEnabled) {
        return Future.error('Location services are disabled.');
      }
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }
}
