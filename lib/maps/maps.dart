import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'dart:math';

import '../Funciones/constantes.dart';
import '../Home/new_project.dart';

class Localization extends StatefulWidget {
  const Localization({Key? key}) : super(key: key);

  @override
  State<Localization> createState() => _LocalizationState();
}

double distanceBetween(LatLng latLng1, LatLng latLng2) {
  const double earthRadius = 6371000; // meters
  double lat1 = latLng1.latitude * pi / 180;
  double lat2 = latLng2.latitude * pi / 180;
  double lon1 = latLng1.longitude * pi / 180;
  double lon2 = latLng2.longitude * pi / 180;
  double dLat = lat2 - lat1;
  double dLon = lon2 - lon1;
  double a = sin(dLat / 2) * sin(dLat / 2) +
      cos(lat1) * cos(lat2) * sin(dLon / 2) * sin(dLon / 2);
  double c = 2 * atan2(sqrt(a), sqrt(1 - a));
  return earthRadius * c;
}

const MAPBOX_ACCESS_TOKEN =
    'pk.eyJ1IjoiZGFuaWVsc2cxOCIsImEiOiJjbGZ1N3F6ZWcwNDByM2Vtamo1OTNoc3hrIn0.5dFY3xEDB7oLtMbCWDdW9A';

class _LocalizationState extends State<Localization> {
  final MapController mapController = MapController();
  List<LatLng> polylineCoordinates = [];
  bool canAddPolylines = true;
  bool isAddingPolylines = false;
  LatLng initialCoordinate = LatLng(37.42796133580664, -122.085749655962);
  double circleRadius = 10.0;
  bool showCircle = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //se tomara una columna Para el resto de la pantalla a parte de la navbar llamada en (Home)
        body: Row(
          children: [
            const SizedBox(
              width: 100,
              child: Navigation(title: 'nav', selectedIndex: 0),
            ),
            Expanded(
                child: Column(children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Text(
                          'Location',
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
                        ),
                      ), //fin modulo
                      const SizedBox(height: 35),
                      IconButton(
                          onPressed: () {
                            Navigator.pop(
                                context, 'Valor enviado a la página anterior');
                          },
                          icon: const Icon(Icons.exit_to_app))
                    ],
                  ),
                  const Divider(
                    color: Colors.black26, //color of divider
                    height: 2, //height spacing of divider
                    thickness: 1, //thickness of divier line
                    indent: 15, //spacing at the start of divider
                    endIndent: 0, //spacing at the end of divider
                  ),
                  Expanded(
                    child: FlutterMap(
                      mapController: mapController,
                      options: MapOptions(
                        onTap: (point, latLng) {
                          if (canAddPolylines && isAddingPolylines) {
                            setState(() {
                              if (polylineCoordinates.isEmpty) {
                                initialCoordinate = latLng;
                                polylineCoordinates.add(latLng);
                              } else {
                                polylineCoordinates.add(latLng);
                                double distance =
                                distanceBetween(latLng, initialCoordinate);
                                if (distance < circleRadius * 1) {
                                  polylineCoordinates.add(initialCoordinate);
                                  canAddPolylines = false;
                                  isAddingPolylines = false;

                                  showDialog(
                                    context: context,
                                    builder: (_) => AlertDialog(
                                      title: const Text('¿Desea guardar la ubicación?'),
                                      actions: [
                                        TextButton(
                                          child: const Text('No'),
                                          onPressed: () {
                                            setState(() {
                                              polylineCoordinates.clear();
                                              canAddPolylines = true;
                                              isAddingPolylines = true;
                                            });
                                            Navigator.pop(context);
                                          },
                                        ),
                                        TextButton(
                                          child: const Text('Sí'),
                                          onPressed: () {
                                            print('Coordenadas de la polilínea:');
                                            for (var coordinate
                                            in polylineCoordinates) {
                                              print(
                                                  '${coordinate.latitude}, ${coordinate.longitude}');
                                            }
                                            Navigator.pop(context);
                                            Navigator.pop(context);
                                          },
                                        ),
                                      ],
                                    ),
                                  );
                                }
                              }
                            });
                          }
                        },
                      ),
                      nonRotatedChildren: [
                        TileLayer(
                          urlTemplate:
                          'https://api.mapbox.com/styles/v1/{id}/tiles/{z}/{x}/{y}?access_token={accessToken}',
                          additionalOptions: const {
                            'accessToken': MAPBOX_ACCESS_TOKEN,
                            'id': 'mapbox/satellite-v9'
                          },
                        ),
                        MarkerLayer(
                          markers: [
                            Marker(
                              width: circleRadius * 2,
                              height: circleRadius * 2,
                              point: initialCoordinate,
                              builder: (ctx) => Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.blue.withOpacity(0.5),
                                ),
                              ),
                            ),
                          ],
                        ),
                        PolylineLayer(
                          polylines: [
                            Polyline(
                              points: polylineCoordinates,
                              strokeWidth: 4.0,
                              color: Colors.blue,
                            ),
                          ],
                        ),
                        Align(
                          alignment: Alignment.bottomLeft,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                color: Color.fromARGB(255, 58, 57, 57),
                                child: Ink(
                                  decoration: ShapeDecoration(
                                    color: Colors.transparent,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  child: IconButton(
                                    icon: Icon(Icons.polyline_rounded),
                                    color: Colors.white,
                                    onPressed: () {
                                      // OnPressed Logic
                                      setState(() {
                                        canAddPolylines = true;
                                        isAddingPolylines = true;
                                      });
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ]))
          ],
        ));
  }
}