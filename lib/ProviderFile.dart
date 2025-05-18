import 'package:flutter/cupertino.dart';
import 'package:live_currency_api_project/ModelFile.dart';
import 'package:live_currency_api_project/ServiceFile.dart';

class ProviderFile with ChangeNotifier{
  ServiceFile _service = ServiceFile();
  Map<String, dynamic> _rates = {};
  bool _isLoading = true;

  Map<String, dynamic> get rates => _rates;
  bool get isLoading => _isLoading;


  Future<void> loadRates() async {
    _isLoading = true;
    notifyListeners();

    try {
      ModelFile data = await _service.fetchRates();
      _rates = data.rates;
    } catch (e) {
      print('Error loading rates: $e');
    }

    _isLoading = false;
    notifyListeners();
  }
}