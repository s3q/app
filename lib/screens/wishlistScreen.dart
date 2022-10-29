import 'package:app/helpers/colorsHelper.dart';
import 'package:app/providers/activityProvider.dart';
import 'package:app/providers/userProvider.dart';
import 'package:app/schemas/activitySchema.dart';
import 'package:app/widgets/textIocnActWidget.dart';
import 'package:flutter/foundation.dart';
import "package:flutter/material.dart";
import 'package:provider/provider.dart';

class WishlistScreen extends StatefulWidget {
  const WishlistScreen({Key? key}) : super(key: key);

  @override
  State<WishlistScreen> createState() => _WishlistScreenState();
}

class _WishlistScreenState extends State<WishlistScreen> {
  @override
  Widget build(BuildContext context) {
    UserProvider userProvider = Provider.of<UserProvider>(context);
    List<ActivitySchema>? wishlist =
        userProvider.currentUser?.wishlist as List<ActivitySchema>? ?? [];
    ActivityProvider activityProvider = Provider.of<ActivityProvider>(context);

    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          Text(
            "Wishlist",
            style: Theme.of(context).textTheme.titleLarge,
          ),
          SizedBox(
            height: 30,
          ),
          //   if (wishlist != null)
          Expanded(
            child: ListView.builder(
                itemCount: wishlist.length,
                itemBuilder: (context, index) {
                  return FutureBuilder(
                      future: activityProvider
                          .fetchActivityWStore(wishlist[index].Id),
                      builder: (context, snapshot) {
                        ActivitySchema? activity =
                            snapshot.data as ActivitySchema?;

                        if (snapshot.connectionState ==
                                ConnectionState.waiting ||
                            !snapshot.hasData ||
                            activity != null) {
                          return Card(
                              child: Container(
                            width: 200,
                            height: 200,
                            child: Row(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: ColorsHelper.grey),
                                  width: 200,
                                  height: 200,
                                  //   child: Image.network(),
                                ),
                                Column(children: []),
                              ],
                            ),
                          ));
                        }

                        return GestureDetector(
                            onTap: () {

                            },
                          child: Card(
                              key: Key(activity?.Id ?? ""),
                            child: Container(
                              width: 200,
                              height: 200,
                              child: Row(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: ColorsHelper.grey),
                                    width: 200,
                                    height: 200,
                                    child: Image.network(activity?.images
                                        .where(
                                            (i) => i.toString().contains("main"))
                                        .toList()[0]),
                                  ),
                                  Column(children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          activity!.title,
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleMedium,
                                        ),
                                       IconButton(
                                icon: Icon(
                                  userProvider.currentUser!.wishlist!
                                          .contains(activity.Id)
                                      ? Icons.favorite
                                      : Icons.favorite_border,
                                ),
                                onPressed: () async {
                                  if (userProvider.currentUser!.wishlist!
                                      .contains(activity.Id)) {
                                    await userProvider
                                        .removeFromWishlist(activity.Id);
                                  } else {
                                     await userProvider
                                        .addToWishlist(activity.Id, activityProvider);
                                  }
                                  setState(() {});
                                },
                              ),
                                      ],
                                    ),
                        
                                      TextIconInfoActWidget(
                                text: activity.address,
                                icon: Icons.location_on_rounded,
                                //  style: Theme.of(context).textTheme.bodySmall,
                              ),
                                SizedBox(
                                height: 10,
                              ),
                        
                                 TextIconInfoActWidget(
                                    icon: Icons.star_rounded,
                                    color: ColorsHelper.yellow,
                                    text: activityProvider
                                            .previewMark(activity.reviews)
                                            .toString() +
                                        "/5",
                                  ),
                                 
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                    activity.reviews.length.toString() + " reviews",
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodySmall
                                        ?.copyWith(fontSize: 12),
                                  ),
                                  ]),
                                ],
                              ),
                            ),
                          ),
                        );
                      });
                }),
          ),
        ],
      ),
    );
  }
}
