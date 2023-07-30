import 'package:flutter/material.dart';
import 'home_page.dart';
import 'result_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: 'home_page',
      routes: {
        'home_page': (context) => const HomePage(),
        'result_page': (context) => const ResultPage(),
      },
    );
  }
}
