import 'package:app/providers/activityProvider.dart';
import 'package:app/schemas/activitySchema.dart';
import 'package:app/widgets/textIocnActWidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:maps_launcher/maps_launcher.dart';
import 'package:provider/provider.dart';

class ActivityCardMap extends StatelessWidget {
  ActivitySchema activitySchema;
  Function() onClicked;
  ActivityCardMap({
    super.key,
    required this.activitySchema,
    required this.onClicked,
  });

  @override
  Widget build(BuildContext context) {
    ActivityProvider activityProvider = Provider.of<ActivityProvider>(context);
    return Container(
      margin: EdgeInsets.all(8),
      height: 100,
      // height: PAGER_HEIGHT * scale,
      // width: MediaQuery.of(context).size.width,
      child: InkWell(
        onTap: onClicked,
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
                    Stack(
                      children: [
                        Image.network(
                          activityProvider
                              .mainDisplayImage(activitySchema.images),
                          fit: BoxFit.cover,
                          height: 100,
                          width: 100,
                        ),
                        IconButton(
                          onPressed: () async {
                            EasyLoading.show();
                            await MapsLauncher.launchCoordinates(
                              activitySchema.lat,
                              activitySchema.lng,
                            );
                            EasyLoading.dismiss();
                          },
                          icon: Icon(Icons.assistant_navigation),
                        ),
                      ],
                    ),
                    Container(
                      margin: EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            activitySchema.title,
                            style: Theme.of(context).textTheme.titleSmall,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),

                          Text(
                            "" + activitySchema.category,
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall!
                                .copyWith(
                                    fontSize: Theme.of(context)
                                            .textTheme
                                            .bodySmall!
                                            .fontSize! -
                                        3),
                            softWrap: true,
                          ),

                          Column(
                            children: [
                              RatingBarIndicator(
                                itemBuilder: (context, index) {
                                  return const Icon(
                                    Icons.star_rate_rounded,
                                    color: Colors.amber,
                                  );
                                },
                                rating: activityProvider
                                    .previewMark(activitySchema.reviews),
                                itemSize: 20,
                              ),
                              Row(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Icon(
                                    Icons.location_on_rounded,
                                    color: Colors.grey,
                                    size: 14,
                                  ),
                                  Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        5, 0, 0, 0),
                                    child: Text(
                                      activitySchema.address,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall!
                                          .copyWith(
                                              fontSize: Theme.of(context)
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
