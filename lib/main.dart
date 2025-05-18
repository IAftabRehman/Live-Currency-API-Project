import 'package:flutter/material.dart';
import 'package:live_currency_api_project/ProviderFile.dart';
import 'package:live_currency_api_project/UI/homeScreen.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ProviderFile(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Live Currency API',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          useMaterial3: true,
        ),
        home: const homeScreen(),
      ),
    );
  }
}