import 'package:flutter/material.dart';
import 'package:ta_safo/routes.dart';
import 'package:ta_safo/view/Home.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter_udid/flutter_udid.dart';

///
///
///
void main() {
  bool debug = false;
  assert(debug = true);
  if (!debug) {
    Crashlytics.instance.enableInDevMode = false;
    FlutterError.onError = (FlutterErrorDetails details) {
      Crashlytics.instance.onError(details);
    };
  }

  runApp(TaSafo());
}

///
///
///
class TaSafo extends StatelessWidget {
  ///
  ///
  ///
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<String>(
      stream: FlutterUdid.consistentUdid.asStream(),
      builder: (context, snapshot) {
        if (snapshot.hasData || snapshot.hasError) {
          if (snapshot.hasData) {
            Crashlytics.instance.setUserIdentifier(snapshot.data);
          }

          return MaterialApp(
            title: 'Tá Safo',
            theme: ThemeData(
              primarySwatch: Colors.green,
            ),
            home: Home(),
            routes: Routes.build(context),
          );
        }
        return CircularProgressIndicator();
      },
    );
  }
}
