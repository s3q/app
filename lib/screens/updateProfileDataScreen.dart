import 'package:app/widgets/SafeScreen.dart';
import 'package:app/widgets/appBarWidget.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';

class UpdateProfileDataScreen extends StatelessWidget {
  static String router = "update_profile";
  UpdateProfileDataScreen({super.key});

  Map data = {};

  TextEditingController _input = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final _isEmail = ModalRoute.of(context)!.settings.arguments as bool;
    // bool _isEmail = args;
    return SafeScreen(
      padding: 0,
      child: Column(children: [
        AppBarWidget(
          title: "Update " + (_isEmail ? "Email" : "Phone Number"),
        ),
        SizedBox(
          height: 30,
        ),
        Container(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              SizedBox(
                height: 30,
              ),
              Text("We'll send an email to confirm your email address."),
              SizedBox(
                height: 10,
              ),
              TextFormField(
                controller: _input,
                keyboardType: TextInputType.emailAddress,
                autofocus: true,
                obscureText: false,
                decoration: InputDecoration(
                  hintText: _isEmail ? "Email" : "Phone Number",
                  filled: true,
                  fillColor: Colors.white,
                  prefixIcon: const Icon(
                    Icons.email_rounded,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.black45,
                      width: 1,
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(16)),
                  ),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.black45,
                      width: 1,
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(16)),
                  ),
                ),
                validator: (val) {
                  if (_isEmail) {
                    if (val == null ||
                        !EmailValidator.validate(val.trim(), true)) {
                      return "invalid email address";
                    }
                    return null;
                  } else {
                    if (val == null)
                      return "Use 6 characters or more for your password";
                    if (val.trim() == "" || val.length < 6)
                      return "Use 6 characters or more for your password";

                    return null;
                  }
                },
                onSaved: (val) {
                  _isEmail
                      ? data["email"] = val?.trim()
                      : data["phoneNumber"] = val?.trim();
                },
              ),
            ],
          ),
        ),
      ]),
    );
  }
}
