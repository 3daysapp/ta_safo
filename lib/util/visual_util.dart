import 'package:flutter/material.dart';

///
///
///
class NoInfo extends StatelessWidget {
  ///
  ///
  ///
  @override
  Widget build(BuildContext context) {
    // TODO: Disparar crash.
    return Center(
      child: Text(
        'Não foi possível obter as informações.',
        style: Theme.of(context).textTheme.bodyText1,
      ),
    );
  }
}

///
///
///
class TryAgain extends StatelessWidget {
  final Object error;
  final VoidCallback callback;

  ///
  ///
  ///
  const TryAgain({Key key, this.error, this.callback}) : super(key: key);

  ///
  ///
  ///
  @override
  Widget build(BuildContext context) {
    // TODO: Disparar crash.
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text(
            'Não foi possível obter as informações.',
            style: Theme.of(context).textTheme.bodyText1,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: RaisedButton(
              onPressed: callback,
              child: Text('Tentar novamente?'),
            ),
          ),
        ],
      ),
    );
  }
}
