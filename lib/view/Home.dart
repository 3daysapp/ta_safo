import 'package:flutter/material.dart';
import 'package:ta_safo/view/AvisosRadio.dart';

///
///
///
class Home extends StatefulWidget {
  static const String routeName = '/home';

  @override
  _HomeState createState() => _HomeState();
}

///
///
///
class _HomeState extends State<Home> {
  List<Map<String, String>> buttons;
  List<Map<String, String>> links;

  @override
  void initState() {
    super.initState();

    buttons = [
      // https://www.marinha.mil.br/chm/sites/www.marinha.mil.br.chm/files/opt/avradio.json
      {
        'label': 'Avisos-Rádio\nNáuticos e SAR',
        'route': AvisosRadio.routeName,
      },
      // https://www.marinha.mil.br/chm/dados-do-segnav-aviso-aos-navegantes-tela/avisos-aos-navegantes
//    {
//      'label': 'Avisos aos\nNavegantes',
//      'route': AvisosRadio.routeName,
//    },
      // https://www.marinha.mil.br/chm/dados-do-smm-avisos-de-mau-tempo/avisos-de-mau-tempo
//    {
//      'label': 'Avisos de\nMau Tempo',
//      'route': AvisosRadio.routeName,
//    },
    ];

    links = [
      {
        'label': 'MB',
        'url': 'https://www.marinha.mil.br/',
      },
      {
        'label': 'DNH',
        'url': 'https://www.marinha.mil.br/dhn/',
      },
      {
        'label': 'CHM',
        'url': 'https://www.marinha.mil.br/chm/',
      }
    ];
  }

  ///
  ///
  ///
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tá Safo'),
      ),
      drawer: Drawer(
        child: Text('Drawer'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.count(
          crossAxisCount: 2, // TODO - Responsividade através do MediaQuery
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
                      splashColor: Colors.green,
                      onPressed: () =>
                          Navigator.of(context).pushNamed(button['route']),
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
