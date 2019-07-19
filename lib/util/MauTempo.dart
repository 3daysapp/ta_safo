import 'package:flutter/widgets.dart';

class MauTempo {
  static void parse(String html) {
    print("Length: ${html.length}");

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

    articleRegex.allMatches(html).forEach((RegExpMatch match) {
//      debugPrint(match[1]);

      pRegex.allMatches(match[1]).forEach((RegExpMatch match) {
        debugPrint(match[1]);
        if(match[1].startsWith("<strong>")) print('Área');

      });

//      print("Group Count: ${match.groupCount}");
//
//      for (int i = 0; i <= match.groupCount; i++) {
//        print("Group $i: ${match.group(i)}");
//      }
    });
  }
}
