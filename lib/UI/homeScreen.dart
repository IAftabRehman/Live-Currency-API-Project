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
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ProviderFile>(context, listen: false).loadRates();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ProviderFile>(context);
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
                    // Currency Selector Dropdown
                    Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          width: width * 0.7,
                          decoration: BoxDecoration(
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
                      ],
                    ),

                    const SizedBox(height: 20),

                    // Search Bar
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                        color: Colors.blueAccent,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: TextField(
                        controller: _searchController,
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                        decoration: InputDecoration(
                          hintText: 'Search by country name...',
                          hintStyle: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                          border: InputBorder.none,
                          prefixIcon: const Icon(
                            Icons.search,
                            color: Colors.white,
                          ),
                          suffixIcon:
                              provider.searchQuery.isNotEmpty
                                  ? IconButton(
                                    icon: const Icon(
                                      Icons.clear,
                                      color: Colors.white,
                                    ),
                                    onPressed: () {
                                      _searchController.clear();
                                      provider.clearSearchQuery();
                                    },
                                  )
                                  : null,
                        ),
                        onChanged: (value) {
                          provider.setSearchQuery(value);
                        },
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Data Table
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: DataTable(
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
                              'Country Name',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                        rows:
                            provider.hasFilteredResults
                                ? _buildDataRows(provider)
                                : [
                                  const DataRow(
                                    cells: [
                                      DataCell(Text("No results found")),
                                      DataCell(Text(" - ")),
                                      DataCell(Text(" - ")),
                                      DataCell(Text(" - ")),
                                    ],
                                  ),
                                ],
                      ),
                    ),
                  ],
                ),
              ),
    );
  }

  List<DataRow> _buildDataRows(ProviderFile provider) {
    return List.generate(provider.filteredRates.length, (index) {
      final entry = provider.filteredRates[index];
      final currencyCode = entry.key;
      final exchangeRate = entry.value;
      final isEven = index % 2 == 0;
      final countryName =
          ModelFile.currencyToCountry[currencyCode] ?? "Unknown";

      return DataRow(
        color: MaterialStateProperty.resolveWith<Color?>((
          Set<MaterialState> states,
        ) {
          return isEven ? Colors.red.shade100 : Colors.lightBlue.shade100;
        }),
        cells: [
          DataCell(Text(currencyCode, style: TextStyle(fontSize: 15))),
          DataCell(Text(exchangeRate.toString(), style: TextStyle(fontSize: 15))),
          DataCell(
            Text(
              "1 ${provider.selectedCurrency} = $exchangeRate $currencyCode", style: TextStyle(fontSize: 15)
            ),
          ),
          DataCell(Text(countryName, style: TextStyle(fontSize: 15))),
        ],
      );
    });
  }
}
