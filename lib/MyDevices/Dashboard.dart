import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:http/http.dart' as http;
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:pianta/constants.dart';

import '../Funciones/constantes.dart';
import '../Graficas/TemplateNewGrafic.dart';
import '../Home/template_model.dart';



class WebDashboard extends StatefulWidget {
  const WebDashboard({Key? key}) : super(key: key);

  @override
  _WebDashboardState createState() => _WebDashboardState();
}

class _WebDashboardState extends State<WebDashboard>
    with SingleTickerProviderStateMixin {
  late List<ProjectTemplate> projects;
  late Future<List<ProjectTemplate>> futureProjects;
  ProjectTemplate? projecto;
  late AnimationController _animationController;
  late Animation<double> _animation;
  final maxProgress = 40.0;
  ProjectTemplate? project;
  @override
  void initState() {
    super.initState();
    futureProjects = fetchProjects();
    _animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 3000));
    _animation = Tween<double>(begin: 0, end: maxProgress).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    )..addListener(() {
      setState(() {

      });
    });
  }

  Future<List<ProjectTemplate>> fetchProjects() async {
    var box = await Hive.openBox(tokenBox);
    final token = box.get("token") as String?;
    final response = await http.get(
        Uri.parse('http://127.0.0.1:8000/user/template/'),
        headers: {'Authorization': 'Token $token'});
    if (response.statusCode == 200) {
      final List<dynamic> jsonList = jsonDecode(response.body);

      final List<ProjectTemplate> projects =
      jsonList.map((json) => ProjectTemplate.fromJson(json)).toList();
      setState(() {
        this.projects = projects;
        projecto = projects.first;
      });
      return projects;
    } else {
      throw Exception('Failed to load project list');
    }
  }

  bool isLoading = false;

  void duplicateCard() {
    if (projects.isNotEmpty) {
      final lastProject = projects.first;
      print(lastProject);
      final duplicatedProject = ProjectTemplate(
        id: lastProject.id + 1,
        name: lastProject.name,
        red: lastProject.red,
        sensor: lastProject.sensor,
        descripcion: lastProject.descripcion,
      );
      setState(() {
        projects = [...projects, duplicatedProject];
        project = duplicatedProject;
      });
    }
  }

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
                                  Navigator.of(
                                      context)
                                      .pop();
                                },
                                child: const Text('Info',
                                    style: const TextStyle(
                                        fontSize: 24, color: Colors.black)),
                              ),
                              TextButton(
                                onPressed: () {
                                  // Acción a realizar al presionar el botón "Dashboard"
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
                  child: Stack(
                    children: [
                      Positioned.fill(
                        bottom: 0,
                        child: Align(
                          alignment: Alignment.bottomLeft,
                          child: Card(
                            margin: const EdgeInsets.all(10),
                            elevation: 4,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                              side: BorderSide(
                                color: Colors.grey.shade300,
                                width: 1,
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 500),
                                curve: Curves.easeInOut,
                                transform: Matrix4.translationValues(
                                    0, _animationController.value * 100, 0),
                                child: Column(
                                  children: [
                                    Text(
                                      projecto?.name ?? '',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 24,
                                      ),
                                    ),
                                    Expanded(
                                      child: Row(
                                        children: [
                                          Flexible(
                                            fit: FlexFit.loose,
                                            child: Card(
                                              elevation: 4,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                BorderRadius.circular(10),
                                              ),
                                              child: InkWell(
                                                onTap: () {
                                                  duplicateCard();
                                                },
                                                child: Column(
                                                  mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                                  crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                                  children: [
                                                    CustomPaint(
                                                      foregroundPainter:
                                                      Circular_graphics(
                                                          _animation.value),
                                                      child: Container(
                                                        width: 250,
                                                        height: 150,
                                                        child: GestureDetector(
                                                          child: const Center(
                                                            child: Text(
                                                              '0 °C',
                                                              style: TextStyle(
                                                                  fontSize: 50),
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
                                          ),
                                          if (project != null) ...[
                                            const SizedBox(width: 70),
                                            Flexible(
                                              fit: FlexFit.loose,
                                              child: Card(
                                                elevation: 4,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                  BorderRadius.circular(10),
                                                ),
                                                child: InkWell(
                                                  onTap: () {
                                                    // Acción a realizar al tocar la tarjeta adicional
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) =>  TempCreateGrafics(),
                                                      ),
                                                    );
                                                  },
                                                  child: Transform.rotate(
                                                    angle: -pi /
                                                        2, // Gira la tarjeta completa -90 grados (acostada)
                                                    child: Column(
                                                      mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .center,
                                                      crossAxisAlignment:
                                                      CrossAxisAlignment
                                                          .center,
                                                      children: [
                                                        Expanded(
                                                          child: RotatedBox(
                                                            quarterTurns:
                                                            1, // Rota la gráfica 270 grados en sentido contrario a las agujas del reloj
                                                            child: CustomPaint(
                                                              foregroundPainter:
                                                              Circular_graphics(
                                                                  _animation
                                                                      .value),
                                                              child: Container(
                                                                child:
                                                                GestureDetector(
                                                                  child:
                                                                  const Center(
                                                                    child: Text(
                                                                      '0 °C',
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                          50),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        const Expanded(
                                                          child: SizedBox(
                                                            height: 250,
                                                            width: 250,
                                                            child: RotatedBox(
                                                              quarterTurns:
                                                              1, // Rota la gráfica 270 grados en sentido contrario a las agujas del reloj
                                                              child:
                                                              Linea_Graphics(),
                                                            ),
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
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

// ignore: camel_case_types
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
    // ignore: non_constant_identifier_names
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

// ignore: camel_case_types
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