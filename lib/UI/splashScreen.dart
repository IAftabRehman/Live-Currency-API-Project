import 'package:flutter/material.dart';
import 'package:live_currency_api_project/UI/homeScreen.dart';

class splashScreen extends StatefulWidget {
  const splashScreen({super.key});

  @override
  State<splashScreen> createState() => _splashScreenState();
}

class _splashScreenState extends State<splashScreen> {

  Future<void> movingScreen() async{
    await Future.delayed(Duration(seconds: 7));
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => homeScreen()));
  }

  @override
  void initState() {
    super.initState();
    movingScreen();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10)
          ),
          child: Image.asset('assets/images/splashScreen.gif', width: double.infinity, height: double.infinity, fit: BoxFit.fill,),
        ),
      ),
    );
  }
}
