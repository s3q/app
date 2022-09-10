import 'package:app/helpers/colorsHelper.dart';
import 'package:app/providers/userProvider.dart';
import 'package:app/screens/updateProfileDataScreen.dart';
import 'package:app/widgets/LinkWidget.dart';
import 'package:app/widgets/SafeScreen.dart';
import 'package:app/widgets/appBarWidget.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EditProfileScreen extends StatefulWidget {
  static String router = "/edit_profile";

  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  TextEditingController _firstNameInput = TextEditingController();
  TextEditingController _secondNameInput = TextEditingController();
  TextEditingController _emailInput = TextEditingController();
  DraggableScrollableController _draggableScrollableController =
      DraggableScrollableController();

  final _formKey = GlobalKey<FormState>();
  bool _loading = false;

  final Map data = {};

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  Future _submit() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    bool validation = _formKey.currentState!.validate();
    _loading = true;

    if (validation) {
      print("Good ! we will work in this later");
    }
  }

  @override
  Widget build(BuildContext context) {
    UserProvider userProvider = Provider.of<UserProvider>(context);
    _firstNameInput.text = userProvider.currentUser!.name.split(" ")[0];
    _secondNameInput.text = userProvider.currentUser!.name.split(" ")[1];
    _emailInput.text = userProvider.currentUser!.email!;

    return SafeScreen(
      padding: 0,
      child: Column(
        children: [
          AppBarWidget(title: "Edit Profile"),
          Expanded(
            child: ListView(
              children: [
                Column(
                  children: [
                    Container(
                      height: 200,
                      padding: EdgeInsets.all(20),
                      child: Form(
                        key: _formKey,
                        child: SizedBox.expand(
                          child: Column(
                            children: [
                              TextFormField(
                                controller: _firstNameInput,
                                keyboardType: TextInputType.name,
                                autofocus: true,
                                obscureText: false,
                                decoration: const InputDecoration(
                                  suffixText: "Fisrt Name",
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
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(16)),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.black45,
                                      width: 1,
                                    ),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(16)),
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
                                  data["name1"] = val?.trim();
                                },
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Expanded(
                                child: TextFormField(
                                  controller: _secondNameInput,
                                  keyboardType: TextInputType.name,
                                  autofocus: true,
                                  obscureText: false,
                                  decoration: const InputDecoration(
                                    suffixText: "Second Name",
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
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(16)),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.black45,
                                        width: 1,
                                      ),
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(16)),
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
                                    data["name2"] = val?.trim();
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
            
                SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Divider(
                height: 1,
              ),
            ),
            ListTile(
              title: Text("Email"),
              subtitle: Text(userProvider.currentUser!.email ?? ""),
              trailing: LinkWidget(
                text: userProvider.currentUser!.email == null
                    ? "Add"
                    : "Edit",
                onPressed: () {},
              ),
              onTap: () {
                print("dfdfdf");
                Navigator.pushNamed(context, UpdateProfileDataScreen.router,
                    arguments: true);
              },
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Divider(
                height: 1,
              ),
            ),
            ListTile(
              title: Text("Phone Number"),
              subtitle: Text(userProvider.currentUser!.phoneNumber ?? ""),
              trailing: LinkWidget(
                text: userProvider.currentUser!.phoneNumber == null
                    ? "Add"
                    : "Edit",
                onPressed: () {},
              ),
              onTap: () {
                print("dfdfdf");
                Navigator.pushNamed(context, UpdateProfileDataScreen.router,
                    arguments: false);
              },
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Divider(
                height: 1,
              ),
            ),
            
                      Container(
              decoration: BoxDecoration(
                  // border: ,
                  ),
              padding: EdgeInsets.all(20),
              child: ElevatedButton(
                child: Text("save"),
                onPressed: () {},
              ),
            ),
              ],
            ),
          ),
          

        ],
      ),
    );
  }
}


           // DraggableScrollableSheet(
            //     controller: _draggableScrollableController,
            //     initialChildSize: 0.1,
            //     maxChildSize: 0.9,
            //     minChildSize: 0.1,
            //     snapSizes: [0.1, 0.9],
            //     snap: true,
            //     builder: (context, scrollController) {
            //       return ListView(controller: scrollController, children: [
            //         Container(
            //           decoration: const BoxDecoration(
            //             color: Colors.white,
            //             borderRadius: BorderRadius.only(
            //               topLeft: Radius.circular(16),
            //               topRight: Radius.circular(16),
            //             ),
            //             boxShadow: [
            //               BoxShadow(
            //                 blurRadius: 8,
            //                 color: Colors.black12,
            //                 spreadRadius: .6,
            //                 offset: Offset(0, -8),
            //               )
            //             ],
            //           ),
            //           margin: EdgeInsets.only(top: 30),
            //           padding:
            //               EdgeInsets.symmetric(vertical: 20, horizontal: 10),
            //           child: Row(
            //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //             children: [
            //               Row(
            //                 children: [
            //                   IconButton(
            //                     onPressed: () {
            //                       scrollController.animateTo(
            //                         0,
            //                         duration: Duration(milliseconds: 400),
            //                         curve: Curves.easeInOut,
            //                       );
            //                     },
            //                     icon: Icon(
            //                       Icons.close_rounded,
            //                       size: 20,
            //                     ),
            //                   ),
            //                   Text("Update Email"),
            //                 ],
            //               ),
            //               Container(
            //                 decoration: BoxDecoration(
            //                   color: Colors.white,
            //                 ),
            //                 child: Center(
            //                   child: Container(
            //                     padding: EdgeInsets.symmetric(vertical: 20),
            //                     decoration: BoxDecoration(
            //                         borderRadius: BorderRadius.circular(50),
            //                         color: ColorsHelper.grey),
            //                     width: 70,
            //                     height: 6,
            //                   ),
            //                 ),
            //               ),
            //             ],
            //           ),
            //         ),
            //         Container(
            //           color: Colors.white,
            //           child: SingleChildScrollView(
            //             child: Container(
            //               padding: EdgeInsets.all(10),
            //               height: MediaQuery.of(context).size.height,
            //               child: Column(
            //                 children: [
            //                   Text(
            //                       "We'll send an email to confirm your email address."),
            //                   SizedBox(
            //                     height: 10,
            //                   ),
            //                   TextFormField(
            //                     controller: _emailInput,
            //                     keyboardType: TextInputType.emailAddress,
            //                     autofocus: true,
            //                     obscureText: false,
            //                     decoration: const InputDecoration(
            //                       hintText: "Email",
            //                       filled: true,
            //                       fillColor: Colors.white,
            //                       prefixIcon: Icon(
            //                         Icons.email_rounded,
            //                       ),
            //                       focusedBorder: OutlineInputBorder(
            //                         borderSide: BorderSide(
            //                           color: Colors.black45,
            //                           width: 1,
            //                         ),
            //                         borderRadius:
            //                             BorderRadius.all(Radius.circular(16)),
            //                       ),
            //                       enabledBorder: OutlineInputBorder(
            //                         borderSide: BorderSide(
            //                           color: Colors.black45,
            //                           width: 1,
            //                         ),
            //                         borderRadius:
            //                             BorderRadius.all(Radius.circular(16)),
            //                       ),
            //                     ),
            //                     validator: (val) {
            //                       if (val == null ||
            //                           !EmailValidator.validate(
            //                               val.trim(), true)) {
            //                         return "invalid email address";
            //                       }
            //                       return null;
            //                     },
            //                     onSaved: (val) {
            //                       data["email"] = val?.trim();
            //                     },
            //                   ),
            //                 ],
            //               ),
            //             ),
            //           ),
            //         ),
            //       ]);
            //     }),