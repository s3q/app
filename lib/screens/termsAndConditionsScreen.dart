import 'package:app/widgets/SafeScreen.dart';
import "package:flutter/material.dart";

class TermsAndConditionsScreen extends StatelessWidget {
  static String router = "/terms_conditions";
  const TermsAndConditionsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeScreen(child: Center(
        child: Text("Terms And Conditions", style: Theme.of(context).textTheme.titleLarge,),
    ));
  }
}
