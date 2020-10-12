import 'package:flutter/material.dart';
import 'package:ta_safo/view/avisos_mau_tempo.dart';
import 'package:ta_safo/view/avisos_navegantes.dart';
import 'package:ta_safo/view/avisos_radio.dart';
import 'package:ta_safo/view/avisos_radio_mapa.dart';
import 'package:ta_safo/view/configuracoes.dart';
import 'package:ta_safo/view/home.dart';
import 'package:ta_safo/view/listagem_pdf.dart';

///
///
///
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
