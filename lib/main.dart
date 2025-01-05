import 'package:flutter/material.dart';
import 'login.dart';
import 'package:jenny_papas_pizzeria/home.dart';
import 'package:jenny_papas_pizzeria/thank_you.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/login',
      routes: {
        '/login': (context) => const LoginPage(),
        '/home': (context) => const Home(),
        '/thank_you': (context) => const ThankYouPage(orderId: 0),
      },
    );
  }
}
