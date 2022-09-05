import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:localization/localization.dart';


class SettingsProvider with ChangeNotifier {
  Map setting = {
    "language": Locale("ar"),
  };

  void update(String key, dynamic value) {
    setting[key] = value;
    // print(setting);

    notifyListeners();
  }
}
