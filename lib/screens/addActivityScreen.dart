import 'package:app/providers/userProvider.dart';
import 'package:app/widgets/SafeScreen.dart';
import 'package:app/widgets/appBarWidget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';

class AddActivityScreen extends StatefulWidget {
  const AddActivityScreen({super.key});

  @override
  State<AddActivityScreen> createState() => _AddActivityScreenState();
}

class _AddActivityScreenState extends State<AddActivityScreen> {
  final _formKey = GlobalKey<FormState>();

  Map data = {};

  @override
  Widget build(BuildContext context) {
    UserProvider userProvider = Provider.of<UserProvider>(context);

    if (userProvider.currentUser?.isProAccount == false &&
        userProvider.proCurrentUser == null) {
      return SafeScreen(
          child: const Center(
        child: Text("you should have been loging in"),
      ));
    } else if (userProvider.currentUser?.isProAccount == false ||
        userProvider.proCurrentUser == null) {
      //  ! error code
    }
    return SafeScreen(
      child: Column(
        children: [
          AppBarWidget(
            title: "Add Activity",
          ),
          SizedBox(
            height: 30,
          ),
          ListView(
            children: [
              Text("dkfjiosdsd,fjkdsfnkjdsnsdmcnsj,ndcs,cnalsmcacqakncam"),
              Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextButton(
                        child: Text("Upload Images"),
                        onPressed: () {},
                      ),
                      TextFormField(
                        // controller: _firstNameInput,
                        keyboardType: TextInputType.name,
                        autofocus: true,
                        obscureText: false,
                        minLines: 4,
                        maxLines: 4,
                        decoration: const InputDecoration(
                          suffixText: "Prices",
                          helperText: "type prices and descripe it.",
                          filled: true,
                          fillColor: Colors.white,
                          prefixIcon: Icon(
                            Icons.person,
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
                          data["pricesDescription"] = val?.trim();
                        },
                      ),
                    ],
                  ))
            ],
          )
        ],
      ),
    );
  }
}
