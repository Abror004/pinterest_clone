import 'package:flutter/material.dart';
import 'package:pinterest/pages/detailPage.dart';
import 'package:pinterest/pages/homePage.dart';
import 'package:pinterest/pages/searchPage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Home_Page(),
      routes: {
        Home_Page.id: (context) => Home_Page(),
        DetailPage.id: (context) => DetailPage(),
        SearchPage.id: (context) => SearchPage(),
      },
    );
  }
}
