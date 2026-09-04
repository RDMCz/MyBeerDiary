// UserSettings are used to calculate blood alcohol concentration

import "package:flutter/material.dart";
import "package:shared_preferences/shared_preferences.dart";

const String _userSettingsIsMale = "isMale";
const String _userSettingsBirthyear = "birthyear";
const String _userSettingsHeight = "height";
const String _userSettingsWeight = "weight";

class UserSettings {
  final bool isMale;
  final int birthyear;
  final int height;
  final int weight;

  const UserSettings({
    required this.isMale,
    required this.birthyear,
    required this.height,
    required this.weight,
  });

  static const UserSettings defaultUserSettings = UserSettings(
    isMale: true,
    birthyear: 2001,
    height: 184,
    weight: 70,
  );
}

Future<UserSettings> userSettingsGet() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();

  return UserSettings(
    isMale:
        prefs.getBool(_userSettingsIsMale) ??
        UserSettings.defaultUserSettings.isMale,
    birthyear:
        prefs.getInt(_userSettingsBirthyear) ??
        UserSettings.defaultUserSettings.birthyear,
    height:
        prefs.getInt(_userSettingsHeight) ??
        UserSettings.defaultUserSettings.height,
    weight:
        prefs.getInt(_userSettingsWeight) ??
        UserSettings.defaultUserSettings.weight,
  );
}

Future<void> userSettingsSet(UserSettings userSettings) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();

  await prefs.setBool(_userSettingsIsMale, userSettings.isMale);
  await prefs.setInt(_userSettingsBirthyear, userSettings.birthyear);
  await prefs.setInt(_userSettingsHeight, userSettings.height);
  await prefs.setInt(_userSettingsWeight, userSettings.weight);
}

class UserSettingsNotifier extends ChangeNotifier {
  UserSettings value = UserSettings.defaultUserSettings;

  Future<void> refresh() async {
    value = await userSettingsGet();
    notifyListeners();
  }
}
