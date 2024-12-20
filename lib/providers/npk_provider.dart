import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/services/thingspeak_service.dart';
import '../providers/user_settings_provider.dart';
class NPKProvider with ChangeNotifier {
  List<double> _temperature = [0];
  List<double> _humidity = [0];
  List<double> _moisture = [0];
  List<double> _nValues = [0];
  List<double> _pValues = [0];
  List<double> _kValues = [0];

  List<double> get temperature => _temperature;
  List<double> get humidity => _humidity;
  List<double> get moisture => _moisture;
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
    final results = '10';

    try {
      _temperature = await ThingSpeakService.fetchFieldData(
          '$baseUrl/1.json?api_key=$apiKey&results=$results', 'field1');
      _humidity = await ThingSpeakService.fetchFieldData(
          '$baseUrl/2.json?api_key=$apiKey&results=$results', 'field2');
      _moisture = await ThingSpeakService.fetchFieldData(
          '$baseUrl/3.json?api_key=$apiKey&results=$results', 'field3');
      _nValues = await ThingSpeakService.fetchFieldData(
          '$baseUrl/4.json?api_key=$apiKey&results=$results', 'field4');
      notifyListeners();
    } catch (e) {
      throw Exception('Error fetching field data: $e');
    }
  }
}
