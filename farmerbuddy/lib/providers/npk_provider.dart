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
    _nValues = await ThingSpeakService.fetchNPK('https://thingspeak.mathworks.com/channels/2599948/charts/1?bgcolor=%23ffffff&color=%23d62020&dynamic=true&results=10&title=Nitrogen%28N%29&type=line&yaxis=mg%2Fkg');
    _pValues = await ThingSpeakService.fetchNPK('https://thingspeak.mathworks.com/channels/2599948/charts/2?bgcolor=%23ffffff&color=%23d62020&dynamic=true&results=60&title=Phosphorus%28P%29&type=line&update=15&yaxis=mg%2Fkg');
    _kValues = await ThingSpeakService.fetchNPK('https://thingspeak.mathworks.com/channels/2599948/charts/3?bgcolor=%23ffffff&color=%23d62020&dynamic=true&results=60&title=Potassium&type=line&update=15&yaxis=mg%2Fkg');
    notifyListeners();
  }
}
