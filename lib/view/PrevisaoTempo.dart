import 'dart:async';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as p;
import 'package:ta_safo/util/VisualUtil.dart';
import 'package:ta_safo/widget/DownloadTile.dart';
import 'package:audioplayers/audioplayers.dart';

///
///
///
class PrevisaoTempo extends StatefulWidget {
  static const String routeName = '/previsao_tempo';

  @override
  _PrevisaoTempoState createState() => _PrevisaoTempoState();
}

///
///
///
class _PrevisaoTempoState extends State<PrevisaoTempo> {
  final String _url = 'http://portal.embratel.com.br'
      '/movelmaritimo/previsao-do-tempo/';

  final RegExp getWaveFiles = RegExp(
    r'\<source src="(.*?)">',
    caseSensitive: false,
    multiLine: true,
  );

  AudioPlayer audioPlayer = AudioPlayer();

  StreamController<String> _streamController;

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
        title: Text('Previsão do Tempo'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.stop),
            onPressed: () {
              audioPlayer.stop();
            },
          ),
        ],
      ),
      body: StreamBuilder<String>(
        stream: _streamController.stream,
        builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
          if (snapshot.hasData) {
            List<DownloadTile> items = [];

            getWaveFiles.allMatches(snapshot.data).forEach((match) {
              String url = _url + match[1].trim();
              String title =
                  p.basenameWithoutExtension(match[1].trim()).toUpperCase();
              String filename = p.basename(match[1].trim());

              items.add(DownloadTile(
                url: url,
                title: title,
                localFilename: filename,
                tapCallback: _playAudio,
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

            items.sort(
              (a, b) => (a.title).compareTo(b.title),
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
    var client = new http.Client();

    String data = "";

    http.Response response =
        await client.get(_url).timeout(Duration(seconds: 10));

    if (response.statusCode != 200) {
      throw Exception("$_url - Status Code: ${response.statusCode}");
    }

    // TODO: Armazenar informações caso fique offline.

    data = response.body;

    client.close();

    return data;
  }

  ///
  ///
  ///
  void _playAudio(String path) {
    if (path == null) {
      // TODO: Disparar crash.
    } else {
      print(path);
      // TODO: Melhorar player.
      audioPlayer.play(path, isLocal: true);
    }
  }

  ///
  ///
  ///
  @override
  void deactivate() {
    audioPlayer.stop().then((_) => audioPlayer.dispose());
    super.deactivate();
  }
}
