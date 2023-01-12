import 'package:app/helpers/appHelper.dart';
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
import 'package:app/widgets/checkboxWidget.dart';
import 'package:app/widgets/inputTextFieldWidget.dart';
import 'package:app/widgets/snakBarWidgets.dart';
import 'package:date_field/date_field.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
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
  TextEditingController _instagramInput = TextEditingController();

  TextEditingController _publicEmailInput = TextEditingController();
  TextEditingController _publicPhoneNumber = TextEditingController();
  Map data = {};

  int indexOverView = 0;
//   bool isCheckedCheckbox = false;
  PhoneNumberUtil _phoneNumber = PhoneNumberUtil();

  final isCheckedCheckbox = ValueNotifier<bool>(false);

  RegionInfo region = const RegionInfo(name: "Oman", code: "OM", prefix: 968);

  void _checkPhoneValidation(BuildContext context, val) async {
    bool isValid = await _phoneNumber.validate(val, region.code);

    if (!isValid) {
      SnakbarWidgets.error(
          context, AppHelper.returnText(context, "Invalid phone number,try again, only +968", "رقم غير صالح, حاول مجددا, 968+ فقط") );
    }
  }

  Future _submit(BuildContext context) async {
    try {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      bool validation = _formKey1.currentState!.validate();
      bool done = false;

      if (validation) {
        _formKey1.currentState!.save();
        print(data);

        EasyLoading.show(maskType: EasyLoadingMaskType.black);

        ProUserSchema proUserData = ProUserSchema(
            createdAt: DateTime.now().millisecondsSinceEpoch,
            userId: userProvider.currentUser!.Id,
            publicPhoneNumber: data["publicPhoneNumber"],
            publicEmail: data["publicEmail"],
            instagram: data["instagram"]);

        bool done = await userProvider.switchToProAccount(
          context: context,
          proUserData: proUserData,
          city: data["city"],
          dateOfBirth: data["dateOfBirth"],
          name: data["name"],
        );

        assert(done != false);

        EasyLoading.showSuccess("");

        //   Navigator.pushNamed(context, ProfileScreen.router);

        setState(() {
          indexOverView += 1;
        });
      }
    } catch (err) {
      print(err);
      EasyLoading.showError("");
    }
    EasyLoading.dismiss();
  }

  @override
  Widget build(BuildContext context) {
    final settingsProvider = Provider.of<SettingsProvider>(context);
    UserProvider userProvider = Provider.of<UserProvider>(context);
    _nameInput.text = userProvider.currentUser!.name ?? data["name"] ?? "";

    _instagramInput.text =
        userProvider.proCurrentUser?.instagram ?? data["instagram"] ?? "";
    _emailInput.text = userProvider.proCurrentUser?.publicEmail ??
        (data["email"] != null &&
                userProvider.proCurrentUser?.publicEmail != data["email"]
            ? data["email"]
            : null) ??
        "";
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
            AppHelper.returnText(context, "Professional Account", "حساب إحترافي") ,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          SizedBox(
            height: 20,
          ),
          Text(
             AppHelper.returnText(context, "Enjoy adding promotional activities and interaction benefits to the platform", "استمتع بإضافة أنشطة ترويجية ومزايا تفاعلية إلى المنصة"),
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
                   AppHelper.returnText(context, " Make sure that the information is correct and not all of them must be fill in, and if you don't enter it correctly, the application will be rejected", "تأكد من أن المعلومات صحيحة ولا يجب ملؤها كلها ، وإذا لم تدخلها بشكل صحيح ، فسيتم رفض الطلب") ),
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
                    decoration:  InputDecoration(
                    
                      labelText: AppHelper.returnText(context, "Name: *", "الاسم: *") ,
                      filled: true,
                      fillColor: Colors.white,
                      prefixIcon: const Icon(
                        Icons.person,
                      ),
                      focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.black45,
                          width: 1,
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(16)),
                      ),
                      border: const OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.black45,
                          width: 1,
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(16)),
                      ),
                    ),
                    validator: (val) {
                      if (val == null)
                        return AppHelper.returnText(context, "Use 3 characters or more for your name", "استخدم 3 أحرف أو أكثر لاسمك") ;
                      if (val.trim() == "" || val.length < 3)
                        return  AppHelper.returnText(context, "Use 3 characters or more for your name", "استخدم 3 أحرف أو أكثر لاسمك");
                      if (val.split(" ").length < 2) {
                        return  AppHelper.returnText(context, "Please write your full name", "الرجاء كتابة اسمك الكامل") ;
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
                    decoration:  InputDecoration(
                      focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.black45,
                          width: 1,
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(16)),
                      ),
                      border: const OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.black45,
                          width: 1,
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(16)),
                      ),
                      contentPadding: EdgeInsets.all(20),
                      suffixIcon: const Icon(Icons.event_note),
                      labelText:  AppHelper.returnText(context, "Date of Birth: *", "تاريخ الميلاد: *"),
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
                        return AppHelper.returnText(context, "You are under 18", "عمرك أقل من 18") ;
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
                    hint: AppHelper.returnText(context, 'City: *', 'المدينة: *'),
                    hasOverlay: true,
                    searchStyle: const TextStyle(
                      fontSize: 18,
                      color: Colors.black,
                    ),
                    validator: (x) {
                      if (!_citiesOfOman.contains(x) || x!.isEmpty) {
                        return AppHelper.returnText(context, "The state is incorrect", "الولاية غير صحيحة" );
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
                    decoration:  InputDecoration(
                      labelText: AppHelper.returnText(context, "Public Email: ", "البريد إلكتروني العام: "),
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
                    decoration:  InputDecoration(
                      //   suffixText: ,
                      labelText:  AppHelper.returnText(context, "Public Phone Number: ", "رقم الهاتف العام :"),
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
                      if (val?.trim().length != 8 && val?.trim().length !=  0) {
                        return AppHelper.returnText(context, "Invalid phone number", "رقم الهاتف غير صحيح");
                      }

                      return null;
                    },
                    onSaved: (val) async {
                      data["publicPhoneNumber"] = val?.trim();
                    },
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  InputTextFieldWidget(
                    text: data["instagram"],
                    labelText: AppHelper.returnText(context, "Instagram Account: ", "حساب الانستجرام: "),
                    helperText: "",
                    validator: (val) {
                      //   if (val == null)
                      //     return "Use 3 characters or more for a title";
                      //   if (val.trim() == "" || val.length < 3)
                      //     return "Use 3 characters or more for a title";
                      //   //   if (val.contains(r'[A-Za-z]')) {
                      //   //     return "The name should only consist of letters";
                      //   //   }
                      return null;
                    },
                    onSaved: (val) {
                      data["instagram"] = val?.trim();
                    },
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  CheckboxWidget(
                    label: AppHelper.returnText(context, "Agree to terms and conditions", "الموافقة على الشروط والأحكام "),
                    isCheck: isCheckedCheckbox.value,
                    onChanged: (bool? value) {
                      isCheckedCheckbox.value = value!;
                    },
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
                  AppHelper.returnText(context, "We almost we Done \n", "لقد انتهينا تقريبًا \n"),
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                Text(AppHelper.returnText(context, "Please wait 6 hours to verify your information, until further notice. After that, you will be able to publish your tourist activity ads in the application.", "يرجى الانتظار 6 ساعات للتحقق من معلوماتك ،حتى اشعار اخر. بعدها ستتمكن من نشر اعلانات انشتطك السياحية في التطبيق")),
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
          AppBarWidget(title: AppHelper.returnText(context, "Professional Account", "حساب إحترافي") ),
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
                              child: Text(AppHelper.returnText(context, "Back", "رجوع")),
                            )
                          : SizedBox(),
                      ValueListenableBuilder(
                          valueListenable: isCheckedCheckbox,
                          builder: (context, value, child) {
                            return ElevatedButton(
                              onPressed: indexOverView == 1 &&
                                      isCheckedCheckbox.value == false
                                  ? null
                                  : () async {
                                      if (indexOverView == 0) {
                                        //!!!!!!!!!

                                        setState(() {
                                          indexOverView += 1;
                                        });
                                      } else if (indexOverView == 2) {
                                        Navigator.pop(context);
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
                              child: indexOverView != 2
                                  ? (indexOverView == 1
                                      ?  Text(AppHelper.returnText(context, "Get Started", "البدء"))
                                      :  Text(AppHelper.returnText(context, "Next", "التالي")))
                                  : Text(AppHelper.returnText(context, "Done", "تم")),
                            );
                          }),
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
