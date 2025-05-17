import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class homeScreen extends StatefulWidget {
  const homeScreen({super.key});

  @override
  State<homeScreen> createState() => _homeScreenState();
}

class _homeScreenState extends State<homeScreen> {
  Map<String, dynamic> exchangeRates = {};
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchExchangeRates();
  }

  Future<void> fetchExchangeRates() async {
    final url = Uri.parse('https://api.exchangerate-api.com/v4/latest/USD');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          exchangeRates = data['rates'];
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load exchange rates');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text(
          "Live Currency",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              children: [
                ListTile(
                  title: Text('PKR'),
                  subtitle: Text("Rate: ${exchangeRates['PKR']}"),
                ),
                ListTile(
                  title: Text('INR'),
                  subtitle: Text("Rate: ${exchangeRates['INR']}"),
                ),
                ListTile(
                  title: Text('EUR'),
                  subtitle: Text("Rate: ${exchangeRates['EUR']}"),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
