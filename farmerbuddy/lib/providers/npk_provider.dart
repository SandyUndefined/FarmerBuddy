import 'package:flutter/material.dart';
import '../core/services/thingspeak_service.dart';

class NPKProvider with ChangeNotifier {
  List<double> _nValues = [];
  List<double> _pValues = [];
  List<double> _kValues = [];

  List<double> get nValues => _nValues;
  List<double> get pValues => _pValues;
  List<double> get kValues => _kValues;

  Future<void> fetchNPKData() async {
    _nValues = await ThingSpeakService.fetchNPK(
        'https://api.thingspeak.com/channels/2599948/fields/1.json?results=10');
    _pValues = await ThingSpeakService.fetchNPK(
        'https://api.thingspeak.com/channels/2599948/fields/2.json?results=10');
    _kValues = await ThingSpeakService.fetchNPK(
        'https://api.thingspeak.com/channels/2599948/fields/3.json?results=10');
    notifyListeners();
  }
}
