import 'package:app/providers/userProvider.dart';
import 'package:app/screens/editProfileScreen.dart';
import 'package:app/widgets/SafeScreen.dart';
import 'package:app/widgets/appBarWidget.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';

class UpdateProfileDataScreen extends StatelessWidget {
  static String router = "update_profile";
  UpdateProfileDataScreen({super.key});
  final _formKey = GlobalKey<FormState>();

  Map<String, dynamic> data = {};

  TextEditingController _input = TextEditingController();

  Future _submit(BuildContext context, bool isEmail) async {
    EasyLoading.show(maskType: EasyLoadingMaskType.black);
    try {
      UserProvider userProvider =
          Provider.of<UserProvider>(context, listen: false);
      bool done = false;

      bool validation = _formKey.currentState!.validate();
      if (validation) {
        _formKey.currentState!.save();

        if (isEmail) {
          if (userProvider.currentUser?.providerId == "password") {
            done = await userProvider.updateEmail(data["email"]);
          }
        } else {
          done = await userProvider.updateUserInfo(context, data);
        }
        assert(done != false);

        EasyLoading.showSuccess("");

        Navigator.popAndPushNamed(context, EditProfileScreen.router);
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
    final _isEmail = ModalRoute.of(context)!.settings.arguments as bool;
    // bool _isEmail = args;
    return SafeScreen(
      padding: 0,
      child: Column(children: [
        AppBarWidget(
          title: "Update " + (_isEmail ? "Email" : "Phone Number"),
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
              const Text("We'll send an email to confirm your email address."),
              const SizedBox(
                height: 10,
              ),
              Form(
                key: _formKey,
                child: TextFormField(
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
              ),
              SizedBox(
                height: 10,
              ),
              ElevatedButton(
                  onPressed: () async {
                    await _submit(context, _isEmail);
                  },
                  child: Text("Save"))
            ],
          ),
        ),
      ]),
    );
  }
}
