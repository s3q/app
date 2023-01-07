import 'package:app/providers/activityProvider.dart';
import 'package:app/providers/userProvider.dart';
import 'package:app/schemas/activitySchema.dart';
import 'package:app/schemas/reviewSchema.dart';
import 'package:app/screens/viewReviewsScreen.dart';
import 'package:app/widgets/SafeScreen.dart';
import 'package:app/widgets/appBarWidget.dart';
import 'package:app/widgets/inputTextFieldWidget.dart';
import 'package:app/widgets/ratingBarWidget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class SendReviewScreen extends StatelessWidget {
  static String router = "/sendReview";
  final _formKey = GlobalKey<FormState>();
  SendReviewScreen({super.key});
  Map data = {};

  Future _submit(context, ActivitySchema activitySchema) async {
    UserProvider userProvider =
        Provider.of<UserProvider>(context, listen: false);
    ActivityProvider activityProvider =
        Provider.of<ActivityProvider>(context, listen: false);
    bool validation = _formKey.currentState!.validate();
    if (validation && userProvider.islogin()) {
      _formKey.currentState?.save();
      ReviewSchecma reviewSchecma = ReviewSchecma(
        userId: userProvider.currentUser!.Id,
        Id: Uuid().v4(),
        createdAt: DateTime.now().millisecondsSinceEpoch,
        rating: data["rating"],
        review: data["review"],
      );
      print(reviewSchecma.toMap());
      await activityProvider.sendReview(
          reviewSchecma, activitySchema.storeId!, activitySchema.Id);
      Navigator.pushReplacementNamed(context, ViewReviewScreen.router,
          arguments: activitySchema);
    }
  }

  @override
  Widget build(BuildContext context) {
    UserProvider userProvider = Provider.of<UserProvider>(context);

    ActivitySchema activitySchema =
        ModalRoute.of(context)?.settings.arguments as ActivitySchema;

    return SafeScreen(
      padding: 0,
      child: Column(children: [
        AppBarWidget(title: "Review"),
        if (userProvider.islogin())
          Expanded(
            child: ListView(children: [
              SizedBox(
                height: 30,
              ),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    Text(
                      'Reviews',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    RatingBarWidget(
                      init: (val) {
                        data["rating"] = val;
                      },
                      onRated: (val) {
                        data["rating"] = val;
                      },
                      size: 30,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: InputTextFieldWidget(
                        text: data["review"],
                        labelText: "Review",
                        minLines: 4,
                        helperText: "review this activity",
                        validator: (val) {
                          if (val == null) return "Use 3 characters or more";
                          if (val.trim() == "" || val.length < 3)
                            return "Use 3 characters or more";

                          if (val.length > 200) return "too long";
                          return null;
                        },
                        onSaved: (val) {
                          data["review"] = val?.trim();
                        },
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        await _submit(context, activitySchema);
                      },
                      child: const Text("send"),
                    ),
                  ],
                ),
              ),
            ]),
          ),
      ]),
    );
  }
}
