import 'package:app/helpers/colorsHelper.dart';
import 'package:app/providers/settingsProvider.dart';
import 'package:app/providers/userProvider.dart';
import 'package:app/schemas/proUserSchema.dart';
import 'package:app/screens/getStartedScreen.dart';
import 'package:app/screens/homeScreen.dart';
import 'package:app/screens/profileScreen.dart';
import 'package:app/widgets/LinkWidget.dart';
import 'package:app/widgets/SafeScreen.dart';
import 'package:app/widgets/appBarWidget.dart';
import 'package:date_field/date_field.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:phone_number/phone_number.dart';
import 'package:provider/provider.dart';
import 'package:searchfield/searchfield.dart';

class SwitchToProAccountScreen extends StatefulWidget {
  static String router = "switch_to_pro_account";

  const SwitchToProAccountScreen({super.key});

  @override
  State<SwitchToProAccountScreen> createState() =>
      _SwitchToProAccountScreenState();
}

class _SwitchToProAccountScreenState extends State<SwitchToProAccountScreen> {
  final _formKey1 = GlobalKey<FormState>();
  final _formKey2 = GlobalKey<FormState>();
  TextEditingController _nameInput = TextEditingController();
  TextEditingController _emailInput = TextEditingController();
  TextEditingController _phoneNumberInput = TextEditingController();
  TextEditingController _cityInput = TextEditingController();

  TextEditingController _publicEmailInput = TextEditingController();
  TextEditingController _publicPhoneNumber = TextEditingController();
  Map data = {};

  int indexOverView = 0;
  bool isCheckedCheckbox = false;
  PhoneNumberUtil _phoneNumber = PhoneNumberUtil();

  RegionInfo region = const RegionInfo(name: "Oman", code: "OM", prefix: 968);

  void _checkPhoneValidation(BuildContext context, val) async {
    bool isValid = await _phoneNumber.validate(val, region.code);

    if (!isValid) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Theme.of(context).errorColor,
        content: const Text("invalid phone number, try again, +986 only"),
      ));
    }
  }

  Future _submit(BuildContext context) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    bool validation = _formKey1.currentState!.validate();
    bool done = false;

    if (validation) {
      _formKey1.currentState!.save();
      print(data);

      ProUserSchema proUserData = ProUserSchema(
        createdAt: DateTime.now().millisecondsSinceEpoch,
        userId: userProvider.currentUser!.Id,
        publicPhoneNumber: data["publicPhoneNumber"],
        publicEmail: data["publicEmail"],
      );

      await userProvider.switchToProAccount(
        context: context,
        proUserData: proUserData,
        city: data["city"],
        dateOfBirth: data["dateOfBirth"],
        name: data["name"],
      );

    //   Navigator.pushNamed(context, ProfileScreen.router);

    setState(() {
      indexOverView += 1;
    });
    }
  }

  @override
  Widget build(BuildContext context) {
    final settingsProvider = Provider.of<SettingsProvider>(context);
    UserProvider userProvider = Provider.of<UserProvider>(context);
    _nameInput.text = userProvider.currentUser!.name ?? data["name"] ?? "";
    _emailInput.text =
        userProvider.proCurrentUser?.publicEmail ?? data["email"] ?? "";
    _phoneNumberInput.text = userProvider.proCurrentUser?.publicPhoneNumber ??
        data["phoneNumber"] ??
        "";
    _cityInput.text = userProvider.currentUser!.city ?? data["city"] ?? "";

    data["city"] = _cityInput.text;

    List _citiesOfOman = ["muscate", "smail", "nazwa"];

    List overViewDescription = [
      // 1
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 100,
          ),
          Text(
            "Profissional Account",
            style: Theme.of(context).textTheme.titleMedium,
          ),
          SizedBox(
            height: 20,
          ),
          Text(
            "Enjoy adding promotional activities and interaction benefits to the platform",
            style: Theme.of(context).textTheme.displaySmall,
          ),
        ],
      ),

      //2
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                Text(
                  "Update Your Information \n",
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                Text(
                    " Make sure that the information is correct and all of them must be fill in, and if you don't enter it correctly, the application will be rejected"),
              ],
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Form(
            key: _formKey1,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  TextFormField(
                    controller: _nameInput,
                    keyboardType: TextInputType.name,
                    obscureText: false,
                    decoration: const InputDecoration(
                      labelText: "Name",
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
                      if (val.split(" ").length > 2) {
                        return "Please write your full name";
                      }
                      //   if (val.contains(r'[A-Za-z]')) {
                      //     return "The name should only consist of letters";
                      //   }
                      return null;
                    },
                    onSaved: (val) {
                      data["name"] = val?.trim();
                    },
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  DateTimeFormField(
                    // initialDate: DateTime.fromMillisecondsSinceEpoch(userProvider.currentUser!.dateOfBirth ?? DateTime.now().millisecondsSinceEpoch),
                    initialValue: DateTime.fromMillisecondsSinceEpoch(
                        userProvider.currentUser!.dateOfBirth ??
                            DateTime.now().millisecondsSinceEpoch),
                    decoration: const InputDecoration(
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
                      contentPadding: EdgeInsets.all(20),
                      suffixIcon: Icon(Icons.event_note),
                      labelText: "Date of Birth",
                    ),
                    mode: DateTimeFieldPickerMode.date,
                    // autovalidateMode: AutovalidateMode.always,
                    validator: (value) {
                      if (value == null) {
                        return "";
                      }
                      if (value.year < (DateTime.now().year - 18)) {
                        print(value);
                      } else {
                        return "You are under 18";
                      }
                    },
                    onSaved: (value) {
                      print(value);
                      data["dateOfBirth"] = value?.millisecondsSinceEpoch;
                    },
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  SearchField(
                    initialValue: SearchFieldListItem(
                        userProvider.currentUser?.city ?? _citiesOfOman[0]),
                    suggestions: _citiesOfOman
                        .map((e) => SearchFieldListItem(e))
                        .toList(),
                    suggestionState: Suggestion.expand,
                    textInputAction: TextInputAction.next,
                    hint: 'City',
                    hasOverlay: true,
                    searchStyle: const TextStyle(
                      fontSize: 18,
                      color: Colors.black,
                    ),
                    validator: (x) {
                      if (!_citiesOfOman.contains(x) || x!.isEmpty) {
                        return 'Please Enter a valid city';
                      }
                      //   return null;
                    },
                    onSubmit: (p0) {
                      print(p0);
                    },
                    searchInputDecoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.black45,
                        ),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black45),
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    maxSuggestionsInViewPort: 6,
                    itemHeight: 40,
                    onSuggestionTap: (x) {
                      data["city"] = x;
                    },
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  TextFormField(
                    controller: _emailInput,
                    keyboardType: TextInputType.name,
                    autofocus: true,
                    obscureText: false,
                    decoration: const InputDecoration(
                      labelText: "Public Email",
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
                      //
                      //
                      //   if (val == null ||
                      //       !EmailValidator.validate(val.trim(), true)) {
                      //     return "invalid email address";
                      //   }
                      //   return null;
                    },
                    onSaved: (val) {
                      data["publicEmail"] = val?.trim();
                    },
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  TextFormField(
                    controller: _phoneNumberInput,
                    keyboardType: TextInputType.name,
                    autofocus: true,
                    obscureText: false,
                    decoration: const InputDecoration(
                      //   suffixText: ,
                      labelText: "Public Phone Number",
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
                      _checkPhoneValidation(context, val);
                      if (val?.length != 8) {
                        return "invalid phone number";
                      }

                      return null;
                    },
                    onSaved: (val) async {
                      data["publicPhoneNumber"] = val?.trim();
                    },
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Row(
                    children: [
                      Checkbox(
                        checkColor: Colors.white,
                        fillColor: MaterialStateProperty.all(Colors.blue),
                        value: isCheckedCheckbox,
                        onChanged: (bool? value) {
                          setState(() {
                            isCheckedCheckbox = value!;
                          });
                        },
                      ),

                      Text("Agree to"),
                  LinkWidget(text: "terms and condition", onPressed: () {})
                    ],
                  ),
                  
                ],
              ),
            ),
          ),
        ],
      ),

      Column(
        children: [
          SizedBox(
            height: 50,
          ),
          Icon(
            Icons.done_all_rounded,
            size: 100,
            color: ColorsHelper.green,
          ),
          SizedBox(
            height: 30,
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                Text(
                  "almost we Done \n",
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                Text(" please wait 6 hours to vertify your infromation"),
              ],
            ),
          ),
          SizedBox(
            height: 20,
          ),
        ],
      )
    ];

    return SafeScreen(
      padding: 0,
      child: Column(
        children: [
          AppBarWidget(title: "Profissional Account"),
          Expanded(
            child: ListView(
              children: [
                SizedBox(
                  height: 30,
                ),
                Padding(
                    padding: const EdgeInsets.all(10),
                    child: overViewDescription[indexOverView]),
                Container(
                  padding: EdgeInsets.all(15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      indexOverView > 0
                          ? ElevatedButton(
                              onPressed: () {
                                if (indexOverView > 0) {
                                  //!!!!!!!!!
                                  setState(() {
                                    indexOverView -= 1;
                                  });
                                }
                              },
                              style: ButtonStyle(
                                padding: MaterialStateProperty.all(
                                  const EdgeInsets.symmetric(
                                      horizontal: 60, vertical: 20),
                                ),
                              ),
                              child: Text("Back"),
                            )
                          : SizedBox(),
                      ElevatedButton(
                        onPressed: () async {
                          if (indexOverView  == 0) {
                            //!!!!!!!!!

                            setState(() {
                              indexOverView += 1;
                            });
                          } else if (indexOverView == 2) {
                            Navigator.pushReplacementNamed(context, ProfileScreen.router);
                          } else {
                            await _submit(context);
                          } 
                        },
                        style: ButtonStyle(
                          padding: MaterialStateProperty.all(
                            const EdgeInsets.symmetric(
                                horizontal: 60, vertical: 20),
                          ),
                        ),
                        child: indexOverView !=  2?  (indexOverView == 1
                            ? const Text("Get Started")
                            : const Text("Next")) : Text("Done"),
                      ),
                    ],
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
