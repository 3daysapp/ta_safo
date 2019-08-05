import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:ta_safo/util/Config.dart';

///
///
///
class MauTempo {
  String area;
  String numero;
  String texto;

  MauTempo(this.area, this.numero, this.texto);

  ///
  ///
  ///
  @override
  String toString() {
    return 'MauTempo => area: $area, numero: $numero, texto: $texto';
  }

  ///
  ///
  ///
  static List<MauTempo> parse(String html) {
    Config config = Config();

    RegExp articleRegex = RegExp(
      r"\<article.*>[\s\S]*?(<p>[\s\S]*<\/p>)[\s\S]*<\/article>",
      caseSensitive: false,
      multiLine: true,
    );

    RegExp pRegex = RegExp(
      r"\<p>([\s\S]*?)<\/p>",
      caseSensitive: false,
      multiLine: true,
    );

    RegExp clearTags = RegExp(
      r"<[^>]*>",
      caseSensitive: false,
      multiLine: true,
    );

    RegExp areaRegex = RegExp(
      r"\<.*#ff0000[^>]*>(.*)<[^>]*>",
      caseSensitive: false,
      multiLine: true,
    );

    RegExp numeroRegex = RegExp(
      r"\<u>(.*?)<\/u>",
      caseSensitive: false,
      multiLine: true,
    );

    RegExp textoRegex = RegExp(
      r"\<br />([\s\S]*)$",
      caseSensitive: false,
      multiLine: true,
    );

    List<MauTempo> list = [];
    MauTempo backup;

    articleRegex.allMatches(html).forEach((RegExpMatch match) {
      String area;

      pRegex.allMatches(match[1]).forEach((RegExpMatch match) {
        if (match[1].contains(areaRegex)) {
          if (backup != null) {
            Crashlytics.instance.log('Erro antes da área: $backup');
            backup = null;
          }
          String tmpArea = match[1].replaceAll(clearTags, "").trim();
          if (config.debug) print("Área: $tmpArea");
          if (tmpArea != area) {
            area = tmpArea;
          }
        } else if (match[1].contains(numeroRegex)) {
          if (backup != null) {
            Crashlytics.instance.log('Erro antes da área: $backup');
            backup = null;
          }
          if (area != null) {
            bool erro = false;

            String numero = '';
            try {
              numero = numeroRegex
                  .firstMatch(match[1])
                  .group(1)
                  .replaceAll(clearTags, "")
                  .trim();
            } catch (exception, stackTrace) {
              Crashlytics.instance
                  .recordError(exception, stackTrace, context: match[1]);
              if (config.debug) print(exception);
            }

            String texto = '';
            try {
              texto = textoRegex
                  .firstMatch(match[1])
                  .group(1)
                  .replaceAll(clearTags, "")
                  .trim();
            } catch (exception) {
              erro = true;
              if (config.debug) print(exception);
            }

            if (erro) {
              backup = MauTempo(area, numero, texto);
            } else {
              list.add(MauTempo(area, numero, texto));
            }
          } else {
            Crashlytics.instance.log('Número sem área: ${match[1]}');
          }
        } else {
          if (config.debug) print('Não processado: ${match[1]}');
          if (backup != null) {
            String texto = match[1].replaceAll(clearTags, "").trim();
            if (texto.isNotEmpty) {
              Crashlytics.instance.log('Não processado: $texto');
              backup.texto = texto;
              list.add(backup);
              backup = null;
            }
          }
        }
      });
    });

    return list;
  }
}
