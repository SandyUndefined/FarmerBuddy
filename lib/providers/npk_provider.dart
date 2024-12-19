import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/services/thingspeak_service.dart';
import '../providers/user_settings_provider.dart';

class NPKProvider with ChangeNotifier {
  List<double> _nValues = [];
  List<double> _pValues = [];
  List<double> _kValues = [];

  List<double> get nValues => _nValues;
  List<double> get pValues => _pValues;
  List<double> get kValues => _kValues;

  Future<void> fetchNPKData(BuildContext context) async {
    final userSettingsProvider =
        Provider.of<UserSettingsProvider>(context, listen: false);
    final apiKey = userSettingsProvider.userSettings.thingspeakApiKey;
    final channelId = userSettingsProvider.userSettings.channelId;

    if (apiKey.isEmpty || channelId.isEmpty) {
      throw Exception('ThingSpeak API Key and Channel ID must be set.');
    }

    final baseUrl = 'https://api.thingspeak.com/channels/$channelId/fields';
    final results = '10'; // Fetch the last 10 results

    try {
      _nValues = await ThingSpeakService.fetchFieldData(
          '$baseUrl/1.json?api_key=$apiKey&results=$results', 'field1');
      _pValues = await ThingSpeakService.fetchFieldData(
          '$baseUrl/2.json?api_key=$apiKey&results=$results', 'field2');
      _kValues = await ThingSpeakService.fetchFieldData(
          '$baseUrl/3.json?api_key=$apiKey&results=$results', 'field3');
      notifyListeners();
    } catch (e) {
      throw Exception('Error fetching NPK data: $e');
    }
  }
}
