import 'package:app/screens/addActivityScreen.dart';
import 'package:app/screens/profileScreen.dart';
import 'package:app/widgets/SafeScreen.dart';
import 'package:app/widgets/appBarWidget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:video_player/video_player.dart';

class OverViewAddActivityScreen extends StatefulWidget {
  static String router = "overview_add_activity";
  const OverViewAddActivityScreen({super.key});

  @override
  State<OverViewAddActivityScreen> createState() =>
      _OverViewAddActivityScreenState();
}

class _OverViewAddActivityScreenState extends State<OverViewAddActivityScreen> {
  Map<int, VideoPlayerController> _controllers = {};
  Map<int, Future<void>> _initializeVideoPlayersFuture = {};
  int indexOverView = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _controllers[1] = VideoPlayerController.network(
      'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4',
    );

    _initializeVideoPlayersFuture[1] = _controllers[1]!.initialize();
    if (_controllers[1] != null) {
      _controllers[1]!.setLooping(true);

      _controllers[1]!.play();
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();

    for (var c in _controllers.values) {
      c.dispose();
    }
  }

  @override
  Widget build(BuildContext context) {
    List overViewDescription = [
      // 1
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 100,
          ),
          Text(
            "Create Activity",
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(
            height: 20,
          ),
          FutureBuilder(
            future: _initializeVideoPlayersFuture[1],
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done &&
                  _controllers[1] != null) {
                return AspectRatio(
                  aspectRatio: _controllers[1]!.value.aspectRatio,
                  child: VideoPlayer(_controllers[1]!),
                );
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            },
          ),
          const SizedBox(
            height: 20,
          ),
          Text(
            "Enjoy adding promotional activities and interaction benefits to the platform",
            style: Theme.of(context).textTheme.displaySmall,
          ),
        ],
      ),

      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 100,
          ),
          Text(
            "reaching many users",
            style: Theme.of(context).textTheme.titleMedium,
          ),
          SizedBox(
            height: 20,
          ),
          Text(
            "add your social media accounts to reach a big number of costumers",
            style: Theme.of(context).textTheme.displaySmall,
          ),
        ],
      ),
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 100,
          ),
          Text(
            "follow statisics",
            style: Theme.of(context).textTheme.titleMedium,
          ),
          SizedBox(
            height: 20,
          ),
          Text(
            "try to improve your reaching your activities pages",
            style: Theme.of(context).textTheme.displaySmall,
          ),
        ],
      ),
    ];

    return SafeScreen(
      padding: 0,
      child: Column(
        children: [
          AppBarWidget(title: "Add Activity"),
          Expanded(
            child: ListView(
              children: [
                SizedBox(
                  height: 30,
                ),
                Padding(
                    padding: const EdgeInsets.all(10),
                    child: overViewDescription[indexOverView]),
                Container(
                  padding: EdgeInsets.all(15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      indexOverView > 0
                          ? ElevatedButton(
                              onPressed: () {
                                if (indexOverView > 0) {
                                  //!!!!!!!!!
                                  setState(() {
                                    indexOverView -= 1;
                                  });
                                }
                              },
                              style: ButtonStyle(
                                padding: MaterialStateProperty.all(
                                  const EdgeInsets.symmetric(
                                      horizontal: 60, vertical: 20),
                                ),
                              ),
                              child: Text("Back"),
                            )
                          : SizedBox(),
                      ElevatedButton(
                        onPressed: () async {
                          if (indexOverView < 2) {
                            //!!!!!!!!!

                            setState(() {
                              indexOverView += 1;
                            });
                          } else if (indexOverView == 2) {
                            Navigator.pushReplacementNamed(
                                context, AddActivityScreen.router);
                          }
                        },
                        style: ButtonStyle(
                          padding: MaterialStateProperty.all(
                            const EdgeInsets.symmetric(
                                horizontal: 60, vertical: 20),
                          ),
                        ),
                        child: Text("Next"),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
