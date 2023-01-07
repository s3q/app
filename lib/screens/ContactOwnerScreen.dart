import 'package:app/helpers/colorsHelper.dart';
import 'package:app/providers/activityProvider.dart';
import 'package:app/providers/chatProvider.dart';
import 'package:app/providers/userProvider.dart';
import 'package:app/schemas/activitySchema.dart';
import 'package:app/schemas/userSchema.dart';
import 'package:app/screens/massagesScreen.dart';
import 'package:app/widgets/DiologsWidgets.dart';
import 'package:app/widgets/SafeScreen.dart';
import 'package:app/widgets/activityCardWidget.dart';
import 'package:app/widgets/appBarWidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:whatsapp/whatsapp.dart';

class ContactOwnerScreen extends StatelessWidget {
  static String router = "contactOwner";
  const ContactOwnerScreen({super.key});

  Future _gotoChat({
    required BuildContext context,
    required String userId,
    required String activityId,
  }) async {
    UserProvider userProvider =
        Provider.of<UserProvider>(context, listen: false);
    if (userProvider.islogin()) {
      final chatProvider = Provider.of<ChatProvider>(context, listen: false);

      // final userProvider = Provider.of<UserProvider>(context, listen: false);

      String s = await chatProvider.addChat(
          context: context, userId: userId, activityId: activityId);
      if (chatProvider.chat != null) {
        if (chatProvider.chat!.users.contains(userId) &&
            chatProvider.chat!.users.contains(userProvider.currentUser!.Id)) {
          print(chatProvider.chat);
          Navigator.pushNamed(context, MassagesScreen.router,
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
    print(activitySchema.phoneNumberWhatsapp);

    print(activitySchema.phoneNumberWhatsapp == null ||
        activitySchema.phoneNumberWhatsapp == "");
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
                if (userProvider.currentUser == null) {
                  DialogWidgets.mustSginin(context);
                  return;
                }
                EasyLoading.show(maskType: EasyLoadingMaskType.black);
                activityProvider.addChatsCountActivity(
                    activitySchema.storeId, activitySchema.Id);
                await _gotoChat(
                    context: context,
                    userId: activitySchema.userId,
                    activityId: activitySchema.Id);

                await Future.delayed(Duration(milliseconds: 2000));

                EasyLoading.dismiss();
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
                final Uri _url =
                    Uri.parse("tel:${activitySchema.phoneNumberCall}");

                final Uri telLaunchUri = Uri(
                  scheme: 'tel',
                  path: activitySchema.phoneNumberCall,
                );
                launchUrl(telLaunchUri);
                await activityProvider.addCallsCountActivity(
                    activitySchema.storeId, activitySchema.Id);
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
              onPressed: activitySchema.phoneNumberWhatsapp == null ||
                      activitySchema.phoneNumberWhatsapp == ""
                  ? null
                  : () async {
                      final Uri _url = Uri.parse(
                          "https://wa.me/${activitySchema.phoneNumberWhatsapp}");
                      // ' https://wa.me/${activitySchema.phoneNumberWhatsapp}?text=Hello');
                      launchUrl(_url,
                          mode: LaunchMode.externalNonBrowserApplication);
//                 WhatsApp whatsapp = WhatsApp();

//                 whatsapp.messagesTemplate(
// 	to: int.tryParse(activitySchema.phoneNumberWhatsapp.toString()) ?? 0,
// 	templateName: "Hey,",

// );
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
                  UserSchema? userSchema;
                  if (snapshot.data is UserSchema) {
                    userSchema = snapshot.data as UserSchema;
                  }
                  print(userSchema?.proAccount?["instagram"]);

                  return ElevatedButton(
                    onPressed: userSchema?.proAccount?["instagram"] == null ||
                            userSchema?.proAccount?["instagram"] == ""
                        ? null
                        : () async {
                            final Uri _url = Uri.parse(
                                'https://instagram.com/${userSchema?.proAccount?["instagram"]}');
                            if (await canLaunchUrl(_url)) {
                              await launchUrl(_url,
                                  mode:
                                      LaunchMode.externalNonBrowserApplication);
                            } else {
                              throw 'Could not launch $_url';
                            }
                          },
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
