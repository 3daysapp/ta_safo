import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;

///
///
///
enum TipoAviso {
  todos,
  sar,
  navarea,
  norte,
  leste,
  sul,
  bacia_amazonica,
  hidrovias_geral,
}

///
///
///
class AvisosRadio extends StatefulWidget {
  static const String routeName = '/avisos_radio';

  @override
  _AvisosRadioState createState() => _AvisosRadioState();
}

///
///
///
class _AvisosRadioState extends State<AvisosRadio> {
  StreamController _streamController;
  TipoAviso _tipoAviso = TipoAviso.todos;

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
        title: Text('Avisos-Rádio e SAR'),
        actions: <Widget>[
          IconButton(
            key: Key('filterIconButton'),
            icon: Icon(FontAwesomeIcons.filter),
            onPressed: () => _settingModalBottomSheet(context),
          ),
          IconButton(
            key: Key('refreshIconButton'),
            icon: Icon(FontAwesomeIcons.sync),
            onPressed: () {
              _loadData(tipo: _tipoAviso);
            },
          ),
        ],
      ),
      body: StreamBuilder(
        stream: _streamController.stream,
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.hasData) {
            Map data = snapshot.data;
            List avisos = data['avisos'];

            switch (_tipoAviso) {
              case TipoAviso.todos:
                // Do nothing.
                break;
              case TipoAviso.sar:
                avisos.retainWhere((aviso) => aviso['costa'] == 'SAR');
                break;
              case TipoAviso.navarea:
                avisos.retainWhere((aviso) => aviso['costa'] == ' ');
                break;
              case TipoAviso.norte:
                avisos.retainWhere((aviso) => aviso['costa'] == 'N');
                break;
              case TipoAviso.leste:
                avisos.retainWhere((aviso) => aviso['costa'] == 'E');
                break;
              case TipoAviso.sul:
                avisos.retainWhere((aviso) => aviso['costa'] == 'S');
                break;
              case TipoAviso.bacia_amazonica:
                avisos.retainWhere((aviso) => aviso['costa'] == 'I');
                break;
              case TipoAviso.hidrovias_geral:
                avisos.retainWhere((aviso) => aviso['costa'] == 'HG');
                break;
            }

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
                        child: Text('Atualizado ${data['atualizado']} GMT'),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: ListView.separated(
                    separatorBuilder: (BuildContext context, int index) =>
                        Divider(),
                    itemCount: avisos.length,
                    itemBuilder: (BuildContext context, int index) {
                      Map aviso = avisos.elementAt(index);
                      String geo = aviso['geometry'];
                      return ListTile(
                        title: Text(aviso['numero']),
                        subtitle: Text(aviso['textoPT']),
                        trailing:
                            geo.isNotEmpty ? Icon(FontAwesomeIcons.map) : null,
                        onTap: geo.isNotEmpty ? () => _parseGeo(geo) : null,
                      );
                    },
                  ),
                ),
              ],
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
  void _parseGeo(String geo) {
    print(geo);
  }

  ///
  ///
  ///
  Future<Map<String, dynamic>> _getData() async {
    var client = new http.Client();

    Map data = {};

    String url = 'https://www.marinha.mil.br/chm/sites/'
        'www.marinha.mil.br.chm/files/opt/avradio.json';

    http.Response response =
        await client.get(url).timeout(Duration(seconds: 10));

    if (response.statusCode != 200) {
      throw Exception("$url - Status Code: ${response.statusCode}");
    }

    // TODO: Armazenar informações caso fique offline.

    data = json.decode(response.body);
    client.close();
    return data;
  }

  ///
  ///
  ///
  _loadData({TipoAviso tipo = TipoAviso.todos}) async {
    _tipoAviso = tipo;
    _streamController.add(null);
    _getData().then((map) {
      _streamController.add(map);
    }).catchError((error) {
      print(error);
      _streamController.addError(error);
    });
  }

  ///
  ///
  ///
  ListTile _getBottomSheetTile(TipoAviso tipo, String label) {
    return ListTile(
      title: Text(label),
      leading: Icon(_tipoAviso == tipo
          ? FontAwesomeIcons.checkCircle
          : FontAwesomeIcons.circle),
      dense: true,
      onTap: () {
        Navigator.of(context).pop();
        _loadData(tipo: tipo);
      },
    );
  }

  ///
  ///
  ///
  void _settingModalBottomSheet(context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              _getBottomSheetTile(
                TipoAviso.todos,
                'Todos',
              ),
              _getBottomSheetTile(
                TipoAviso.sar,
                'SAR',
              ),
              _getBottomSheetTile(
                TipoAviso.navarea,
                'Navarea V',
              ),
              _getBottomSheetTile(
                TipoAviso.norte,
                'Costa Norte',
              ),
              _getBottomSheetTile(
                TipoAviso.leste,
                'Costa Leste',
              ),
              _getBottomSheetTile(
                TipoAviso.sul,
                'Costa Sul',
              ),
              _getBottomSheetTile(
                TipoAviso.bacia_amazonica,
                'Bacia Amazônica',
              ),
              _getBottomSheetTile(
                TipoAviso.hidrovias_geral,
                'Hidrovias em Geral',
              ),
            ],
          ),
        );
      },
    );
  }
}
