import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:ta_safo/util/Geo.dart';
import 'package:ta_safo/util/VisualUtil.dart';
import 'package:ta_safo/view/AvisosRadioMapa.dart';

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
  String _url = 'https://www.marinha.mil.br/chm/sites/'
      'www.marinha.mil.br.chm/files/opt/avradio.json';

  TipoAviso _filtroTipo = TipoAviso.todos;

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
            onPressed: _loadData,
          ),
        ],
      ),
      body: StreamBuilder(
        stream: _streamController.stream,
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.hasData) {
            Map data = snapshot.data;
            List avisos = data['avisos'];

            switch (_filtroTipo) {
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
              default:
                // Do nothing.
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
                        child: Text(
                          'Atualizado ${data['atualizado']} GMT',
                          key: Key('atualizadoText'),
                        ),
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

                      List<Map<String, dynamic>> geos = [];

                      try {
                        String geo = aviso['geometry'];
                        if (geo.isNotEmpty) {
                          geos = Geo.parse(aviso['geometry']);
                        }
                      } catch (e) {
                        // TODO: Relatar crash.
                      }

                      return ListTile(
                        title: Text(aviso['numero']),
                        subtitle: Text(aviso['textoPT']),
                        trailing:
                            geos.isNotEmpty ? Icon(FontAwesomeIcons.map) : null,
                        onTap: geos.isNotEmpty
                            ? () => _showGeometry(aviso['numero'], geos)
                            : null,
                      );
                    },
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
  void _showGeometry(String title, List<Map<String, dynamic>> geos) {
    Navigator.of(context).pushNamed(
      AvisosRadioMapa.routeName,
      arguments: {
        'title': title,
        'geos': geos,
      },
    );
  }

  ///
  ///
  ///
  _loadData() async {
    _streamController.add(null);
    _getData().then((map) {
      _streamController.add(map);
    }).catchError((error) {
      print(error);
      // TODO: Disparar crash.
      _streamController.addError(error);
    });
  }

  ///
  ///
  ///
  Future<Map<String, dynamic>> _getData() async {
    var client = new http.Client();

    Map data = {};

    http.Response response =
        await client.get(_url).timeout(Duration(seconds: 10));

    if (response.statusCode != 200) {
      throw Exception("$_url - Status Code: ${response.statusCode}");
    }

    // TODO: User cloud storage para cache.
    // TODO: Armazenar informações caso fique offline.

    data = json.decode(response.body);
    client.close();
    return data;
  }

  ///
  ///
  ///
  ListTile _getBottomSheetTile(TipoAviso tipo, String label) {
    return ListTile(
      key: Key('${tipo.toString()}Tile'),
      title: Text(label),
      leading: Icon(
        _filtroTipo == tipo
            ? FontAwesomeIcons.checkCircle
            : FontAwesomeIcons.circle,
      ),
      dense: true,
      onTap: () {
        _filtroTipo = tipo;
        _loadData();
        Navigator.of(context).pop();
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
          child: ListView(
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
