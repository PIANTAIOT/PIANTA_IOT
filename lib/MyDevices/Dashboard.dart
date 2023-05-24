/*import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../Funciones/constantes.dart';
import '../Graficas/TemplateNewGrafic.dart';
class Project {
  int id;
  final String name;
  final String sensor;
  final String red;
  final String descripcion;
  Project({
    required this.id,
    required this.name,
    required this.red,
    required this.sensor,
    required this.descripcion,
  });
  factory Project.fromJson(Map<String, dynamic> json) {
    return Project(
      id: json['id'],
      name: json['name'],
      red: json['red'],
      sensor: json['sensor'],
      descripcion: json['descripcion'],
    );
  }
}
List<Project> projects = <Project>[];
class WebDashboard extends StatefulWidget {
  const WebDashboard({Key? key}) : super(key: key);
  @override
  State<WebDashboard> createState() => _WebDashboardState();
}
class _WebDashboardState extends State<WebDashboard> {
  late List<Project> projects;
  late Future<List<Project>> futureProjects;
  Project? project;
  @override
  void initState() {
    super.initState();
    futureProjects = fetchProjects();
    _animationController = AnimationController(
        vsync: this, duration: Duration(milliseconds: 3000));
    _animation =
    Tween<double>(begin: 0, end: maxProgress).animate(_animationController)
      ..addListener(() {
        setState(() {});
      });
  }
  Future<List<Project>> fetchProjects() async {
    final response =
        await http.get(Uri.parse('http://127.0.0.1:8000/user/template/'));
    if (response.statusCode == 200) {
      final List<dynamic> jsonList = jsonDecode(response.body);
      final List<Project> projects =
          jsonList.map((json) => Project.fromJson(json)).toList();
      setState(() {
        this.projects = projects;
        project = projects.first;
      });
      return projects;
    } else {
      throw Exception('Failed to load project list');
    }
  }
  bool isLoading = false;
  //final FirebaseDatabase _database = FirebaseDatabase.instance;
  late AnimationController _animationController;
  late Animation<double> _animation;
  final maxProgress = 40.0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          const SizedBox(
            width: 100,
            child: Navigation(
              title: 'nav',
              selectedIndex: 1,
            ),
          ),
          Expanded(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            project?.name ?? '',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 24,
                            ),
                          ),
                          Row(
                            children: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: const Text('Info',
                                    style: const TextStyle(
                                        fontSize: 24, color: Colors.black)),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const WebDashboard(),
                                    ),
                                  );
                                },
                                child: const Text(
                                  'Web Dashboard',
                                  style: const TextStyle(
                                      fontSize: 24, color: Colors.black),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const TempCreateGrafics(),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        primary: const Color.fromRGBO(0, 191, 174, 1),
                      ),
                      child: const Text('Create Grafics'),
                    ),
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
                  child: Card(
                    margin: const EdgeInsets.all(16),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          const ListTile(
                            leading: Icon(Icons.person_2_outlined, size: 100),
                            title: Text('Device Name', style: TextStyle(fontSize: 40)),
                          ),
                          SizedBox(height: 16),
                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                CustomPaint(
                                  foregroundPainter: Circular_graphics(_animation.value),
                                  child: Container(
                                    width: 300,
                                    height: 300,
                                    child: GestureDetector(
                                      onTap: () {
                                        if (_animationController.value == maxProgress) {
                                          _animationController.reverse();
                                        } else {
                                          _animationController.forward();
                                        }
                                      },
                                      child: Center(
                                        child: Text(
                                          '${_animation.value.toInt()} °C',
                                          style: TextStyle(fontSize: 50),
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
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
class Circular_graphics extends CustomPainter {
  final strokeCircle = 13.0;
  double currentProgress;
  Circular_graphics(this.currentProgress);
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
    Paint AnimationArc = Paint()
      ..strokeWidth = 5
      ..color = Colors.purpleAccent
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    double angle = 2 * pi * (currentProgress / 100);
    canvas.drawArc(Rect.fromCircle(center: center, radius: radius), pi / 2,
        angle, false, AnimationArc);
  }
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
//grafica dias. lineal
class Linea_Graphics extends StatelessWidget {
  const Linea_Graphics({super.key});
  @override
  Widget build(BuildContext context) {
    final data = [
      Expenses(2, 120),
      Expenses(3, 220),
      Expenses(4, 219),
      Expenses(5, 154
      ),
      Expenses(6, 310),
      Expenses(7, 290),
      Expenses(8, 390),
    ];
    final series = [
      charts.Series(
        id: 'Expenses',
        data: data,
        domainFn: (Expenses expenses, _) => expenses.day,
        measureFn: (Expenses expenses, _) => expenses.amount,
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        labelAccessorFn: (Expenses expenses, _) => '${expenses.day}: \$${expenses.amount}',
      ),
    ];
    final chart = charts.LineChart(
      series,
      animate: true,
    );
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: chart,
    );
  }
}
class Expenses {
  final int day;
  final int amount;
  Expenses(this.day, this.amount);
}
 */
import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:charts_flutter/flutter.dart' as charts;

import '../Funciones/constantes.dart';
import '../Graficas/TemplateNewGrafic.dart';

class Project {
  int id; // Identificador del proyecto
  final String name; // Nombre del proyecto (requerido)
  final String sensor; // Tipo de sensor del proyecto (requerido)
  final String red; // Red asociada al proyecto (requerido)
  final String descripcion; // Descripción del proyecto (requerido)

  Project({
    required this.id,
    required this.name,
    required this.red,
    required this.sensor,
    required this.descripcion,
  });

  factory Project.fromJson(Map<String, dynamic> json) {
    // Método de fábrica para crear una instancia de Project desde un mapa JSON
    return Project(
      id: json['id'],
      name: json['name'],
      red: json['red'],
      sensor: json['sensor'],
      descripcion: json['descripcion'],
    );
  }
}

List<Project> projects = <Project>[]; // Lista de proyectos vacía

class WebDashboard extends StatefulWidget {
  const WebDashboard({Key? key}) : super(key: key);

  @override
  State<WebDashboard> createState() => _WebDashboardState();
}

class _WebDashboardState extends State<WebDashboard>
    with SingleTickerProviderStateMixin {
  late List<Project> projects; // Lista de proyectos (se asignará más adelante)
  late Future<List<Project>> futureProjects; // Futuro que devuelve la lista de proyectos
  Project? project; // Proyecto seleccionado actualmente
  late AnimationController _animationController; // Controlador de animación
  late Animation<double> _animation; // Animación de progreso
  final maxProgress = 40.0; // Valor máximo de progreso

  @override
  void initState() {
    super.initState();
    futureProjects = fetchProjects(); // Inicializa el futuro de la lista de proyectos
    _animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 3000)); // Inicializa el controlador de animación
    _animation = Tween<double>(begin: 0, end: maxProgress).animate(
        CurvedAnimation(parent: _animationController, curve: Curves.easeOut)) // Crea una animación que va desde 0 hasta maxProgress
      ..addListener(() {
        setState(() {});
      });
  }

  Future<List<Project>> fetchProjects() async {
    final response =
    await http.get(Uri.parse('http://127.0.0.1:8000/user/template/')); // Realiza una solicitud HTTP para obtener la lista de proyectos
    if (response.statusCode == 200) {
      final List<dynamic> jsonList = jsonDecode(response.body); // Decodifica la respuesta JSON
      final List<Project> projects =
      jsonList.map((json) => Project.fromJson(json)).toList(); // Crea una lista de proyectos a partir del JSON
      setState(() {
        this.projects = projects; // Actualiza la lista de proyectos
        project = projects.first; // Establece el primer proyecto como proyecto actual
      });
      return projects;
    } else {
      throw Exception('Failed to load project list'); // Lanza una excepción si falla la carga de la lista de proyectos
    }
  }

  bool isLoading = false; // Variable que indica si se está cargando la lista de proyectos

  //final FirebaseDatabase _database = FirebaseDatabase.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          const SizedBox(
            width: 100,
            child: Navigation(
              title: 'nav',
              selectedIndex: 1,
            ),
          ),
          Expanded(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            project?.name ?? '', // Muestra el nombre del proyecto actual o una cadena vacía si no hay proyecto
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 24,
                            ),
                          ),
                          Row(
                            children: [
                              TextButton(
                                onPressed: () {
                                  // Acción a realizar al presionar el botón "Info"
                                },
                                child: const Text(
                                  'Info',
                                  style: const TextStyle(fontSize: 24, color: Colors.black),
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  // Acción a realizar al presionar el botón "Dashboard"
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const WebDashboard(),
                                    ),
                                  );
                                },
                                child: const Text(
                                  'Web Dashboard',
                                  style: const TextStyle(fontSize: 24, color: Colors.black),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const TempCreateGrafics(),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        primary: const Color.fromRGBO(0, 191, 174, 1),
                      ),
                      child: const Text('Create Grafics'),
                    ),
                  ],
                ),

                const Divider(
                  color: Colors.black26,
                  // Color del divisor
                  height: 2,
                  // Espacio de altura del divisor
                  thickness: 1,
                  // Grosor de la línea del divisor
                  indent: 15,
                  // Espacio al inicio del divisor
                  endIndent: 0, // Espacio al final del divisor
                ),
                Expanded(
                  child: Card(
                    margin: const EdgeInsets.all(16),
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                      side: BorderSide(
                        color: Colors.grey.shade300,
                        width: 1,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          Card(
                            elevation: 3,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: InkWell(
                              onTap: () {
                                // Acción al presionar el "botón"
                              },
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  CustomPaint(
                                    foregroundPainter:
                                    Circular_graphics(_animation.value),
                                    child: Container(
                                      width: 300,
                                      height: 300,
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
                                          child: Text(
                                            '${_animation.value.toInt()} °C',
                                            style: TextStyle(fontSize: 50),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 200,
                                    width: 200,
                                    child: Linea_Graphics(),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}


class Circular_graphics extends CustomPainter {
  final strokeCircle = 5.0;
  double currentProgress;

  Circular_graphics(this.currentProgress);
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
    double radius = 100;
    canvas.drawCircle(center, radius, circle);
    Paint AnimationArc = Paint()
      ..strokeWidth = 5
      ..color = Colors.purpleAccent
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    double angle = 2 * pi * (currentProgress / 100);
    canvas.drawArc(Rect.fromCircle(center: center, radius: radius), pi / 2,
        angle, false, AnimationArc);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class Linea_Graphics extends StatelessWidget {
  const Linea_Graphics({super.key});

  @override
  Widget build(BuildContext context) {
    final data = [
      Expenses(2, 120),
      Expenses(3, 220),
      Expenses(4, 219),
      Expenses(5, 154),
      Expenses(6, 310),
      Expenses(7, 290),
      Expenses(8, 390),
    ];
    final series = [
      charts.Series(
        id: 'Expenses',
        data: data,
        domainFn: (Expenses expenses, _) => expenses.day,
        measureFn: (Expenses expenses, _) => expenses.amount,
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        labelAccessorFn: (Expenses expenses, _) =>
        '${expenses.day}: \$${expenses.amount}',
      ),
    ];

    final chart = charts.LineChart(
      series,
      animate: true,
    );

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: chart,
    );
  }
}

class Expenses {
  final int day;
  final int amount;

  Expenses(this.day, this.amount);
}