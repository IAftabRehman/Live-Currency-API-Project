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
    final provider = Provider.of<ProviderFile>(context);
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text(
          "Live Currency",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  width: width * 0.7,
                  decoration: BoxDecoration(
                    backgroundBlendMode: BlendMode.hardLight,
                    color: Colors.blueAccent,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.deepPurpleAccent),
                  ),
                  child: Center(
                    child: DropdownButton<String>(
                      value: provider.selectedCurrency,
                      items: provider.topCurrency.map((currency) {
                        return DropdownMenuItem<String>(
                          value: currency,
                          child: Text('${provider.currencyNames[currency]} ($currency)'),
                        );
                      }).toList(),
                      onChanged: (value) {
                        if (value != null) {
                          provider.setSelectedCurrency(value);
                        }
                      },
                      dropdownColor: Colors.white,
                      isExpanded: true,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Center(
              child: Container(
                height: height * 0.5,
                width: width * 0.95,
                padding: EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.greenAccent,
                ),
                child: Consumer<ProviderFile>(
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
                            trailing: Text("1 ${provider.selectedCurrency} = $key ${value.toString()}"),
                          );
                        },
                      );
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
