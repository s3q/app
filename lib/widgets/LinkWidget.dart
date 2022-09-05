import "package:flutter/material.dart";

class LinkWidget extends StatelessWidget {
  String text;
  Function() onPressed;
  LinkWidget({Key? key, required this.text, required this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: onPressed,
      child: Text(
        text,
        style: TextStyle(
          fontSize: Theme.of(context).textTheme.bodyMedium?.fontSize,
          color: Theme.of(context).colorScheme.secondary,
          decoration: TextDecoration.underline,
        ),
      ),
    );
  }
}
