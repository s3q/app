import "package:flutter/material.dart";

class LinkWidget extends StatelessWidget {
  String text;
  Color color;
  Function() onPressed;
  LinkWidget({Key? key, required this.text, required this.onPressed,  this.color = Colors.black})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 10),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 16,
            color: color,
            decoration: TextDecoration.underline,
          ),
        ),
      ),
    );
  }
}
