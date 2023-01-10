import 'package:app/helpers/colorsHelper.dart';
import 'package:app/providers/activityProvider.dart';
import 'package:app/providers/userProvider.dart';
import 'package:app/schemas/activitySchema.dart';
import 'package:app/widgets/textIocnActWidget.dart';
import 'package:app/widgets/wishlistIconButtonWidget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ActivityCardWishlistWidget extends StatelessWidget {
  ActivitySchema activity;
  Function onPressed;
  ActivityCardWishlistWidget(
      {super.key, required this.activity, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    UserProvider userProvider = Provider.of<UserProvider>(context);
    ActivityProvider activityProvider = Provider.of<ActivityProvider>(context);

    return Container(
      margin: EdgeInsets.symmetric(vertical: 20),
      height: 160,
      child: GestureDetector(
        onTap: () {
          onPressed();
        },
        child: Card(
          clipBehavior: Clip.antiAliasWithSaveLayer,
          elevation: 3,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          key: Key(activity.Id),
          child: Stack(
            children: [
              Align(
                alignment: const Alignment(1, -1),
                child: WishlistIconButtonWidget( activityStoreId:  activity.storeId!, activityId: activity.Id),
              ),
              Row(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Hero(
                    tag: activity.images[0],
                    child: Image.network(
                      // "",
                      activityProvider.mainDisplayImage( activity.images),
                    
                      width: 80,
                      height: 160,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width - 80 - 80,
                            child: Text(
                              activity.title,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.start,
                              maxLines: 2,
                              style: Theme.of(context).textTheme.titleMedium,
                            ),

                            // WishlistIconButtonWidget(activityId: activity.Id),
                          ),
                          TextIconInfoActWidget(
                            text: activity.address,
                            icon: Icons.location_on_rounded,
                            //  style: Theme.of(context).textTheme.bodySmall,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
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
                                    activity.reviews.length.toString() +
                                        " reviews",
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodySmall
                                        ?.copyWith(fontSize: 12),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ]),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
