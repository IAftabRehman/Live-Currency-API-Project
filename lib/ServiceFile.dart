import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:live_currency_api_project/ModelFile.dart';

class ServiceFile {
  Future<ModelFile> fetchRates(String BaseCurrency) async {
    final url = Uri.parse('https://api.exchangerate-api.com/v4/latest/${BaseCurrency}');

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return ModelFile.fromJson(data);
    } else {
      throw Exception('Failed to load exchange rates');
    }
  }
}
