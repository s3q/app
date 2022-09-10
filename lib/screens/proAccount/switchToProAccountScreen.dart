import 'package:app/providers/settingsProvider.dart';
import 'package:app/providers/userProvider.dart';
import 'package:app/screens/getStartedScreen.dart';
import 'package:app/screens/homeScreen.dart';
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
  final _formKey = GlobalKey<FormState>();
  TextEditingController _firstNameInput = TextEditingController();
  TextEditingController _secondNameInput = TextEditingController();
  TextEditingController _emailInput = TextEditingController();
  TextEditingController _phoneNumberInput = TextEditingController();
  TextEditingController _cityInput = TextEditingController();

  Map data = {};

  int indexOverView = 0;
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

  @override
  Widget build(BuildContext context) {
    final settingsProvider = Provider.of<SettingsProvider>(context);
    UserProvider userProvider = Provider.of<UserProvider>(context);
    _firstNameInput.text = userProvider.currentUser!.name.split(" ")[0];
    _secondNameInput.text = userProvider.currentUser!.name.split(" ")[1];
    _emailInput.text = userProvider.currentUser!.email!;
    _phoneNumberInput.text = userProvider.currentUser!.phoneNumber ?? "";
    _cityInput.text = userProvider.currentUser!.city ?? "";
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
            style: Theme.of(context).textTheme.displayMedium,
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
          SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Text(
              "Update Your",
              style: Theme.of(context).textTheme.displaySmall,
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  TextFormField(
                    controller: _firstNameInput,
                    keyboardType: TextInputType.name,
                    autofocus: true,
                    obscureText: false,
                    decoration: const InputDecoration(
                      suffixText: "Name",
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
                      enabledBorder: OutlineInputBorder(
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
                      data["name"] = val?.trim();
                    },
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  DateTimeFormField(
                    decoration:  InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                          borderSide:
                              BorderSide(color: Colors.black45, width: 1),
                        ),
                        suffixIcon: Icon(Icons.event_note),
                        hintText: "Date of Birth"),
                    mode: DateTimeFieldPickerMode.date,
                    autovalidateMode: AutovalidateMode.always,
                    validator: (value) {
                      print(value);
                    },
                    onDateSelected: (DateTime value) {
                      print(value);
                      data["dateOfBirth"];
                    },
                  ),
                  SizedBox(
                    height: 10,
                  ),
                   
                 SearchField(
                   suggestions: _citiesOfOman
                       .map((e) => SearchFieldListItem(e))
                       .toList(),
                   suggestionState: Suggestion.expand,
                   textInputAction: TextInputAction.next,
                   hint: 'City',
                   hasOverlay: false,
                   searchStyle: const TextStyle(
                     fontSize: 18,
                     color: Colors.black,
                   ),
                   validator: (x) {
                     if (!_citiesOfOman.contains(x) || x!.isEmpty) {
                       return 'Please Enter a valid city';
                     }
                     return null;
                   },
                   onSubmit: (p0) {
                     print(p0);
                   },
                   searchInputDecoration:  InputDecoration(
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
                   itemHeight: 50,
                   // onTap: (x) {},
                 ),
                 SizedBox(height: 10,),
                  TextFormField(
                    controller: _emailInput,
                    keyboardType: TextInputType.name,
                    autofocus: true,
                    obscureText: false,
                    decoration: const InputDecoration(
                      suffixText: "Email",
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
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.black45,
                          width: 1,
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(16)),
                      ),
                    ),
                    validator: (val) {
                      if (val == null ||
                          !EmailValidator.validate(val.trim(), true)) {
                        return "invalid email address";
                      }
                      return null;
                    },
                    onSaved: (val) {
                      data["email"] = val?.trim();
                    },
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    controller: _phoneNumberInput,
                    keyboardType: TextInputType.name,
                    autofocus: true,
                    obscureText: false,
                    decoration: const InputDecoration(
                      suffixText: "Phone Number",
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
                      enabledBorder: OutlineInputBorder(
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
                  SizedBox(
                    height: 10,
                  ),
             
                ],
              ),
            ),
          ),
        ],
      ),
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 20,
          ),
          Text(
            "",
            style: Theme.of(context).textTheme.displaySmall,
          ),
        ],
      ),
    ];

    return SafeScreen(
      padding: 0,
      child: Column(
        children: [
          AppBarWidget(title: "Profissional Account"),
          Expanded(
            child: ListView(
              children: [
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
                        onPressed: () {
                          if (indexOverView != 2) {
                            //!!!!!!!!!
                            setState(() {
                              indexOverView += 1;
                            });
                          } else {
                            Navigator.of(context)
                                .pushReplacementNamed(HomeScreen.router);
                          }
                        },
                        style: ButtonStyle(
                          padding: MaterialStateProperty.all(
                            const EdgeInsets.symmetric(
                                horizontal: 60, vertical: 20),
                          ),
                        ),
                        child: indexOverView == 2
                            ? const Text("Get Started")
                            : const Text("Next"),
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
