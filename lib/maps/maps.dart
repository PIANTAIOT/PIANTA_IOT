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

// Función que calcula la distancia entre dos puntos geográficos
double distanceBetween(LatLng latLng1, LatLng latLng2) {
  const double earthRadius = 6371000; // radio de la Tierra en metros

  // Convertir las coordenadas de grados a radianes
  double lat1 = latLng1.latitude * pi / 180;
  double lat2 = latLng2.latitude * pi / 180;
  double lon1 = latLng1.longitude * pi / 180;
  double lon2 = latLng2.longitude * pi / 180;

  // Calcular la diferencia en latitud y longitud
  double dLat = lat2 - lat1;
  double dLon = lon2 - lon1;

  // Aplicar la fórmula de la distancia entre dos puntos en una esfera
  double a = sin(dLat / 2) * sin(dLat / 2) +
      cos(lat1) * cos(lat2) * sin(dLon / 2) * sin(dLon / 2);
  double c = 2 * atan2(sqrt(a), sqrt(1 - a));

  // Calcular la distancia multiplicando el resultado por el radio de la Tierra
  return earthRadius * c;
}

// Token de acceso para Mapbox
const MAPBOX_ACCESS_TOKEN =
    'pk.eyJ1IjoiZGFuaWVsc2cxOCIsImEiOiJjbGZ1N3F6ZWcwNDByM2Vtamo1OTNoc3hrIn0.5dFY3xEDB7oLtMbCWDdW9A';

// Clase que representa el estado de la localización
class _LocalizationState extends State<Localization> {
  final MapController mapController = MapController();
  List<LatLng> polylineCoordinates = []; // Coordenadas de la polilínea
  bool canAddPolylines = true; // Indica si se pueden agregar polilíneas
  bool isAddingPolylines = false; // Indica si se están agregando polilíneas
  LatLng initialCoordinate = LatLng(37.42796133580664, -122.085749655962); // Coordenada inicial
  double circleRadius = 10.0; // Radio del círculo
  bool showCircle = true; // Indica si se muestra el círculo
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
                      mapController: mapController, // Controlador del mapa
                      options: MapOptions(
                        onTap: (point, latLng) { // Evento que se activa al tocar en el mapa
                          if (canAddPolylines && isAddingPolylines) { // Verifica si se pueden agregar polilíneas y si se está agregando una actualmente
                            setState(() { // Actualiza el estado del widget
                              if (polylineCoordinates.isEmpty) { // Verifica si no hay coordenadas de polilíneas existentes
                                initialCoordinate = latLng; // Establece la coordenada inicial de la polilínea
                                polylineCoordinates.add(latLng); // Agrega la coordenada inicial a las coordenadas de la polilínea
                              } else {
                                polylineCoordinates.add(latLng); // Agrega la coordenada tocada a las coordenadas de la polilínea
                                double distance = distanceBetween(latLng, initialCoordinate); // Calcula la distancia entre la coordenada tocada y la inicial
                                if (distance < circleRadius * 1) { // Verifica si la distancia es menor que el radio del círculo multiplicado por 1
                                  polylineCoordinates.add(initialCoordinate); // Agrega la coordenada inicial al final de las coordenadas de la polilínea
                                  canAddPolylines = false; // Deshabilita la adición de polilíneas
                                  isAddingPolylines = false; // Finaliza el proceso de adición de polilíneas

                                  showDialog(
                                    context: context,
                                    builder: (_) => AlertDialog(
                                      title: const Text('¿Desea guardar la ubicación?'), // Diálogo de confirmación para guardar la ubicación
                                      actions: [
                                        TextButton(
                                          child: const Text('No'),
                                          onPressed: () {
                                            setState(() {
                                              polylineCoordinates.clear(); // Borra las coordenadas de la polilínea
                                              canAddPolylines = true; // Habilita la adición de polilíneas
                                              isAddingPolylines = true; // Habilita la adición de polilíneas
                                            });
                                            Navigator.pop(context); // Cierra el diálogo
                                          },
                                        ),
                                        TextButton(
                                          child: const Text('Sí'),
                                          onPressed: () {
                                            print('Coordenadas de la polilínea:');
                                            for (var coordinate in polylineCoordinates) {
                                              print('${coordinate.latitude}, ${coordinate.longitude}'); // Imprime las coordenadas de la polilínea
                                            }
                                            Navigator.pop(context); // Cierra el diálogo
                                            Navigator.pop(context); // Navega hacia atrás dos veces
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
                          urlTemplate: 'https://api.mapbox.com/styles/v1/{id}/tiles/{z}/{x}/{y}?access_token={accessToken}', // Plantilla de URL para obtener los azulejos del mapa
                          additionalOptions: const {
                            'accessToken': MAPBOX_ACCESS_TOKEN, // Token de acceso de Mapbox
                            'id': 'mapbox/satellite-v9', // ID del estilo del mapa (satélite)
                          },
                        ),
                        MarkerLayer(
                          markers: [
                            Marker(
                              width: circleRadius * 2, // Ancho del marcador
                              height: circleRadius * 2, // Alto del marcador
                              point: initialCoordinate, // Coordenada del marcador
                              builder: (ctx) => Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle, // Forma circular
                                  color: Colors.blue.withOpacity(0.5), // Color azul semi-opaco
                                ),
                              ),
                            ),
                          ],
                        ),
                        PolylineLayer(
                          polylines: [
                            Polyline(
                              points: polylineCoordinates, // Coordenadas de la polilínea
                              strokeWidth: 4.0, // Ancho de la línea de la polilínea
                              color: Colors.blue, // Color azul
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
                                      borderRadius: BorderRadius.circular(10), // Bordes redondeados del botón
                                    ),
                                  ),
                                  child: IconButton(
                                    icon: Icon(Icons.polyline_rounded), // Icono del botón
                                    color: Colors.white, // Color blanco del icono
                                    onPressed: () {
                                      // Lógica del onPressed
                                      setState(() {
                                        canAddPolylines = true; // Habilita la adición de polilíneas
                                        isAddingPolylines = true; // Habilita la adición de polilíneas
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