import 'package:app/helpers/colorsHelper.dart';
import 'package:app/providers/activityProvider.dart';
import 'package:app/providers/userProvider.dart';
import 'package:app/schemas/activitySchema.dart';
import 'package:app/screens/activityStatisticsScreen.dart';
import 'package:app/screens/addActivityScreen.dart';
import 'package:app/screens/editActivityScreen.dart';
import 'package:app/widgets/SafeScreen.dart';
import 'package:app/widgets/appBarWidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class OwnerActivitesScreen extends StatefulWidget {
  static String router = "owner_activites";
  const OwnerActivitesScreen({super.key});

  @override
  State<OwnerActivitesScreen> createState() => _OwnerActivitesScreenState();
}

class _OwnerActivitesScreenState extends State<OwnerActivitesScreen> {
  Future deleteActivity(String activityStoreId) async {
    ActivityProvider activityProvider =
        Provider.of<ActivityProvider>(context, listen: false);

    showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete'),
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                Text(
                    'Are you sure do you want to delete this activity for ever!'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Yes'),
              onPressed: () async {
                EasyLoading.show(maskType: EasyLoadingMaskType.black);
                try {
                  bool done = await activityProvider.deleteActivity(
                      context, activityStoreId);

                  assert(done != true);

                  EasyLoading.showSuccess("");

                  Navigator.of(context).pop();
                } catch (err) {
                  print(err);
                   EasyLoading.showError("");
                }

                    await Future.delayed(Duration(milliseconds: 1500));


                EasyLoading.dismiss();
                setState(() {});
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    ActivityProvider activityProvider = Provider.of<ActivityProvider>(context);
    UserProvider userProvider = Provider.of<UserProvider>(context);

    return Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "My Activities",
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(
              height: 30,
            ),
            FutureBuilder(
                future: activityProvider.fetchUserActivities(
                    context, userProvider.currentUser?.Id),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState ||
                      !snapshot.hasData ||
                      (snapshot.data.runtimeType != List<ActivitySchema>)) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  List<ActivitySchema> activityListSchema =
                      snapshot.data as List<ActivitySchema>;

                  print(activityListSchema);

                  return Expanded(
                      child: ListView(children: [
                    const SizedBox(
                      height: 30,
                    ),
                    ...activityListSchema.map((a) {
                      return Card(
                        margin: EdgeInsets.symmetric(vertical: 10),
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        elevation: 3,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: ColorsHelper.grey),
                                    width: 100,
                                    height: 160,
                                    child: Image.network(
                                      activityProvider.mainDisplayImage(a.images),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width -
                                                100 -
                                                50,
                                        child: Text(
                                          a.title,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium!
                                              .copyWith(
                                                  fontWeight: FontWeight.bold),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Text("Status : " + a.isActive.toString()),
                                      Text("Publish date : " +
                                          DateFormat('MM/dd/yyyy')
                                              .format(DateTime
                                                  .fromMillisecondsSinceEpoch(
                                                      a.createdAt))
                                              .toString()),
                                    ],
                                  )
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    RoundedButton(
                                      icon: Icons.edit_rounded,
                                      text: "Edit",
                                      color: Colors.black45,
                                      onPressed: () async {
                                        EasyLoading.show();
                                        Navigator.pushNamed(
                                            context, EditActivityScreen.router,
                                            arguments: a);
                                        await Future.delayed(
                                            Duration(milliseconds: 1000));
                                        EasyLoading.dismiss();
                                      },
                                    ),

                                    RoundedButton(
                                      icon: Icons.insert_chart_rounded,
                                      text: "Statistics",
                                      color: Colors.black45,
                                      onPressed: () async {
                                        EasyLoading.show();
                                        Navigator.pushNamed(context,
                                            ActivityStatisticsScreen.router,
                                            arguments: a);
                                        await Future.delayed(
                                            Duration(milliseconds: 1000));
                                        EasyLoading.dismiss();
                                      },
                                    ),
                                    RoundedButton(
                                      icon: Icons.stop_circle_sharp,
                                      text: a.isActive ? "Freeze" : "Activate",
                                      color: Colors.black45,
                                      onPressed: () async {
                                        EasyLoading.show(maskType: EasyLoadingMaskType.black);

                                        if (a.isActive) {
                                          await activityProvider.freezeActivity(
                                              context, a.storeId!);
                                        } else {
                                          await activityProvider
                                              .activateActivity(
                                                  context, a.storeId!);
                                        }

                                        setState(() {});
                                        EasyLoading.dismiss();
                                      },
                                    ),
                                    //   T
                                    RoundedButton(
                                      icon: Icons.delete_rounded,
                                      text: "Delete",
                                      color: ColorsHelper.red,
                                      onPressed: () async {
                                        deleteActivity(a.storeId!);
                                      },
                                    ),
                                    //   T
                                  ],
                                ),
                              )
                            ]),
                      );
                    }).toList(),
                  ]));
                }),
          ],
        ));
  }
}

class RoundedButton extends StatelessWidget {
  IconData icon;
  Color color;
  String text;
  Function onPressed;
  RoundedButton(
      {super.key,
      required this.icon,
      required this.onPressed,
      required this.color,
      required this.text});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        child: Column(
          children: [
            IconButton(
              onPressed: () {
                onPressed();
              },
              icon: Icon(icon),
              padding: EdgeInsets.all(0),
              iconSize: 30,
              //   highlightColor: color,
              color: color,
            ),
            Text(text,
                style: Theme.of(context)
                    .textTheme
                    .bodySmall!
                    .copyWith(color: color))
          ],
        ),
      ),
    );
  }
}
