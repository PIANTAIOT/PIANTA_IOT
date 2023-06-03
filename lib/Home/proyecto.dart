import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/adapters.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:pianta/Funciones/constantes.dart';
import 'package:pianta/MyDevices/My_Devices.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants.dart';
import 'new_project.dart';
import 'package:uuid/uuid.dart';
import 'package:pianta/Home/model_proyect.dart';

import 'open_project.dart';
//el Project es lo que esta en la api


class Proyectos extends StatefulWidget {
  const Proyectos({Key? key}) : super(key: key);

  @override
  State<Proyectos> createState() => _ProyectosState();
}

class _ProyectosState extends State<Proyectos> {
  final project = projects = [];
  late Future<List<Project>> futureProjects;
  final projectListKey = GlobalKey<_ProyectosState>();
  late String idrandomValue;

  @override
  void initState() {
    super.initState();
    futureProjects = fetchProjects();
    idrandomValue = "1";
  }


//esta Future es para eliminar el projecto por medio del id
  Future<void> deleteProject(int projectId) async {
    var box = await Hive.openBox(tokenBox);
    final token = box.get("token") as String?;
    final response = await http.delete(
      Uri.parse('http://127.0.0.1:8000/user/project/$projectId/'),
      headers: {'Authorization': 'Token $token'},
    );
    if (response.statusCode == 200) {
      print('Project deleted successfully');
      await refreshProjects();
    } else {
      throw Exception('Failed to delete project');
    }
  }
/*
  void createNewCard(String idrandom) async {
    var box = await Hive.openBox(tokenBox);
    final token = box.get("token") as String?;
    // 1. Obtener el proyecto específico usando el `idrandom`.
    final response = await http.get(
      Uri.parse('http://127.0.0.1:8000/user/project/$idrandom/'),
      headers: {'Authorization': 'Token $token'},
    );
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body)[0];
      final project = Project.fromJson(json);

      // 2. Crear una nueva instancia de `Project` con los mismos valores del proyecto obtenido anteriormente.
      final newProject = Project(
        id: project.id,
        idrandom: project.idrandom,
        name: project.name,
        description: project.description,
      );

      // 3. Agregar la nueva instancia de `Project` a la lista de proyectos existente.
      setState(()  {
        projects.add(newProject);
      });
      await refreshProjects();
    } else {
      throw Exception('Failed to load project');
    }
  }

 */


//esto es para mostrar la card


  bool isValidIdRandom(String value) {
    try {
      Uuid.parse(value);
      return true;
    } catch (e) {
      return false;
    }
  }

  //esto es para meter el id para el guardar un proyecto
  //final sharedProjectApiUrl = 'http://127.0.0.1:8000/user/project/detail/';
  TextEditingController idRandom = TextEditingController();
  /*
  class Project {
  final int id;
  final String idrandom;
  final String name;
  final String location;
  final String description;
  final String relationUserProject;

  Project({
  required this.id,
  required this.idrandom,
  required this.name,
  required this.location,
  required this.description,
  required this.relationUserProject,
  });

  factory Project.fromJson(Map<String, dynamic> json) {
  return Project(
  id: json['id'],
  idrandom: json['idrandom'],
  name: json['name'],
  location: json['location'],
  description: json['description'],
  relationUserProject: json['relationUserProject'],
  );
  }
  }   */

  Future<Project> shareProject(String idrandom) async {
    final response = await http.post(
      Uri.parse('http://127.0.0.1:8000/user/project/share/'),
      body: {'idrandom': idrandom},
    );
  print(response.body);
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      final project = Project.fromJson(json);

      setState(() {
        projects.add(project);
      });
    print(project.name);
      return project;
    } else {
      throw Exception("Failed to share project");
    }
  }

/*
  Future<Project> getSharedProject(String idrandom) async {
    final url =
        Uri.parse('http://127.0.0.1:8000/user/project/detail/$idrandom/');
    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        // aquí puedes agregar cualquier header adicional que necesites, como el token de autenticación
      },
    );
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final project = Project.fromJson(data);
      return project;
    } else if (response.statusCode == 404) {
      throw Exception('Project not found');
    } else {
      throw Exception('Failed to get shared project');
    }
  }


  Future<void> addSharedProjectIfAny(List<Project> projects) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? sharedProjectString = prefs.getString('sharedProject');
    if (sharedProjectString != null && sharedProjectString.isNotEmpty) {
      try {
        dynamic sharedProjectJson = json.decode(sharedProjectString);
        if (sharedProjectJson is Map<String, dynamic>) {
          Project sharedProject = Project.fromJson(sharedProjectJson);
          projects.add(sharedProject);
          print(projects);
        } else {
          print(
              "La cadena de proyecto compartido no es un objeto JSON válido.");
        }
      } catch (e) {
        print("Error al decodificar la cadena JSON: $e");
      }
    } else {
      print("La cadena de proyecto compartido es nula o vacía.");
    }
  }
 */
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: projectListKey,
      body: Container(
        /*
          onRefresh: () async {
            setState(() {
              futureProjects = fetchProjects();
            });
          },
         */
          child: Row(children: [
            //llamado de la barra
            const SizedBox(
              width: 100,
              child: Navigation(
                  title: 'nav',
                  selectedIndex:
                      0 /* Fundamental SelectIndex para que funcione el selector*/),
            ),
            Expanded(
                child: Column(children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Padding(
                    padding: EdgeInsets.all(10),
                    child: Text(
                      'Project',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 30,
                          color: Colors.black),
                    ),
                  ),
                  Row(
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => open_project()),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 5),
                          backgroundColor:
                              const Color.fromRGBO(255, 255, 255, 1.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                        child:  const Text(
                          "Shared Projects",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 15,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            backgroundColor: Color.fromRGBO(0, 191, 174, 1),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5),
                            )),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                content: Container(
                                    width:
                                        MediaQuery.of(context).size.width * 0.7,
                                    height: MediaQuery.of(context).size.height *
                                        0.9,
                                    child: Column(
                                      children: [
                                        Expanded(
                                            child:

                                            AddProjectScreen()

                                        ),
                                      ],
                                    )),
                              );
                            },
                          );

                        },
                        child: const Text(
                          "+New Project",
                          style: TextStyle(
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const Divider(
                color: Colors.black26, //color of divider
                height: 4, //height spacing of divider
                thickness: 1, //thickness of divier line
                indent: 15, //spacing at the start of divider
                endIndent: 0,
              ),
              Expanded(
                child: FutureBuilder<List<Project>>(
                  future: futureProjects,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                       projects = snapshot.data!;
                      return GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount:
                              MediaQuery.of(context).size.width > 1200
                                  ? 5
                                  : MediaQuery.of(context).size.width > 800
                                      ? 4
                                      : MediaQuery.of(context).size.width > 600
                                          ? 3
                                          : 2,
                          mainAxisSpacing: 16,
                          crossAxisSpacing: 16,
                          childAspectRatio: 1.0,
                        ),
                        itemCount: projects.length,
                        itemBuilder: (BuildContext context, int index) {
                          final project = projects[index];
                          return Container(
                            height: 1200,
                            child: Card(
                              color: Color.fromRGBO(0, 191, 174, 1),
                              child: Padding(
                                padding: EdgeInsets.all(0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      padding: new EdgeInsets.all(0),
                                      height: 100,
                                      decoration: new BoxDecoration(
                                        border:
                                            new Border.all(color: Colors.white),
                                        color: Colors.white,
                                      ),
                                    ),
                                    ListTile(
                                      title: Text(
                                        project.name,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                      onTap: () {
                                        // Navegar a la pantalla de detalles del proyecto
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => MyDevice()),
                                        );
                                      },
                                    ),
                                    Align(
                                      alignment: Alignment.bottomRight,
                                      child: Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                        children: [
                                          IconButton(
                                            icon: Icon(Icons.delete),
                                            onPressed: () async {
                                              bool confirmDelete =
                                              await showDialog(
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  return AlertDialog(
                                                    title: Text(
                                                        "Do you want to delete this project?"),
                                                    content: Text(
                                                      project.name,
                                                      textAlign:
                                                      TextAlign.center,
                                                    ),
                                                    actions: <Widget>[
                                                      Align(
                                                        alignment: Alignment
                                                            .bottomRight, // Align buttons to bottom right corner
                                                        child: Row(
                                                          mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                          children: [
                                                            ElevatedButton(
                                                              onPressed: () =>
                                                                  Navigator.of(
                                                                      context)
                                                                      .pop(
                                                                      true),
                                                              style:
                                                              ElevatedButton
                                                                  .styleFrom(
                                                                minimumSize:
                                                                const Size(
                                                                    100,
                                                                    30),
                                                                backgroundColor:
                                                                const Color
                                                                    .fromRGBO(
                                                                    242,
                                                                    23,
                                                                    23,
                                                                    1),
                                                              ),
                                                              child: const Text(
                                                                'Delete',
                                                                textAlign:
                                                                TextAlign
                                                                    .center,
                                                                style:
                                                                TextStyle(
                                                                  fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                                  fontSize: 12,
                                                                  color: Colors
                                                                      .white,
                                                                ),
                                                              ),
                                                            ),
                                                            SizedBox(), // Add some space between buttons
                                                            ElevatedButton(
                                                              onPressed: () {
                                                                Navigator.pop(
                                                                    context,
                                                                    false);
                                                              },
                                                              style:
                                                              ElevatedButton
                                                                  .styleFrom(
                                                                minimumSize:
                                                                const Size(
                                                                    100,
                                                                    30),
                                                                backgroundColor:
                                                                const Color
                                                                    .fromRGBO(
                                                                    0,
                                                                    191,
                                                                    174,
                                                                    1),
                                                              ),
                                                              child: const Text(
                                                                'Cancel',
                                                                textAlign:
                                                                TextAlign
                                                                    .center,
                                                                style:
                                                                TextStyle(
                                                                  fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                                  fontSize: 12,
                                                                  color: Colors
                                                                      .white,
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  );
                                                },
                                              );
                                              if (confirmDelete == true) {
                                                try {
                                                  await deleteProject(
                                                      project.id);
                                                  setState(() {
                                                    projects.remove(project);
                                                  });
                                                } catch (e) {
                                                  print(
                                                      "Error deleting project: $e");
                                                }
                                              }
                                            },
                                          ),
                                          IconButton(
                                            icon: Icon(Icons.share),
                                            onPressed: () {
                                              showDialog(
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  return AlertDialog(
                                                    title: Text("Random ID"),
                                                    content: Row(
                                                      mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                      children: [
                                                        Text(project.idrandom),
                                                        IconButton(
                                                          icon:
                                                          Icon(Icons.copy),
                                                          onPressed: () {
                                                            //se guarda en el porta papeles
                                                            Clipboard.setData(
                                                                ClipboardData(
                                                                    text: project
                                                                        .idrandom));
                                                            ScaffoldMessenger
                                                                .of(context)
                                                                .showSnackBar(
                                                              SnackBar(
                                                                  content: Text(
                                                                      "code copied to clipboard")),
                                                            );
                                                          },
                                                        ),
                                                      ],
                                                    ),
                                                    actions: [
                                                      TextButton(
                                                        child: Text("Close"),
                                                        onPressed: () {
                                                          Navigator.of(context)
                                                              .pop();
                                                        },
                                                      ),
                                                    ],
                                                  );
                                                },
                                              );
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    } else if (snapshot.hasError) {
                      return Text("${snapshot.error}");
                    }
                    // By default, show a loading spinner
                    return Center(child: CircularProgressIndicator());
                  },
                ),
              ),
            ]))
          ])),
    );
  }
}
