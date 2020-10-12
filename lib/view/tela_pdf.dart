import 'dart:async';

import 'package:path/path.dart' as p;
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';

///
///
///
class TelaPdf extends StatefulWidget {
  final String path;

  ///
  ///
  ///
  TelaPdf({Key key, this.path}) : super(key: key);

  ///
  ///
  ///
  @override
  _TelaPdfState createState() => _TelaPdfState();
}

///
///
///
class _TelaPdfState extends State<TelaPdf> {
  final Completer<PDFViewController> _controller =
      Completer<PDFViewController>();

  int pages = 0;
  bool isReady = false;

  ///
  ///
  ///
  @override
  Widget build(BuildContext context) {
    final String filename = p.basename(widget.path);

    return Scaffold(
      appBar: AppBar(
        title: Text(filename),
      ),
      body: Stack(
        children: <Widget>[
          PDFView(
            filePath: widget.path,
            enableSwipe: true,
            swipeHorizontal: true,
            autoSpacing: true,
            pageFling: true,
            onRender: (_pages) {
              setState(() {
                pages = _pages;
                isReady = true;
              });
            },
            onError: (error) {
              print(error.toString());
            },
            onPageError: (page, error) {
              print('$page: ${error.toString()}');
            },
            onViewCreated: (PDFViewController pdfViewController) {
              _controller.complete(pdfViewController);
            },
            onPageChanged: (int page, int total) {
              print('page change: $page/$total');
            },
          ),
          !isReady
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : Container()
        ],
      ),
//      floatingActionButton: FutureBuilder<PDFViewController>(
//        future: _controller.future,
//        builder: (context, AsyncSnapshot<PDFViewController> snapshot) {
//          if (snapshot.hasData) {
//            return FloatingActionButton.extended(
//              label: Text("Go to $pages"),
//              onPressed: () async {
//                await snapshot.data.setPage(pages);
//              },
//            );
//          }
//
//          return Container();
//        },
//      ),
    );
  }
}
