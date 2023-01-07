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
import 'package:app/widgets/SafeScreen.dart';
import 'package:app/widgets/appBarWidget.dart';
import 'package:app/widgets/checkboxWidget.dart';
import 'package:app/widgets/dividerWidget.dart';
import 'package:app/widgets/inputTextFieldWidget.dart';
import 'package:app/widgets/loadingWidget.dart';
import 'package:app/widgets/uploadDatesBoxWidget.dart';
import 'package:app/widgets/uploadImagePagesWidget.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:searchfield/searchfield.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:translator/translator.dart';
import 'package:uuid/uuid.dart';

enum BestTutorSite { Days, Dates }

class EditActivityScreen extends StatefulWidget {
  static String router = "edit_activity";
  const EditActivityScreen({super.key});

  @override
  State<EditActivityScreen> createState() => _EditActivityScreenState();
}

class _EditActivityScreenState extends State<EditActivityScreen> {
  final _formKey = GlobalKey<FormState>();
  final ImagePicker _picker = ImagePicker();
  late String Id;
  int count = 0;

  final _phoneNumberWhatsappController = TextEditingController();
  final _phoneNumberCallController = TextEditingController();

  PageController pageViewController = PageController(initialPage: 0);

  bool _checkboxChatT = true;
  final _checkboxChatW = ValueNotifier<bool>(false);
  final _checkboxChatC = ValueNotifier<bool>(true);
  final _instagramCheck = ValueNotifier<bool>(false);
  final _daysOrDatesCheck = ValueNotifier<bool>(false);
  final _avilableDates = ValueNotifier<List>([]);
  bool _checkboxOp_SFC = true;
  bool _checkboxOp_GOA = true;
  bool _checkboxOp_SCT = false;

  bool _isLoading = false;
//   List overlay = [];

  final _uploadedImagesPath = ValueNotifier<List<String>>([]);
  Map<int, String> uploadedumagesPath = {};
  List deletedImagesPath = [];

  String? errorInUploadImages;
  final _errorMassage = ValueNotifier<String?>(null);

  List _categories = AppHelper.categories.map((e) => e["title"]).toList();

  Map<String, dynamic> data = {};
  Map<String, int> suitableAges = {};
  Map<String, dynamic> genderSuitability = {};

  Map<String, dynamic> prices = {};

  List dates = [];

  Map weekDays = {
    "sunday": false,
    "moday": false,
    "tuesday": false,
    "wenday": false,
    "thursday": false,
    "firsday": false,
    "starday": false,
  };

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
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
    print("Home");
  }

  Future _submit(BuildContext context, ActivitySchema activitySchema) async {
    EasyLoading.show(maskType: EasyLoadingMaskType.black);
    try {
      ActivityProvider activityProvider =
          Provider.of<ActivityProvider>(context, listen: false);
      UserProvider userProvider =
          Provider.of<UserProvider>(context, listen: false);
      bool validation = _formKey.currentState!.validate();

      Map<String, dynamic> activityData = activitySchema.toMap();

      if (validation) {
        _formKey.currentState!.save();

        data["prices"] = prices.values.toList();
        data["genderSuitability"] = genderSuitability;
        data["dates"] = dates;

        data["suitableAges"]["max"] = suitableAges["max"];
        data["suitableAges"]["min"] = suitableAges["min"];

        data["availableDays"] = weekDays.keys.map((v) {
          if (weekDays[v] == true) {
            print(v);
            return v;
          }
        }).toList();

        //   data["availableDays"] = data["availableDays"].map((e) {
        //     if (e != null && e?.toString().trim() != "") {
        //       return e;
        //     }
        //   }).toList();

        //   data["availableDays"].removeWhere(((key, value) => value == null));
        data["availableDays"]
            .removeWhere((e) => e == null || e?.toString().trim() == "");
        data["dates"]
            .removeWhere((e) => e == null || e?.toString().trim() == "");

        print(data["availableDays"]);

        print(uploadedumagesPath);

        setState(() {
          _isLoading = true;
        });

        //   overlay = AppHelper.showOverlay(context, LoadingWidget());

        String Id = data["Id"];

        if (activitySchema.images != uploadedumagesPath) {
          activitySchema.images.map((e) {
            if (!uploadedumagesPath.containsValue(e)) {
              deletedImagesPath.add(e);
            }
          });
          for (var cacheImage in uploadedumagesPath.values) {
            if (cacheImage.trim() == "" || cacheImage == null) {
              //   uploadedumagesPath.remove(e);
              continue;
            }

            String prefix =
                uploadedumagesPath.values.singleWhere((e) => e == cacheImage) ==
                        0
                    ? "main"
                    : "regu";

            if (!cacheImage.startsWith("http")) {
              String path =
                  "${ActivityProvider.collection}/$Id/displayImages/${prefix + Uuid().v4()}.jpg";
              final storageRef = FirebaseStorage.instance.ref(path);
              File file = File(cacheImage);

              await storageRef.putFile(file).then((p0) async {
                await p0.ref
                    .getDownloadURL()
                    .then((value) => activityData["images"].add(value));
              });
            }
            // return path;
          }

          print("delete images");
          print(deletedImagesPath);

          for (String l in deletedImagesPath) {
            String path = l.toString().split("/o/")[1].split("?")[0];
            final storageRef = FirebaseStorage.instance.ref(path);
            await storageRef.delete();
          }

          data["images"].removeWhere((e) => e == null);
        }

        // activityData.images = uploadedumagesPath.values.toList();
        data.remove("reviews");
        print(data);
        data = data.map((key, value) {
          if (activityData[key] != data[key]) {
            return MapEntry(key, value);
          }
          return MapEntry(key, data[key]);
        });

        // $ ------------------------ translate ---------------------
        List tags = [];
        GoogleTranslator translator = GoogleTranslator();
        print(data["title"]);
        print("translate");

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

        data["tags"] = tags;
        // $ ----------------------------------------------------------

        data.removeWhere(((key, value) => value == null));

        print(data);

        ActivitySchema updatedActivitySchema = ActivitySchema.toSchema(data);
        print(updatedActivitySchema);

        bool done = await activityProvider.updateActivityData(
            context: context,
            data: updatedActivitySchema.toMap(),
            activityStoreId: activitySchema.storeId.toString());

        assert(done != false);

        //   overlay[1].remove();

        EasyLoading.showSuccess('');

        Navigator.pushNamedAndRemoveUntil(context, HomeScreen.router, (route) {
          return false;
        });

        print("Done");
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
    ActivityProvider activityProvider = Provider.of<ActivityProvider>(context);

    if (userProvider.currentUser?.isProAccount == false &&
        userProvider.proCurrentUser == null) {
      return SafeScreen(
          child: const Center(
        child: Text("you should have been loging in"),
      ));
    } else if (userProvider.currentUser?.isProAccount == false ||
        userProvider.proCurrentUser == null) {
      print("user");
      //  ! error code
    }

    _phoneNumberCallController.text =
        userProvider.proCurrentUser!.publicPhoneNumber;
    _phoneNumberWhatsappController.text =
        userProvider.proCurrentUser!.publicPhoneNumber;

    // !!!!! init code

    ActivitySchema activitySchema =
        ModalRoute.of(context)!.settings.arguments as ActivitySchema;
    if (count == 0) {
      activitySchema.images.asMap().map((key, value) {
        uploadedumagesPath[key + 1] = value;

        return MapEntry(key, value);
      });

      print(uploadedumagesPath);
      //   uploadedumagesPath = activitySchema.images.asMap() as Map<int, String>;

      data = activitySchema.toMap();

      weekDays = weekDays.map((key, value) {
        if (activitySchema.availableDays.contains(key)) {
          return MapEntry(key, true);
        }
        return MapEntry(key, value);
      });

      dates = data["dates"];

      prices = activitySchema.prices.asMap().map((key, value) {
        // prices["${key + 1}"] = value;

        return MapEntry("${key + 1}", value);
      });
      print(prices);

      genderSuitability = data["genderSuitability"];

      suitableAges["max"] = data["suitableAges"]["max"];
      suitableAges["min"] = data["suitableAges"]["min"];
      count = 1;
    }

    return SafeScreen(
      padding: 0,
      child: Column(
        children: [
          AppBarWidget(
            title: "Add Activity",
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
                                helperText: "Give your activity title.",
                                validator: (val) {
                                  if (val == null)
                                    return "Use 3 characters or more for a title";
                                  if (val.trim() == "" || val.length < 3)
                                    return "Use 3 characters or more for a title";
                                  //   if (val.contains(r'[A-Za-z]')) {
                                  //     return "The name should only consist of letters";
                                  //   }
                                  return null;
                                },
                                onSaved: (val) {
                                  print(val);
                                  data["title"] = val?.trim();
                                },
                              ),
                              const SizedBox(
                                height: 15,
                              ),
                              SearchField(
                                suggestions: _categories
                                    .map((e) => SearchFieldListItem(e))
                                    .toList(),
                                suggestionState: Suggestion.expand,
                                textInputAction: TextInputAction.next,
                                hint: 'Choose category',
                                hasOverlay: true,
                                searchStyle: const TextStyle(
                                  fontSize: 18,
                                  color: Colors.black,
                                ),
                                validator: (x) {
                                  if (!_categories.contains(x) || x!.isEmpty) {
                                    return 'Please Enter a valid Category';
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
                                initialValue:
                                    SearchFieldListItem(data["category"]),
                                onSuggestionTap: (x) {
                                  data["category"] = x.searchKey;
                                },
                              ),
                              const SizedBox(
                                height: 20,
                              ),

                              Row(
                                children: [
                                  Expanded(
                                    child: InputTextFieldWidget(
                                      text: prices["1"]["price"] ?? "",
                                      labelText: "\$",
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
                                          return "One price at least";
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
                                      labelText: "Price",
                                      text: prices["1"]["des"] ?? "",
                                      validator: (val) {
                                        if (prices["1"]?["price"] != null &&
                                            prices["1"]?["price"] != "") {
                                          if (val == null)
                                            return "Type the price";
                                          if (val.trim() == "" ||
                                              val.length < 1)
                                            return "Type the price";
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
                                      labelText: "\$",
                                      text: prices["2"]["price"] ?? "",
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
                                      labelText: "Price",
                                      text: prices["2"]["des"] ?? "",
                                      validator: (val) {
                                        if (prices["2"]?["price"] != null &&
                                            prices["2"]?["price"] != "") {
                                          if (val == null)
                                            return "Type the price";
                                          if (val.trim() == "" ||
                                              val.length < 1)
                                            return "Type the price";
                                        }
                                        return null;
                                      },
                                      onSaved: (val) {
                                        if (prices["2"]?["price"] != null &&
                                            prices["2"]?["price"] != "") {
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
                                      labelText: "\$",
                                      text: prices["3"]["price"] ?? "",
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
                                      labelText: "Price",
                                      text: prices["3"]["price"] ?? "",
                                      validator: (val) {
                                        if (prices["3"]?["price"] != null &&
                                            prices["3"]?["price"] != "") {
                                          if (val == null)
                                            return "Type the price";
                                          if (val.trim() == "" ||
                                              val.length < 1)
                                            return "Type the price";
                                        }
                                        return null;
                                      },
                                      onSaved: (val) {
                                        if (prices["3"]?["price"] != null &&
                                            prices["3"]?["price"] != "") {
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
                                labelText: "Price Notes",
                                minLines: 4,
                                helperText: "Add the prices for your activity.",
                                validator: (val) {
                                  if (val.length > 50) return "too long";

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
                                    "Add more details about the activitiy",
                                validator: (val) {
                                  if (val == null)
                                    return "Use 10 characters or more for description";
                                  if (val.trim() == "" || val.length < 10)
                                    return "Use 10 characters or more for description";

                                  if (val.length > 100) return "too long";

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
                                  if (val == null)
                                    return "Use 10 characters or more for important information";
                                  if (val.trim() == "" || val.length < 10)
                                    return "Use 10 characters or more for important information";

                                  if (val.length > 100) return "too long";

                                  return null;
                                },
                                onSaved: (val) {
                                  data["importantInformation"] = val?.trim();
                                },
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              InputTextFieldWidget(
                                labelText: "address",
                                text: data["address"],
                                validator: (val) {
                                  if (val == null)
                                    return "Use 2 characters or more for address";
                                  if (val.trim() == "" || val.length < 2)
                                    return "Use 2 characters or more for address";

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
                              PickupLocation(
                                onChanged: (latlang) {
                                  data["lat"] = latlang.latitude;
                                  data["lng"] = latlang.longitude;
                                },
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              const Text(
                                "Choose how you would like to be contacted by customers",
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              CheckboxWidget(
                                  label: "Trippoint Chat",
                                  isCheck: _checkboxChatT,
                                  onChanged: (isChecked) {
                                    print(isChecked);
                                    _checkboxChatT = isChecked;
                                  }),
                              CheckboxWidget(
                                  label: "Whatsapp",
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
                                    labelText: "Phone Number",
                                    //   labelStyle:,
                                    helperText:
                                        "Add Your Phone Number to recive massages on whatsapp.",
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
                                  label: "Call",
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
                                        "Add Your Phone Number to recive calls.",

                                    validator: (val) {
                                      if (_checkboxChatC.value) {
                                        AppHelper.checkPhoneValidation(
                                            context, val);
                                        if (val?.length != 8) {
                                          return "invalid phone number";
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
                              Container(
                                padding: EdgeInsets.all(10),
                                margin: EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                      color: Colors.grey,
                                      width: 1,
                                    )),
                                child: Column(children: [
                                  //   const Text(
                                  //                 "chose the days will the activity is visiable"),
                                  RasiedButtonContainer(
                                    onChanged: () {
                                      _daysOrDatesCheck.value =
                                          !_daysOrDatesCheck.value;

                                    },
                                  ),

                                  SizedBox(
                                    height: 10,
                                  ),
                                  ValueListenableBuilder(
                                      valueListenable: _daysOrDatesCheck,
                                      builder: (context, value, child) {
                                        return AbsorbPointer( 
                                            ignoringSemantics:true,
                                            absorbing: (value as bool),
                                            child: Column(
                                              children: [
                                                const Text(
                                                    "chose the days will the activity is visiable"),
                                                ...weekDays.keys.map((v) {
                                                  return CheckboxWidget(
                                                      label: v,
                                                      isCheck: weekDays[v],
                                                      onChanged: (isChecked) {
                                                        print(isChecked);
                                                        weekDays[v] = isChecked;
                                                      });
                                                }).toList(),
                                              ],
                                            ));
                                      }),
                                  DividerWidget(
                                    text: "Or",
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),

                                  ValueListenableBuilder(
                                      valueListenable: _daysOrDatesCheck,
                                      builder: (context, value, child) {
                                        return AbsorbPointer(ignoringSemantics:false,
                                          absorbing: !(value as bool),
                                          child: UploadDatesBoxWidget(
                                              dates: dates,
                                              onDatesSelected: (fdates) {
                                                print(fdates);
                                                dates = fdates;
                                              }),
                                        );
                                      }),
                                ]),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    child: InputTextFieldWidget(
                                      keyboardType: TextInputType.number,
                                      labelText: "Max Age",
                                      text: suitableAges["max"].toString(),
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
                                      labelText: "Min Age",
                                      text: suitableAges["min"].toString(),
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

                              const Text("Who Activity for ?"),
                              Row(
                                children: [
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Expanded(
                                    child: CheckboxWidget(
                                        label: "man",
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
                                        label: "woman",
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
                                  label: "Does activity accept group booking",
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
                              ElevatedButton(
                                onPressed: () async {
                                  await _submit(context, activitySchema);
                                },
                                child: const Text("Submit"),
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

class PickupLocation extends StatefulWidget {
  Function(LatLng) onChanged;
  PickupLocation({super.key, required this.onChanged});

  @override
  State<PickupLocation> createState() => _PickupLocationState();
}

class _PickupLocationState extends State<PickupLocation> {
  double? lat;
  double? lng;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        OutlinedButton.icon(
          icon: const Icon(Icons.location_on_outlined),
          label: const Text("Add the activity location"),
          onPressed: () async {
            final latlanArg =
                await Navigator.pushNamed(context, PickLocationSceen.router)
                    as LatLng;
            print(latlanArg);
            if (latlanArg != null) {
              lat = latlanArg.latitude;
              lng = latlanArg.longitude;
              widget.onChanged(latlanArg);
            }
          },
        ),
        const SizedBox(
          height: 5,
        ),
        Center(
          child: Row(children: [
            Text(lat.toString()),
            const SizedBox(
              width: 10,
            ),
            Text(lng.toString()),
          ]),
        ),
      ],
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
      child: const Text(
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
    return Container(
      child: Column(children: [
        ListTile(
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
        ListTile(
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
        ),),
      ]),
    );
  }
}
