import 'package:flutter/material.dart';
import 'package:ta_safo/view/AvisosMauTempo.dart';
import 'package:ta_safo/view/AvisosRadio.dart';
import 'package:ta_safo/view/AvisosRadioMapa.dart';
import 'package:ta_safo/view/Home.dart';

class Routes {
  static Map<String, WidgetBuilder> build(BuildContext context) {
    return {
      Home.routeName: (_) => Home(),
      AvisosRadio.routeName: (_) => AvisosRadio(),
      AvisosRadioMapa.routeName: (_) => AvisosRadioMapa(),
      AvisosMauTempo.routeName: (_) => AvisosMauTempo(),
    };
  }
}
