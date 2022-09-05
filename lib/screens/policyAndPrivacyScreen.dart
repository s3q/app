import 'package:app/widgets/SafeScreen.dart';

import 'package:flutter/material.dart';

class PolicyAndPrivacyScreen extends StatelessWidget {
  static String router = "/policy_privacy";
  const PolicyAndPrivacyScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeScreen(
        child: Center(
      child: Text(
        "Policy Privacy",
        style: Theme.of(context).textTheme.titleLarge,
      ),
    ));
  }
}
