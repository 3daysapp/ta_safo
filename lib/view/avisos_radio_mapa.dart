import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';

///
///
///
class AvisosRadioMapa extends StatefulWidget {
  static const String routeName = '/avisos_radio_mapa';

  ///
  ///
  ///
  @override
  _AvisosRadioMapaState createState() => _AvisosRadioMapaState();
}

///
///
///
class _AvisosRadioMapaState extends State<AvisosRadioMapa> {
  ///
  ///
  ///
  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> args = ModalRoute.of(context).settings.arguments;

    return Scaffold(
      appBar: AppBar(
        title: Text(args['title']),
      ),
      body: _processBody(args['geos']),
    );
  }

  ///
  ///
  ///
  Widget _processBody(List<Map<String, dynamic>> args) {
    if (args == null || args.isEmpty) {
      // TODO : Disparar crash.
      return Center(
        child: Text('Não foram encontrados dados para exibição.'),
      );
    }

    List<Polygon> polygons = [];
    List<Polyline> polylines = [];
    List<CircleMarker> circles = [];
    List<Marker> markers = [];

    LatLng center;

    args.forEach((geo) {
      LatLng latLng;
      if (geo.containsKey('marker')) {
        Map<String, dynamic> pos = geo['marker']['position'];
        latLng = LatLng(pos['lat'], pos['lng']);
        markers.add(
          Marker(
            point: latLng,
            builder: (ctx) => Container(
              child: Icon(
                Icons.place,
                color: Colors.red,
              ),
            ),
          ),
        );
      } else if (geo.containsKey('polygon')) {
        List paths = geo['polygon']['paths'];
        List<LatLng> points = _getLatLngList(paths);
        polygons.add(
          Polygon(
            points: points,
            color: Colors.red,
          ),
        );
        latLng = points.first;
      } else if (geo.containsKey('polyline')) {
        List paths = geo['polyline']['path'];
        List<LatLng> points = _getLatLngList(paths);
        polylines.add(
          Polyline(
            points: points,
            strokeWidth: 4.0,
            color: Colors.red,
          ),
        );
        latLng = points.first;
      } else if (geo.containsKey('circle')) {
        var circle = geo['circle'];
        circles.add(
          CircleMarker(
            point: LatLng(
              circle['center']['lat'],
              circle['center']['lng'],
            ),
            color: Colors.transparent,
            radius: circle['radius'],
            useRadiusInMeter: true,
            borderColor: Colors.red,
            borderStrokeWidth: 2.0,
          ),
        );
      } else {
        // TODO : Disparar crash.
      }
      center = latLng;
    });

    if (polygons.isEmpty &&
        polylines.isEmpty &&
        circles.isEmpty &&
        markers.isEmpty) {
      // TODO : Disparar crash.
      return Center(
        child: Text('Não foram encontradas geometrias para exibição.'),
      );
    }

    List<LayerOptions> layers = [];

    // layers.add(TileLayerOptions(
    //   urlTemplate: 'https://api.tiles.mapbox.com/v4/'
    //       '{id}/{z}/{x}/{y}@2x.png?access_token={accessToken}',
    //   additionalOptions: {
    //     'accessToken': Secrets.mapboxToken,
    //     'id': 'mapbox.streets',
    //   },
    // ));

    layers.add(TileLayerOptions(
      urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
      subdomains: ['a', 'b', 'c'],
    ));

    if (polygons.isNotEmpty) {
      layers.add(
        PolygonLayerOptions(
          polygons: polygons,
        ),
      );
    }

    if (polylines.isNotEmpty) {
      layers.add(
        PolylineLayerOptions(
          polylines: polylines,
        ),
      );
    }

    if (circles.isNotEmpty) {
      layers.add(
        CircleLayerOptions(
          circles: circles,
        ),
      );
    }

    if (markers.isNotEmpty) {
      layers.add(
        MarkerLayerOptions(
          markers: markers,
        ),
      );
    }

    return FlutterMap(
      options: MapOptions(
        center: center ?? LatLng(0, 0),
        zoom: 10.0,
      ),
      layers: layers,
    );
  }

  ///
  ///
  ///
  List<LatLng> _getLatLngList(List items) {
    List<LatLng> list = [];
    items.forEach((item) => list.add(LatLng(item['lat'], item['lng'])));
    return list;
  }
}
