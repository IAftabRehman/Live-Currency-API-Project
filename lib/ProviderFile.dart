import 'package:flutter/cupertino.dart';
import 'package:live_currency_api_project/ModelFile.dart';
import 'package:live_currency_api_project/ServiceFile.dart';

class ProviderFile with ChangeNotifier{
  List<String> topCurrency = ['USD', 'EUR', 'GBP', 'INR', 'JPY', 'PKR'];
  Map<String, String> currencyNames = {
    'USD': 'United States',
    'EUR': 'Eurozone',
    'GBP': 'United Kingdom',
    'INR': 'India',
    'JPY': 'Japan',
    'PKR': 'Pakistan',
  };
  String _selectedCurrency = 'USD';
  String get selectedCurrency => _selectedCurrency;

  void setSelectedCurrency(String currency) {
    _selectedCurrency = currency;
    notifyListeners();
    loadRates();
    ServiceFile().fetchRates(selectedCurrency);
  }




  Map<String, dynamic> _rates = {};
  bool _isLoading = true;

  Map<String, dynamic> get rates => _rates;
  bool get isLoading => _isLoading;

  Future<void> loadRates() async {
    print("Load Rates");
    _isLoading = true;
    notifyListeners();

    try {
      ModelFile data = await ServiceFile().fetchRates(selectedCurrency);
      _rates = data.rates;
    } catch (e) {
      print('Error loading rates: $e');
    }

    _isLoading = false;
    notifyListeners();
  }
}