import 'package:app/providers/chatProvider.dart';
import 'package:app/providers/userProvider.dart';
import 'package:app/schemas/chatSchema.dart';
import 'package:app/schemas/userSchema.dart';
import 'package:app/screens/massagesScreen.dart';
import 'package:app/widgets/profileAvatarWidget.dart';
import "package:flutter/material.dart";
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ChatBoxWidget extends StatelessWidget {
  ChatSchema chat;
  ChatBoxWidget({Key? key, required this.chat}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print(chat.users[0]);
    ChatProvider chatprovider =
        Provider.of<ChatProvider>(context, listen: false);
    UserProvider userProvider =
        Provider.of<UserProvider>(context, listen: false);
    UserSchema user = userProvider.users[chat.users[0]]!;

    return InkWell(
      onTap: () async {
        EasyLoading.show();
        chatprovider.chat = chat;
        Navigator.pushNamed(context, MassagesScreen.router, arguments: chat);
        await Future.delayed(Duration(milliseconds: 1000), () {});
        EasyLoading.dismiss();
      },
      child: Container(
        decoration: BoxDecoration(
            border: Border.symmetric(
                horizontal: BorderSide(color: Color(0xFFF5F5F5), width: 1))),
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.all(10),
        child: Row(
          children: [
            // ClipOval(
            //   child: user.profileImagePath?.trim() == "" ||
            //           user.profileImagePath == null
            //       ? Container(
            //           color: Color(
            //               user.profileColor ?? Colors.grey.shade400.value))
            //       : Image.network(
            //           user.profileImagePath!,
            //           fit: BoxFit.cover,
            //         ),
            // ),

            ProfileAvatarWidget(
              profileColor: user.profileColor,
              profileImagePath: user.profileImagePath,
              size: 20,
            ),

            const SizedBox(
              width: 15,
            ),
            Expanded(
              child: Column(
                // crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        user.name.toString(),
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium!
                            .copyWith(fontWeight: FontWeight.bold),
                      ),

                      Row(
                        children: [
                          if (chat.massages != null &&
                              chat.massages!.length > 0)
                            Text(
                              chat.massages?[0] != null
                                  ? DateFormat('dd/MM/yyyy').format(
                                      DateTime.fromMillisecondsSinceEpoch(
                                          chat.massages![0].createdAt))
                                  : "",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(
                                      color: Colors.grey,
                                      overflow: TextOverflow.ellipsis,
                                      fontWeight: FontWeight.bold),
                            ),
                          SizedBox(
                            width: 10,
                          ),
                          if (chat.massages != null &&
                              chat.massages!.length > 0 &&
                              chat.unread
                                  .contains(userProvider.currentUser?.Id))
                            const Icon(
                              Icons.fiber_manual_record_sharp,
                              size: 10,
                              color: Colors.redAccent,
                            ),
                        ],
                      )
                      // Expanded(child: SizedBox()),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      if (chat.massages != null && chat.massages!.length > 0)
                        Row(
                          children: [
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              chat.massages![0].massage!.trim().length <= 45
                                  ? chat.massages![0].massage!.trim()
                                  : chat.massages![0].massage!
                                          .trim()
                                          .substring(0, 45)
                                          .toString() +
                                      (chat.massages![0].massage!
                                                  .trim()
                                                  .length >=
                                              45
                                          ? "..."
                                          : ""),
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(
                                    color: Colors.grey,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                              maxLines: 1,
                            ),
                          ],
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
