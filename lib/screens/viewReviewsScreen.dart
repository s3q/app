import 'package:app/providers/activityProvider.dart';
import 'package:app/providers/userProvider.dart';
import 'package:app/schemas/activitySchema.dart';
import 'package:app/schemas/userSchema.dart';
import 'package:app/screens/sendReviewScreen.dart';
import 'package:app/widgets/SafeScreen.dart';
import 'package:app/widgets/appBarWidget.dart';
import 'package:app/widgets/ratingBarWidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ViewReviewScreen extends StatefulWidget {
  static String router = "viewReview";

  const ViewReviewScreen({super.key});

  @override
  State<ViewReviewScreen> createState() => _ViewReviewScreenState();
}

class _ViewReviewScreenState extends State<ViewReviewScreen> {
  @override
  Widget build(BuildContext context) {
    UserProvider userProvider = Provider.of<UserProvider>(context);
    ActivityProvider activityProvider = Provider.of<ActivityProvider>(context);

    ActivitySchema activitySchema =
        ModalRoute.of(context)?.settings.arguments as ActivitySchema;

    return SafeScreen(
      padding: 0,
      child: Column(children: [
        AppBarWidget(title: "Reviews"),
        Expanded(
          child: ListView(children: [
            SizedBox(
              height: 30,
            ),
            Container(
                height: 150,
              padding: EdgeInsets.all(8),
              child: Column(
                children: [
                  Text(
                    activityProvider
                        .previewMark(activitySchema.reviews)
                        .toString(),
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  RatingBarWidget(
                    // init: ,
                    onRated: (val) {
                      print(val);
                      Navigator.pushReplacementNamed(
                          context, SendReviewScreen.router,
                          arguments: activitySchema);
                    },
                    size: 30,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    activitySchema.reviews.length.toString() + " reviews",
                    // style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
            const Divider(
              thickness: 2,
            ),
            Container(
                height: MediaQuery.of(context).size.height - 300,
                child: ListView.builder(
                    itemCount: activitySchema.reviews.length,
                    itemBuilder: (context, index) {
                      return FutureBuilder(
                          future: userProvider.fetchUserData(
                              userId: activitySchema.reviews[index]["userId"]),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                    ConnectionState.waiting ||
                                !snapshot.hasData) {
                              return  Column(
                              children: [
                                ListTile(
                                                                   

                                 leading: const CircleAvatar(
                                  radius: 25,
                                ),
                                  title: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text("... ...", style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),), 
                                       RatingBarIndicator(
                                        itemBuilder: (context, index) {
                                          return const Icon(
                                            Icons.star_rate_rounded,
                                            color: Colors.amber,
                                          );
                                        },
                                        rating: activitySchema.reviews[index]
                                            ["rating"],
                                        itemSize: 18,
                                      ),
                                    ],
                                  ),
                                  subtitle: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                        SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                        activitySchema.reviews[index]["review"]
                                            .toString(),
                                        style:
                                            Theme.of(context).textTheme.bodySmall,
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                        DateFormat('MM/dd/yyyy, hh:mm a').format(
                                            DateTime.fromMillisecondsSinceEpoch(
                                                activitySchema.reviews[index]
                                                    ["createdAt"])),
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall
                                            ?.copyWith(color: Colors.grey[600]),
                                      )
                                    ],
                                  ),
                                ),
                                                                Divider(thickness: 2,),

                              ],
                            ); ListTile(
                                shape: Border.all(width: 2),
                                leading: const CircleAvatar(
                                  radius: 25,
                                ),
                                title: const Text('... ...'),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    RatingBarIndicator(
                                      itemBuilder: (context, index) {
                                        return const Icon(
                                          Icons.star_rate_rounded,
                                          color: Colors.amber,
                                        );
                                      },
                                      rating: activitySchema.reviews[index]
                                          ["rating"],
                                      itemSize: 18,
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      activitySchema.reviews[index]["review"]
                                          .toString(),
                                      style:
                                          Theme.of(context).textTheme.bodySmall,
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      DateFormat('MM/dd/yyyy, hh:mm a').format(
                                          DateTime.fromMillisecondsSinceEpoch(
                                              activitySchema.reviews[index]
                                                  ["createdAt"])),
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall
                                          ?.copyWith(color: Colors.grey[600]),
                                    )
                                  ],
                                ),
                              );
                            }

                            UserSchema userData = snapshot.data as UserSchema;
                            return Column(
                              children: [
                                ListTile(
                                                                   

                                  leading: CircleAvatar(
                                    backgroundColor: userData.profileColor != null
                                        ? Color(userData.profileColor!)
                                        : null,
                                    backgroundImage: userData.profileImagePath !=
                                            null
                                        ? NetworkImage(userData.profileImagePath!)
                                        : null,
                                    radius: 25,
                                  ),
                                  title: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(userData.name, style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),), 
                                       RatingBarIndicator(
                                        itemBuilder: (context, index) {
                                          return const Icon(
                                            Icons.star_rate_rounded,
                                            color: Colors.amber,
                                          );
                                        },
                                        rating: activitySchema.reviews[index]
                                            ["rating"],
                                        itemSize: 18,
                                      ),
                                    ],
                                  ),
                                  subtitle: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                        SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                        activitySchema.reviews[index]["review"]
                                            .toString(),
                                        style:
                                            Theme.of(context).textTheme.bodySmall,
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                        DateFormat('MM/dd/yyyy, hh:mm a').format(
                                            DateTime.fromMillisecondsSinceEpoch(
                                                activitySchema.reviews[index]
                                                    ["createdAt"])),
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall
                                            ?.copyWith(color: Colors.grey[600]),
                                      )
                                    ],
                                  ),
                                ),
                                                                Divider(thickness: 2,),

                              ],
                            );
                          });
                    })),
          ]),
        )
      ]),
    );
  }
}
