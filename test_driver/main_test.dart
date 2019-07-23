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

      await driver.scrollIntoView(avisosRadioNauticosTile);

      await driver.waitFor(avisosRadioNauticosTile);

      await driver.tap(avisosRadioNauticosTile);

      SerializableFinder atualizadoText = find.byValueKey('atualizadoText');

      await driver.waitFor(atualizadoText);

      await screenshot(driver, config, '2');
    }, timeout: Timeout(Duration(seconds: 30)));

    ///
    ///
    ///
    test('Avisos-Rádio Náuticos Filter Test', () async {
      SerializableFinder filterIconButton = find.byValueKey('filterIconButton');

      await driver.waitFor(filterIconButton);

      await driver.tap(filterIconButton);

      SerializableFinder tipoAvisoSarTile =
          find.byValueKey('TipoAviso.sarTile');

      await driver.waitFor(tipoAvisoSarTile);

      await screenshot(driver, config, '3');

      await driver.tap(tipoAvisoSarTile);

      SerializableFinder atualizadoText = find.byValueKey('atualizadoText');

      await driver.waitFor(atualizadoText);

    }, timeout: Timeout(Duration(seconds: 30)));

    // TODO: Teste de reload.

    ///
    ///
    ///
    // TODO: Teste com o mapa.
//    test('Avisos-Rádio Náuticos Mapa Test', () async {
//      SerializableFinder avisosRadioList = find.byValueKey('avisosRadioList');
//      await driver.waitFor(avisosRadioList);
//    }, timeout: Timeout(Duration(seconds: 30)));

    ///
    ///
    ///
    test('Avisos-Rádio Náuticos Page Back Test', () async {
      SerializableFinder pageBack = find.pageBack();
      await driver.tap(pageBack);
    }, timeout: Timeout(Duration(seconds: 30)));

    ///
    ///
    ///
    test('Avisos aos Navegantes Test', () async {
      SerializableFinder avisosAosNavegantesButton =
          find.byValueKey('avisoAosNavegantesButton');

      await driver.scrollIntoView(avisosAosNavegantesButton);

      await driver.waitFor(avisosAosNavegantesButton);

      await driver.tap(avisosAosNavegantesButton);

      await screenshot(driver, config, '4');

      SerializableFinder pageBack = find.pageBack();

      await driver.tap(pageBack);
    }, timeout: Timeout(Duration(seconds: 30)));

    // TODO: Explorar os avisos aos navegantes. Não tirar print.
    // TODO: areaMaritimaHidroviasGeral
    // TODO: hidroviaParaguaiParana
    // TODO: hidroviaTieteParana

    ///
    ///
    ///
    test('Avisos de Mau Tempo Test', () async {
      SerializableFinder avisosDeMauTempoButton =
          find.byValueKey('avisosDeMauTempoButton');

      await driver.scrollIntoView(avisosDeMauTempoButton);

      await driver.waitFor(avisosDeMauTempoButton);

      await driver.tap(avisosDeMauTempoButton);

      // FIXME: Esperar a tela carregar os dados.
      await screenshot(driver, config, '5');

      SerializableFinder pageBack = find.pageBack();

      await driver.tap(pageBack);
    }, timeout: Timeout(Duration(seconds: 30)));

    // TODO: Teste com filtro.

    // TODO: Teste de reload.
  });
}
