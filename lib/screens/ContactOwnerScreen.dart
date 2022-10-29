import 'package:app/helpers/colorsHelper.dart';
import 'package:app/providers/activityProvider.dart';
import 'package:app/providers/chatProvider.dart';
import 'package:app/providers/userProvider.dart';
import 'package:app/schemas/activitySchema.dart';
import 'package:app/screens/massagesScreen.dart';
import 'package:app/widgets/SafeScreen.dart';
import 'package:app/widgets/activityCardWidget.dart';
import 'package:app/widgets/appBarWidget.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class ContactOwnerScreen extends StatelessWidget {
  static String router = "contactOwner";
  const ContactOwnerScreen({super.key});

  void _gotoChat({
    required BuildContext context,
    required String userId,
    required String activityId,
  }) async {
    UserProvider userProvider =
        Provider.of<UserProvider>(context, listen: false);
    if (userProvider.islogin()) {
      final chatProvider = Provider.of<ChatProvider>(context, listen: false);

      // final userProvider = Provider.of<UserProvider>(context, listen: false);

      String s = await chatProvider.addChat(context: context, userId: userId, activityId: activityId);
      if (chatProvider.chat != null) {
        if (chatProvider.chat!.users.contains(userId) &&
            chatProvider.chat!.users.contains(userProvider.currentUser!.Id)) {
          await Navigator.pushNamed(context, MassagesScreen.router,
              arguments: chatProvider.chat);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    UserProvider userProvider = Provider.of<UserProvider>(context);
    ActivityProvider activityProvider = Provider.of<ActivityProvider>(context);
    ActivitySchema activitySchema =
        ModalRoute.of(context)?.settings.arguments as ActivitySchema;
    return SafeScreen(
      padding: 0,
      child: Column(children: [
        AppBarWidget(title: "Contact Owner"),
        SizedBox(
          height: 40,
        ),
        Container(
          padding: EdgeInsets.all(8),
          child: Column(children: [
            ElevatedButton(
              onPressed: () async {
                await activityProvider.addChatsCountActivity(activitySchema.Id);
                _gotoChat(context: context, userId: activitySchema.userId, activityId: activitySchema.Id);
              },
              style: ElevatedButton.styleFrom(
                primary: ColorsHelper.yellow,
                padding:
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50)),
              ),
              child: SizedBox(
                //   width: 200,
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(
                        Icons.chat_bubble_outline_rounded,
                        // color: Colors.white,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        " Trippoint Chat ",
                        // style: TextStyle(color: Colors.white),
                      ),
                    ]),
              ),
            ),
            SizedBox(
              height: 30,
            ),
            ElevatedButton(
              onPressed: () async {
                                await activityProvider.addCallsCountActivity(activitySchema.Id);

              },
              style: ElevatedButton.styleFrom(
                primary: ColorsHelper.green,
                padding:
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50)),
              ),
              child: SizedBox(
                //   width: 200,
                child:
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Icon(
                    Icons.call,
                    color: Colors.white,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    " Call " + activitySchema.phoneNumberCall.toString(),
                    style: TextStyle(color: Colors.white),
                  ),
                ]),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            ElevatedButton(
              onPressed: () async {},
              style: ElevatedButton.styleFrom(
                primary: ColorsHelper.green,
                padding:
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50)),
              ),
              child: SizedBox(
                //   width: 200,
                child:
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  const Icon(
                    Icons.whatsapp_rounded,
                    color: Colors.white,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    " Whatsapp " +
                        activitySchema.phoneNumberWhatsapp.toString(),
                    style: TextStyle(color: Colors.white),
                  ),
                ]),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            FutureBuilder(
                future:
                    userProvider.fetchUserData(userId: activitySchema.userId),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting ||
                      !snapshot.hasData) {
                    return ElevatedButton(
                      onPressed: null,
                      style: ElevatedButton.styleFrom(
                        primary: ColorsHelper.green,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 40, vertical: 15),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50)),
                      ),
                      child: SizedBox(
                        //   width: 200,
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Icon(
                                Icons.chat_bubble_outline_rounded,
                                color: Colors.white,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                " Instagram ",
                                style: TextStyle(color: Colors.white),
                              ),
                            ]),
                      ),
                    );
                  }
                  return ElevatedButton(
                    onPressed: () async {},
                    style: ElevatedButton.styleFrom(
                      primary: ColorsHelper.green,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 40, vertical: 15),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50)),
                    ),
                    child: SizedBox(
                      //   width: 200,
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(
                              FontAwesomeIcons.instagram,
                              color: Colors.white,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              " Instagram ",
                              style: TextStyle(color: Colors.white),
                            ),
                          ]),
                    ),
                  );
                }),
            const SizedBox(
              height: 10,
            ),
          ]),
        ),
      ]),
    );
  }
}
