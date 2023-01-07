import 'package:app/screens/getStartedScreen.dart';
import 'package:flutter/material.dart';

class DialogWidgets {
  static void mustSginin(BuildContext context) {
    showDialog<void>(
      context: context,
      //   barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('You Havn\'t Sgin in'),
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                Text('You must sgin in first'),
                Text('do this with esay steps.'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Sgin in'),
              onPressed: () {
                Navigator.pushReplacementNamed(context, GetStartedScreen.router);
                // Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
