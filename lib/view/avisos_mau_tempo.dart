import 'dart:async';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart';
import 'package:ta_safo/util/mau_tempo.dart';
import 'package:ta_safo/util/metric_http_client.dart';

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
  StreamController<String> _streamController;
  final String _url = 'https://www.marinha.mil.br/chm/'
      'dados-do-smm-avisos-de-mau-tempo/avisos-de-mau-tempo';

  static const String noFilter = 'TODAS';
  String _filtroArea = noFilter;
  List<String> _areas;

  ///
  ///
  ///
  @override
  void initState() {
    _streamController = StreamController();
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
        builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
          if (snapshot.hasData) {
            List<MauTempo> lista = MauTempo.parse(snapshot.data);
            _areas = [noFilter];

            lista.forEach((aviso) {
              if (!_areas.contains(aviso.area)) {
                _areas.add(aviso.area);
              }
            });

            if (_filtroArea != noFilter) {
              lista.retainWhere((aviso) => aviso.area == _filtroArea);
            }

            String area;

            List<Widget> listWidgets = [];

            lista.forEach((MauTempo item) {
              if (area != item.area) {
                if (area != null) {
                  listWidgets.add(Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Divider(),
                  ));
                }

                listWidgets.add(
                  SizedBox(
                    width: double.infinity,
                    height: 40.0,
                    child: Center(
                      child: Text(
                        item.area,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                        textScaleFactor: 1.2,
                      ),
                    ),
                  ),
                );
                area = item.area;
              }

              listWidgets.add(
                Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: ListTile(
                    title: Text(item.numero),
                    subtitle: Text(item.texto),
                  ),
                ),
              );
            });

            listWidgets.add(SizedBox(
              height: 30,
              width: double.infinity,
              child: Text(''),
            ));

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
                  child: ListView(
                    children: listWidgets,
                  ),
                ),
              ],
            );
          }
          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Não foi possível obter as informações.',
                style: Theme.of(context).textTheme.bodyText1,
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
    MetricHttpClient client = MetricHttpClient(Client());

    String data = '';

    Response response = await client.get(_url).timeout(Duration(seconds: 10));

    if (response.statusCode != 200) {
      throw Exception('$_url - Status Code: ${response.statusCode}');
    }

    // TODO: Armazenar informações caso fique offline.

    data = response.body;

    client.close();

    return data;
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
  void _settingModalBottomSheet(context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          child: ListView(
            children: _areas
                .map(
                  (area) => ListTile(
                    key: Key('${area}Tile'),
                    title: Text(area),
                    leading: Icon(
                      _filtroArea == area
                          ? FontAwesomeIcons.checkCircle
                          : FontAwesomeIcons.circle,
                    ),
                    dense: true,
                    onTap: () {
                      _filtroArea = area;
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
