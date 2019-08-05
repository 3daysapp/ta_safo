import 'dart:async';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:flutter/material.dart';
import 'package:ta_safo/routes.dart';
import 'package:ta_safo/util/Config.dart';
import 'package:ta_safo/view/Home.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter_udid/flutter_udid.dart';

///
///
///
void main() {
  bool debug = false;

  assert(debug = true);

  Config config = Config();

  config.debug = debug;

  if (debug) {
    runApp(TaSafo());
  } else {
    Crashlytics.instance.enableInDevMode = false;
    FlutterError.onError = Crashlytics.instance.recordFlutterError;

    runZoned<Future<void>>(
      () async => runApp(TaSafo()),
      onError: Crashlytics.instance.recordError,
    );
  }
}

///
///
///
class TaSafo extends StatelessWidget {
  static FirebaseAnalytics analytics = FirebaseAnalytics();
  static FirebaseAnalyticsObserver observer =
  FirebaseAnalyticsObserver(analytics: analytics);

  Config config = Config();

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
            navigatorObservers: <NavigatorObserver>[observer],
            home: Home(),
            routes: Routes.build(context),
          );
        }
        return Container(
          child: Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }
}
