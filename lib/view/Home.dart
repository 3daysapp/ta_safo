import 'package:flutter/material.dart';
import 'package:ta_safo/util/Geo.dart';
import 'package:ta_safo/view/AvisosRadio.dart';

///
///
///
class Home extends StatefulWidget {
  static const String routeName = '/home';

  @override
  _HomeState createState() => _HomeState();
}

///
///
///
class _HomeState extends State<Home> {
  List<Map<String, String>> buttons;
  List<Map<String, String>> links;

  @override
  void initState() {
    super.initState();

    buttons = [
      // https://www.marinha.mil.br/chm/sites/www.marinha.mil.br.chm/files/opt/avradio.json
      {
        'label': 'Avisos-Rádio\nNáuticos e SAR',
        'route': AvisosRadio.routeName,
      },
      // https://www.marinha.mil.br/chm/dados-do-segnav-aviso-aos-navegantes-tela/avisos-aos-navegantes
//    {
//      'label': 'Avisos aos\nNavegantes',
//      'route': AvisosRadio.routeName,
//    },
      // https://www.marinha.mil.br/chm/dados-do-smm-avisos-de-mau-tempo/avisos-de-mau-tempo
//    {
//      'label': 'Avisos de\nMau Tempo',
//      'route': AvisosRadio.routeName,
//    },
    ];

    links = [
      {
        'label': 'MB',
        'url': 'https://www.marinha.mil.br/',
      },
      {
        'label': 'DNH',
        'url': 'https://www.marinha.mil.br/dhn/',
      },
      {
        'label': 'CHM',
        'url': 'https://www.marinha.mil.br/chm/',
      }
    ];
  }

  ///
  ///
  ///
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tá Safo'),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.bug_report), onPressed: _testGeo)
        ],
      ),
      drawer: Drawer(
        child: Text('Drawer'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.count(
          crossAxisCount: 2, // TODO - Responsividade através do MediaQuery
          children: buttons
              .map(
                (button) => Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black54, width: 1.0),
                      borderRadius: BorderRadius.all(
                        Radius.circular(8),
                      ),
                    ),
                    child: FlatButton(
                      splashColor: Colors.green,
                      onPressed: () =>
                          Navigator.of(context).pushNamed(button['route']),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 12.0),
                            child: SizedBox(
                              width: double.infinity,
                              child: Text(
                                button['label'],
                                textAlign: TextAlign.end,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              )
              .toList(),
        ),
      ),
    );
  }

  void _testGeo() {
    // new google.maps.Marker({"position": new google.maps.LatLng(-20.703,-40.406666666666666)})
    // new google.maps.Polygon({"paths": [new google.maps.LatLng(5.6,-48.36666666666667), new google.maps.LatLng(5.633333333333333,-47.38333333333333), new google.maps.LatLng(5.1,-47.36666666666667), new google.maps.LatLng(5.083333333333333,-48.35)]})|new google.maps.Polygon({"paths": [new google.maps.LatLng(5.433333333333334,-47.11666666666667), new google.maps.LatLng(5.433333333333334,-45.36666666666667), new google.maps.LatLng(5.166666666666667,-45.36666666666667), new google.maps.LatLng(5.166666666666667,-47.11666666666667)]})
    // new google.maps.Circle({"center": new google.maps.LatLng(-0.5898333333333333,-47.92466666666667), "radius": 37.04})|new google.maps.Marker({"position": new google.maps.LatLng(-0.5898333333333333,-47.92466666666667)})
    // new google.maps.Polyline({"geodesic": true, "path": [new google.maps.LatLng(-3.6708333333333334,-38.4825), new google.maps.LatLng(-3.671666666666667,-38.492666666666665), new google.maps.LatLng(-3.711333333333333,-38.49433333333333), new google.maps.LatLng(-3.7003333333333335,-38.48983333333334), new google.maps.LatLng(-3.7068333333333334,-38.482166666666664)]})

    String geo =
        'new google.maps.Polygon({"paths": [new google.maps.LatLng(5.6,-48.36666666666667), new google.maps.LatLng(5.633333333333333,-47.38333333333333), new google.maps.LatLng(5.1,-47.36666666666667), new google.maps.LatLng(5.083333333333333,-48.35)]})|new google.maps.Polygon({"paths": [new google.maps.LatLng(5.433333333333334,-47.11666666666667), new google.maps.LatLng(5.433333333333334,-45.36666666666667), new google.maps.LatLng(5.166666666666667,-45.36666666666667), new google.maps.LatLng(5.166666666666667,-47.11666666666667)]})';

    Geo.valid(geo);
  }
}
