import 'package:app/constants/constants.dart';
import 'package:app/schemas/ReportSchema.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:localization/localization.dart';

class SettingsProvider with ChangeNotifier {
  String reportsCollection = CollectionsConstants.reports;
  static final auth = FirebaseAuth.instance;
  static final store = FirebaseFirestore.instance;
  static final storage = FirebaseStorage.instance;

  Map setting = {
    "language": Locale("ar"),
  };

  Future sendReport(ReportSchema reportSchema) async {
    // if (reportSchema.userId ==
    try {
      await store.collection(reportsCollection).add(reportSchema.toMap());
      return true;
    } catch (err) {
      print(err);
      return false;
    }
  }

  void update(String key, dynamic value) {
    setting[key] = value;
    // print(setting);

    notifyListeners();
  }
}
