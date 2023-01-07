import 'package:app/providers/userProvider.dart';
import 'package:app/screens/accountCreatedScreen.dart';
import 'package:app/screens/forgotPasswordScreen.dart';
import 'package:app/screens/homeScreen.dart';
import 'package:app/screens/policyAndPrivacyScreen.dart';
import 'package:app/screens/termsAndConditionsScreen.dart';
import 'package:app/widgets/LinkWidget.dart';
import 'package:app/widgets/SafeScreen.dart';
import 'package:app/widgets/appBarWidget.dart';
import 'package:app/widgets/inputTextFieldWidget.dart';
import 'package:app/widgets/textButtonWidget.dart';
import 'package:email_validator/email_validator.dart';
import "package:flutter/material.dart";
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';
import "package:easy_localization/easy_localization.dart";

class SigninScreen extends StatefulWidget {
  static String router = "/signin";

  SigninScreen({Key? key}) : super(key: key);

  @override
  State<SigninScreen> createState() => _SigninScreenState();
}

class _SigninScreenState extends State<SigninScreen> {
  final _formKey = GlobalKey<FormState>();

  final Map data = {};

  bool _islogin = true;

  void _submit(context) async {
    EasyLoading.show(maskType: EasyLoadingMaskType.black);
    try {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      bool validation = _formKey.currentState!.validate();
      bool done = false;

      if (validation) {
        _formKey.currentState!.save();
        if (data != {}) {
          if (_islogin) {
            done = await userProvider.login(
              context,
              email: data["email"],
              password: data["password1"],
            );
          } else {
            if (data["password1"] != data["password2"]) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                backgroundColor: Theme.of(context).errorColor,
                content: const Text("Those passwords didn't match. Try again."),
              ));
              return;
            }
            done = await userProvider.signup(
              context,
              email: data["email"],
              password: data["password1"],
              name: "${data["name1"]} ${data["name2"]}",
            );
          }
          assert(done != false);

          EasyLoading.showSuccess("");
          Navigator.pushNamedAndRemoveUntil(context, HomeScreen.router,
              (route) {
            return false;
          });
        }
      }
    } catch (err) {
      print(err);
      EasyLoading.showError("");
    }
    await Future.delayed(Duration(milliseconds: 1500));
    EasyLoading.dismiss();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeScreen(
        padding: 0,
        child: Column(
          children: [
            AppBarWidget(title: _islogin ? "Sign up" : "Login"),
            Expanded(
              child: ListView(
                children: [
                  Container(
                    padding: EdgeInsets.all(10),
                    // height: MediaQuery.of(context).size.height - 20,
                    child: Column(children: [
                      Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            SizedBox(
                              height: 30,
                            ),
                            Container(
                              width: 100,
                              height: 100,
                              decoration: const BoxDecoration(
                                  image: DecorationImage(
                                      image: AssetImage(
                                          "assets/images/profile.png"),
                                      fit: BoxFit.fill)),
                            ),
                            SizedBox(
                              height: 40,
                            ),
                            if (!_islogin)
                              Row(
                                children: [
                                  Expanded(
                                    child: InputTextFieldWidget(
                                      labelText: "Fisrt Name",
                                      prefixIcon: Icons.person,
                                      validator: (val) {
                                        if (val == null)
                                          return "Use 3 characters or more for your name";
                                        if (val.trim() == "" || val.length < 3)
                                          return "Use 3 characters or more for your name";
                                        //   if (val.contains(r'[A-Za-z]')) {
                                        //     return "The name should only consist of letters";
                                        //   }
                                        return null;
                                      },
                                      onSaved: (val) {
                                        data["name1"] = val?.trim();
                                      },
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Expanded(
                                    child: InputTextFieldWidget(
                                      keyboardType: TextInputType.name,
                                      labelText: "Second Name",
                                      prefixIcon: Icons.person,
                                      validator: (val) {
                                        if (val == null)
                                          return "Use 3 characters or more for your name";
                                        if (val.trim() == "" || val.length < 3)
                                          return "Use 3 characters or more for your name";
                                        //   if (!val.contains(r'^[A-Za-z]+$')) {
                                        //     return "The name should only consist of letters";
                                        //   }
                                        return null;
                                      },
                                      onSaved: (val) {
                                        data["name2"] = val?.trim();
                                      },
                                    ),
                                  )
                                ],
                              ),
                            //     SizedBox(
                            //     height: 20,
                            //   ),
                            SizedBox(
                              height: 15,
                            ),
                            InputTextFieldWidget(
                              labelText: "Email",
                              prefixIcon: Icons.email_rounded,
                              validator: (val) {
                                if (val == null ||
                                    !EmailValidator.validate(
                                        val.trim(), true)) {
                                  return "invalid email address";
                                }
                                return null;
                              },
                              onSaved: (val) {
                                data["email"] = val?.trim();
                              },
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            InputTextFieldWidget(
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
                            if (_islogin) ...[
                              const SizedBox(
                                height: 10,
                              ),
                              TextButtonWidget(
                                  text: "forgot password?",
                                  onPressed: () {
                                    Navigator.pushNamed(
                                        context, ForgotPasswordScreen.router);
                                  }),
                            ],

                            if (!_islogin) ...[
                              const SizedBox(
                                height: 15,
                              ),
                              InputTextFieldWidget(
                                labelText: "confirm Password",
                                prefixIcon: Icons.key_rounded,
                                validator: (val) {
                                  if (val == null) {
                                    return "Use 6 characters or more for your password";
                                  }
                                  if (val.trim() == "" || val.length < 6) {
                                    return "Use 6 characters or more for your password";
                                  }
                                  if (data["password1"].toString().trim() !=
                                      val.trim()) {
                                    return "Those passwords didn't match. Try again.";
                                  }
                                  return null;
                                },
                                onSaved: (val) {
                                  data["password2"] = val?.trim();
                                },
                              )
                            ],
                            SizedBox(
                              height: 20,
                            ),
                            ElevatedButton.icon(
                              onPressed: () {
                                _submit(context);
                              },
                              icon: Icon(Icons.keyboard_backspace_rounded),
                              label: Text(_islogin ? "Login" : "Sign up"),
                            ),
                            SizedBox(
                              height: 30,
                            ),

                            Text(
                              _islogin
                                  ? "Have an account?"
                                  : "Don't have an account?",
                              // style: Theme.of(context).textTheme.bodyLarge,
                            ),

                            SizedBox(
                              height: 20,
                            ),
                            OutlinedButton(
                                onPressed: () {
                                  setState(() {
                                    _islogin = !_islogin;
                                  });
                                },
                                child: Text(_islogin ? "Login" : "Sign up")),
                            // LinkWidget(
                            //     text: _islogin ? "Login" : "Sign up",
                            //     onPressed: () {
                            //       setState(() {
                            //         _islogin = !_islogin;
                            //       });
                            //     })

                            SizedBox(
                              height: 40,
                            ),
                          ],
                        ),
                      ),
                      if (!_islogin)
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Column(
                            children: [
                              Text(
                                "By clicking Sign up you agree to our ",
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                              Row(
                                children: [
                                  LinkWidget(
                                      onPressed: () {
                                        Navigator.pushNamed(context,
                                            TermsAndConditionsScreen.router);
                                      },
                                      text: "Terms and condition".tr()),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    "and",
                                    style:
                                        Theme.of(context).textTheme.bodySmall,
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  LinkWidget(
                                      onPressed: () {
                                        Navigator.pushNamed(context,
                                            PolicyAndPrivacyScreen.router);
                                      },
                                      text: "Policy Privacy".tr()),
                                ],
                              )
                            ],
                          ),
                        ),
                    ]),
                  ),
                ],
              ),
            ),
          ],
        ));
  }
}
