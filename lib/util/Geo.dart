import 'dart:convert';

class Geo {
  static String valid(String geo) {
    RegExp polygonRegex = new RegExp(
      r"(.*)(new google.maps.Polygon\()(.*)(\))(.*)",
      caseSensitive: false,
      multiLine: true,
    );

    RegExp circleRegex = new RegExp(
      r"(.*)(new google.maps.Circle\()(.*)(\))(.*)",
      caseSensitive: false,
      multiLine: true,
    );

    RegExp markerRegex = new RegExp(
      r"(.*)(new google.maps.Marker\()(.*)(\))(.*)",
      caseSensitive: false,
      multiLine: true,
    );

//    RegExp latLngRegex = new RegExp(
//      r"(.*)(new google.maps.LatLng\()(.*),(.*)(\))(.*)",
//      caseSensitive: false,
//      multiLine: true,
//    );

    RegExp latLngRegex = new RegExp(
      r"(new google.maps.LatLng\()(\W+),(\W+)(\))",
      caseSensitive: false,
      multiLine: true,
    );

    geo.split("|").forEach((String part) {
      print('Part: $part');

      polygonRegex.allMatches(part).forEach((RegExpMatch match) {
        if (match.groupCount == 5) {
          String last = match.group(5).isEmpty ? '' : ', ${match.group(5)}';
          part = '${match.group(1)} "polygon" : ${match.group(3)}$last';
        }
      });

      circleRegex.allMatches(part).forEach((RegExpMatch match) {
//        print('Group Count: ${match.groupCount}');
//        for (int i = 0; i <= match.groupCount; i++) {
//          print('Group $i: ${match.group(i)}');
//        }

        if (match.groupCount == 5) {
          String last = match.group(5).isEmpty ? '' : ', ${match.group(5)}';
          part = '${match.group(1)} "circle" : ${match.group(3)}$last';
        }
      });

      markerRegex.allMatches(part).forEach((RegExpMatch match) {
        if (match.groupCount == 5) {
          String last = match.group(5).isEmpty ? '' : ', ${match.group(5)}';
          part = '${match.group(1)} "marker" : ${match.group(3)}$last';
        }
      });

      latLngRegex.allMatches(part).forEach((RegExpMatch match) {
        print('Group Count: ${match.groupCount}');
        for (int i = 0; i <= match.groupCount; i++) {
          print('Group $i: ${match.group(i)}');
        }

//        if (match.groupCount == 6) {
//          part = '${match.group(1)}{ "lat": ${match.group(3)}, '
//              '"lng": ${match.group(4)}} ${match.group(6)}';
//        }
      });

      part = '{${part.trim()}}';

      try {
        var map = json.decode(part);
        print('SUCESS: $map');
      } catch (e) {
        print('Processed: $part');
        print('ERROR: $e');
      }

      print('\n');
    });

    return geo;
  }
}
