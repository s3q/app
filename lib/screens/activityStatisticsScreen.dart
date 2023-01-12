import 'package:app/helpers/appHelper.dart';
import 'package:app/providers/activityProvider.dart';
import 'package:app/schemas/activitySchema.dart';
import 'package:app/schemas/activityStatisticsSchema.dart';
import 'package:app/screens/viewReviewsScreen.dart';
import 'package:app/widgets/SafeScreen.dart';
import 'package:app/widgets/appBarWidget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ActivityStatisticsScreen extends StatefulWidget {
  static String router = "activity_statistics";
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
            AppBarWidget(title: AppHelper.returnText(context, "Statistics", "إحصائيات")),
            FutureBuilder(
                future:
                    activityProvider.fetchActivityStatistics(activitySchema.Id),
                builder: (context, snapshot) {
                //   if (snapshot.connectionState == ConnectionState.waiting ||
                //       !snapshot.hasData ||
                //       (snapshot.data.runtimeType != ActivityStatisticsSchema)) {
                //     return Center(
                //       child: CircularProgressIndicator(),
                //     );
                //   }

                  //   ActivityStatisticsSchema activityStatisticsSchema =
                  //       snapshot.data as ActivityStatisticsSchema;

                  ActivitySchema activityStatisticsSchema = activitySchema;
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
                                      AppHelper.returnText(context, ' reviews', "تقييمات"),
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
                            child: Text(AppHelper.returnText(context, 'see reviews', "التقيمات")),
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
                                      AppHelper.returnText(context, "Views Count ", " عدد المشاهدات"),
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleLarge,
                                    ),
                                  ],
                                ),
                                Text(
                                    AppHelper.returnText(context, "The number of times your tourism activity was viewed by the customer" , " عدد المرات التي شاهد فيها العميل نشاطك السياحي")),
                                Text(
                                  activityStatisticsSchema.viewsCount
                                      .toString(),
                                  style: Theme.of(context).textTheme.titleLarge,
                                ),
                                Divider(
                                  thickness: 1,
                                )
                              ],
                            ),),
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
                                       AppHelper.returnText(context, "Calls Count ", " عدد المكالمات"),
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleLarge,
                                    ),
                                  ],
                                ),
                                  Text(
                                    AppHelper.returnText(context, "How many time call button is clicked", "كم مرة يتم النقر على زر الاتصال")),
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
                                Row(
                                  children: [
                                    Icon(Icons.favorite_rounded),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                       AppHelper.returnText(context, "Likes Count ", " عدد مرات الإعجاب"),
                                      style: Theme.of(context).textTheme.titleLarge,
                                    ),
                                  ],
                                ),
                                Text(AppHelper.returnText(context, "How many time like button is clicked", "كم مرة يتم النقر على زر أعجبني")
                                    ),
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
                                Row(
                                  children: [
                                    Icon(Icons.share_rounded),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      AppHelper.returnText(context, "Shares Count ", " عدد المشاركات"),
                                      style: Theme.of(context).textTheme.titleLarge,
                                    ),
                                  ],
                                ),
                                Text(
                                    AppHelper.returnText(context, "How many time share button is clicked", "كم مرة يتم النقر على زر المشاركة")),
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
                                Row(
                                  children: [
                                    Icon(Icons.chat_rounded),
                                    SizedBox(
                                      width: 10,
                                    ),
                                Text(
                                  AppHelper.returnText(context, "Chats Count ", " عدد الدردشات"),
                                  style: Theme.of(context).textTheme.titleLarge,
                                ),
                                  ],
                                ),
                                Text(
                                    AppHelper.returnText(context, "How many time chat button is clicked", "كم مرة يتم النقر على زر الدردشة")),
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
