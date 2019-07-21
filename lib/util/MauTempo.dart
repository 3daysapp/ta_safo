///
///
///
class MauTempo {
  final String area;
  final String numero;
  final String texto;

  MauTempo(this.area, this.numero, this.texto);

  ///
  ///
  ///
  static List<MauTempo> parse(String html) {
    RegExp articleRegex = RegExp(
      r"\<article.*>[\s\S]*<div.*>(<p>[\s\S]*</p>)[\s\S]*</div.*</article>",
      caseSensitive: false,
      multiLine: true,
    );

    RegExp pRegex = RegExp(
      r"\<p>([\s\S]*?)</p>",
      caseSensitive: false,
      multiLine: true,
    );

    RegExp clearTags = RegExp(
      r"<[^>]*>",
      caseSensitive: false,
      multiLine: true,
    );

    RegExp numeroRegex = RegExp(
      r"\<u><strong>(.*?)</strong></u>",
      caseSensitive: false,
      multiLine: true,
    );

    RegExp textoRegex = RegExp(
      r"\<br />([\s\S]*)$",
      caseSensitive: false,
      multiLine: true,
    );

    List<MauTempo> list = [];

    articleRegex.allMatches(html).forEach((RegExpMatch match) {
      String area;

      pRegex.allMatches(match[1]).forEach((RegExpMatch match) {
        if (match[1].startsWith('<span style="color:#ff0000;"><strong>')) {
          String tmpArea = match[1].replaceAll(clearTags, "");
          if (tmpArea != area) {
            area = tmpArea;
          }
        } else if (match[1].startsWith("<u>")) {
          if (area != null) {
            String numero = numeroRegex
                .firstMatch(match[1])
                .group(1)
                .replaceAll(clearTags, "");

            String texto = textoRegex
                .firstMatch(match[1])
                .group(1)
                .replaceAll(clearTags, "");

            list.add(MauTempo(area, numero, texto));
          }
        }
      });
    });

    return list;
  }
}
