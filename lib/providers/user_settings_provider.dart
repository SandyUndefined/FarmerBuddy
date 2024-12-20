import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_settings.dart';

class UserSettingsProvider with ChangeNotifier {
  UserSettings _userSettings = UserSettings();

  UserSettings get userSettings => _userSettings;

  UserSettingsProvider() {
    _loadSettings();
  }

  // Update the Thingspeak API key
  void updateThingspeakApiKey(String apiKey) {
    _userSettings.thingspeakApiKey = apiKey;
    _saveSettings();
    notifyListeners();
  }

  // Update the Thingspeak Channel ID
  void updateChannelId(String channelId) {
    _userSettings.channelId = channelId;
    _saveSettings();
    notifyListeners();
  }

  // Update the selected crop date
  void updateCropDate(DateTime date) {
    _userSettings.cropDate = date;
    _saveSettings();
    notifyListeners();
  }

  // Update the selected language
  void updateLanguage(String language) {
    _userSettings.language = language;
    _saveSettings();
    notifyListeners();
  }

  // Update the selected crop type
  void updateCropType(String cropType) {
    _userSettings.cropType = cropType;
    _saveSettings();
    notifyListeners();
  }

  // Save all settings to SharedPreferences
  Future<void> _saveSettings() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('thingspeakApiKey', _userSettings.thingspeakApiKey);
    prefs.setString('channelId', _userSettings.channelId);
    prefs.setString('language', _userSettings.language ?? 'en');
    prefs.setString('cropType', _userSettings.cropType ?? '');
    if (_userSettings.cropDate != null) {
      prefs.setString('cropDate', _userSettings.cropDate!.toIso8601String());
    }
  }

  // Load all settings from SharedPreferences
  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    _userSettings.thingspeakApiKey = prefs.getString('thingspeakApiKey') ?? '';
    _userSettings.channelId = prefs.getString('channelId') ?? '';
    _userSettings.language = prefs.getString('language') ?? 'en';
    _userSettings.cropType = prefs.getString('cropType') ?? '';
    final cropDate = prefs.getString('cropDate');
    if (cropDate != null) {
      _userSettings.cropDate = DateTime.parse(cropDate);
    }
    notifyListeners();
  }
}
