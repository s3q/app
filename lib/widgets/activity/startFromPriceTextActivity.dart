import 'package:app/providers/activityProvider.dart';
import 'package:app/schemas/activitySchema.dart';
import "package:flutter/material.dart";
import 'package:provider/provider.dart';

class StartFromPriceTextActivity extends StatelessWidget {
  ActivitySchema activitySchema;
  StartFromPriceTextActivity({super.key, required this.activitySchema});

  @override
  Widget build(BuildContext context) {
    ActivityProvider activityProvider = Provider.of<ActivityProvider>(context);

    return Container(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Align(
            alignment: const AlignmentDirectional(0, 0),
            child: Text(
              'Starting From',
              textAlign: TextAlign.start,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              Text(
                activityProvider
                    .startFromPrice(activitySchema.prices)
                    .toString(),
                // ! widget.activity.priceStartFrom.toString(),
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              SizedBox(
                width: 5,
              ),
              Text('OMR'),
            ],
          ),
        ],
      ),
    );
  }
}
