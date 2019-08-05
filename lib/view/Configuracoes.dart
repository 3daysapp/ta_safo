import 'dart:io';

import 'package:flutter/material.dart';
import 'package:package_info/package_info.dart';
import 'package:flutter_udid/flutter_udid.dart';
import 'package:path_provider/path_provider.dart';
import 'package:ta_safo/util/Config.dart';

///
///
///
class Configuracoes extends StatefulWidget {
  static const String routeName = '/configuracoes';

  @override
  _ConfiguracoesState createState() => _ConfiguracoesState();
}

///
///
///
class _ConfiguracoesState extends State<Configuracoes> {
  Config config = Config();

  ///
  ///
  ///
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Configurações'),
      ),
      body: Builder(
        builder: (context) => ListView(
          children: _getItens(),
        ),
      ),
    );
  }

  ///
  ///
  ///
  List<Widget> _getItens() {
    List<Widget> lista = [];

    lista.add(Divider());

    lista.add(ListTile(
      leading: Icon(Icons.clear_all),
      title: Text('Esvaziar Cache'),
      subtitle: Text('Esta opção irá limpar todos os downloads que '
          'foram realizados.'),
      onTap: () => _clearCache(context),
    ));

    lista.add(Divider());

    lista.add(StreamBuilder<PackageInfo>(
      stream: PackageInfo.fromPlatform().asStream(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return ListTile(
            leading: Icon(Icons.verified_user),
            title: Text('Versão'),
            subtitle: Text(snapshot.data.version),
          );
        }
        return ListTile(
          title: Text('Carregando...'),
        );
      },
    ));

    lista.add(Divider());

    if (config.remoteConfig.getBool('show_uuid') ?? false) {
      lista.add(StreamBuilder<String>(
        stream: FlutterUdid.consistentUdid.asStream(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListTile(
              leading: Icon(Icons.android),
              title: Text('Udid'),
              subtitle: Text(snapshot.data),
            );
          }
          return ListTile(
            title: Text('Carregando...'),
          );
        },
      ));

      lista.add(Divider());
    }

    return lista;
  }

  ///
  ///
  ///
  Future<void> _clearCache(BuildContext context) async {
    Directory tempDir = await getTemporaryDirectory();

    List<FileSystemEntity> fses = tempDir.listSync(
      recursive: true,
      followLinks: false,
    );

    int count = 0;
    fses.forEach((fse) {
      if (fse.statSync().type == FileSystemEntityType.file) {
        fse.deleteSync();
        count++;
      }
    });

    Scaffold.of(context).showSnackBar(
      SnackBar(
        content: count == 0
            ? Text('O cache já está vazio.')
            : count == 1
                ? Text('1 arquivo excluído!')
                : Text('$count arquivos excluídos!'),
        duration: Duration(seconds: 3),
      ),
    );
  }
}
