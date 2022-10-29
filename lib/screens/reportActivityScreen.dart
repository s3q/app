import 'package:app/helpers/appHelper.dart';
import 'package:app/providers/settingsProvider.dart';
import 'package:app/providers/userProvider.dart';
import 'package:app/schemas/ReportSchema.dart';
import 'package:app/widgets/SafeScreen.dart';
import 'package:app/widgets/appBarWidget.dart';
import 'package:app/widgets/inputTextFieldWidget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class ReportActivityScreen extends StatefulWidget {
  static String router = "reportActivity";
  const ReportActivityScreen({super.key});

  @override
  State<ReportActivityScreen> createState() => _ReportActivityScreenState();
}

class _ReportActivityScreenState extends State<ReportActivityScreen> {
  final _formKey = GlobalKey<FormState>();
  Map data = {};

  Future _submit(context, String activityId) async {
    UserProvider userProvider =
        Provider.of<UserProvider>(context, listen: false);
    SettingsProvider settingsProvider =
        Provider.of<SettingsProvider>(context, listen: false);
    bool validation = _formKey.currentState!.validate();

    if (validation && userProvider.islogin()) {
              _formKey.currentState?.save();

      ReportSchema reportSchema = ReportSchema(
          Id: Uuid().v4(),
          activityId: activityId,
          userId: userProvider.currentUser!.Id,
          phoneNumber: data["phoneNumber"],
          report: data["report"],
          reportFor: "activity",
          createdAt: DateTime.now().millisecondsSinceEpoch);
      await settingsProvider.sendReport(reportSchema);
    }
  }

  @override
  Widget build(BuildContext context) {
    UserProvider userProvider = Provider.of<UserProvider>(context);
    String activityId = ModalRoute.of(context)?.settings.arguments as String;

    // if (userProvider.islogin()) return SafeScreen(
    //   padding: 0);

    return SafeScreen(
      padding: 0,
      child: Column(
        children: [
          AppBarWidget(title: "Report"),
          if (userProvider.islogin())
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
                        InputTextFieldWidget(
                          keyboardType: TextInputType.number,
                          text: data["phoneNumber"],
                          labelText: "Phone Number",
                          //   labelStyle:,
                          helperText: "Add Your Phone Number to recive calls.",

                          validator: (val) {
                            AppHelper.checkPhoneValidation(context, val);
                            if (val?.length != 8) {
                              return "invalid phone number";
                            }
                          },
                          onSaved: (val) {
                            data["phoneNumber"] = val?.trim();
                          },
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        InputTextFieldWidget(
                          text: data["report"],
                          labelText: "Report",
                          minLines: 4,
                          helperText: "be honest ",
                          validator: (val) {
                            if (val == null) return "Use 3 characters or more";
                            if (val.trim() == "" || val.length < 10)
                              return "Use 3 characters or more";

                            if (val.length > 200) return "too long";

                            return null;
                          },
                          onSaved: (val) {
                            data["report"] = val?.trim();
                          },
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        ElevatedButton(
                          onPressed: () async {
                            await _submit(context, activityId);
                          },
                          child: const Text("Send"),
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
