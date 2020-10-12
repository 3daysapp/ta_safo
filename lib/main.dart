import 'dart:async';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_udid/flutter_udid.dart';
import 'package:ta_safo/routes.dart';
import 'package:ta_safo/util/config.dart';
import 'package:ta_safo/view/home.dart';

///
///
///
void main() async {
  bool debug = false;
  assert(debug = true);

  Config().debug = debug;

  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();

  if (debug) {
    runApp(TaSafo());
  } else {
    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;

    runZonedGuarded(() {
      runApp(TaSafo());
    }, FirebaseCrashlytics.instance.recordError);
  }
}

///
///
///
class TaSafo extends StatelessWidget {
  static FirebaseAnalytics analytics = FirebaseAnalytics();

  ///
  ///
  ///
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: FlutterUdid.consistentUdid,
      builder: (context, snapshot) {
        if (snapshot.hasData || snapshot.hasError) {
          if (snapshot.hasData) {
            FirebaseCrashlytics.instance.setUserIdentifier(snapshot.data);
          }
          return MaterialApp(
            title: 'Tá Safo',
            theme: ThemeData(
              primarySwatch: Colors.green,
            ),
            navigatorObservers: [
              FirebaseAnalyticsObserver(analytics: analytics),
            ],
            home: Home(),
            routes: Routes.build(context),
            localizationsDelegates: [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
            ],
            supportedLocales: [
              Locale('pt', 'BR'),
            ],
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
