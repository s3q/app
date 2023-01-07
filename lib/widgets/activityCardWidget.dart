import 'package:app/helpers/colorsHelper.dart';
import 'package:app/providers/activityProvider.dart';
import 'package:app/providers/userProvider.dart';
import 'package:app/schemas/activitySchema.dart';
import 'package:app/widgets/activity/reviewsTextActivity.dart';
import 'package:app/widgets/textBoxActWidget.dart';
import 'package:app/widgets/textIocnActWidget.dart';
import 'package:app/widgets/wishlistIconButtonWidget.dart';
import 'package:firebase_storage/firebase_storage.dart';
import "package:flutter/material.dart";
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class ActivityCardWidget extends StatefulWidget {
  Function() onPressed;
  ActivitySchema activity;
  ActivityCardWidget(
      {Key? key, required this.activity, required this.onPressed})
      : super(key: key);

  @override
  State<ActivityCardWidget> createState() => _ActivityCardWidgetState();
}

class _ActivityCardWidgetState extends State<ActivityCardWidget> {
  List<bool> isSelected = [
    false,
  ];

//   Future loadimage() async {
//     String link = await FirebaseStorage.instance
//         .ref(widget.activity.images[0])
//         .getDownloadURL();
//     print(link);
//   }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // Future.delayed(Duration.zero, () => loadimage());
  }

  @override
  Widget build(BuildContext context) {
    UserProvider userProvider = Provider.of<UserProvider>(context);
    ActivityProvider activityProvider = Provider.of<ActivityProvider>(context);
    return Container(
      margin: EdgeInsets.symmetric(vertical: 20),
      child: Stack(
        children: [
          GestureDetector(
            onTap: widget.onPressed,
            child: Card(
              clipBehavior: Clip.antiAliasWithSaveLayer,
              elevation: 3,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: 170,
                    child: Stack(
                      children: [
                        Hero(
                          tag: widget.activity.images[0],
                          child: Image.network(
                            // "",
                            widget.activity.images[0].toString(),
                            width: MediaQuery.of(context).size.width,
                            height: 170,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Align(
                            alignment: const Alignment(1, -1),
                            child: Container(
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(10),
                                  bottomLeft: Radius.circular(10),
                                ),
                              ),
                              child: WishlistIconButtonWidget( activityStoreId:  widget.activity.storeId!,
                                  activityId: widget.activity.Id),
                            )),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 18, horizontal: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.activity.title,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(
                          height: 15,
                        ),

                           TextIconInfoActWidget(
                              text:  widget.activity.address,
                              icon: Icons.location_on_rounded,
                              //  style: Theme.of(context).textTheme.bodySmall,
                            ),
                    

                        // ! SizedBox(
                        //   height: 10,
                        // ),
                        // Row(
                        //   mainAxisSize: MainAxisSize.max,
                        //   children: [
                        //     Icon(
                        //       Icons.timelapse_sharp,
                        //       size: 20,
                        //     ),
                        //     Padding(
                        //       padding:
                        //           EdgeInsetsDirectional.fromSTEB(5, 0, 0, 0),
                        //       child: Text(
                        //         "",
                        //         style: Theme.of(context).textTheme.bodyMedium,
                        //       ),
                        //     ),
                        //   ],
                        // ),

                        Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ReviewsTextActivity(activitySchema: widget.activity),
                            Padding(
                              padding:
                                  EdgeInsetsDirectional.fromSTEB(0, 20, 10, 0),
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Align(
                                    alignment: const AlignmentDirectional(0, 0),
                                    child: Text(
                                      'Starting From',
                                      textAlign: TextAlign.start,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium,
                                    ),
                                  ),
                                  Row(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Text(
                                        activityProvider
                                            .startFromPrice(
                                                widget.activity.prices)
                                            .toString(),
                                        // ! widget.activity.priceStartFrom.toString(),
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyLarge,
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
                          ],
                        ),
                        // Container(
                        //   decoration: BoxDecoration(
                        //     color: Color(0xFFD6D6D6),
                        //     borderRadius: BorderRadius.circular(8),
                        //   ),
                        //   child: Padding(
                        //     padding: EdgeInsetsDirectional.fromSTEB(5, 5, 5, 5),
                        //     child: Text(
                        //       'private only',
                        //       // style:
                        //     ),
                        //   ),
                        // ),

                        Row(
                          children: [
                            if (widget.activity.genderSuitability["woman"] ==
                                    true &&
                                (widget.activity.genderSuitability["man"] ==
                                        false ||
                                    widget.activity.genderSuitability["man"] ==
                                        null))
                              TextBoxActWidget(
                                text: "Women only",
                              ),
                            if (widget.activity.suitableAges["min"] != null &&
                                widget.activity.suitableAges["min"]
                                        .toString()
                                        .trim() !=
                                    "")
                              TextBoxActWidget(
                                text:
                                    "Above ${widget.activity.suitableAges["min"].toString()}",
                              ),
                            if (widget.activity.op_GOA == true)
                              TextBoxActWidget(
                                text: "Private group",
                              ),
                          ],
                        ),
                        // Row(
                        //   mainAxisAlignment: MainAxisAlignment.end,
                        //   children: [
                        //     Container(
                        //       margin: EdgeInsets.symmetric(horizontal: 5),
                        //       child: ToggleButtons(
                        //         selectedColor: Colors.black87,
                        //         selectedBorderColor: Colors.transparent,
                        //         borderColor: Colors.transparent,
                        //         splashColor: Colors.transparent,
                        //         fillColor: Colors.transparent,
                        //         children: [
                        //           isSelected[0]
                        //               ? Icon(
                        //                   Icons.bookmark,
                        //                   size: 30,
                        //                 )
                        //               : Icon(
                        //                   Icons.bookmark_border,
                        //                   size: 30,
                        //                 ),
                        //         ],
                        //         onPressed: (int index) {
                        //           print(index);
                        //           setState(() {
                        //             isSelected[index] = !isSelected[index];
                        //           });
                        //         },
                        //         isSelected: isSelected,
                        //       ),
                        //     ),
                        //     Container(
                        //       margin: EdgeInsets.symmetric(horizontal: 5),
                        //       child: ElevatedButton.icon(
                        //         onPressed: () {},
                        //         icon: Icon(
                        //           Icons.share,
                        //           size: 30,
                        //         ),
                        //         label: Text("Share"),
                        //       ),
                        //     ),
                        //   ],
                        // ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          //   Align(
          //     alignment: AlignmentDirectional(.9, 9),
          //     child: Container(
          //       //   padding: EdgeInsets.all(10),
          //       decoration: BoxDecoration(
          //         borderRadius: BorderRadius.circular(10),
          //         color: Colors.white,
          //       ),
          //       child: Row(
          //         mainAxisSize: MainAxisSize.min,
          //         children: [
          //           Container(
          //             margin: EdgeInsets.symmetric(horizontal: 5),
          //             child: ToggleButtons(
          //               selectedColor: Colors.red,
          //               selectedBorderColor: Colors.transparent,
          //               borderColor: Colors.transparent,
          //               splashColor: Colors.transparent,
          //               fillColor: Colors.transparent,
          //               children: [
          //                 isSelected[0]
          //                     ? Icon(
          //                         Icons.bookmark,
          //                         size: 30,
          //                       )
          //                     : Icon(
          //                         Icons.bookmark_border,
          //                         size: 30,
          //                       ),
          //               ],
          //               onPressed: (int index) {
          //                 print(index);
          //                 setState(() {
          //                   isSelected[index] = !isSelected[index];
          //                 });
          //               },
          //               isSelected: isSelected,
          //             ),
          //           ),
          //           Container(
          //             margin: EdgeInsets.symmetric(horizontal: 5),
          //             child: ElevatedButton.icon(
          //               onPressed: () {},
          //               icon: Icon(
          //                 Icons.share,
          //                 size: 30,
          //               ),
          //               label: Text(""),
          //             ),
          //           ),
          //         ],
          //       ),
          //     ),
          //   ),
        ],
      ),
    );
  }
}
