class ModelFile {
  final String base;
  final String date;
  final Map<String, double> rates;

  ModelFile({
    required this.base,
    required this.date,
    required this.rates,
  });



  factory ModelFile.fromJson(Map<String, dynamic> json) {
    final ratesMap = Map<String, double>.from(
      json['rates'].map(
            (key, value) => MapEntry(key, (value as num).toDouble()),
      ),
    );

    return ModelFile(
      base: json['base'] ?? '',
      date: json['date'] ?? '',
      rates: ratesMap,
    );
  }
}

Map<String, String> currencyCountries = {
  'USD': '🇺🇸 United States',
  'PKR': '🇵🇰 Pakistan',
  'EUR': '🇪🇺 Europe',
  'INR': '🇮🇳 India',
  'GBP': '🇬🇧 UK',
  'JPY': '🇯🇵 Japan',
  'CNY': '🇨🇳 China',
  'CAD': '🇨🇦 Canada',
  'AUD': '🇦🇺 Australia',
};