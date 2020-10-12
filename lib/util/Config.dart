///
///
///
class Config {
  static final Config _singleton = Config._internal();

  ///
  ///
  ///
  factory Config() {
    return _singleton;
  }

  bool debug = false;

  Config._internal();
}
