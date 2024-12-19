import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_settings.dart';

class UserSettingsProvider with ChangeNotifier {
  UserSettings _userSettings = UserSettings();

  UserSettings get userSettings => _userSettings;

  UserSettingsProvider() {
    _loadSettings();
  }

  void updateThingspeakApiKey(String apiKey) {
    _userSettings.thingspeakApiKey = apiKey;
    _saveSettings();
    notifyListeners();
  }

  void updateChannelId(String channelId) {
    _userSettings.channelId = channelId;
    _saveSettings();
    notifyListeners();
  }

  void updateCropDate(DateTime date) {
    _userSettings.cropDate = date;
    _saveSettings();
    notifyListeners();
  }

  void updateLanguage(String language) {
    _userSettings.language = language;
    _saveSettings();
    notifyListeners();
  }

  Future<void> _saveSettings() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('thingspeakApiKey', _userSettings.thingspeakApiKey);
    prefs.setString('channelId', _userSettings.channelId);
    prefs.setString('language', _userSettings.language ?? 'en');
    if (_userSettings.cropDate != null) {
      prefs.setString('cropDate', _userSettings.cropDate!.toIso8601String());
    }
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    _userSettings.thingspeakApiKey = prefs.getString('thingspeakApiKey') ?? '';
    _userSettings.channelId = prefs.getString('channelId') ?? '';
    _userSettings.language = prefs.getString('language') ?? 'en';
    final cropDate = prefs.getString('cropDate');
    if (cropDate != null) {
      _userSettings.cropDate = DateTime.parse(cropDate);
    }
    notifyListeners();
  }
}
