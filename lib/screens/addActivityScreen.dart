
import 'package:app/helpers/appHelper.dart';
import 'package:app/providers/activityProvider.dart';
import 'package:app/providers/userProvider.dart';
import 'package:app/schemas/activitySchema.dart';
import 'package:app/screens/pickLocationScreen.dart';
import 'package:app/widgets/SafeScreen.dart';
import 'package:app/widgets/appBarWidget.dart';
import 'package:app/widgets/checkboxWidget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:searchfield/searchfield.dart';
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
  bool _checkboxChatW = false;
  bool _checkboxChatC = true;
  bool _instagramCheck = false;
  bool _checkboxOp_SFC = true;
  bool _checkboxOp_GOA = true;
  bool _checkboxOp_SCT = false;
  List _uploadedImages = [
    UploadContainer(),
  ];

  List<String> _uploadedImagesPath = [];

  String? errorInUploadImages;

  List _categories = AppHelper.categories.map((e) => e["title"]).toList();

  Map data = {};

  void _pickImage() async {
    final List<XFile>? images = await _picker.pickMultiImage();

    if (images != null) {
      if (images.isNotEmpty) {
        _uploadedImages.remove(UploadContainer());
      }
      images.forEach((e) {
        data["images"] = [
          if (data["images"] != null) ...data["images"],
          e.path
        ];
        _uploadedImagesPath.add(e.path);
        _uploadedImages.add(Image.asset(
          e.path,
          height: 200,
          //   width: MediaQuery.of(context).size.width,
        ));
      });
    }
  }

  Future _submit(BuildContext context) async {
    ActivityProvider activityProvider =
        Provider.of<ActivityProvider>(context, listen: false);
    UserProvider userProvider =
        Provider.of<UserProvider>(context, listen: false);
    bool validation = _formKey.currentState!.validate();

    if (validation && _uploadedImages.length > 4) {
      ActivitySchema activityData = ActivitySchema(
          userId: userProvider.currentUser!.Id,
          Id: Uuid().v4(),
          lat: data["lat"],
          lng: data["lng"],
          address: data["address"],
          phoneNumberWhatsapp: data["phoneNumberWhatsapp"],
          phoneNumberCall: data["phoneNumberCall"],
          description: data["description"],
          images: _uploadedImagesPath,
          importantInformation: data["importantInformation"],
          instagramAccount: data["instagramAccount"],
          cCall: data["cCall"],
          cTrippointChat: data["cTrippointChat"],
          cWhatsapp: data["cWhatsapp"],
          category: data["category"],
          priceStartFrom: data["priceStartFrom"],
          pricesDescription: data["pricesDescription"],
          op_GOA: _checkboxOp_GOA,
          op_SCT: _checkboxOp_SCT,
          op_SFC: _checkboxOp_SFC,
          title: data["title"]);
      activityProvider.createActivity(context, activityData);
    }
  }

  @override
  Widget build(BuildContext context) {
    print(_categories);
    UserProvider userProvider = Provider.of<UserProvider>(context);

    _phoneNumberWhatsappController.text =
        userProvider.proCurrentUser!.publicPhoneNumber;
    _phoneNumberWhatsappController.text =
        userProvider.proCurrentUser!.publicPhoneNumber;

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
          Expanded(
            child: ListView(
              children: [
                SizedBox(
                  height: 30,
                ),
                Expanded(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        TextButton(
                          child: const Text("Add photos"),
                          onPressed: () async {
                            setState(() {
                              errorInUploadImages = null;
                            });

                            _pickImage();
                          },
                        ),
                        if (errorInUploadImages != null)
                          Text(errorInUploadImages!),
                        PageView(
                          controller: pageViewController,
                          scrollDirection: Axis.horizontal,
                          children: [..._uploadedImages],
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        TextFormField(
                          keyboardType: TextInputType.name,
                          autofocus: true,
                          obscureText: false,
                          decoration: const InputDecoration(
                            labelText: "Title",
                            helperText: "Give your activity title.",
                            filled: true,
                            fillColor: Colors.white,
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.black45,
                                width: 1,
                              ),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(16)),
                            ),
                            border: OutlineInputBorder(
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
                            data["pricesDescription"] = val?.trim();
                          },
                        ),
                        SizedBox(
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
                            data["categories"];
                          },
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        TextFormField(
                          keyboardType: TextInputType.name,
                          autofocus: true,
                          obscureText: false,
                          minLines: 4,
                          maxLines: 4,
                          decoration: const InputDecoration(
                            labelText: "Prices",
                            helperText: "Add the prices for your activity.",
                            filled: true,
                            fillColor: Colors.white,
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.black45,
                                width: 1,
                              ),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(16)),
                            ),
                            border: OutlineInputBorder(
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
                            data["pricesDescription"] = val?.trim();
                          },
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        TextFormField(
                          keyboardType: TextInputType.name,
                          autofocus: true,
                          obscureText: false,
                          minLines: 4,
                          maxLines: 4,
                          decoration: const InputDecoration(
                            labelText: "start from",
                            helperText: "the price start from",
                            filled: true,
                            fillColor: Colors.white,
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.black45,
                                width: 1,
                              ),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(16)),
                            ),
                            border: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.black45,
                                width: 1,
                              ),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(16)),
                            ),
                          ),
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
                        TextFormField(
                          keyboardType: TextInputType.name,
                          autofocus: true,
                          obscureText: false,
                          minLines: 4,
                          maxLines: 4,
                          decoration: const InputDecoration(
                            labelText: "Description",
                            helperText: "Add more details about the activitiy",
                            filled: true,
                            fillColor: Colors.white,
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.black45,
                                width: 1,
                              ),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(16)),
                            ),
                            border: OutlineInputBorder(
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
                        TextFormField(
                          keyboardType: TextInputType.name,
                          autofocus: true,
                          obscureText: false,
                          minLines: 4,
                          maxLines: 4,
                          decoration: const InputDecoration(
                            labelText: "Important Information",
                            helperText: "Add important information",
                            filled: true,
                            fillColor: Colors.white,
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.black45,
                                width: 1,
                              ),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(16)),
                            ),
                            border: OutlineInputBorder(
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

                        TextFormField(
                          keyboardType: TextInputType.name,
                          autofocus: true,
                          obscureText: false,
                          minLines: 4,
                          maxLines: 4,
                          decoration: const InputDecoration(
                            labelText: "address",
                            // helperText: "Add important information",
                            filled: true,
                            fillColor: Colors.white,
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.black45,
                                width: 1,
                              ),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(16)),
                            ),
                            border: OutlineInputBorder(
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
                              return "Use 2 characters or more for address";
                            if (val.trim() == "" || val.length < 2)
                              return "Use 2 characters or more for address";
                            //   if (val.contains(r'[A-Za-z]')) {
                            //     return "The name should only consist of letters";
                            //   }
                            return null;
                          },
                          onSaved: (val) {
                            data["address"] = val?.trim();
                          },
                        ),
                        TextButton(
                          child: Text("Add the activity location"),
                          onPressed: () async {
                            final latlanArg = await Navigator.pushNamed(
                                context, PickLocationSceen.router) as LatLng;
                            print(latlanArg);
                            if (latlanArg != null) {
                              data["lat"] = latlanArg.latitude;
                              data["lng"] = latlanArg.longitude;
                            }
                            setState(() {});
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
                            }),
                        CheckboxWidget(
                            label: "Whatsapp",
                            isCheck: _checkboxChatW,
                            onChanged: (isChecked) {
                              print(isChecked);
                            }),

                        TextFormField(
                          keyboardType: TextInputType.name,
                          autofocus: true,
                          obscureText: false,
                          minLines: 4,
                          maxLines: 4,
                          decoration: const InputDecoration(
                            labelText: "Phone Number",
                            //   labelStyle:,
                            helperText:
                                "Add Your Phone Number to recive massages on whatsapp.",
                            filled: true,
                            fillColor: Colors.white,

                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.black45,
                                width: 1,
                              ),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(16)),
                            ),
                            border: OutlineInputBorder(
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
                              return "Use 2 characters or more for instagram";
                            if (val.trim() == "" || val.length < 2)
                              return "Use 40 characters or more for instagram";
                            //   if (val.contains(r'[A-Za-z]')) {
                            //     return "The name should only consist of letters";
                            //   }
                            return null;
                          },
                          onSaved: (val) {
                            data["phoneNumberWhatsapp"] = val?.trim();
                          },
                        ),
                        CheckboxWidget(
                            label: "Call",
                            isCheck: _checkboxChatC,
                            onChanged: (isChecked) {
                              print(isChecked);
                            }),

                        TextFormField(
                          keyboardType: TextInputType.name,
                          autofocus: true,
                          obscureText: false,
                          minLines: 4,
                          maxLines: 4,
                          decoration: const InputDecoration(
                            labelText: "Phone Number",
                            //   labelStyle:,
                            helperText:
                                "Add Your Phone Number to recive calls.",
                            filled: true,
                            fillColor: Colors.white,

                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.black45,
                                width: 1,
                              ),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(16)),
                            ),
                            border: OutlineInputBorder(
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
                              return "Use 2 characters or more for instagram";
                            if (val.trim() == "" || val.length < 2)
                              return "Use 40 characters or more for instagram";
                            //   if (val.contains(r'[A-Za-z]')) {
                            //     return "The name should only consist of letters";
                            //   }
                            return null;
                          },
                          onSaved: (val) {
                            data["phoneNumberCall"] = val?.trim();
                          },
                        ),
                        SizedBox(
                          height: 15,
                        ),

                        CheckboxWidget(
                            label:
                                "Would you like to add the activity Instagram page ?",
                            isCheck: _instagramCheck,
                            onChanged: (isChecked) {
                              print(isChecked);
                            }),
                        // SizedBox(height: 5,),
                        if (_instagramCheck)
                          TextFormField(
                            keyboardType: TextInputType.name,
                            autofocus: true,
                            obscureText: false,
                            minLines: 4,
                            maxLines: 4,
                            decoration: const InputDecoration(
                              labelText: "instagram Account",
                              //   labelStyle:,
                              helperText: "Add Your instagram.",
                              filled: true,
                              fillColor: Colors.white,

                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.black45,
                                  width: 1,
                                ),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(16)),
                              ),
                              border: OutlineInputBorder(
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
                                return "Use 2 characters or more for instagram";
                              if (val.trim() == "" || val.length < 2)
                                return "Use 40 characters or more for instagram";
                              //   if (val.contains(r'[A-Za-z]')) {
                              //     return "The name should only consist of letters";
                              //   }
                              return null;
                            },
                            onSaved: (val) {
                              data["instagramAccount"] = val?.trim();
                            },
                          ),
                        SizedBox(
                          height: 20,
                        ),
                        CheckboxWidget(
                            label: "Is the activity suitable for children ?",
                            isCheck: _checkboxOp_SFC,
                            onChanged: (isChecked) {
                              print(isChecked);
                            }),
                        CheckboxWidget(
                            label: "Is private group option available ?",
                            isCheck: _checkboxOp_GOA,
                            onChanged: (isChecked) {
                              print(isChecked);
                            }),
                        CheckboxWidget(
                            label:
                                "Is your activity requires any skills or tools that the customer should has ?",
                            isCheck: _checkboxOp_SCT,
                            onChanged: (isChecked) {
                              print(isChecked);
                            }),

                        SizedBox(
                          height: 20,
                        ),
                        ElevatedButton(
                            onPressed: () async {
                            //   await _submit();
                            },
                            child: Text("Submit")),
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
    );
  }
}
