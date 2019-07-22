import 'package:flutter/material.dart';
import 'package:flutter_driver/driver_extension.dart';
import 'package:ta_safo/main.dart';


void main() {
  // Enable integration testing with the Flutter Driver extension.
  // See https://flutter.io/testing/ for more info.
  enableFlutterDriverExtension();
  WidgetsApp.debugAllowBannerOverride = false;
  runApp(TaSafo());
}