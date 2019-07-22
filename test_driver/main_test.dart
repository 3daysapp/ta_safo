import 'package:flutter_driver/flutter_driver.dart';
import 'package:screenshots/screenshots.dart';
import 'package:test/test.dart';

///
///
///
void main() {
  ///
  ///
  ///
  group('end-to-end-test', () {
    FlutterDriver driver;
    final Map config = Config().configInfo;

    ///
    ///
    ///
    setUpAll(() async {
      driver = await FlutterDriver.connect();
    });

    ///
    ///
    ///
    tearDownAll(() async {
      if (driver != null) await driver.close();
    });

    ///
    ///
    ///
    test('Drawer Test', () async {
      // FIXME: Melhor forma de localizar o Drawer.
      SerializableFinder homeDrawer = find.byTooltip('Open navigation menu');

      await driver.waitFor(homeDrawer);

      await screenshot(driver, config, '0');

      await driver.tap(homeDrawer);

      await screenshot(driver, config, '1');
    }, timeout: Timeout(Duration(seconds: 30)));

    ///
    ///
    ///
    test('Avisos-Rádio Náuticos Test', () async {
      SerializableFinder avisosRadioNauticosTile =
          find.byValueKey('avisosRadioNauticosTile');

      await driver.waitFor(avisosRadioNauticosTile);

      await driver.tap(avisosRadioNauticosTile);

      SerializableFinder atualizadoText = find.byValueKey('atualizadoText');

      await driver.waitFor(atualizadoText);

      await screenshot(driver, config, '2');

      SerializableFinder pageBack = find.pageBack();

      await driver.tap(pageBack);
    }, timeout: Timeout(Duration(seconds: 30)));

    // TODO: Teste com o mapa.
    ///
    ///
    ///
//    test('Avisos-Rádio Náuticos Mapa Test', () async {
//      SerializableFinder avisosRadioList = find.byValueKey('avisosRadioList');
//      await driver.waitFor(avisosRadioList);
//    }, timeout: Timeout(Duration(seconds: 30)));

    ///
    ///
    ///
    test('Avisos de Mau Tempo Test', () async {
      SerializableFinder avisosDeMauTempoButton =
          find.byValueKey('avisosDeMauTempoButton');

      await driver.waitFor(avisosDeMauTempoButton);

      await driver.tap(avisosDeMauTempoButton);

      // FIXME: Esperar a tela carregar os dados.
      await screenshot(driver, config, '3');

      SerializableFinder pageBack = find.pageBack();

      await driver.tap(pageBack);
    }, timeout: Timeout(Duration(seconds: 30)));
  });
}
