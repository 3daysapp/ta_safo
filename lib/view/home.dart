import 'package:flutter/material.dart';
import 'package:ta_safo/view/avisos_mau_tempo.dart';
import 'package:ta_safo/view/avisos_navegantes.dart';
import 'package:ta_safo/view/avisos_radio.dart';
import 'package:ta_safo/view/configuracoes.dart';
import 'package:url_launcher/url_launcher.dart';

///
///
///
class Home extends StatefulWidget {
  static const String routeName = '/home';

  ///
  ///
  ///
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
    ];

    return Scaffold(
      key: Key('homeScaffold'),
      appBar: AppBar(
        title: Text('Tá Safo'),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: _drawerData(
            context: context,
            buttons: buttons,
          ),
        ),
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
                      onPressed: () => Navigator.of(context)
                          .pushNamed(button['route'] ?? Home.routeName),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: 12.0,
                            ),
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
  }) {
    List<Widget> list = [];

    list.add(UserAccountsDrawerHeader(
      accountName: Text('Tá Safo'),
      accountEmail: Text('www.3daysapp.com.br'),
      currentAccountPicture: CircleAvatar(
        backgroundImage: AssetImage('assets/images/ic_launcher.png'),
        backgroundColor: Colors.transparent,
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

    list.add(
      ListTile(
        leading: Icon(Icons.settings),
        title: Text('Configurações do App'),
        onTap: () =>
            Navigator.of(context).popAndPushNamed(Configuracoes.routeName),
      ),
    );

    list.add(Divider());

    list.add(Padding(
      padding: const EdgeInsets.only(left: 16.0),
      child: Text(
        'Links Externos',
        textAlign: TextAlign.left,
        style: Theme.of(context).textTheme.caption,
      ),
    ));

    List<dynamic> links = [
      {
        'label': 'Marinha do Brasil',
        'url': 'https://www.marinha.mil.br/',
      }
    ];

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
    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
    }
    if (await canLaunch(url)) {
      await launch(url);
    }
  }
}
