import 'package:flutter/material.dart';

class SnakbarWidgets {
    static void error(BuildContext context, String error) {
         ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Theme.of(context).errorColor,
        content: Text(error),
      ));
    }
}