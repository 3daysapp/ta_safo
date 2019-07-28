import 'package:flutter/material.dart';
import 'package:ta_safo/view/AvisosMauTempo.dart';
import 'package:ta_safo/view/AvisosNavegantes.dart';
import 'package:ta_safo/view/AvisosRadio.dart';
import 'package:ta_safo/view/AvisosRadioMapa.dart';
import 'package:ta_safo/view/Configuracoes.dart';
import 'package:ta_safo/view/Home.dart';
import 'package:ta_safo/view/ListagemPdf.dart';

class Routes {
  static Map<String, WidgetBuilder> build(BuildContext context) {
    return {
      Home.routeName: (_) => Home(),
      Configuracoes.routeName: (_) => Configuracoes(),
      AvisosRadio.routeName: (_) => AvisosRadio(),
      AvisosRadioMapa.routeName: (_) => AvisosRadioMapa(),
      AvisosNavegantes.routeName: (_) => AvisosNavegantes(),
      AvisosMauTempo.routeName: (_) => AvisosMauTempo(),
      ListagemPdf.routeName: (_) => ListagemPdf(),
    };
  }
}
