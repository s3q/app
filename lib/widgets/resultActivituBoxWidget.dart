import 'package:app/providers/activityProvider.dart';
import 'package:app/schemas/activitySchema.dart';
import 'package:app/widgets/activity/reviewsTextActivity.dart';
import 'package:app/widgets/textIocnActWidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:maps_launcher/maps_launcher.dart';
import 'package:provider/provider.dart';

class ResultActivituBoxWidget extends StatefulWidget {
  ActivitySchema activitySchema;
  Function() showOnMap;
  Function() onClicked;
  ResultActivituBoxWidget(
      {super.key,
      required this.activitySchema,
      required this.showOnMap,
      required this.onClicked});

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
    ActivityProvider activityProvider = Provider.of<ActivityProvider>(context);
    // widget.activitySchema.images
    //     .removeWhere((e) => e == null || e.toString().trim() == "");
    return Container(
      margin: EdgeInsets.symmetric(vertical: 20),
      height: 240,
      child: InkWell(
        onTap: widget.onClicked,
        child: Card(
          clipBehavior: Clip.antiAliasWithSaveLayer,
          elevation: 3,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              Image.network(
                activityProvider.mainDisplayImage(widget.activitySchema.images),
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
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                widget.activitySchema.title,
                                style: Theme.of(context).textTheme.titleMedium,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              Column(
                                children: [
                                  ReviewsTextActivity(
                                      activitySchema: widget.activitySchema),
                                  TextIconInfoActWidget(
                                    text: widget.activitySchema.address,
                                    icon: Icons.location_on_rounded,
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisSize: MainAxisSize.max,
                                //  crossAxisAlignment: CrossAxisAlignment.end,
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(
                                    activityProvider
                                        .startFromPrice(
                                            widget.activitySchema.prices)
                                        .toString(),
                                    style:
                                        Theme.of(context).textTheme.bodyLarge,
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Text('OMR'),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(vertical: 5),
                          child: Row(
                            children: [
                              Container(
                                margin: EdgeInsets.symmetric(horizontal: 5),
                                child: ElevatedButton.icon(
                                  onPressed: () {
                                    EasyLoading.show();

                                    MapsLauncher.launchCoordinates(
                                      widget.activitySchema.lat,
                                      widget.activitySchema.lng,
                                    );
                                    EasyLoading.dismiss();
                                  },
                                  label: Text("Google Map"),
                                  icon: Icon(
                                    Icons.assistant_navigation,
                                    size: 25,
                                  ),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.symmetric(horizontal: 5),
                                child: IconButton(
                                  onPressed: () {
                                    widget.showOnMap();
                                  },
                                  icon: const Icon(
                                    Icons.gps_fixed_rounded,
                                    size: 25,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ]),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
