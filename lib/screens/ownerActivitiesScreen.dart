import 'package:app/helpers/colorsHelper.dart';
import 'package:app/providers/activityProvider.dart';
import 'package:app/providers/userProvider.dart';
import 'package:app/schemas/activitySchema.dart';
import 'package:app/screens/addActivityScreen.dart';
import 'package:app/widgets/SafeScreen.dart';
import 'package:app/widgets/appBarWidget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OwnerActivitesScreen extends StatefulWidget {
  static String router = "owner_activites";
  const OwnerActivitesScreen({super.key});

  @override
  State<OwnerActivitesScreen> createState() => _OwnerActivitesScreenState();
}

class _OwnerActivitesScreenState extends State<OwnerActivitesScreen> {
  @override
  Widget build(BuildContext context) {
    ActivityProvider activityProvider = Provider.of<ActivityProvider>(context);
    UserProvider userProvider = Provider.of<UserProvider>(context);

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, AddActivityScreen.router);
        },
        child: Row(
          children: const [
            Icon(Icons.add_rounded),
            SizedBox(
              width: 10,
            ),
            Text("Add Activity"),
          ],
        ),
      ),
      body: SafeArea(
        child: Container(
          width: double.infinity,
          color: Colors.white,
          child: Column(
            children: [
              AppBarWidget(title: "Statistics"),
              FutureBuilder(
                  future: activityProvider.fetchUserActivities(
                      context, userProvider.currentUser?.Id),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState ||
                        !snapshot.hasData ||
                        (snapshot.data.runtimeType == List<ActivitySchema>)) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    List<ActivitySchema> activityListSchema =
                        snapshot.data as List<ActivitySchema>;
                    return Expanded(
                        child: ListView(children: [
                      const SizedBox(
                        height: 30,
                      ),
                      ...activityListSchema.map((a) {
                        return Container(
                          margin: EdgeInsets.symmetric(vertical: 10),
                          child: Column(children: [
                            Row(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: ColorsHelper.grey),
                                  width: 200,
                                  height: 200,
                                  child: Image.network(a.images
                                      .where(
                                          (i) => i.toString().contains("main"))
                                      .toList()[0]),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Column(
                                  children: [
                                    Text(a.title),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Text("Status : " + a.isActive.toString()),
                                  ],
                                )
                              ],
                            ),
                            Row(
                              children: [
                                SizedBox.fromSize(
                                  size: Size(56, 56),
                                  child: ClipOval(
                                    child: Material(
                                      color: ColorsHelper.grey,
                                      child: InkWell(
                                        splashColor: Colors.white12,
                                        onTap: () {},
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: const [
                                            Icon(
                                                Icons.edit_rounded), // <-- Icon
                                            Text("Edit"), // <-- Text
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox.fromSize(
                                  size: Size(56, 56),
                                  child: ClipOval(
                                    child: Material(
                                      color: ColorsHelper.grey,
                                      child: InkWell(
                                        splashColor: Colors.white12,
                                        onTap: () {},
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: const [
                                            Icon(Icons
                                                .insert_chart_rounded), // <-- Icon
                                            Text("Statistics"), // <-- Text
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox.fromSize(
                                  size: Size(56, 56),
                                  child: ClipOval(
                                    child: Material(
                                      color: ColorsHelper.grey,
                                      child: InkWell(
                                        splashColor: Colors.white12,
                                        onTap: () {},
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: const [
                                            Icon(Icons
                                                .stop_circle_sharp), // <-- Icon
                                            Text("Freeze"), // <-- Text
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox.fromSize(
                                  size: Size(56, 56),
                                  child: ClipOval(
                                    child: Material(
                                      color: ColorsHelper.grey,
                                      child: InkWell(
                                        splashColor: Colors.white12,
                                        onTap: () {},
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: const [
                                            Icon(Icons
                                                .delete_rounded), // <-- Icon
                                            Text("Delete"), // <-- Text
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            )
                          ]),
                        );
                      }).toList(),
                    ]));
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
