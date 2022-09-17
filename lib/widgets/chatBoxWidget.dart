import 'package:app/providers/chatProvider.dart';
import 'package:app/providers/userProvider.dart';
import 'package:app/schemas/chatSchema.dart';
import 'package:app/schemas/userSchema.dart';
import 'package:app/screens/massagesScreen.dart';
import "package:flutter/material.dart";
import 'package:provider/provider.dart';

class ChatBoxWidget extends StatelessWidget {
  ChatSchema chat;
  ChatBoxWidget({Key? key, required this.chat}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print(chat.users[0]);
    ChatProvider chatprovider =
        Provider.of<ChatProvider>(context, listen: false);
        UserProvider userProvider = Provider.of<UserProvider>(context, listen: false);
    UserSchema user = userProvider.users[chat.users[0]]!;

    return InkWell(
      onTap: () async {
        chatprovider.chat = chat;
        await Navigator.pushNamed(context, MassagesScreen.router, arguments: chat);
      },
      child: Container(
        padding: EdgeInsets.all(10),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: Color(user.profileColor!),
            ),
            const SizedBox(
              width: 15,
            ),
            Column(
              children: [
                Text(
                  user.name.toString(),
                  style: Theme.of(context).textTheme.titleMedium,
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
