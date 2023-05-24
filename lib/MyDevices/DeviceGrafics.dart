import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:http/http.dart' as http;
import 'dart:math';

import '../Funciones/constantes.dart';

// ignore: camel_case_types
//grafica circular

import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

class SensorData {
  final String name; // Nombre del sensor
  final DateTime createdAt; // Fecha de creación
  final double v12; // Valor del sensor v12

  SensorData({
    required this.name,
    required this.createdAt,
    required this.v12,
  });

  // Método de fábrica para crear una instancia de SensorData a partir de un mapa JSON
  factory SensorData.fromJson(Map<String, dynamic> json) {
    return SensorData(
      name: json['name'],
      createdAt: DateTime.parse(json['created_at']),
      v12: json['v12'],
    );
  }
}

class Device {
  int id; // ID del dispositivo
  final String name; // Nombre del dispositivo
  final String location; // Ubicación del dispositivo

  Device({
    required this.id,
    required this.name,
    required this.location,
  });

  // Método de fábrica para crear una instancia de Device a partir de un mapa JSON
  factory Device.fromJson(Map<String, dynamic> json) {
    return Device(
      id: json['id'],
      name: json['name'],
      location: json['location'],
    );
  }
}

List<Device> devices = <Device>[]; // Lista de dispositivos
List<SensorData> device = []; // Lista de datos de sensores

class DeviceGrafics extends StatefulWidget {
  const DeviceGrafics({super.key});

  @override
  State<DeviceGrafics> createState() => _DeviceGraficsState();
}

class _DeviceGraficsState extends State<DeviceGrafics>
    with SingleTickerProviderStateMixin {
  Device? selectedDevices; // Dispositivo seleccionado
  bool isLoading = false; // Indicador de carga
  late AnimationController _animationController; // Controlador de animación
  late Animation<double> _animation; // Animación de progreso
  final maxProgress = 100.0; // Progreso máximo
  double v12 = 0.0; // Valor del sensor v12
  SensorData? selectedDevice; // Sensor seleccionado
  Map<String, dynamic>? apiData; // Datos de la API
  late Future<List<
      SensorData>> _fetchDevicesFuture; // Futuro de la lista de datos de sensores

  Future<void> _fetchData() async {
    try {
      final response = await http.get(
          Uri.parse('http://127.0.0.1:8000/user/datos-sensores/v12/'));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          apiData = data;
        });
      } else {
        // Manejar el error
      }
    } catch (e) {
      // Manejar el error
    }
  }

  void handleDeviceSelection(Device device) {
    setState(() {
      selectedDevices = device;
    });
  }

  Future<List<SensorData>> fetchDevices() async {
    final response = await http.get(
        Uri.parse('http://127.0.0.1:8000/user/datos-sensores/v12/'));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List<SensorData> devices = [];
      for (var item in data) {
        devices.add(SensorData.fromJson(item));
      }
      setState(() {
        device = devices;
        selectedDevice = devices.isNotEmpty ? devices[0] : null;
      });
      return devices;
    } else {
      throw Exception('Failed to load devices');
    }
  }

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3000),
    );
    _animation =
    Tween<double>(begin: 0, end: maxProgress).animate(_animationController)
      ..addListener(() {
        setState(() {});
      });
    _fetchData();
    _fetchDevicesFuture = fetchDevices();
    super.initState();

    // Programamos la actualización cada 5 segundos
    Timer.periodic(const Duration(seconds: 5), (timer) {
      setState(() {
        _fetchDevicesFuture = fetchDevices();
      });
    });
  }

  @override
  void dispose() {
    // Cancelamos el timer cuando se destruye el widget
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final lastData = device.isNotEmpty ? device.last : null;
// La variable 'lastData' se inicializa con el último elemento de la lista 'device', si no está vacía. De lo contrario, se establece en null.

    return SafeArea(
      child: Scaffold(
        body: Container(
          child: Row(children: [
            const SizedBox(
              width: 100,
              child: Navigation(title: 'nav', selectedIndex: 0),
            ),
            Expanded(
              child: Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Text(
                          'Graphics',
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 30),
                        ),
                      ), // Fin del módulo
                      SizedBox(height: 35),
                    ],
                  ),
                  const Divider(
                    color: Colors.black26,
                    height: 2,
                    thickness: 1,
                    indent: 15,
                    endIndent: 0,
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          const ListTile(
                            leading: Icon(Icons.person_2_outlined, size: 100),
                          ),
                          Text(
                            selectedDevice != null
                                ? selectedDevice!.name
                                : 'No device selected',
                            style: TextStyle(fontSize: 40),
                          ),
                          SizedBox(
                            height: 400,
                            width: 950,
                            child: Card(
                              elevation: 4,
                              child: Container(
                                padding: EdgeInsets.all(16.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment
                                      .spaceEvenly,
                                  children: [
                                    CustomPaint(
                                      painter: CircularGraphicsPainter(
                                          lastData?.v12 ?? 0.0),
                                      // Utiliza el painter personalizado 'CircularGraphicsPainter' para dibujar un gráfico circular.
                                      // El valor de 'currentProgress' se toma de 'lastData.v12' si 'lastData' no es nulo, de lo contrario, se establece en 0.0.
                                      child: SizedBox(
                                        child: GestureDetector(
                                          onTap: () {
                                            if (_animationController.value ==
                                                maxProgress) {
                                              _animationController.reverse();
                                            } else {
                                              _animationController.forward();
                                            }
                                          },
                                          child: Center(
                                            child: lastData == null
                                                ? const Text(
                                                'No data available')
                                                : Text(
                                              '${lastData.v12} °C',
                                              style: const TextStyle(
                                                  fontSize: 50),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 300.0,
                                      width: 300.0,
                                      child: Linea_Graphics(),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ]),
        ),
      ),
    );
  }
}

class CircularGraphicsPainter extends CustomPainter {
  final double currentProgress;

  CircularGraphicsPainter(this.currentProgress);

  @override
  void paint(Canvas canvas, Size size) {
    Paint circle = Paint()
      ..strokeWidth = 5
      ..color = Colors.black
      ..style = PaintingStyle.stroke;

    Offset center = Offset(
      size.width / 2,
      size.height / 2,
    );
    double radius = 150;
    canvas.drawCircle(center, radius, circle);

    Paint animationArc = Paint()
      ..strokeWidth = 5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    if (currentProgress > 30) {
      animationArc.color = Colors.red;
    } else if (currentProgress > 27) {
      animationArc.color = Colors.orange;
    } else if (currentProgress > 20) {
      animationArc.color = Colors.yellow;
    } else {
      animationArc.color = Colors.blue;
    }

    double angle = 2 * pi * (currentProgress / 100);
    canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        pi / 2,
        angle,
        false,
        animationArc);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

//grafica dias. lineal
class Linea_Graphics extends StatelessWidget {
  const Linea_Graphics({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // FutureBuilder se utiliza para construir el widget en función de un Future que devuelve los datos del sensor.
    return FutureBuilder<List<SensorData>>(
      future: fetchSensorData(), // Llama a la función fetchSensorData() para obtener los datos del sensor.
      builder: (context, snapshot) { // El builder se ejecuta cuando el Future ha sido completado.
        if (snapshot.hasData) { // Comprueba si el Future ha devuelto datos.
          final data = snapshot.data!; // Obtiene los datos del sensor del Future.
          final series = [
            charts.Series(
              id: 'Sensor Data',
              data: data, // Establece los datos del sensor en el gráfico.
              domainFn: (SensorData sensorData, _) => sensorData.createdAt, // Función para obtener los valores del eje x (dominio).
              measureFn: (SensorData sensorData, _) => sensorData.v12, // Función para obtener los valores del eje y (medida).
              colorFn: (_,__) => charts.MaterialPalette.blue.shadeDefault, // Función para establecer el color de la serie en azul.
              labelAccessorFn: (SensorData sensorData, _) =>
              '${sensorData.createdAt}: ${sensorData.v12}', // Función para mostrar etiquetas en el gráfico.
            ),
          ];
          final chart = charts.TimeSeriesChart(
            series, // Establece las series de datos en el gráfico.
            animate: true, // Habilita la animación del gráfico.
          );
          return Padding(
            padding: const EdgeInsets.all(10.0),
            child: chart, // Muestra el gráfico envuelto en un widget de relleno.
          );
        } else if (snapshot.hasError) { // Comprueba si el Future ha devuelto un error.
          return Text('${snapshot.error}'); // Muestra el error en forma de texto.
        }
        return const CircularProgressIndicator(); // Muestra un indicador de progreso circular mientras se espera la carga de datos.
      },
    );
  }
}

Future<List<SensorData>> fetchSensorData() async {
  // Realiza una solicitud HTTP para obtener los datos del sensor.
  final response = await http
      .get(Uri.parse('http://127.0.0.1:8000/user/datos-sensores/v12/'));
  if (response.statusCode == 200) { // Comprueba si la solicitud HTTP fue exitosa.
    final jsonData = json.decode(response.body); // Decodifica la respuesta JSON obtenida.
    final sensorDataList =
    List<SensorData>.from(jsonData.map((x) => SensorData.fromJson(x))); // Convierte los datos JSON en una lista de objetos SensorData.
    return sensorDataList; // Devuelve la lista de datos del sensor.
  } else {
    throw Exception('Failed to load sensor data'); // Lanza una excepción si la solicitud HTTP falla.
  }
}
