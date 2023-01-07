import 'package:app/providers/activityProvider.dart';
import 'package:app/providers/userProvider.dart';
import 'package:app/screens/homeScreen.dart';
import 'package:app/widgets/SafeScreen.dart';
import 'package:app/widgets/appBarWidget.dart';
import 'package:app/widgets/inputTextFieldWidget.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';

class ForgotPasswordScreen extends StatelessWidget {
  static String router = "forgot_password";
  ForgotPasswordScreen({super.key});

  final _formKey = GlobalKey<FormState>();
  Map data = {};

  Future<void> _showSuccessDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Next Step'),
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                Text('Check your email.'),
                Text('We send link to reset the password'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Ok'),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.pushNamedAndRemoveUntil(
                    context, HomeScreen.router, (route) => false);
              },
            ),
          ],
        );
      },
    );
  }

  Future _submit(context) async {
    EasyLoading.show(maskType: EasyLoadingMaskType.black);

    try {
      UserProvider userProvider =
          Provider.of<UserProvider>(context, listen: false);
      bool validation = _formKey.currentState!.validate();
      if (validation) {
        _formKey.currentState!.save();

        bool done = await userProvider.forgotPassword(
            context: context, email: data["email"]);

        assert(done != false);

        _showSuccessDialog(context);
      }
    } catch (err) {
      print(err);
      EasyLoading.showError("");
    }
    await Future.delayed(Duration(milliseconds: 1500));
    EasyLoading.dismiss();
  }

  @override
  Widget build(BuildContext context) {
    return SafeScreen(
      padding: 0,
      child: Column(children: [
        AppBarWidget(
          title: "Reset Password",
        ),
        const SizedBox(
          height: 30,
        ),
        Container(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              const SizedBox(
                height: 30,
              ),
              const Text("We'll send an email to reset your password."),
              const SizedBox(
                height: 10,
              ),
              Form(
                key: _formKey,
                child: InputTextFieldWidget(
                  keyboardType: TextInputType.emailAddress,
                  autofocus: true,
                  obscureText: false,
                  hintText: "Email",
                  prefixIcon: Icons.email_rounded,
                  validator: (val) {
                    if (val == null ||
                        !EmailValidator.validate(val.trim(), true)) {
                      return "invalid email address";
                    }
                  },
                  onSaved: (val) {
                    data["email"] = val?.trim();
                  },
                ),
              ),
            ],
          ),
        ),
        Center(
          child: ElevatedButton(
            child: Text("Send"),
            onPressed: () async {
              await _submit(context);
            },
          ),
        ),
      ]),
    );
  }
}
