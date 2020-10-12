import 'dart:convert';

///
///
///
class Geo {
  static List<Map<String, dynamic>> parse(String geo) {
    RegExp polygonRegex = RegExp(
      r'new google.maps.Polygon\((.*)\)',
      caseSensitive: false,
      multiLine: true,
    );

    RegExp polylineRegex = RegExp(
      r'new google.maps.Polyline\((.*)\)',
      caseSensitive: false,
      multiLine: true,
    );

    RegExp circleRegex = RegExp(
      r'new google.maps.Circle\((.*)\)',
      caseSensitive: false,
      multiLine: true,
    );

    RegExp markerRegex = RegExp(
      r'new google.maps.Marker\((.*)\)',
      caseSensitive: false,
      multiLine: true,
    );

    RegExp latLngRegex = RegExp(
      r'new google.maps.LatLng\(([0-9\.-]*),([0-9\.-]*)\)',
      caseSensitive: false,
      multiLine: true,
    );

    List<Map<String, dynamic>> list = [];

    geo.split('|').forEach((String part) {
      part = part.replaceAllMapped(
        polygonRegex,
        (Match match) => '"polygon" : ${match[1]}',
      );

      part = part.replaceAllMapped(
        polylineRegex,
        (Match match) => '"polyline" : ${match[1]}',
      );

      part = part.replaceAllMapped(
        circleRegex,
        (Match match) => '"circle" : ${match[1]}',
      );

      part = part.replaceAllMapped(
        markerRegex,
        (Match match) => '"marker" : ${match[1]}',
      );

      part = part.replaceAllMapped(
        latLngRegex,
        (Match match) => '{ "lat" : ${match[1]}, "lng" : ${match[2]}}',
      );

      part = '{${part.trim()}}';

      list.add(json.decode(part));
    });

    return list;
  }
}
