import 'dart:async';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:ta_safo/util/MauTempo.dart';

///
///
///
class AvisosMauTempo extends StatefulWidget {
  static const String routeName = '/avisos_mau_tempo';

  @override
  _AvisosMauTempoState createState() => _AvisosMauTempoState();
}

///
///
///
class _AvisosMauTempoState extends State<AvisosMauTempo> {
  StreamController _streamController;

  ///
  ///
  ///
  @override
  void initState() {
    _streamController = new StreamController();
    _loadData();
    super.initState();
  }

  ///
  ///
  ///
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Avisos de Mau Tempo'),
        actions: <Widget>[
          IconButton(
            key: Key('refreshIconButton'),
            icon: Icon(FontAwesomeIcons.sync),
            onPressed: () {
              _loadData();
            },
          ),
        ],
      ),
      body: StreamBuilder(
        stream: _streamController.stream,
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.hasData) {
            List<MauTempo> lista = MauTempo.parse(snapshot.data);

            return ListView.separated(
              separatorBuilder: (BuildContext context, int index) => Divider(),
              itemCount: lista.length,
              itemBuilder: (BuildContext context, int index) {
                MauTempo item = lista.elementAt(index);
                return ListTile(
                  title: Text("${item.area} - ${item.numero}"),
                  subtitle: Text(item.texto),
                );
              },
            );
          }
          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Não foi possível obter as informações.',
                style: Theme.of(context).textTheme.body2,
              ),
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
  Future<String> _getData() async {
    var client = new http.Client();

    String data = "";

    String url = 'https://www.marinha.mil.br/chm/'
        'dados-do-smm-avisos-de-mau-tempo/avisos-de-mau-tempo';

    http.Response response =
        await client.get(url).timeout(Duration(seconds: 10));

    if (response.statusCode != 200) {
      throw Exception("$url - Status Code: ${response.statusCode}");
    }

    // TODO: Armazenar informações caso fique offline.

    data = response.body;

    client.close();

    return data;
  }

  ///
  ///
  ///
  _loadData() async {
    _streamController.add(null);
    _getData().then((data) {
      _streamController.add(data);
    }).catchError((error) {
      print(error);
      _streamController.addError(error);
    });
  }
}
