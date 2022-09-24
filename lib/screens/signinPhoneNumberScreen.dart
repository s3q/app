import 'package:app/providers/userProvider.dart';
import 'package:app/screens/getStartedScreen.dart';
import 'package:app/screens/homeScreen.dart';
import 'package:app/screens/policyAndPrivacyScreen.dart';
import 'package:app/screens/signinScreen.dart';
import 'package:app/screens/termsAndConditionsScreen.dart';
import 'package:app/widgets/LinkWidget.dart';
import 'package:app/widgets/SafeScreen.dart';
import 'package:app/widgets/textButtonWidget.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import "package:flutter/material.dart";
import 'package:flutter/services.dart';
import 'package:phone_number/phone_number.dart';
import 'package:provider/provider.dart';
import "package:easy_localization/easy_localization.dart";

class SigninPhoneNumberScreen extends StatefulWidget {
  static String router = "/signinPhoneNumber";

  SigninPhoneNumberScreen({Key? key}) : super(key: key);

  @override
  State<SigninPhoneNumberScreen> createState() =>
      _SigninPhoneNumberScreenState();
}

class _SigninPhoneNumberScreenState extends State<SigninPhoneNumberScreen> {
  final auth = FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState>();
  PhoneNumberUtil _phoneNumber = PhoneNumberUtil();

  final Map data = {};

  RegionInfo region = const RegionInfo(name: "Oman", code: "OM", prefix: 968);
  bool _issent = false;

  void _checkPhoneValidation(BuildContext context, val) async {
    bool isValid = await _phoneNumber.validate(val, region.code);

    if (!isValid) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Theme.of(context).errorColor,
        content: const Text("invalid phone number, try again"),
      ));
    }
  }

  void _submit(context) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    bool validation = _formKey.currentState!.validate();
    bool done = false;

    if (validation) {
      _formKey.currentState!.save();
      if (data != {}) {
        await auth.verifyPhoneNumber(
          phoneNumber: data["phoneNumber"],
          //   timeout: const Duration(seconds: 60),
          verificationCompleted: (PhoneAuthCredential credential) {},
          verificationFailed: (FirebaseAuthException e) {},
          codeSent: (String verificationId, int? resendToken) async {
            setState(() {
              _issent = true;
            });
            data["verificationId"] = verificationId;
          },
          codeAutoRetrievalTimeout: (String verificationId) {
            setState(() {
              _issent = true;
            });
            data["verificationId"] = verificationId;
          },
        );
      }
    }
  }

  void _signinWithPhoneNumber(context) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    print(data["otp"]);
    print(data["verificationId"]);
    try {
      // Create a PhoneAuthCredential with the code
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
          verificationId: data["verificationId"], smsCode: data["otp"]);

      // Sign the user in (or link) with the credential
      UserCredential userCredential =
          await auth.signInWithCredential(credential);

      await userProvider.saveSignInUserData(
        context,
        userCredential.user!,
        signinWithPhoneNumber: true,
      );

      await Navigator.pushNamedAndRemoveUntil(context, HomeScreen.router,
          (route) {
        return false;
      });
    } catch (err) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Theme.of(context).errorColor,
        content: const Text("OTP code doesn't match, try again"),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeScreen(
        padding: 0,
        child: ListView(
          children: [
            Container(
              padding: EdgeInsets.all(10),
              height: MediaQuery.of(context).size.height - 20,
              child: Stack(alignment: Alignment.topCenter, children: [
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Text(
                        "Sign up to TripPoint",
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        keyboardType: TextInputType.phone,
                        autofocus: true,
                        obscureText: false,
                        decoration: const InputDecoration(
                          hintText: "Phone Number +986",
                          filled: true,
                          fillColor: Color(0xFFECF6FF),
                          prefixIcon: Icon(
                            Icons.person,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Color(0x00000000),
                              width: 1,
                            ),
                            borderRadius: BorderRadius.all(Radius.circular(16)),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Color(0x00000000),
                              width: 1,
                            ),
                            borderRadius: BorderRadius.all(Radius.circular(16)),
                          ),
                        ),
                        validator: (val) {
                          _checkPhoneValidation(context, val);
                          if (val?.length != 8) {
                            return "invalid phone number";
                          }

                          return null;
                        },
                        onChanged: (val) async {
                          data["phoneNumber"] = await PhoneNumberUtil().format(
                              "+" + region.prefix.toString() + val.trim(),
                              region.code);
                          print("iiiiiiiii");
                          print(data["phoneNumber"]);
                        },
                        onSaved: (val) async {
                          data["phoneNumber"] = await PhoneNumberUtil().format(
                              "+" +
                                  region.prefix.toString() +
                                  (val?.trim() ?? ""),
                              region.code);
                          print("iiiiiiiii");
                          print(data["phoneNumber"]);
                        },
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      if (_issent)
                        TextFormField(
                          keyboardType: TextInputType.number,
                          autofocus: true,
                          obscureText: false,
                          decoration: const InputDecoration(
                            hintText: "OTP Code",
                            filled: true,
                            fillColor: Color(0xFFECF6FF),
                            prefixIcon: Icon(
                              Icons.person,
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Color(0x00000000),
                                width: 1,
                              ),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(16)),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Color(0x00000000),
                                width: 1,
                              ),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(16)),
                            ),
                          ),
                          validator: (val) {
                            if (val?.trim() == "" || val?.length == 6)
                              return "OTP code at least 6 characters";

                            return null;
                          },
                          onChanged: (val) {
                            data["otp"] = val.trim();
                          },
                        ),
                      ElevatedButton.icon(
                        onPressed: () {
                          if (_issent) {
                            _signinWithPhoneNumber(context);
                          } else {
                            _submit(context);
                          }
                        },
                        icon: Icon(Icons.keyboard_backspace_rounded),
                        label: Text(_issent ? "Sgin in" : "send OTP code"),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Column(
                        children: [
                          Text(
                            "Do you want to signin with email?",
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                          LinkWidget(
                            text: "Login",
                            onPressed: () {
                              Navigator.pushReplacementNamed(
                                context,
                                SigninPhoneNumberScreen.router,
                              );
                            },
                          ),
                          LinkWidget(
                            text: "With Google",
                            onPressed: () {
                              Navigator.pushReplacementNamed(
                                context,
                                GetStartedScreen.router,
                              );
                            },
                          )
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                    ],
                  ),
                ),
                Positioned(
                  bottom: 20,
                  child: Column(
                    children: [
                      Text(
                        "By clicking Sign up you agree to our ",
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      Row(
                        children: [
                          LinkWidget(
                              onPressed: () {
                                Navigator.pushNamed(
                                    context, TermsAndConditionsScreen.router);
                              },
                              text: "Terms and condition".tr()),
                          const SizedBox(
                            width: 10,
                          ),
                          Text(
                            "and",
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          LinkWidget(
                              onPressed: () {
                                Navigator.pushNamed(
                                    context, PolicyAndPrivacyScreen.router);
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
        ));
  }
}
