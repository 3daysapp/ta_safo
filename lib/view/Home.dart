import 'package:flutter/material.dart';
import 'package:ta_safo/view/AvisosMauTempo.dart';
import 'package:ta_safo/view/AvisosNavegantes.dart';
import 'package:ta_safo/view/AvisosRadio.dart';
import 'package:url_launcher/url_launcher.dart';

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
  ///
  ///
  ///
  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;

    final List<Map<String, String>> buttons = [
      {
        'label': 'Avisos-Rádio\nNáuticos e SAR',
        'route': AvisosRadio.routeName,
        'key': 'avisosRadioNauticos',
      },
      {
        'label': 'Avisos aos\nNavegantes',
        'route': AvisosNavegantes.routeName,
        'key': 'avisoAosNavegantes',
      },
      {
        'label': 'Avisos de\nMau Tempo',
        'route': AvisosMauTempo.routeName,
        'key': 'avisosDeMauTempo',
      },
      // http://portal.embratel.com.br/movelmaritimo/previsao-do-tempo/
    ];

    List<Map<String, String>> links = [
      {
        'label': 'Marinha do Brasil',
        'url': 'https://www.marinha.mil.br/',
      },
      {
        'label': 'Diretoria de Hidrografia e Navegação',
        'url': 'https://www.marinha.mil.br/dhn/',
      },
      {
        'label': 'Centro de Hidrografia da Marinha',
        'url': 'https://www.marinha.mil.br/chm/',
      },
      {
        'label': 'Serviço Móvel Marítimo',
        'url': 'http://portal.embratel.com.br/movelmaritimo/'
      }
    ];

    return Scaffold(
      key: Key('homeScaffold'),
      appBar: AppBar(
        title: Text('Tá Safo'),
//        actions: <Widget>[
//          IconButton(
//            icon: Icon(Icons.bug_report),
//            onPressed: _testMap,
//          )
//        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: _drawerData(
            context: context,
            buttons: buttons,
            links: links,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.count(
          crossAxisCount: width ~/ 200,
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

  ///
  ///
  ///
  List<Widget> _drawerData({
    BuildContext context,
    List<Map<String, dynamic>> buttons,
    List<Map<String, dynamic>> links,
  }) {
    List<Widget> list = [];

    list.add(UserAccountsDrawerHeader(
      accountName: Text('Tá Safo'),
      accountEmail: null,
      currentAccountPicture: CircleAvatar(
        backgroundColor: Colors.black45,
        child: Text(
          'TS',
          style: TextStyle(
            color: Colors.white,
            fontSize: 38.0,
          ),
        ),
      ),
    ));

    list.addAll(buttons
        .map(
          (button) => ListTile(
            key: Key('${button['key']}Tile'),
            leading: Icon(Icons.label),
            title: Text(button['label'].replaceAll('\n', ' ')),
            onTap: () => Navigator.of(context).popAndPushNamed(button['route']),
          ),
        )
        .toList());

    list.add(Divider());

    list.addAll(links
        .map(
          (link) => ListTile(
            leading: Icon(Icons.link),
            title: Text(link['label']),
            onTap: () => _launchUrl(context, link['url']),
          ),
        )
        .toList());

    return list;
  }

  ///
  ///
  ///
  void _launchUrl(BuildContext context, String url) async {
    Navigator.of(context).pop();
    if (await canLaunch(url)) {
      await launch(url);
    }
  }
}
