import 'package:flutter/cupertino.dart';
import 'package:live_currency_api_project/ModelFile.dart';
import 'package:live_currency_api_project/ServiceFile.dart';

class ProviderFile with ChangeNotifier{

  //  This is For Top Currencies, Where user can Comparison with others
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


  // -------------------------------------------------------------------------------
  // This is the Search Query, Where user can search any specific country details
  String _searchQuery = '';
  String get searchQuery => _searchQuery;

  void setSearchQuery(String query) {
    _searchQuery = query.toLowerCase();
    notifyListeners();
  }

  void clearSearchQuery() {
    _searchQuery = '';
    notifyListeners();
  }



  Map<String, dynamic> _rates = {};
  bool _isLoading = true;

  Map<String, dynamic> get rates => _rates;
  bool get isLoading => _isLoading;

  List<MapEntry<String, dynamic>> get filteredRates {
    if (_searchQuery.isEmpty) {
      return _rates.entries.toList();
    }

    return _rates.entries.where((entry) {
      final currencyCode = entry.key;
      final countryName = ModelFile.currencyToCountry[currencyCode] ?? "Unknown";

      return countryName.toLowerCase().contains(_searchQuery);
    }).toList();
  }

  // Check if filtered results are empty
  bool get hasFilteredResults {
    return filteredRates.isNotEmpty;
  }

  // ------------------------------------------------------------------------------
  // This is Load Data to show all the details
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