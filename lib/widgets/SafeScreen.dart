import "package:flutter/material.dart";

class SafeScreen extends StatelessWidget {
  Widget child;
  double? padding;
  SafeScreen({Key? key, required this.child, this.padding}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
            color: Colors.white,
          padding: EdgeInsets.all(padding ?? 10),
          child: child,
        ),
      ),
    );
  }
}
