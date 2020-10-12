import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

///
///
///
enum PopupOperation {
  force_download,
  delete_file,
}

///
///
///
class DownloadTile extends StatefulWidget {
  final String url;
  final String localFilename;
  final String title;
  final String subtitle;
  final ValueSetter<String> tapCallback;

  ///
  ///
  ///
  const DownloadTile({
    Key key,
    this.url,
    this.localFilename,
    this.title,
    this.subtitle,
    this.tapCallback,
  }) : super(key: key);

  ///
  ///
  ///
  @override
  _DownloadTileState createState() => _DownloadTileState();
}

///
///
///
class _DownloadTileState extends State<DownloadTile> {
  StreamController<double> _streamController;
  String _path;

  ///
  ///
  ///
  @override
  void initState() {
    _streamController = StreamController();
    _verifyLocalFile();
    super.initState();
  }

  ///
  ///
  ///
  Future<File> _getLocalFile() async {
    String dir = (await getTemporaryDirectory()).path;
    return File('$dir/${widget.localFilename}');
  }

  ///
  ///
  ///
  Future<void> _verifyLocalFile() async {
    File file = await _getLocalFile();
    if (file.existsSync()) {
      _path = file.path;
      _streamController.add(1.0);
      await _streamController.close();
    }
  }

  ///
  ///
  ///
  @override
  Widget build(BuildContext context) {
    // TODO: Cancelar download.
    return ListTile(
      leading: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          StreamBuilder<double>(
            stream: _streamController.stream,
            builder: (BuildContext context, AsyncSnapshot<double> snapshot) {
              if (snapshot.hasData) {
                if (snapshot.data < 1) {
                  return CircularProgressIndicator(
                    value: snapshot.data < 0 ? null : snapshot.data,
                  );
                } else {
                  return Icon(Icons.check_circle);
                }
              }
              if (snapshot.hasError) {
                // TODO: Disparar crash.
                return Icon(Icons.error);
              }
              return Icon(Icons.file_download);
            },
          ),
        ],
      ),
      title: Text('${widget.title}'),
      subtitle: widget.subtitle == null ? null : Text(widget.subtitle),
      trailing: PopupMenuButton<PopupOperation>(
        icon: Icon(Icons.more_vert),
        onSelected: _popupSelect,
        itemBuilder: (BuildContext context) {
          return [
            _getPopupItem(
              PopupOperation.force_download,
              'Baixar Novamente',
              Icons.file_download,
            ),
            PopupMenuDivider(),
            _getPopupItem(
              PopupOperation.delete_file,
              'Excluir Arquivo',
              Icons.delete,
            ),
          ];
        },
      ),
      onTap: _tapAction,
    );
  }

  ///
  ///
  ///
  PopupMenuItem<PopupOperation> _getPopupItem(
    PopupOperation operation,
    String label,
    IconData icons,
  ) {
    return PopupMenuItem<PopupOperation>(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: Icon(
              icons,
              color: Colors.black45,
            ),
          ),
          Text(label),
        ],
      ),
      value: operation,
    );
  }

  ///
  ///
  ///
  void _popupSelect(PopupOperation selected) {
    switch (selected) {
      case PopupOperation.force_download:
        _downloadFile();
        break;
      case PopupOperation.delete_file:
        _deleteFile();
        break;
    }
  }

  ///
  ///
  ///
  void _tapAction() {
    if (!_streamController.isClosed) {
      _downloadFile();
    } else {
      if (widget.tapCallback != null) {
        widget.tapCallback(_path);
      }
    }
  }

  ///
  ///
  ///
  void _downloadFile() {
    if (_streamController.isClosed) {
      setState(() {
        _streamController = StreamController();
      });
    }

    _streamController.add(-1.0);

    _createFileOfUrl()
        .then((String path) {
          _path = path;
          _streamController.add(1.0);
        })
        .catchError(
          (error) => _streamController.addError(error),
        )
        .whenComplete(
          () => _streamController.close(),
        );
  }

  ///
  ///
  ///
  Future<void> _deleteFile() async {
    File file = await _getLocalFile();
    if (file.existsSync()) {
      file.deleteSync();
    }
    _path = null;
    setState(() {
      _streamController = StreamController()..add(null);
    });
  }

  ///
  ///
  ///
  Future<String> _createFileOfUrl() async {
    HttpClientRequest request =
        await HttpClient().getUrl(Uri.parse(widget.url));
    HttpClientResponse response = await request.close();

    if (response.statusCode < 200 || response.statusCode > 299) {
      _streamController
          .addError('Response status code: ${response.statusCode}');
      return null;
    }

    Uint8List bytes = await consolidateHttpClientResponseBytes(
      response,
      onBytesReceived: (int received, int length) {
        int total = length ?? 10000000;
        double percent = received / total;
        if (percent > 1.0) {
          percent = -1;
        }
        _streamController.add(percent);
      },
    );
    File file = await _getLocalFile();
    await file.writeAsBytes(bytes);
    return file.path;
  }
}
