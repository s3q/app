import 'package:app/providers/activityProvider.dart';
import 'package:app/schemas/activitySchema.dart';
import 'package:app/schemas/activityStatisticsSchema.dart';
import 'package:app/screens/viewReviewsScreen.dart';
import 'package:app/widgets/SafeScreen.dart';
import 'package:app/widgets/appBarWidget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ActivityStatisticsScreen extends StatefulWidget {
  ActivityStatisticsScreen({super.key});

  @override
  State<ActivityStatisticsScreen> createState() =>
      _ActivityStatisticsScreenState();
}

class _ActivityStatisticsScreenState extends State<ActivityStatisticsScreen> {
  @override
  Widget build(BuildContext context) {
    ActivityProvider activityProvider = Provider.of<ActivityProvider>(context);
    ActivitySchema activitySchema =
        ModalRoute.of(context)?.settings.arguments as ActivitySchema;
    return SafeScreen(
        padding: 0,
        child: Column(
          children: [
            AppBarWidget(title: "Statistics"),
            FutureBuilder(
                future:
                    activityProvider.fetchActivityStatistics(activitySchema.Id),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState ||
                      !snapshot.hasData ||
                      (snapshot.data.runtimeType == ActivityStatisticsSchema)) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  ActivityStatisticsSchema activityStatisticsSchema =
                      snapshot.data as ActivityStatisticsSchema;
                  return Expanded(
                    child: ListView(
                      children: [
                        const SizedBox(
                          height: 30,
                        ),
                        ListTile(
                          title: Row(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              const Icon(
                                Icons.star_rounded,
                                color: Color(0xFFFFA130),
                                size: 25,
                              ),
                              Padding(
                                padding:
                                    EdgeInsetsDirectional.fromSTEB(4, 0, 0, 0),
                                child: Text(
                                  activityProvider
                                          .previewMark(activitySchema.reviews)
                                          .toString() +
                                      "/5",
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                              ),
                              Padding(
                                padding:
                                    EdgeInsetsDirectional.fromSTEB(8, 0, 0, 0),
                                child: Text(
                                  activitySchema.reviews.length.toString() +
                                      ' reviews',
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                              ),
                            ],
                          ),
                          trailing: OutlinedButton(
                            onPressed: () {
                              print('Button pressed ...');
                              Navigator.pushNamed(
                                  context, ViewReviewScreen.router,
                                  arguments: activitySchema);
                            },
                            style: OutlinedButton.styleFrom(
                                // primary: ColorsHelper.green,
                                // padding: EdgeInsets.symmetric(
                                //     vertical: 10, horizontal: 30),
                                // side:
                                //     BorderSide(width: 3, color: ColorsHelper.green),
                                // shape: RoundedRectangleBorder(
                                //   borderRadius: BorderRadius.circular(8),
                                // ),
                                ),
                            child: const Text('see reviews'),
                          ),
                        ),
                        Container(
                            padding: EdgeInsets.all(8),
                            margin: EdgeInsets.symmetric(vertical: 10),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Icon(Icons.people_alt_rounded),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      "Views Count ",
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleLarge,
                                    ),
                                  ],
                                ),
                                Text(
                                    "The number of times your ad was viewed by the customer"),
                                Text(
                                  activityStatisticsSchema.viewsCount
                                      .toString(),
                                  style: Theme.of(context).textTheme.titleLarge,
                                ),
                                Divider(
                                  thickness: 1,
                                )
                              ],
                            )),
                        Container(
                            padding: EdgeInsets.all(8),
                            margin: EdgeInsets.symmetric(vertical: 10),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Icon(Icons.call_rounded),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      "Calls Count ",
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleLarge,
                                    ),
                                  ],
                                ),
                                Text(
                                    "The number of times your ad was viewed by the customer"),
                                Text(
                                  activityStatisticsSchema.callsCount
                                      .toString(),
                                  style: Theme.of(context).textTheme.titleLarge,
                                ),
                                Divider(
                                  thickness: 1,
                                )
                              ],
                            )),
                        Container(
                            padding: EdgeInsets.all(8),
                            margin: EdgeInsets.symmetric(vertical: 10),
                            child: Column(
                              children: [
                                Text(
                                  "Likes Count ",
                                  style: Theme.of(context).textTheme.titleLarge,
                                ),
                                Text(
                                    "The number of times your ad was viewed by the customer"),
                                Text(
                                  activityStatisticsSchema.likesCount
                                      .toString(),
                                  style: Theme.of(context).textTheme.titleLarge,
                                ),
                                Divider(
                                  thickness: 1,
                                )
                              ],
                            )),
                        Container(
                            padding: EdgeInsets.all(8),
                            margin: EdgeInsets.symmetric(vertical: 10),
                            child: Column(
                              children: [
                                Text(
                                  "Shares Count ",
                                  style: Theme.of(context).textTheme.titleLarge,
                                ),
                                Text(
                                    "The number of times your ad was viewed by the customer"),
                                Text(
                                  activityStatisticsSchema.sharesCount
                                      .toString(),
                                  style: Theme.of(context).textTheme.titleLarge,
                                ),
                                Divider(
                                  thickness: 1,
                                )
                              ],
                            )),
                        Container(
                            padding: EdgeInsets.all(8),
                            margin: EdgeInsets.symmetric(vertical: 10),
                            child: Column(
                              children: [
                                Text(
                                  "Chats Count ",
                                  style: Theme.of(context).textTheme.titleLarge,
                                ),
                                Text(
                                    "The number of times your ad was viewed by the customer"),
                                Text(
                                  activityStatisticsSchema.chatsCount
                                      .toString(),
                                  style: Theme.of(context).textTheme.titleLarge,
                                ),
                                // Divider(thickness: 1,)
                              ],
                            )),
                      ],
                    ),
                  );
                }),
          ],
        ));
  }
}
