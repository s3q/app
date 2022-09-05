import "package:flutter/material.dart";

class TextButtonWidget extends StatelessWidget {
  Function() onPressed;
  String text;
  TextButtonWidget({Key? key, required this.text, required this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Text(
        text,
        style: TextStyle(
            fontSize: Theme.of(context).textTheme.bodyMedium?.fontSize,
            fontWeight: Theme.of(context).textTheme.bodyMedium?.fontWeight,
            color: Theme.of(context).hintColor,
        ),
      ),
    );
  }
}
