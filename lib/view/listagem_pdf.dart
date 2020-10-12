import 'dart:async';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart';
import 'package:ta_safo/util/metric_http_client.dart';
import 'package:ta_safo/util/visual_util.dart';
import 'package:ta_safo/view/tela_pdf.dart';
import 'package:ta_safo/widget/download_tile.dart';

///
///
///
class ListagemPdf extends StatefulWidget {
  static const String routeName = '/listagem_pdf';

  @override
  _ListagemPdfState createState() => _ListagemPdfState();
}

///
///
///
class _ListagemPdfState extends State<ListagemPdf> {
  StreamController _streamController;
  String _url;

  static const String noFilter = 'TODOS';
  String _filtroAno = noFilter;
  List<String> _anos;

  ///
  ///
  ///
  @override
  void initState() {
    _streamController = StreamController();
    super.initState();
  }

  ///
  ///
  ///
  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> args = ModalRoute.of(context).settings.arguments;

    _url = args['url'];

    final RegExp getLinks = RegExp(
      args['regexp'],
      caseSensitive: false,
      multiLine: true,
    );

    final RegExp getName = RegExp(
      r'[^\/]*(\d{2})(\d{4}).{0,10}\.pdf$',
      caseSensitive: false,
    );

    _loadData();

    return Scaffold(
      appBar: AppBar(
        title: Text(args['title']),
        actions: <Widget>[
          IconButton(
            key: Key('filterIconButton'),
            icon: Icon(FontAwesomeIcons.filter),
            onPressed: () => _settingModalBottomSheet(context),
          ),
          IconButton(
            key: Key('refreshIconButton'),
            icon: Icon(FontAwesomeIcons.sync),
            onPressed: _loadData,
          ),
        ],
      ),
      body: StreamBuilder(
        stream: _streamController.stream,
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.hasData) {
            List<DownloadTile> items = [];
            _anos = [noFilter];

            getLinks.allMatches(snapshot.data).forEach(
              (match) {
                String url = match.namedGroup('link');

                String filename;
                String folheto;
                String ano;
                String subtitle;

                RegExpMatch matchUrl = getName.firstMatch(url);

                if (matchUrl.groupCount == 2) {
                  filename = matchUrl[0];
                  folheto = matchUrl[1];
                  ano = matchUrl[2];
                }

                if (folheto == null || folheto.isEmpty) {
                  if (match.groupNames.contains('content')) {
                    folheto = match.namedGroup('content').trim();
                  }
                }

                if (match.groupNames.contains('title')) {
                  subtitle = match.namedGroup('title');
                }

                if (!_anos.contains(ano)) {
                  _anos.add(ano);
                }

                if (_filtroAno == noFilter || _filtroAno == ano) {
                  items.add(
                    DownloadTile(
                      url: url,
                      localFilename: filename,
                      title: '$ano - $folheto',
                      subtitle: subtitle,
                      tapCallback: _showPdf,
                    ),
                  );
                }
              },
            );

            if (items.isEmpty) {
              return Center(
                child: Text(
                  'Nenhuma informação encontrada.',
                  style: Theme.of(context).textTheme.bodyText1,
                ),
              );
            }

            items.sort(
              (a, b) => (b.title).compareTo(a.title),
            );

            DateTime now = DateTime.now().toUtc();

            String data = now.day.toString().padLeft(2, '0') +
                '/' +
                now.month.toString().padLeft(2, '0') +
                '/' +
                now.year.toString() +
                ' ' +
                now.hour.toString().padLeft(2, '0') +
                ':' +
                now.minute.toString().padLeft(2, '0');

            return Column(
              children: <Widget>[
                SizedBox(
                  width: double.infinity,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: Colors.black12,
                    ),
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(6.0),
                        child: Text(
                          'Verificado às $data UTC',
                          key: Key('atualizadoText'),
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: ListView.separated(
                    itemBuilder: (context, index) => items.elementAt(index),
                    separatorBuilder: (context, index) => Divider(),
                    itemCount: items.length,
                  ),
                ),
              ],
            );
          }

          if (snapshot.hasError) {
            return TryAgain(
              error: snapshot.error,
              callback: _loadData,
            );
          }

          return Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }

  ///
  ///
  ///
  void _loadData() async {
    _streamController.add(null);
    await _getData().then((data) {
      _streamController.add(data);
    }).catchError((error) {
      print(error);
      // TODO: Disparar crash.
      _streamController.addError(error);
    });
  }

  ///
  ///
  ///
  Future<String> _getData() async {
    MetricHttpClient client = MetricHttpClient(Client());

    String data = '';

    Response response = await client.get(_url).timeout(Duration(seconds: 10));

    if (response.statusCode != 200) {
      throw Exception('$_url - Status Code: ${response.statusCode}');
    }

    // TODO: Armazenar informações caso fique offline?

    data = response.body;

    client.close();

    return data;
  }

  ///
  ///
  ///
  void _showPdf(String path) {
    if (path == null) {
      // TODO: Disparar crash.
    } else {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => TelaPdf(
            path: path,
          ),
        ),
      );
    }
  }

  ///
  ///
  ///
  void _settingModalBottomSheet(context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          child: ListView(
            children: _anos
                .map(
                  (ano) => ListTile(
                    key: Key('ano${ano}Tile'),
                    title: Text(ano),
                    leading: Icon(
                      _filtroAno == ano
                          ? FontAwesomeIcons.checkCircle
                          : FontAwesomeIcons.circle,
                    ),
                    dense: true,
                    onTap: () {
                      _filtroAno = ano;
                      _loadData();
                      Navigator.of(context).pop();
                    },
                  ),
                )
                .toList(),
          ),
        );
      },
    );
  }
}
