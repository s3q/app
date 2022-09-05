import "package:flutter/material.dart";

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: ListView(
          children: [
              Text("Profile", style: Theme.of(context).textTheme.titleLarge,),
          ],
      ),
    );
  }
}
