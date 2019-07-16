import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;

enum SarNavarea { sar, navarea }

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
  SarNavarea _character = SarNavarea.sar;
  StreamController _streamController;

  @override
  void initState() {
    _streamController = new StreamController();
    loadData();
    super.initState();
  }

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
            onPressed: loadData,
          ),
        ],
      ),
      body: StreamBuilder(
        stream: _streamController.stream,
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.hasData) {
            Map data = snapshot.data;
            List avisos = data['avisos'];
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
                        child: Text('Atualizado ${data['atualizado']}'),
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
                        onTap: geo.isNotEmpty
                            ? () {
                                print(geo);
                              }
                            : null,
                      );
                    },
                  ),
                ),
              ],
            );
          }
          if (snapshot.hasError) {
            // TODO : Indicar uma mensagem derro.
            return Text('Ocorreu um erro');
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
  Future<Map<String, dynamic>> _getData() async {
    var client = new http.Client();
    Map data = {};
    try {
      http.Response response = await client.get(
          'https://www.marinha.mil.br/chm/sites/www.marinha.mil.br.chm/files/opt/avradio.json');
      // TODO: Tratar Response Status
      data = json.decode(response.body);
    } finally {
      client.close();
    }
    return data;
  }

  ///
  ///
  ///
  loadData() async {
    _streamController.add(null);
    _getData().then((map) {
      _streamController.add(map);
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
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                title: const Text('SAR'),
              ),
              ListTile(
                title: const Text('Navarea V'),
              ),
              ListTile(
                title: const Text('Costa Norte'),
              ),
              ListTile(
                title: const Text('Costa Leste'),
              ),
              ListTile(
                title: const Text('Costa Sul'),
              ),
            ],
          ),
        );
      },
    );
  }
}
