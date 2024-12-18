import 'package:flutter/material.dart';
import '../models/user_settings.dart';

class UserSettingsProvider with ChangeNotifier {
  UserSettings _userSettings = UserSettings();

  UserSettings get userSettings => _userSettings;

  void updateThingspeakApiKey(String apiKey) {
    _userSettings.thingspeakApiKey = apiKey;
    notifyListeners();
  }

  void updateChannelId(String channelId) {
    _userSettings.channelId = channelId;
    notifyListeners();
  }

  void updateCropDate(DateTime date) {
    _userSettings.cropDate = date;
    notifyListeners();
  }
}
