import 'package:flutter/material.dart';
import 'package:ta_safo/routes.dart';
import 'package:ta_safo/view/Home.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';

///
///
///
void main() {
  Crashlytics.instance.enableInDevMode = true;

  FlutterError.onError = (FlutterErrorDetails details) {
    Crashlytics.instance.onError(details);
  };

  runApp(TaSafo());
}

///
///
///
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
