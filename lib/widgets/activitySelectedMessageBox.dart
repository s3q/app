import 'package:app/helpers/colorsHelper.dart';
import 'package:app/providers/activityProvider.dart';
import 'package:app/providers/userProvider.dart';
import 'package:app/schemas/activitySchema.dart';
import 'package:app/screens/activityDetailsScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ActivitySelectedMessageBox extends StatelessWidget {
  String text;
  String url;
  int date;
  ActivitySelectedMessageBox(
      {super.key, required this.text, required this.date, required this.url});

  @override
  Widget build(BuildContext context) {
    UserProvider userProvider = Provider.of<UserProvider>(context);
    ActivityProvider activityProvider = Provider.of<ActivityProvider>(context);
    String activityId = url.split("|||")[1];
    String activityTitle = url.split("|||")[0];
    print(url);
    return InkWell(
        highlightColor: Colors.grey[200],
      onTap: () async {
        EasyLoading.show();
        ActivitySchema activitySchema =
            await activityProvider.fetchActivityWStore(activityId);
        Navigator.pushNamed(context, ActivityDetailsScreen.router,
            arguments: activitySchema);
        // await Future.delayed(Duration(milliseconds: 1000));
        EasyLoading.dismiss();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
        margin: const EdgeInsets.only(top: 12),
        //   color: ColorsHelper.grey,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Colors.grey[200],
        ),
        child: Column(
          children: [
            RichText(
              text: TextSpan(
                // Note: Styles for TextSpans must be explicitly defined.
                // Child text spans will inherit styles from parent
                style: const TextStyle(
                  fontSize: 14.0,
                  color: Colors.black,
                ),
                children: <TextSpan>[
                  TextSpan(
                    text: text,
                  ),
                  TextSpan(
                      onEnter: (event) {
                        print("go");
                      },
                      text: ' "${activityTitle}."  ',
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  TextSpan(
                      text: DateFormat('dd/MM/yyyy')
                          .format(DateTime.fromMillisecondsSinceEpoch(date))
                          .toString(),
                      style: Theme.of(context).textTheme.bodySmall),
                ],
              ),
            ),
            SizedBox(
              height: 5,
            ),
            Align(
                alignment: Alignment.bottomRight,
                child: Icon(Icons.arrow_forward_rounded)),
          ],
        ),
      ),
    );
  }
}
