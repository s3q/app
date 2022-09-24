import 'package:app/helpers/colorsHelper.dart';
import 'package:app/providers/userProvider.dart';
import 'package:app/screens/getStartedScreen.dart';
import 'package:app/screens/homeScreen.dart';
import 'package:app/widgets/SafeScreen.dart';
import 'package:app/widgets/appBarWidget.dart';
import 'package:app/widgets/inputTextFieldWidget.dart';
import 'package:app/widgets/textButtonWidget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class DeleteAccountScreen extends StatefulWidget {
  static String router = "delete_account";
  const DeleteAccountScreen({super.key});

  @override
  State<DeleteAccountScreen> createState() => _DeleteAccountScreenState();
}

class _DeleteAccountScreenState extends State<DeleteAccountScreen> {
  final _formKey = GlobalKey<FormState>();

  final Map data = {};

  Future<bool> _submit(context) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    bool validation = _formKey.currentState!.validate();
    bool done = false;

    if (validation) {
      _formKey.currentState!.save();
      if (data != {}) {
        done = await userProvider.login(
          context,
          email: userProvider.currentUser!.email,
          password: data["password1"],
        );
      }
    }

    return done;
  }

  @override
  Widget build(BuildContext context) {
    UserProvider userProvider = Provider.of<UserProvider>(context);

    return SafeScreen(
        child: Column(
      children: [
        AppBarWidget(title: "Delete Your Account"),
        Expanded(
            child: ListView(
          children: [
            SizedBox(
              height: 30,
            ),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  if (userProvider.currentUser!.providerId == "password")
                      Column(
                          children: [
                            InputTextFieldWidget(
                              //   obscureText: true,
                              labelText: "Password",
                              prefixIcon: Icons.key_rounded,
                              validator: (val) {
                                if (val == null)
                                  return "Use 6 characters or more for your password";
                                if (val.trim() == "" || val.length < 6)
                                  return "Use 6 characters or more for your password";

                                return null;
                              },
                              onChanged: (val) {
                                data["password1"] = val.trim();
                              },
                              onSaved: (val) {
                                data["password1"] = val?.trim();
                              },
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            TextButtonWidget(
                                text: "forget password?",
                                onPressed: () {
                                  print("yes ...............");
                                }),
                          ],
                        ),
                      

                  Text(
                          "Your accoiunt will deleted be carful You cant restore data or back to this account."),
                  SizedBox(
                    height: 30,
                  ),
                  ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                          primary: ColorsHelper.orange),
                      onPressed: () async {
                        bool islogin = false;
                        if (userProvider.currentUser!.providerId ==
                            "password") {
                          islogin = await _submit(context);
                        } else {
                          islogin = true;
                        }
                        if (islogin) {
                          print(islogin);
                          bool done = await userProvider.deleteAccount(context);
                          if (done) {
                            Navigator.pushNamedAndRemoveUntil(context,
                                GetStartedScreen.router, (route) => false);
                          }
                        }
                      },
                      icon: Icon(Icons.delete),
                      label: Text("delete")),
                ],
              ),
            ),
          ],
        ))
      ],
    ));
  }
}
