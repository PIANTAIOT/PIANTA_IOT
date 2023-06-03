import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/adapters.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';
import '../Funciones/constantes.dart';
import '../MyDevices/My_Devices.dart';
import '../constants.dart';



class ShareProject {
  int id;
  final String idrandom;
  final String name;
  //final String location;
  final String description;
  final String relationUserProject;

  ShareProject({
    required this.id,
    required this.idrandom,
    required this.name,
    //required this.location,
    required this.description,
    required this.relationUserProject,

  })  : assert(id != null),

        assert(idrandom != null),
        assert(name != null),
  // assert(location != null),
        assert(description != null);

  factory ShareProject.fromJson(Map<String, dynamic> json) {
    return ShareProject(
      id: json['id'],
      idrandom: json['idrandom'],
      name: json['name'],
      //location: json['location'],
      description: json['description'],
      relationUserProject: json['relationUserProject'],
    );
  }
}
class SharedRelation {
  final int id;
  final int user;
  final int project;
  final String timestamp;

  SharedRelation({
    required this.id,
    required this.user,
    required this.project,
    required this.timestamp,
  });

  factory SharedRelation.fromJson(Map<String, dynamic> json) {
    return SharedRelation(
      id: json['id'],
      user: json['user'],
      project: json['project'],
      timestamp: json['timestamp'],
    );
  }
}

List<ShareProject> Shareprojects = [];

class open_project extends StatefulWidget {
  const open_project({Key? key}) : super(key: key);
  @override
  State<open_project> createState() => _open_projectState();
}
class _open_projectState extends State<open_project> {
  final _keyForm = GlobalKey<FormState>();
  List<ShareProject> Shareprojects = [];
  late Future<List<ShareProject>> futureShareProjects;

  @override
  void initState() {
    super.initState();
    futureShareProjects = fetchProjects();
  }

  bool isValidIdRandom(String value) {
    try {
      Uuid.parse(value);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<void> deleteShareProject(int sharedProjectIds) async {
    var box = await Hive.openBox(tokenBox);
    final token = box.get("token") as String?;
    final response = await http.delete(
      Uri.parse('http://127.0.0.1:8000/user/project/share/$sharedProjectIds/'), // Usar el sharedProjectId para llamar la URL correcta
      headers: {'Authorization': 'Token $token'},
    );
    if (response.statusCode == 204) {//204 status code means successful deletion
      print('Shared project deleted successfully');
      await refreshProjects();
    } else if (response.statusCode == 404) { //if the shared project is not found
      throw Exception('Shared project not found');
    } else if (response.statusCode == 403) { //if the user does not have permission to delete the shared project
      throw Exception('You do not have permission to delete this shared project');
    } else {
      throw Exception('Failed to delete shared project');
    }
  }

  Future<List<ShareProject>> fetchProjects() async {
    var box = await Hive.openBox(tokenBox);
    final token = box.get("token") as String?;
    final response = await http.get(
      Uri.parse('http://127.0.0.1:8000/user/project/share/'),
      headers: {'Authorization': 'Token $token'},
    );

    if (response.statusCode == 200) {
      final dynamic jsonData = jsonDecode(response.body);
      if (jsonData.containsKey("projects")) {
        final List<dynamic> projectsJson = jsonData["projects"];
        final List<ShareProject> projects = projectsJson.map((json) => ShareProject.fromJson(json)).toList();
        return projects;
      } else {
        throw Exception('Invalid JSON format');
      }
    } else {
      throw Exception('Failed to load project list');
    }
  }

  Future<void> refreshProjects() async {
    futureShareProjects = fetchProjects();
  }
  //esto es para meter el id para el guardar un proyecto
  //final sharedProjectApiUrl = 'http://127.0.0.1:8000/user/project/detail/';
  TextEditingController idRandom = TextEditingController();
  Future<ShareProject> shareProject(String idrandom) async {
    var box = await Hive.openBox(tokenBox);
    final token = box.get("token") as String?;
    final response = await http.post(
      Uri.parse('http://127.0.0.1:8000/user/project/share/'),
      body: {'idrandom': idrandom},
        headers: {'Authorization': 'Token $token'},
    );
    print(response.body);
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      final project = ShareProject.fromJson(json);
      setState(() {
        Shareprojects.add(project);
      });
      print(project.name);
      return project;
    } else {
      final json = jsonDecode(response.body);
      final errorMessage = json['res'];
      Future.delayed(Duration.zero, () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Error"),
              content: Text(errorMessage),
              actions: <Widget>[
                TextButton(
                  child: Text("OK"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      });
      throw Exception("Failed to share project");
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _keyForm,
      body: Row(children: [
        const SizedBox(
          width: 100,
          child: Navigation(
              title: 'nav',
              selectedIndex:
              0 /* Fundamental SelectIndex para que funcione el selector*/),
        ),
        Expanded(
            child: Column(
                children: [

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start, // alinear el contenido a la derecha horizontalmente
                      children: const [
                        Padding(
                          padding: EdgeInsets.all(10),
                          child: Text(
                            'Shared Projects',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 30,
                              color: Colors.black,
                            ),
                            textAlign: TextAlign.left, // alinear el texto a la derecha
                          ),
                        ),
                        // agregar más elementos aquí si es necesario
                      ],
                    ),
                  ),

                  Row(
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text('Project Created'),
                                content: SizedBox(
                                  width: 500,
                                  height: 100,
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      const Text('Project ID:'),
                                      TextFormField(
                                        controller: idRandom,
                                        onChanged: (value) {
                                          idRandom.text = value.trim();
                                        },
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Please input an idrandom';
                                          }
                                          return null;
                                        },
                                        decoration: const InputDecoration(
                                          prefixIcon: Icon(Icons.code),
                                          border: OutlineInputBorder(),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                actions: <Widget>[
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text('Cancel',
                                        style: TextStyle(color: Colors.black)),
                                  ),
                                  const Spacer(),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor:
                                      const Color.fromRGBO(0, 191, 174, 1),
                                    ),
                                    onPressed: () async {
                                    String idrandoms = idRandom.text;
                                    print(idrandoms);
                                    try {
                                      ShareProject sharedProject = await shareProject(
                                          idrandoms);
                                      //projects.add(sharedProject);
                                      print(sharedProject);
                                    } catch (e) {
                                      print(
                                          'Error compartiendo el proyecto: $e');
                                    }
                                    //SharedPreferences prefs = await SharedPreferences.getInstance();
                                    //String sharedProject = json.encode(url); // convertir el objeto project a una cadena de texto
                                    //await prefs.setString('sharedProject', sharedProject); // guardar la cadena en SharedPreferences
                                    // await addSharedProjectIfAny(projects); // agregar el proyecto compartido si aún no existe en la lista de proyectos
                                    Navigator.of(context).pop();
                                    // Manejar cualquier excepción lanzada por shareProject o getSharedProject

    },
                                    child: const Text('Accept'),
                                  ),
                                ],
                              );
                            },
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
                        child: const Text(
                          "Open Project",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 15,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      SizedBox(
                        width: 50,
                        height: 50,
                        child: Tooltip(
                          message: 'Return to the previous page',
                          child: IconButton(
                              onPressed: () {
                                Navigator.pop(
                                    context, 'Value page previous');
                              },
                              icon: const Icon(Icons.exit_to_app))
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
                child: FutureBuilder<List<ShareProject>>(
                  future: futureShareProjects,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      Shareprojects = snapshot.data!;
                      return GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount:
                          MediaQuery.of(context).size.width > 1200 ? 5 : MediaQuery.of(context).size.width > 800 ? 4 : MediaQuery.of(context).size.width > 600 ? 3 : 2,
                          mainAxisSpacing: 16,
                          crossAxisSpacing: 16,
                          childAspectRatio: 1.0,
                        ),
                        itemCount: Shareprojects.length,
                        itemBuilder: (BuildContext context, int index) {
                          final project = Shareprojects[index];
                          return SizedBox(
                            height: 1200,
                            child: Card(
                              color: const Color.fromRGBO(0, 191, 174, 1),
                              child: Padding(
                                padding: const EdgeInsets.all(0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(0),
                                      height: 100,
                                      decoration: BoxDecoration(
                                        border:
                                        Border.all(color: Colors.white),
                                        color: Colors.white,
                                      ),
                                    ),
                                    ListTile(
                                      title: Text(
                                        project.name,
                                        style: const TextStyle(
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
                                              builder: (context) => const MyDevice()),
                                        );
                                      },
                                    ),
                                    ListTile(
                                      title: Text(
                                        'User: ${project.relationUserProject}',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                    Align(
                                      alignment: Alignment.bottomRight,
                                      child: Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,

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
                    return const Center(child: CircularProgressIndicator());
                  },
                ),
              ),

            ]))
      ]),
    );
  }
}
