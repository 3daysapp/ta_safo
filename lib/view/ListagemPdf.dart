import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:ta_safo/view/TelaPdf.dart';

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

  ///
  ///
  ///
  @override
  void initState() {
    _streamController = new StreamController();
    super.initState();
  }

  ///
  ///
  ///
  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> args = ModalRoute.of(context).settings.arguments;

    final RegExp getLinks = RegExp(
      args['regexp'],
      caseSensitive: false,
      multiLine: true,
    );

    final RegExp getName = RegExp(
      r'[^\/]*(\d{2})(\d{4}).{0,10}\.pdf$',
      caseSensitive: false,
    );

    _loadData(args['url']);

    return Scaffold(
      appBar: AppBar(
        title: Text(args['title']),
      ),
      body: StreamBuilder(
          stream: _streamController.stream,
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            if (snapshot.hasData) {
              List<Widget> items = [];

              // TODO: Ordenar resultados.

              getLinks.allMatches(snapshot.data).forEach((match) {
                String url = match.namedGroup('link');

                String filename = '??';
                String folheto;
                String ano = '??';

                RegExpMatch matchUrl = getName.firstMatch(url);

                if (matchUrl.groupCount == 2) {
                  filename = matchUrl[0];
                  folheto = matchUrl[1];
                  ano = matchUrl[2];
                }

                String content = match.namedGroup('content').trim();

                Text subtitle;
                if (match.groupNames.contains('title')) {
                  subtitle = Text(match.namedGroup('title'));
                }

                items.add(ListTile(
                  leading: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(Icons.file_download),
                    ],
                  ),
                  title: Text('$ano - ${folheto ?? content}'),
                  subtitle: subtitle,
                  onTap: () {
                    _showPdf(url: url, filename: filename);
                  },
                ));
              });

              if (items.isEmpty) {
                return Center(
                  child: Text(
                    'Nenhuma informação encontrada.',
                    style: Theme.of(context).textTheme.body2,
                  ),
                );
              }

              return ListView.separated(
                itemBuilder: (BuildContext context, int index) =>
                    items.elementAt(index),
                separatorBuilder: (BuildContext context, int index) =>
                    Divider(),
                itemCount: items.length,
              );
            }

            if (snapshot.hasError) {
              // TODO: Adicionar botão de Tentar Novamente.
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      'Não foi possível obter as informações.',
                      style: Theme.of(context).textTheme.body2,
                    ),
                  ],
                ),
              );
            }

            return Center(
              child: CircularProgressIndicator(),
            );
          }),
    );
  }

  ///
  ///
  ///
  Future<String> _getData(String url) async {
    var client = new http.Client();

    String data = "";

    http.Response response =
        await client.get(url).timeout(Duration(seconds: 10));

    if (response.statusCode != 200) {
      throw Exception("$url - Status Code: ${response.statusCode}");
    }

    // TODO: Armazenar informações caso fique offline?

    data = response.body;

    client.close();

    return data;
  }

  ///
  ///
  ///
  void _loadData(String url) async {
    _streamController.add(null);
    _getData(url).then((data) {
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
  void _showPdf({final String url, final String filename}) {
    // TODO: Exibir tela Aguarde...
    // TODO: Quando cancelar um download?
    // TODO: Mostrar os arquivos que já foram baixados.
    _createFileOfPdfUrl(url).then((path) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => TelaPdf(
            path: path,
            filename: filename,
          ),
        ),
      );
    }).catchError(
      (error) => print(error),
    );
  }

  ///
  ///
  ///
  Future<String> _createFileOfPdfUrl(String url) async {
    final filename = url.substring(url.lastIndexOf("/") + 1);
    var request = await HttpClient().getUrl(Uri.parse(url));
    var response = await request.close();
    var bytes = await consolidateHttpClientResponseBytes(response,
        onBytesReceived: (int received, int length) {
      print('$received / $length');
    });
    String dir = (await getTemporaryDirectory()).path;
    File file = new File('$dir/$filename');
    await file.writeAsBytes(bytes);
    return file.path;
  }
}
