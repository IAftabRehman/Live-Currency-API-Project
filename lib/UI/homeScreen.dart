import 'package:flutter/material.dart';
import 'package:live_currency_api_project/ModelFile.dart';
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
    // final height = MediaQuery.of(context).size.height;
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
      body:
          provider.isLoading
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                padding: const EdgeInsets.all(10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
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
                          items:
                              provider.topCurrency.map((currency) {
                                return DropdownMenuItem<String>(
                                  value: currency,
                                  child: Text(
                                    '${provider.currencyNames[currency]} ($currency)',
                                  ),
                                );
                              }).toList(),
                          onChanged: (value) {
                            if (value != null) {
                              provider.setSelectedCurrency(value);
                            }
                          },
                          dropdownColor: Colors.white,
                          isExpanded: true,
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
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
                          items:
                          provider.topCurrency.map((currency) {
                            return DropdownMenuItem<String>(
                              value: currency,
                              child: Text(
                                '${provider.currencyNames[currency]} ($currency)',
                              ),
                            );
                          }).toList(),
                          onChanged: (value) {
                            if (value != null) {
                              provider.setSelectedCurrency(value);
                            }
                          },
                          dropdownColor: Colors.white,
                          isExpanded: true,
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: DataTable(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10)
                        ),
                        headingRowColor: MaterialStateProperty.all(
                          Colors.blue,
                        ),
                        columns: const [
                          DataColumn(
                            label: Text(
                              'Currency Code',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              'Exchange Rate',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              'Converted Amount',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              'Country',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                        rows: List.generate(provider.rates.length, (index) {
                          final key = provider.rates.keys.elementAt(index);
                          final value = provider.rates[key];
                          final isEven = index % 2 == 0;
                          final countryName =
                              ModelFile.currencyToCountry[key] ?? "Unknown";

                          return DataRow(
                            color: MaterialStateProperty.resolveWith<Color?>((
                              Set<MaterialState> states,
                            ) {
                              return isEven ? Colors.green[200] : Colors.red[200];
                            }),
                            cells: [
                              DataCell(Text(key)),
                              DataCell(Text(value.toString())),
                              DataCell(
                                Text(
                                  "1 ${provider.selectedCurrency} = $value $key",
                                ),
                              ),
                              DataCell(Text(countryName)),
                            ],
                          );
                        }),
                      ),
                    ),
                  ],
                ),
              ),
    );
  }
}
