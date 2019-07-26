import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:ta_safo/util/VisualUtil.dart';
import 'package:ta_safo/view/TelaPdf.dart';
import 'package:ta_safo/widget/DownloadTile.dart';

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
      ),
      body: StreamBuilder(
        stream: _streamController.stream,
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.hasData) {
            List<DownloadTile> items = [];

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

                items.add(DownloadTile(
                  url: url,
                  localFilename: filename,
                  title: "$ano - $folheto",
                  subtitle: subtitle,
                  tapCallback: _showPdf,
                ));
              },
            );

            if (items.isEmpty) {
              return Center(
                child: Text(
                  'Nenhuma informação encontrada.',
                  style: Theme.of(context).textTheme.body2,
                ),
              );
            }

            items.sort(
              (a, b) => (b.title).compareTo(a.title),
            );

            return ListView.separated(
              itemBuilder: (BuildContext context, int index) {
                return items.elementAt(index);
              },
              separatorBuilder: (BuildContext context, int index) => Divider(),
              itemCount: items.length,
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
    _getData().then((data) {
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
    var client = http.Client();

    String data = "";

    http.Response response =
        await client.get(_url).timeout(Duration(seconds: 10));

    if (response.statusCode != 200) {
      throw Exception("$_url - Status Code: ${response.statusCode}");
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
}
