import 'package:flutter/material.dart';
import 'package:ta_safo/routes.dart';
import 'package:ta_safo/view/Home.dart';

void main() {
  runApp(TaSafo());
}

class TaSafo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tá Safo',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: Home(),
      routes: Routes.build(context),
    );
  }
}
