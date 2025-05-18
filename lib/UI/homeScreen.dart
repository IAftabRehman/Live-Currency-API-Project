import 'package:flutter/material.dart';
import 'package:live_currency_api_project/ProviderFile.dart';
import 'package:provider/provider.dart';

class homeScreen extends StatefulWidget {
  const homeScreen({super.key});

  @override
  State<homeScreen> createState() => _homeScreenState();
}

class _homeScreenState extends State<homeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ProviderFile>(context, listen: false).loadRates();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text(
          "Live Currency",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: Consumer<ProviderFile>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (provider.rates.isEmpty) {
            return const Center(child: Text("No data available"));
          } else {
            return ListView.builder(
              itemCount: provider.rates.length,
              itemBuilder: (context, index) {
                final key = provider.rates.keys.elementAt(index);
                final value = provider.rates[key];
                return ListTile(
                  title: Text(key),
                  subtitle: Text(value.toString()),
                  trailing: Text("USD 1 = $key ${value.toString()}"),
                );
              },
            );
          }
        },
      ),
    );
  }
}