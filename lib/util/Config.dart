import 'package:firebase_remote_config/firebase_remote_config.dart';

///
///
///
class Config {
  static final Config _singleton = Config._internal();

  factory Config() {
    return _singleton;
  }

  bool debug = false;
  RemoteConfig remoteConfig;

  Config._internal();
}
