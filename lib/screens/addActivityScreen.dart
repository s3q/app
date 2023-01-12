import 'dart:io';
import 'dart:typed_data';

import 'package:app/helpers/appHelper.dart';
import 'package:app/helpers/colorsHelper.dart';
import 'package:app/providers/activityProvider.dart';
import 'package:app/providers/userProvider.dart';
import 'package:app/schemas/activitySchema.dart';
import 'package:app/screens/activityCreatedScreen.dart';
import 'package:app/screens/homeScreen.dart';
import 'package:app/screens/pickLocationScreen.dart';
import 'package:app/screens/policyAndPrivacyScreen.dart';
import 'package:app/screens/previewNewActivityScreen.dart';
import 'package:app/screens/termsAndConditionsScreen.dart';
import 'package:app/widgets/LinkWidget.dart';
import 'package:app/widgets/SafeScreen.dart';
import 'package:app/widgets/appBarWidget.dart';
import 'package:app/widgets/checkboxWidget.dart';
import 'package:app/widgets/dividerWidget.dart';
import 'package:app/widgets/inputTextFieldWidget.dart';
import 'package:app/widgets/loadingWidget.dart';
import 'package:app/widgets/uploadDatesBoxWidget.dart';
import 'package:app/widgets/uploadImagePagesWidget.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:searchfield/searchfield.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:translator/translator.dart';
import 'package:uuid/uuid.dart';
import "package:localization/localization.dart";

enum BestTutorSite { Days, Dates }

class AddActivityScreen extends StatefulWidget {
  static String router = "add_activity";
  const AddActivityScreen({super.key});

  @override
  State<AddActivityScreen> createState() => _AddActivityScreenState();
}

class _AddActivityScreenState extends State<AddActivityScreen> {
  final _formKey = GlobalKey<FormState>();
  final ImagePicker _picker = ImagePicker();
  late String Id;

  int onceCheck = 0;

  final _phoneNumberWhatsappController = TextEditingController();
  final _phoneNumberCallController = TextEditingController();

  PageController pageViewController = PageController(initialPage: 0);

  bool _checkboxChatT = true;
  final _checkboxChatW = ValueNotifier<bool>(false);
  final _checkboxChatC = ValueNotifier<bool>(true);
  final _instagramCheck = ValueNotifier<bool>(false);
  final _daysOrDatesCheck = ValueNotifier<bool>(true);
  final _daysContainerSize = ValueNotifier<Size>(Size(0, 0));
  final _datesContainerSize = ValueNotifier<Size>(Size(0, 0));
  final _avilableDates = ValueNotifier<List>([]);
  bool _checkboxOp_SFC = true;
  bool _checkboxOp_GOA = true;
  bool _checkboxOp_SCT = false;

  bool _isLoading = false;
  List overlay = [];

  final _uploadedImagesPath = ValueNotifier<List<String>>([]);
//   Map<int, String> uploadedumagesPath = {};
  Map<int, String> uploadedumagesPath = {
    1: "",
    2: "",
    3: "",
    4: "",
    5: "",
    6: "",
    7: "",
  };
  String? errorInUploadImages;
  final _errorMassage = ValueNotifier<String?>(null);

  List _categories = AppHelper.categories.map((e) => e["title"]).toList();

  Map data = {};
  Map<String, int> suitableAges = {};
  Map<String, bool> genderSuitability = {};

  Map<String, Map<String, String?>?> prices = {};

  List dates = [];

  Map weekDays = {
    "sunday": false,
    "monday": false,
    "tuesday": false,
    "wednesday": false,
    "thursday": false,
    "friday": false,
    "saturday": false,
  };

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    Id = Uuid().v4();
  }

  void _pickImage() async {
    final List<XFile>? images = await _picker.pickMultiImage();

    if (images != null) {
      images.forEach((e) {
        _uploadedImagesPath.value = [e.path, ..._uploadedImagesPath.value];
      });
    }
  }

  void removeUploadedImage(value) {
    bool re = _uploadedImagesPath.value.remove(value);
    print(re);
  }

  void bookmarkMainPhoto(value) {
    _uploadedImagesPath.value.remove(value);
    _uploadedImagesPath.value.insertAll(0, value);
  }

  Future _submit(BuildContext context) async {
    EasyLoading.show(maskType: EasyLoadingMaskType.black);
    try {
      ActivityProvider activityProvider =
          Provider.of<ActivityProvider>(context, listen: false);
      UserProvider userProvider =
          Provider.of<UserProvider>(context, listen: false);
      bool validation = _formKey.currentState!.validate();

      if (validation) {
        _formKey.currentState!.save();

        if (_daysOrDatesCheck.value) {
          dates = [];
        } else {
          for (var d in weekDays.keys) {
            weekDays[d] = false;
          }
        }

        data["availableDays"] = weekDays.keys.map((v) {
          if (weekDays[v] == true) {
            print(v);
            return v;
          }
        }).toList();

        data["availableDays"]
            .removeWhere((e) => e == null || e?.toString().trim() == "");
        dates.removeWhere((e) => e == null || e?.toString().trim() == "");

        List tags = [];
        GoogleTranslator translator = GoogleTranslator();

        await translator
            .translate(data["title"], from: "auto", to: "ar")
            .then((value) => tags.add(value.text));
        await translator
            .translate(data["title"], from: "auto", to: "en")
            .then((value) => tags.add(value.text));

        await translator
            .translate(data["title"], from: "auto", to: "ar")
            .then((value) => tags.add(value.text));
        await translator
            .translate(data["address"], from: "auto", to: "en")
            .then((value) => tags.add(value.text));

        //   prices = prices.map((k, v) {
        //     print(prices[k]?["price"].runtimeType);
        //     if (prices[k]?["price"] == null || prices[k]?["price"]?.trim() == "") {
        //       print(k);

        //       return MapEntry(k, null);
        //     }
        //     return MapEntry(k, prices[k]!);
        //   });

        print(prices);

        ActivitySchema activityData = ActivitySchema(
          isActive: false,
          createdAt: DateTime.now().millisecondsSinceEpoch,
          lastUpdate: DateTime.now().millisecondsSinceEpoch,
          userId: userProvider.currentUser!.Id,
          Id: Id,
          dates: dates,
          lat: data["lat"],
          lng: data["lng"],
          address: data["address"],
          phoneNumberWhatsapp: data["phoneNumberWhatsapp"] ?? "",
          phoneNumberCall: data["phoneNumberCall"],
          description: data["description"],
          images: [],
          importantInformation: data["importantInformation"],
          availableDays: data["availableDays"],
          cTrippointChat: _checkboxChatT,
          category: data["category"],
          prices: prices.values.toList(),
          priceNote: data["priceNote"],
          op_GOA: _checkboxOp_GOA,
          suitableAges: suitableAges,
          genderSuitability: genderSuitability,
          title: data["title"],
          reviews: [],
          tags: tags,
        );

        //   setState(() {
        //     _isLoading = true;
        //   });

        //   overlay = AppHelper.showOverlay(context, LoadingWidget());

        print(uploadedumagesPath);

        for (var cacheImage in uploadedumagesPath.values) {
          if (cacheImage.trim() == "" || cacheImage == null) {
            //   uploadedumagesPath.remove(e);
            continue;
          }

          String prefix =
              uploadedumagesPath.values.singleWhere((e) => e == cacheImage) == 0
                  ? "main"
                  : "regu";

          String path =
              "${ActivityProvider.collection}/$Id/displayImages/${prefix + Uuid().v4()}.jpg";
          final storageRef = FirebaseStorage.instance.ref(path);
          File file = File(cacheImage);
          await storageRef.putFile(file).then((p0) async {
            await p0.ref
                .getDownloadURL()
                .then((value) => activityData.images.add(value));
          });
        }

        //   activityData.images = await uploadedumagesPath.keys.map((e) async {
        //     String prefix = e == 0 ? "main" : "regu";

        //     if (uploadedumagesPath[e]?.trim() == "" ||
        //         uploadedumagesPath[e] == null) {
        //       //   uploadedumagesPath.remove(e);
        //       return "";
        //     }
        //     String path =
        //         "${ActivityProvider.collection}/$Id/displayImages/${prefix + Uuid().v4()}.jpg";
        //     final storageRef = FirebaseStorage.instance.ref(path);
        //     File file = File(uploadedumagesPath[e]!);
        //     return await storageRef.putFile(file).then<String>((p0) async {
        //       return await p0.ref.getDownloadURL();
        //     });

        //     // uploadedumagesPath[e] = path;
        //     // return path;
        //   }).toList();

        //   activityData.images = uploadedumagesPath.values.toList();
        activityData.images.removeWhere(((e) => e == null));
        activityData.availableDays.removeWhere(((e) => e == null));
        //   activityData.availableDays.removeWhere(((e) => e == null));

        print(activityData.images);

        print(activityData.toMap());

        bool done =
            await activityProvider.createActivity(context, activityData);

        assert(done != false);

        //   overlay[1].remove();
        EasyLoading.showSuccess('');

        //   Navigator.pushReplacementNamed(context, ActivityCreatedScreen.router);
        Navigator.pushNamedAndRemoveUntil(context, PreviewNewActivityScreen.router, (route) {
          return false;
        }, arguments: activityData);
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
    // EasyLoading.dismiss();

    // overlay[0].dispose();
  }

  @override
  Widget build(BuildContext context) {
    UserProvider userProvider = Provider.of<UserProvider>(context);

    if (userProvider.currentUser?.isProAccount == false &&
        userProvider.proCurrentUser == null) {
      return SafeScreen(
          child: Center(
        child: Text(AppHelper.returnText(context, "You should have been logging in", "كان يجب أن تقوم بتسجيل الدخول")),
      ));
    } else if (userProvider.currentUser?.isProAccount == false ||
        userProvider.proCurrentUser == null) {
      print("user");
      //  ! error code
    }

    if (onceCheck == 0) {
      _phoneNumberWhatsappController.text =
          userProvider.proCurrentUser!.publicPhoneNumber;
      _phoneNumberWhatsappController.text =
          userProvider.proCurrentUser!.publicPhoneNumber;
      onceCheck == 1;
    }

    final daysContainerKey = GlobalKey();
    final datesContainerKey = GlobalKey();
    return SafeScreen(
      padding: 0,
      child: Column(
        children: [
          AppBarWidget(
            title: AppHelper.returnText(context, "Add Activity", "إضافة نشاط"),
          ),
          Expanded(
            child: ListView(
              children: [
                SizedBox(
                  height: 30,
                ),
                AbsorbPointer(
                  absorbing: _isLoading,
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        //   OutlinedButton.icon(
                        //     icon: Icon(Icons.photo_camera_back_outlined),
                        //     label: const Text("Add photos"),
                        //     onPressed: () async {
                        //       setState(() {
                        //         errorInUploadImages = null;
                        //       });
                        //       _pickImage();
                        //     },
                        //   ),
                        //   if (errorInUploadImages != null)
                        //     Text(errorInUploadImages!),
                        UploadImagePagesWidget(
                            imagesPath: uploadedumagesPath,
                            onImageAdded: (images) {
                              uploadedumagesPath = images;
                              print(uploadedumagesPath);
                            }),
                        SizedBox(
                          height: 20,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10),
                          child: Column(
                            children: [
                              const SizedBox(
                                height: 15,
                              ),
                              InputTextFieldWidget(
                                text: data["title"],
                                labelText: "Title",
                                helperText: AppHelper.returnText(context, "Give your activity a title.", "ضع نشاطك عنوانًا."),
                                validator: (val) {
                                  if (val == null)
                                                          return AppHelper.returnText(context, "Use 3 characters or more for the title", "استخدم 3 أحرف أو أكثر للعنوان") ;

                                  if (val.trim() == "" || val.length < 3)
                                                          return AppHelper.returnText(context, "Use 3 characters or more for the title", "استخدم 3 أحرف أو أكثر للعنوان") ;
                                  
                                  if (val.length > 100)
                                                                                            return AppHelper.returnText(context, "The title is too long", "العنوان طويل جدًا") ;

                                  //   if (val.contains(r'[A-Za-z]')) {
                                  //     return "The name should only consist of letters";
                                  //   }
                                  return null;
                                },
                                onSaved: (val) {
                                  data["title"] = val?.trim();
                                },
                              ),
                              const SizedBox(
                                height: 15,
                              ),
                            
                              SearchField(
                                suggestions: _categories
                                    .map((e) => SearchFieldListItem(e.toString().tr()))
                                    .toList(),
                                suggestionState: Suggestion.expand,
                                textInputAction: TextInputAction.next,
                                hint: AppHelper.returnText(context, 'Choose category', "اختر التصنيف"),
                                hasOverlay: true,
                                searchStyle: const TextStyle(
                                  fontSize: 18,
                                  color: Colors.black,
                                ),
                                validator: (x) {
                                  if (!_categories.contains(x) || x!.isEmpty) {
                                    return AppHelper.returnText(context, 'Please Enter category from the list', "الرجاء إدخال فئة من القائمة");
                                  }
                                },
                                onSubmit: (p0) {
                                  print(p0);
                                },
                                searchInputDecoration: InputDecoration(
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                      color: Colors.black45,
                                    ),
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  border: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.black45),
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                ),
                                maxSuggestionsInViewPort: 6,
                                itemHeight: 40,
                                initialValue: data["categories"],
                                onSuggestionTap: (x) {
                                  data["category"] = x.searchKey;
                                },
                              ),
                              const SizedBox(
                                height: 25,
                              ),
                              Text(AppHelper.returnText(context, "You can add more than one price to your activity that suits your customers more.", "يمكنك إضافة أكثر من سعر إلى نشاطك بما يناسب عملائك أكثر.")),
                             
                             const SizedBox(
                                height: 5,
                              ),
                               Row(
                                children: [
                                  Expanded(
                                    child: InputTextFieldWidget(
                                      labelText: "OMR: *",
                                      validator: (val) {
                                        bool empty = true;
                                        print(prices.values);
                                        prices.values.map((e) {
                                          if (e != null) {
                                            if (e.toString().trim() != "") {
                                              empty = false;
                                            }
                                          }
                                        });
                                        if (val.toString().trim() != "") {
                                          empty = false;
                                        }
                                        if (empty) {
                                          return AppHelper.returnText(context, "One price at least", "سعر واحد على الأقل") ;
                                        }
                                        //   if (val.contains(r'[A-Za-z]')) {
                                        //     return "The name should only consist of letters";
                                        //   }
                                        return null;
                                      },
                                      onSaved: (val) {
                                        prices["1"] = {
                                          "price": val?.trim(),
                                        };
                                      },
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: InputTextFieldWidget(
                                      labelText: AppHelper.returnText(context, "Price: *", "السعر: *"),
                                      validator: (val) {
                                        if (prices["1"]?["price"] != null) {
                                          if (val == null)
                                            return AppHelper.returnText(context, "Type the price", "اكتب السعر");
                                          if (val.trim() == "" ||
                                              val.length < 1)
                                            return AppHelper.returnText(context, "Type the price", "اكتب السعر");
                                        }
                                        //   if (val.contains(r'[A-Za-z]')) {
                                        //     return "The name should only consist of letters";
                                        //   }
                                        return null;
                                      },
                                      onSaved: (val) {
                                        if (prices["1"]?["price"] != null) {
                                          prices["1"] = {
                                            "price": prices["1"]?["price"],
                                            "des": val?.trim(),
                                          };
                                        }
                                      },
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(
                                height: 10,
                              ),

                              Row(
                                children: [
                                  Expanded(
                                    child: InputTextFieldWidget(
                                      labelText:  "OMR: ",
                                      validator: (val) {
                                        //   if (val.contains(r'[A-Za-z]')) {
                                        //     return "The name should only consist of letters";
                                        //   }
                                        return null;
                                      },
                                      onSaved: (val) {
                                        if (val.toString().trim() != "") {
                                          prices["2"] = {
                                            "price": val?.trim(),
                                          };
                                        }
                                      },
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: InputTextFieldWidget(
                                      labelText:  AppHelper.returnText(context, "Price:", "السعر:"),
                                      validator: (val) {
                                        if (prices["2"]?["price"] != null) {
                                          if (val == null)
                                                                                        return AppHelper.returnText(context, "Type the price", "اكتب السعر");

                                          if (val.trim() == "" ||
                                              val.length < 1)
                                                                                        return AppHelper.returnText(context, "Type the price", "اكتب السعر");

                                        }
                                        return null;
                                      },
                                      onSaved: (val) {
                                        if (prices["2"]?["price"] != null) {
                                          prices["2"] = {
                                            "price": prices["2"]?["price"],
                                            "des": val?.trim(),
                                          };
                                        }
                                      },
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(
                                height: 10,
                              ),

                              Row(
                                children: [
                                  Expanded(
                                    child: InputTextFieldWidget(
                                      labelText:  "OMR:",
                                      validator: (val) {
                                        //   if (val.contains(r'[A-Za-z]')) {
                                        //     return "The name should only consist of letters";
                                        //   }
                                        return null;
                                      },
                                      onSaved: (val) {
                                        if (val.toString().trim() != "") {
                                          prices["3"] = {
                                            "price": val?.trim(),
                                          };
                                        }
                                      },
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: InputTextFieldWidget(
                                      labelText:  AppHelper.returnText(context, "Price:", "السعر:"),
                                      validator: (val) {
                                        if (prices["3"]?["price"] != null) {
                                          if (val == null)
                                                                                        return AppHelper.returnText(context, "Type the price", "اكتب السعر");

                                          if (val.trim() == "" ||
                                              val.length < 1)
                                                                                        return AppHelper.returnText(context, "Type the price", "اكتب السعر");

                                        }
                                        return null;
                                      },
                                      onSaved: (val) {
                                        if (prices["3"]?["price"] != null) {
                                          prices["3"] = {
                                            "price": prices["2"]?["price"],
                                            "des": val?.trim(),
                                          };
                                        }
                                      },
                                    ),
                                  ),
                                ],
                              ),

                              SizedBox(
                                height: 10,
                              ),

                              const SizedBox(
                                height: 20,
                              ),
                              InputTextFieldWidget(
                                text: data["priceNote"],
                                labelText:  AppHelper.returnText(context, "Price Notes: ", "ملاحظات السعر:"),
                                minLines: 4,
                                helperText:  AppHelper.returnText(context, "You can add a description that explains the prices more.","بامكانك اضافة وصف يوضح الاسعار أكثر. "),
                                validator: (val) {
                                  if (val.length > 200) return AppHelper.returnText(context, "The text is too long", "النص طويل جدا");

                                  return null;
                                },
                                onSaved: (val) {
                                  data["priceNote"] = val?.trim();
                                },
                              ),
                              const SizedBox(
                                height: 15,
                              ),

                              InputTextFieldWidget(
                                text: data["description"],
                                labelText: "Description",
                                minLines: 4,
                                helperText:
                                    AppHelper.returnText(context, "Add more details about the activity.", "أضف المزيد من التفاصيل حول النشاط ."),
                                validator: (val) {
                                  if (val == null)
                                    return AppHelper.returnText(context, "Use 10 characters or more for description", "استخدم 10 أحرف أو أكثر للوصف");
                                  if (val.trim() == "" || val.length < 10)
                                    return AppHelper.returnText(context, "Use 10 characters or more for description", "استخدم 10 أحرف أو أكثر للوصف");

                                  if (val.length > 300)                             return AppHelper.returnText(context, "The text is too long", "النص طويل جدا");
 

                                  return null;
                                },
                                onSaved: (val) {
                                  data["description"] = val?.trim();
                                },
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              InputTextFieldWidget(
                                text: data["importantInformation"],
                                labelText: "Important Information",
                                minLines: 4,
                                helperText: "Add important information",
                                validator: (val) {
                                //   if (val == null)
                                //     return AppHelper.returnText(context, "Use 10 characters or more for important information", "استخدم 10 أحرف أو أكثر في المعلومات مهمة");
                                //   if (val.trim() == "" || val.length < 10)
                                //     return AppHelper.returnText(context, "Use 10 characters or more for important information", "استخدم 10 أحرف أو أكثر في المعلومات مهمة");

                                  if (val.length > 300)  return AppHelper.returnText(context, "The text is too long", "النص طويل جدا");;

                                  return null;
                                },
                                onSaved: (val) {
                                  data["importantInformation"] = val?.trim() ?? "";
                                },
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              InputTextFieldWidget(
                                labelText: AppHelper.returnText(context, "Address: *", "عنوان: *") ,
                                text: data["address"],
                                validator: (val) {
                                  if (val == null)
                                    return AppHelper.returnText(context, "Use 2 characters or more for address", "استخدم حرفين أو أكثر للعنوان");
                                  if (val.trim() == "" || val.length < 2)
                                    return AppHelper.returnText(context, "Use 2 characters or more for address", "استخدم حرفين أو أكثر للعنوان");

                                  return null;
                                },
                                onSaved: (val) {
                                  print(val);
                                  data["address"] = val?.trim();
                                },
                              ),

                              SizedBox(
                                height: 20,
                              ),
                              OutlinedButton.icon(
                                icon: Icon(Icons.location_on_outlined),
                                label: Text(AppHelper.returnText(context, "Add the activity location: *", "أضف موقع النشاط: *")),
                                onPressed: () async {
                                  final latlanArg = await Navigator.pushNamed(
                                          context, PickLocationSceen.router)
                                      as LatLng;
                                  print(latlanArg);
                                  if (latlanArg != null) {
                                    data["lat"] = latlanArg.latitude;
                                    data["lng"] = latlanArg.longitude;
                                  }
                                },
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                               Text(
                                AppHelper.returnText(context,  "Choose how you would like to be contacted by customers: *", "اختر الطريقة التي تود أن يتواصل بها العملاء معك: *"),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              CheckboxWidget(
                                  label: AppHelper.returnText(context, "Trippoint Chat", "Trippoint محادثات"),
                                  isCheck: _checkboxChatT,
                                  onChanged: (isChecked) {
                                    print(isChecked);
                                    _checkboxChatT = isChecked;
                                  }),
                              CheckboxWidget(
                                  label:  AppHelper.returnText(context, "Whatsapp", "واتساب"),
                                  isCheck: _checkboxChatW.value,
                                  onChanged: (isChecked) {
                                    print(isChecked);
                                    _checkboxChatW.value = isChecked;
                                  }),
                              ValueListenableBuilder(
                                valueListenable: _checkboxChatW,
                                builder: (context, value, child) {
                                  return InputTextFieldWidget(
                                    enabled: value as bool,
                                    keyboardType: TextInputType.number,
                                    text: data["phoneNumberWhatsapp"],
                                    labelText: AppHelper.returnText(context, "Phone Number: ", "رقم الهاتف: "),
                                    //   labelStyle:,
                                    helperText:
                                        AppHelper.returnText(context, "Add Your Phone Number to receive messages on whatsapp.", "أضف رقم هاتفك لتلقي الرسائل على الواتس اب."),
                                    validator: (val) {
                                      // AppHelper.checkPhoneValidation(
                                      //     context, val);
                                      // if (val?.length != 8) {
                                      //   return "invalid phone number";
                                      // }
                                    },

                                    onSaved: (val) {
                                      data["phoneNumberWhatsapp"] = val?.trim();
                                    },
                                  );
                                },
                              ),
                              CheckboxWidget(
                                  label: AppHelper.returnText(context, "Calls", "المكالمات"),
                                  isCheck: _checkboxChatC.value,
                                  onChanged: (isChecked) {
                                    _checkboxChatC.value =
                                        !_checkboxChatC.value;
                                  }),

                              ValueListenableBuilder(
                                valueListenable: _checkboxChatC,
                                builder: (context, value, child) {
                                  return InputTextFieldWidget(
                                    enabled: value as bool,
                                    keyboardType: TextInputType.number,
                                    text: data["phoneNumberCall"],
                                    labelText: "Phone Number",
                                    //   labelStyle:,
                                    helperText:
                                        AppHelper.returnText(context, "Add Your Phone Number to receive calls.", "أضف رقم هاتفك لتلقي المكالمات."),

                                    validator: (val) {
                                      if (_checkboxChatC.value) {
                                        AppHelper.checkPhoneValidation(
                                            context, val);
                                        if (val?.length != 8) {
                                          return  AppHelper.returnText(context, "Invalid phone number, try again", "رقم الهاتف غير صالح ، حاول مرة أخرى");
                                        }
                                      }
                                    },
                                    onSaved: (val) {
                                      data["phoneNumberCall"] = val?.trim();
                                    },
                                  );
                                },
                              ),
                              const SizedBox(
                                height: 15,
                              ),

                              // CheckboxWidget(
                              //     label:
                              //         "Would you like to add the activity Instagram page ?",
                              //     isCheck: _instagramCheck.value,
                              //     onChanged: (isChecked) {
                              //       print(isChecked);
                              //       _instagramCheck.value =
                              //           !_instagramCheck.value;
                              //     }),
                              // // SizedBox(height: 5,),
                              // ValueListenableBuilder(
                              //   valueListenable: _instagramCheck,
                              //   builder: (context, value, child) {
                              //     return InputTextFieldWidget(
                              //       enabled: value as bool,
                              //       keyboardType: TextInputType.number,

                              //       labelText: "instagram Account",
                              //       //   labelStyle:,
                              //       helperText: "Add Your instagram.",

                              //       validator: (val) {},
                              //       onSaved: (val) {
                              //         data["instagramAccount"] = val?.trim();
                              //       },
                              //     );
                              //   },
                              // ),
                              SizedBox(
                                height: 20,
                              ),

                              InputDatesOrDays(
                                dates: dates,
                                weekDays: weekDays,
                                onChangedDates: (d1) {
                                  print(d1);
                                  dates = d1;
                                },
                                onChangedDays: (d2) {
                                  print(d2);
                                  weekDays = d2;
                                },
                                onChanged: (c1) {
                                  _daysOrDatesCheck.value = c1;
                                },
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                                                             Text(AppHelper.returnText(context, "What are the allowed age for this activity? (Optional)", "ما هو العمر المسموح به لهذا النشاط؟ (اختياري)")),

                              Row(
                                children: [
                                  Expanded(
                                    child: InputTextFieldWidget(
                                      keyboardType: TextInputType.number,
                                      labelText:  AppHelper.returnText(context, "Maximum Age: ", "الحد الأقصى للعمر: "),
                                      onSaved: (val) {
                                        try {
                                          assert(val.toString().trim() != "");
                                          suitableAges["max"] =
                                              int.parse(val?.trim());
                                        } catch (err) {}
                                      },
                                    ),
                                  ),
                                  SizedBox(
                                    width: 20,
                                  ),
                                  Expanded(
                                    child: InputTextFieldWidget(
                                      keyboardType: TextInputType.number,
                                      labelText: AppHelper.returnText(context, "Minimum Age: ", "الحد الإدنى للعمر: "),
                                      onSaved: (val) {
                                        try {
                                          assert(val.toString().trim() != "");
                                          suitableAges["min"] =
                                              int.parse(val?.trim());
                                        } catch (err) {}
                                      },
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 20,
                              ),

                               Text(AppHelper.returnText(context, "Who this activity for ? (Optional)", "لمن هذا النشاط؟ (اختياري)")),
                              Row(
                                children: [
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Expanded(
                                    child: CheckboxWidget(
                                        label: AppHelper.returnText(context, "Men Only", "الرجال فقط"),
                                        isCheck:
                                            genderSuitability["man"] ?? false,
                                        onChanged: (isChecked) {
                                          print(isChecked);
                                          genderSuitability["man"] = isChecked;
                                        }),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Expanded(
                                    child: CheckboxWidget(
                                        label:  AppHelper.returnText(context, "Women Only", "النساء فقط"),
                                        isCheck:
                                            genderSuitability["woman"] ?? false,
                                        onChanged: (isChecked) {
                                          print(isChecked);
                                          genderSuitability["woman"] =
                                              isChecked;
                                        }),
                                  ),
                                ],
                              ),

                              const SizedBox(
                                height: 20,
                              ),
                              CheckboxWidget(
                                  label: AppHelper.returnText(context, "Do you have group bookings like for families ?", "هل لديك حجوزات جماعية مثل العائلات؟"),
                                  isCheck: _checkboxOp_GOA,
                                  onChanged: (isChecked) {
                                    print(isChecked);
                                    _checkboxOp_GOA = isChecked;
                                  }),

                              const SizedBox(
                                height: 20,
                              ),

                              ValueListenableBuilder(
                                valueListenable: _errorMassage,
                                builder: (context, value, child) {
                                  if (value.runtimeType != String) {
                                    return SizedBox();
                                  }
                                  return Column(
                                    children: [
                                      Container(
                                        margin: const EdgeInsets.all(10),
                                        padding: const EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                          color: ColorsHelper.red,
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        child: Text(value.toString()),
                                      ),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                    ],
                                  );
                                },
                              ),

                              SizedBox(
                                height: 20,
                              ),
                              Align(
                                  alignment: Alignment.bottomCenter,
                                  child: Column(
                                    children: [
                                      Text(
                                        AppHelper.returnText(context, "By clicking create activity you agree to our ", "بالنقر فوق إنشاء نشاط ، فإنك توافق على"),
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall,
                                      ),
                                      Row(
                                        children: [
                                          LinkWidget(
                                              onPressed: () {
                                                Navigator.pushNamed(
                                                    context,
                                                    TermsAndConditionsScreen
                                                        .router);
                                              },
                                              text: "Terms and condition".tr()),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          Text(
                                            "and",
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodySmall,
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          LinkWidget(
                                              onPressed: () {
                                                Navigator.pushNamed(
                                                    context,
                                                    PolicyAndPrivacyScreen
                                                        .router);
                                              },
                                              text: "Policy Privacy".tr()),
                                        ],
                                      )
                                    ],
                                  )),

                              SizedBox(
                                height: 20,
                              ),
                              ElevatedButton(
                                onPressed: () async {
                                  await _submit(context);
                                },
                                child: Text("Create Activity".tr()),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class UploadContainer extends StatelessWidget {
  const UploadContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      width: MediaQuery.of(context).size.width,
      child: Text(
        "upload Image",
      ),
    );
  }
}

class RasiedButtonContainer extends StatefulWidget {
  Function onChanged;
  RasiedButtonContainer({required this.onChanged});

  @override
  State<RasiedButtonContainer> createState() => _RasiedButtonContainerState();
}

class _RasiedButtonContainerState extends State<RasiedButtonContainer> {
  BestTutorSite _site = BestTutorSite.Days;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: ListTile(
            title: Text("Days"),
            leading: Radio(
              value: BestTutorSite.Days,
              groupValue: _site,
              onChanged: (value) {
                if (value != _site) {
                  widget.onChanged();
                }
                setState(() {
                  _site = value as BestTutorSite;
                });
              },
            ),
          ),
        ),
        Expanded(
          child: ListTile(
            title: Text("Dates"),
            leading: Radio(
              value: BestTutorSite.Dates,
              groupValue: _site,
              onChanged: (value) {
                if (value != _site) {
                  widget.onChanged();
                }
                setState(() {
                  _site = value as BestTutorSite;
                });
              },
            ),
          ),
        ),
      ],
    );
  }
}

class InputDatesOrDays extends StatefulWidget {
  Map weekDays;
  List dates;
  Function(Map) onChangedDays;
  Function(List) onChangedDates;
  Function(bool) onChanged;
  InputDatesOrDays({
    super.key,
    required this.weekDays,
    required this.dates,
    required this.onChangedDates,
    required this.onChangedDays,
    required this.onChanged,
  });

  @override
  State<InputDatesOrDays> createState() => _InputDatesOrDaysState();
}

class _InputDatesOrDaysState extends State<InputDatesOrDays> {
  bool _daysOrDatesCheck = true;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      margin: EdgeInsets.all(5),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: Colors.grey,
            width: 1,
          )),
      child: Column(children: [
        RasiedButtonContainer(
          onChanged: () {
            setState(() {
              _daysOrDatesCheck = !_daysOrDatesCheck;
            });
            widget.onChanged(_daysOrDatesCheck);
          },
        ),

        SizedBox(
          height: 10,
        ),
        //   absorbing: (value as bool),
        if (_daysOrDatesCheck == true)
          Column(
            children: [
              const Text("chose the days will the activity is visiable"),
              ...widget.weekDays.keys.map((v) {
                return CheckboxWidget(
                    label: v,
                    isCheck: widget.weekDays[v] ?? false,
                    onChanged: (isChecked) {
                      print(isChecked);
                      widget.weekDays[v] = isChecked;

                      widget.onChangedDays(widget.weekDays);
                    });
              }).toList(),
            ],
          ),
        if (_daysOrDatesCheck == false)
          UploadDatesBoxWidget(
              dates: widget.dates,
              onDatesSelected: (fdates) {
                print(fdates);
                widget.onChangedDates(fdates);
                //   widget.dates = fdates;
              }),
      ]),
    );
  }
}
