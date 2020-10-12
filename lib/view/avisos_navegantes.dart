import 'package:flutter/material.dart';
import 'package:ta_safo/view/listagem_pdf.dart';

///
///
///
class AvisosNavegantes extends StatefulWidget {
  static const String routeName = '/avisos_navegantes';

  ///
  ///
  ///
  @override
  _AvisosNavegantesState createState() => _AvisosNavegantesState();
}

///
///
///
class _AvisosNavegantesState extends State<AvisosNavegantes> {
  List<Map<String, dynamic>> buttons;

  ///
  ///
  ///
  @override
  void initState() {
    super.initState();

    buttons = [
      {
        'label': 'Área Marítima e\nHidrovias em Geral',
        'route': ListagemPdf.routeName,
        'key': 'areaMaritimaHidroviasGeral',
        'args': {
          'title': 'Área Marítima e Hidrovias em Geral',
          'url': 'https://www.marinha.mil.br/chm/dados-do-segnav/folhetos',
          'regexp':
              r'\<a href="(?<link>.*?://.*?\.pdf)".*title="(?<title>.*?)".*?>(?<content>.*?)</a>',
        },
      },
      {
        'label': 'Hidrovia\nParaguai-Paraná',
        'route': ListagemPdf.routeName,
        'key': 'hidroviaParaguaiParana',
        'args': {
          'title': 'Hidrovia Paraguai-Paraná',
          'url':
              'https://www.marinha.mil.br/chm/dados-do-segnav/hidrovia-paraguai',
          'regexp':
              r'\<a href="(?<link>.*?://.*?\.pdf)".*?>(?<content>.*?)</a>',
        },
      },
      {
        'label': 'Hidrovia\nTietê-Paraná',
        'route': ListagemPdf.routeName,
        'key': 'hidroviaTieteParana',
        'args': {
          'title': 'Hidrovia Tietê-Paraná',
          'url':
              'https://www.marinha.mil.br/chm/dados-do-segnav/hidrovia-tiete-parana',
          'regexp':
              r'\<a href="(?<link>.*?://.*?\.pdf)".*?>(?<content>.*?)</a>',
        },
      },
    ];
  }

  ///
  ///
  ///
  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text('Aviso aos Navegantes'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.count(
          crossAxisCount: width >= 1024 ? width ~/ 200 : 2,
          children: buttons
              .map(
                (button) => Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black54, width: 1.0),
                      borderRadius: BorderRadius.all(
                        Radius.circular(8),
                      ),
                    ),
                    child: FlatButton(
                      key: Key('${button['key']}Button'),
                      splashColor: Colors.green,
                      onPressed: () => Navigator.of(context).pushNamed(
                        button['route'],
                        arguments: button['args'],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 12.0),
                            child: SizedBox(
                              width: double.infinity,
                              child: Text(
                                button['label'],
                                textAlign: TextAlign.end,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}
