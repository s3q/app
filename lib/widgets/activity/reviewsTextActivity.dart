import 'package:app/helpers/colorsHelper.dart';
import 'package:app/providers/activityProvider.dart';
import 'package:app/schemas/activitySchema.dart';
import 'package:app/widgets/textIocnActWidget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ReviewsTextActivity extends StatelessWidget {
    ActivitySchema activitySchema;
   ReviewsTextActivity({super.key, required this.activitySchema});

  @override
  Widget build(BuildContext context) {
        ActivityProvider activityProvider = Provider.of<ActivityProvider>(context);

    return Container(
        child:   Row(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                TextIconInfoActWidget(
                                  icon: Icons.star_rounded,
                                  color: ColorsHelper.yellow,
                                  text: activityProvider
                                          .previewMark(activitySchema.reviews)
                                          .toString() +
                                      "/5",
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  activitySchema.reviews.length.toString() + " reviews",
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall
                                      ?.copyWith(fontSize: 12),
                                ),
                              ],
                            ),
    );
  }
}