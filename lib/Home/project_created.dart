import 'dart:math';
import 'package:flutter/material.dart';
import 'package:pianta/Home/proyecto.dart';

class ProjectCreated extends StatefulWidget {
  const ProjectCreated({Key? key}) : super(key: key);

  @override
  State<ProjectCreated> createState() => _ProjectCreatedState();
}

class _ProjectCreatedState extends State<ProjectCreated> {

  String _projectId = '';
  List<Widget> _cards = [];

  @override
  void initState() {
    super.initState();
    _projectId = generateRandomId();
  }

  String generateRandomId() {
    // Aquí puedes implementar la lógica para generar un ID aleatorio
    // por ejemplo, utilizando la librería 'random'
    return Random().nextInt(10000).toString();
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(width: 70),
          Expanded(
            child: Center(
              child: Card(
                elevation: 4.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(0),
                ),
                child: SizedBox(
                  width: 380,
                  height: 350,
                  child: Padding(
                    padding: const EdgeInsets.all(40.0),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: const [
                            Text(
                              'Project Created',
                              style: TextStyle(
                                fontWeight: FontWeight.normal,
                                fontSize: 15,
                              ),
                              textAlign: TextAlign.left,
                            ),
                          ],
                        ),
                        const SizedBox(height: 20.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: const [
                            Text(
                              'ID PROJECT',
                              style: TextStyle(
                                fontWeight: FontWeight.normal,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 1),
                          child: TextField(
                            keyboardType: TextInputType.text,
                            decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                borderSide:
                                BorderSide(width: 0, color: Colors.grey),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 70.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const Proyectos(),
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                  minimumSize: const Size(100, 30),
                                  backgroundColor:
                                  const Color.fromRGBO(255, 255, 255, 1)),
                              child: const Text(
                                'Cancel',
                                style: TextStyle(
                                    fontSize: 12,
                                    color: Color.fromRGBO(16, 16, 16, 1)),
                              ),
                            ),
                            const SizedBox(
                              width: 100, // Espacio de 16 píxeles entre los botones
                            ),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const Proyectos(),
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                minimumSize: const Size(100, 30),
                                backgroundColor:
                                const Color.fromRGBO(0, 191, 174, 1),
                              ),
                              child: const Text(
                                'Save',
                                style: TextStyle(
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ],
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
    );
  }
}
