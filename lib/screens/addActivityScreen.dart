import 'dart:io';

import 'package:app/helpers/appHelper.dart';
import 'package:app/providers/activityProvider.dart';
import 'package:app/providers/userProvider.dart';
import 'package:app/schemas/activitySchema.dart';
import 'package:app/screens/pickLocationScreen.dart';
import 'package:app/widgets/SafeScreen.dart';
import 'package:app/widgets/appBarWidget.dart';
import 'package:app/widgets/checkboxWidget.dart';
import 'package:app/widgets/inputTextFieldWidget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:searchfield/searchfield.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:uuid/uuid.dart';

class AddActivityScreen extends StatefulWidget {
  static String router = "add_activity";
  const AddActivityScreen({super.key});

  @override
  State<AddActivityScreen> createState() => _AddActivityScreenState();
}

class _AddActivityScreenState extends State<AddActivityScreen> {
  final _formKey = GlobalKey<FormState>();
  final ImagePicker _picker = ImagePicker();

  final _phoneNumberWhatsappController = TextEditingController();
  final _phoneNumberCallController = TextEditingController();

  PageController pageViewController = PageController(initialPage: 0);

  bool _checkboxChatT = true;
  final _checkboxChatW = ValueNotifier<bool>(false);
  final _checkboxChatC = ValueNotifier<bool>(true);
  final _instagramCheck = ValueNotifier<bool>(false);
  bool _checkboxOp_SFC = true;
  bool _checkboxOp_GOA = true;
  bool _checkboxOp_SCT = false;

  final _uploadedImagesPath = ValueNotifier<List<String>>([]);

  String? errorInUploadImages;

  List _categories = AppHelper.categories.map((e) => e["title"]).toList();

  Map data = {};

  void _pickImage() async {
    final List<XFile>? images = await _picker.pickMultiImage();

    if (images != null) {
      images.forEach((e) {
        _uploadedImagesPath.value = [e.path, ..._uploadedImagesPath.value];
      });
    }
  }

  Future _submit(BuildContext context) async {
    ActivityProvider activityProvider =
        Provider.of<ActivityProvider>(context, listen: false);
    UserProvider userProvider =
        Provider.of<UserProvider>(context, listen: false);
    bool validation = _formKey.currentState!.validate();

    if (validation && _uploadedImagesPath.value.length > 4) {
      _formKey.currentState!.save();
      ActivitySchema activityData = ActivitySchema(
          userId: userProvider.currentUser!.Id,
          Id: Uuid().v4(),
          lat: data["lat"],
          lng: data["lng"],
          address: data["address"],
          phoneNumberWhatsapp: data["phoneNumberWhatsapp"] ?? "",
          phoneNumberCall: data["phoneNumberCall"],
          description: data["description"],
          images: _uploadedImagesPath.value,
          importantInformation: data["importantInformation"],
          instagramAccount: data["instagramAccount"] ?? "",
          //   cCall: data["cCall"],
          //   cTrippointChat: data["cTrippointChat"],
          //   cWhatsapp: data["cWhatsapp"],
          category: data["category"],
          priceStartFrom:  int.parse(data["priceStartFrom"]),
          pricesDescription: data["pricesDescription"],
          op_GOA: _checkboxOp_GOA,
          op_SCT: _checkboxOp_SCT,
          op_SFC: _checkboxOp_SFC,
          title: data["title"],);
      print(activityData.toMap());
      await activityProvider.createActivity(context, activityData);
    }
  }

  @override
  Widget build(BuildContext context) {
    print(_categories);
    UserProvider userProvider = Provider.of<UserProvider>(context);

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

    _phoneNumberWhatsappController.text =
        userProvider.proCurrentUser!.publicPhoneNumber;
    _phoneNumberWhatsappController.text =
        userProvider.proCurrentUser!.publicPhoneNumber;

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
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      OutlinedButton.icon(
                        icon: Icon(Icons.photo_camera_back_outlined),
                        label: const Text("Add photos"),
                        onPressed: () async {
                          setState(() {
                            errorInUploadImages = null;
                          });

                          _pickImage();
                        },
                      ),
                      if (errorInUploadImages != null)
                        Text(errorInUploadImages!),
                      Container(
                        height: 200,
                        child: ValueListenableBuilder(
                          valueListenable: _uploadedImagesPath,
                          builder: (context, value, child) {
                            return Stack(
                              children: [
                                PageView(
                                  controller: pageViewController,
                                  scrollDirection: Axis.horizontal,
                                  children: (value as List<String>)
                                      .map((e) => Image.file(
                                            File(e),
                                            height: 200,
                                            fit: BoxFit.cover,
                                          ))
                                      .toList(),
                                ),
                                if (value.length > 1)
                                  Align(
                                    alignment:
                                        const AlignmentDirectional(.7, .9),
                                    child: SmoothPageIndicator(
                                      controller: pageViewController,
                                      count: value.length,
                                      axisDirection: Axis.horizontal,
                                      onDotClicked: (i) {
                                        pageViewController.animateToPage(
                                          i,
                                          duration:
                                              const Duration(milliseconds: 500),
                                          curve: Curves.ease,
                                        );
                                      },
                                      effect: const ExpandingDotsEffect(
                                        expansionFactor: 1.5,
                                        spacing: 6,
                                        radius: 16,
                                        dotWidth: 12,
                                        dotHeight: 12,
                                        dotColor: Color(0xFF9E9E9E),
                                        activeDotColor: Color(0xFF3F51B5),
                                        paintStyle: PaintingStyle.fill,
                                      ),
                                    ),
                                  ),
                              ],
                            );
                          },
                        ),
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
                                  borderSide: BorderSide(color: Colors.black45),
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
                              height: 15,
                            ),
                            InputTextFieldWidget(
                              text: data["pricesDescription"],
                              labelText: "Prices",
                              minLines: 4,
                              helperText: "Add the prices for your activity.",
                              validator: (val) {
                                if (val == null)
                                  return "Use 25 characters or more for a prices Description";
                                if (val.trim() == "" || val.length < 25)
                                  return "Use 25 characters or more for a prices Description";
                                //   if (val.contains(r'[A-Za-z]')) {
                                //     return "The name should only consist of letters";
                                //   }
                                return null;
                              },
                              onSaved: (val) {
                                data["pricesDescription"] = val?.trim();
                              },
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            InputTextFieldWidget(
                              text: data["priceStartFrom"],
                              labelText: "start from",
                              helperText: "the price start from",
                              validator: (val) {
                                // if (val == null)
                                //   return "Use 40 characters or more for important information";
                                // if (val.trim() == "" || val.length < 40)
                                //   return "Use 40 characters or more for important information";
                                // //   if (val.contains(r'[A-Za-z]')) {
                                // //     return "The name should only consist of letters";
                                // //   }
                                return null;
                              },
                              onSaved: (val) {
                                data["priceStartFrom"] = val?.trim();
                              },
                            ),
                            SizedBox(
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
                                  return "Use 40 characters or more for description";
                                if (val.trim() == "" || val.length < 40)
                                  return "Use 40 characters or more for description";
                                //   if (val.contains(r'[A-Za-z]')) {
                                //     return "The name should only consist of letters";
                                //   }
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
                                  return "Use 40 characters or more for important information";
                                if (val.trim() == "" || val.length < 40)
                                  return "Use 40 characters or more for important information";
                                //   if (val.contains(r'[A-Za-z]')) {
                                //     return "The name should only consist of letters";
                                //   }
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
                                //   if (val.contains(r'[A-Za-z]')) {
                                //     return "The name should only consist of letters";
                                //   }
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
                              label: Text("Add the activity location"),
                              onPressed: () async {
                                final latlanArg = await Navigator.pushNamed(
                                        context, PickLocationSceen.router)
                                    as LatLng;
                                print(latlanArg);
                                print("EEEEEEEEEEEEEEEEEEEEEE");
                                if (latlanArg != null) {
                                  data["lat"] = latlanArg.latitude;
                                  data["lng"] = latlanArg.longitude;
                                }
                              },
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Text(
                              "Choose how you would like to be contacted by customers",
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            CheckboxWidget(
                                label: "Trippoint Chat",
                                isCheck: _checkboxChatT,
                                onChanged: (isChecked) {
                                  print(isChecked);
                                  _checkboxChatT = !_checkboxChatT;
                                }),
                            CheckboxWidget(
                                label: "Whatsapp",
                                isCheck: _checkboxChatW.value,
                                onChanged: (isChecked) {
                                  print(isChecked);
                                  _checkboxChatW.value = !_checkboxChatW.value;
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
                                  setState(() {
                                    _checkboxChatC.value =
                                        !_checkboxChatC.value;
                                  });
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
                                    AppHelper.checkPhoneValidation(
                                        context, val);
                                    if (val?.length != 8) {
                                      return "invalid phone number";
                                    }
                                  },
                                  onSaved: (val) {
                                    data["phoneNumberCall"] = val?.trim();
                                  },
                                );
                              },
                            ),
                            SizedBox(
                              height: 15,
                            ),

                            CheckboxWidget(
                                label:
                                    "Would you like to add the activity Instagram page ?",
                                isCheck: _instagramCheck.value,
                                onChanged: (isChecked) {
                                  print(isChecked);
                                  _instagramCheck.value =
                                      !_instagramCheck.value;
                                }),
                            // SizedBox(height: 5,),
                            ValueListenableBuilder(
                              valueListenable: _instagramCheck,
                              builder: (context, value, child) {
                                return InputTextFieldWidget(
                                  enabled: value as bool,
                                  keyboardType: TextInputType.number,

                                  labelText: "instagram Account",
                                  //   labelStyle:,
                                  helperText: "Add Your instagram.",

                                  validator: (val) {
                                   
                                  },
                                  onSaved: (val) {
                                    data["instagramAccount"] = val?.trim();
                                  },
                                );
                              },
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            CheckboxWidget(
                                label:
                                    "Is the activity suitable for children ?",
                                isCheck: _checkboxOp_SFC,
                                onChanged: (isChecked) {
                                  print(isChecked);
                                  _checkboxOp_SFC = !_checkboxOp_SFC;
                                }),
                            CheckboxWidget(
                                label: "Is private group option available ?",
                                isCheck: _checkboxOp_GOA,
                                onChanged: (isChecked) {
                                  print(isChecked);
                                  _checkboxOp_GOA = !_checkboxOp_GOA;
                                }),
                            CheckboxWidget(
                                label:
                                    "Is your activity requires any skills or tools that the customer should has ?",
                                isCheck: _checkboxOp_SCT,
                                onChanged: (isChecked) {
                                  print(isChecked);
                                  _checkboxOp_GOA = !_checkboxOp_GOA;
                                }),

                            SizedBox(
                              height: 20,
                            ),
                            ElevatedButton(
                                onPressed: () async {
                                  await _submit(context);
                                },
                                child: const Text("Submit"),),
                          ],
                        ),
                      ),
                    ],
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
