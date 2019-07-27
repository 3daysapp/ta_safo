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
    int _count = 0;

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

      await screenshot(driver, config, (_count++).toString());

      await driver.tap(homeDrawer);

      await screenshot(driver, config, (_count++).toString());
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

      await screenshot(driver, config, (_count++).toString());
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

      await screenshot(driver, config, (_count++).toString());

      await driver.tap(tipoAvisoSarTile);

      SerializableFinder atualizadoText = find.byValueKey('atualizadoText');

      await driver.waitFor(atualizadoText);
    }, timeout: Timeout(Duration(seconds: 30)));

    ///
    ///
    ///
    test('Avisos-Rádio Náuticos Refresh Test', () async {
      SerializableFinder refreshIconButton =
          find.byValueKey('refreshIconButton');

      await driver.waitFor(refreshIconButton);

      await driver.tap(refreshIconButton);

      SerializableFinder atualizadoText = find.byValueKey('atualizadoText');

      await driver.waitFor(atualizadoText);
    }, timeout: Timeout(Duration(seconds: 30)));

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

      await screenshot(driver, config, (_count++).toString());
    }, timeout: Timeout(Duration(seconds: 30)));

    ///
    ///
    ///
    List<Map<String, dynamic>> confs = [
      {
        'name': 'Área Marítima',
        'key': 'areaMaritimaHidroviasGeralButton',
        'capture': true,
      },
      {
        'name': 'Paraguai-Paraná',
        'key': 'hidroviaParaguaiParanaButton',
        'capture': false,
      },
      {
        'name': 'Tietê-Paraná',
        'key': 'hidroviaTieteParanaButton',
        'capture': false,
      },
    ];

    confs.forEach((conf) {
      ///
      ///
      ///
      test('Avisos aos Navegantes ${conf['name']} Test', () async {
        SerializableFinder button = find.byValueKey(conf['key']);

        await driver.scrollIntoView(button);

        await driver.waitFor(button);

        await driver.tap(button);

        SerializableFinder atualizadoText = find.byValueKey('atualizadoText');

        await driver.waitFor(atualizadoText);

        if (conf['capture']) {
          await screenshot(driver, config, (_count++).toString());
        }
      }, timeout: Timeout(Duration(seconds: 30)));

      ///
      ///
      ///
      test('Avisos aos Navegantes ${conf['name']} Filter Test', () async {
        SerializableFinder filterIconButton =
            find.byValueKey('filterIconButton');

        await driver.waitFor(filterIconButton);

        await driver.tap(filterIconButton);

        SerializableFinder filterTile = find.byValueKey('ano2019Tile');

        await driver.waitFor(filterTile);

        await driver.tap(filterTile);

        SerializableFinder atualizadoText = find.byValueKey('atualizadoText');

        await driver.waitFor(atualizadoText);
      }, timeout: Timeout(Duration(seconds: 30)));

      ///
      ///
      ///
      test('Avisos aos Navegantes ${conf['name']} Refresh Test', () async {
        SerializableFinder refreshIconButton =
            find.byValueKey('refreshIconButton');

        await driver.waitFor(refreshIconButton);

        await driver.tap(refreshIconButton);

        SerializableFinder atualizadoText = find.byValueKey('atualizadoText');

        await driver.waitFor(atualizadoText);
      }, timeout: Timeout(Duration(seconds: 30)));

      ///
      ///
      ///
      test('Avisos aos Navegantes ${conf['name']} Page Back Test', () async {
        SerializableFinder pageBack = find.pageBack();
        await driver.tap(pageBack);
      }, timeout: Timeout(Duration(seconds: 30)));
    });

    ///
    ///
    ///
    test('Avisos aos Navegantes Page Back Test', () async {
      SerializableFinder pageBack = find.pageBack();
      await driver.tap(pageBack);
    }, timeout: Timeout(Duration(seconds: 30)));

    ///
    ///
    ///
    test('Avisos de Mau Tempo Test', () async {
      SerializableFinder avisosDeMauTempoButton =
          find.byValueKey('avisosDeMauTempoButton');

      await driver.scrollIntoView(avisosDeMauTempoButton);

      await driver.waitFor(avisosDeMauTempoButton);

      await driver.tap(avisosDeMauTempoButton);

      SerializableFinder atualizadoText = find.byValueKey('atualizadoText');

      await driver.waitFor(atualizadoText);

      await screenshot(driver, config, (_count++).toString());
    }, timeout: Timeout(Duration(seconds: 30)));

    ///
    ///
    ///
    test('Avisos de Mau Tempo Filter Test', () async {
      SerializableFinder filterIconButton = find.byValueKey('filterIconButton');

      await driver.waitFor(filterIconButton);

      await driver.tap(filterIconButton);

      SerializableFinder filterTile = find.byValueKey('TODASTile');

      await driver.waitFor(filterTile);

      await driver.tap(filterTile);

      SerializableFinder atualizadoText = find.byValueKey('atualizadoText');

      await driver.waitFor(atualizadoText);
    }, timeout: Timeout(Duration(seconds: 30)));

    ///
    ///
    ///
    test('Avisos de Mau Tempo Refresh Test', () async {
      SerializableFinder refreshIconButton =
          find.byValueKey('refreshIconButton');

      await driver.waitFor(refreshIconButton);

      await driver.tap(refreshIconButton);

      SerializableFinder atualizadoText = find.byValueKey('atualizadoText');

      await driver.waitFor(atualizadoText);
    }, timeout: Timeout(Duration(seconds: 30)));

    ///
    ///
    ///
    test('Avisos de Mau Tempo Page Back Test', () async {
      SerializableFinder pageBack = find.pageBack();
      await driver.tap(pageBack);
    }, timeout: Timeout(Duration(seconds: 30)));
  });
}
