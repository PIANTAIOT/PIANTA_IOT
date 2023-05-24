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
  int id; // Identificador del proyecto
  final String idrandom; // Identificador aleatorio del proyecto
  final String name; // Nombre del proyecto
  //final String location; // Ubicación del proyecto (comentado)
  final String description; // Descripción del proyecto
  final String relationUserProject; // Relación usuario-proyecto

  ShareProject({
    required this.id,
    required this.idrandom,
    required this.name,
    //required this.location, // Ubicación del proyecto (comentado)
    required this.description,
    required this.relationUserProject,
  })  : assert(id != null), // Asegura que el ID no sea nulo
        assert(idrandom != null), // Asegura que el ID aleatorio no sea nulo
        assert(name != null), // Asegura que el nombre no sea nulo
  // assert(location != null), // Asegura que la ubicación no sea nula (comentado)
        assert(description != null); // Asegura que la descripción no sea nula

  factory ShareProject.fromJson(Map<String, dynamic> json) {
    return ShareProject(
      id: json['id'],
      idrandom: json['idrandom'],
      name: json['name'],
      //location: json['location'], // Ubicación del proyecto (comentado)
      description: json['description'],
      relationUserProject: json['relationUserProject'],
    );
  }
}

class SharedRelation {
  final int id; // Identificador de la relación
  final int user; // ID del usuario
  final int project; // ID del proyecto
  final String timestamp; // Marca de tiempo

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

List<ShareProject> Shareprojects = []; // Lista de proyectos compartidos

class open_project extends StatefulWidget {
  const open_project({Key? key}) : super(key: key);
  @override
  State<open_project> createState() => _open_projectState();
}
class _open_projectState extends State<open_project> {
  final _keyForm = GlobalKey<FormState>(); // Clave global para el formulario
  List<ShareProject> Shareprojects = []; // Lista de proyectos compartidos
  late Future<List<ShareProject>> futureShareProjects; // Futuro de la lista de proyectos compartidos

  @override
  void initState() {
    super.initState();
    futureShareProjects = fetchProjects(); // Inicialización del futuro de la lista de proyectos compartidos al llamar a fetchProjects()
  }

  bool isValidIdRandom(String value) {
    try {
      Uuid.parse(value); // Intenta analizar el valor como un ID aleatorio válido
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<void> deleteShareProject(int sharedProjectIds) async {
    var box = await Hive.openBox(tokenBox); // Abre la caja de Hive (base de datos local)
    final token = box.get("token") as String?; // Obtiene el token almacenado en la base de datos local
    final response = await http.delete(
      Uri.parse('http://127.0.0.1:8000/user/project/share/$sharedProjectIds/'), // URL para eliminar el proyecto compartido con el sharedProjectId correcto
      headers: {'Authorization': 'Token $token'}, // Encabezados de la solicitud con el token de autorización
    );
    if (response.statusCode == 204) { // Código de estado 204 significa eliminación exitosa
      print('Shared project deleted successfully');
      await refreshProjects(); // Actualiza la lista de proyectos después de eliminar
    } else if (response.statusCode == 404) { // Si no se encuentra el proyecto compartido
      throw Exception('Shared project not found');
    } else if (response.statusCode == 403) { // Si el usuario no tiene permiso para eliminar el proyecto compartido
      throw Exception('You do not have permission to delete this shared project');
    } else {
      throw Exception('Failed to delete shared project');
    }
  }

  Future<List<ShareProject>> fetchProjects() async {
    var box = await Hive.openBox(tokenBox); // Abre la caja de Hive (base de datos local)
    final token = box.get("token") as String?; // Obtiene el token almacenado en la base de datos local
    final response = await http.get(
      Uri.parse('http://127.0.0.1:8000/user/project/share/'), // URL para obtener la lista de proyectos compartidos
      headers: {'Authorization': 'Token $token'}, // Encabezados de la solicitud con el token de autorización
    );

    if (response.statusCode == 200) { // Código de estado 200 significa solicitud exitosa
      final dynamic jsonData = jsonDecode(response.body); // Decodifica el JSON de la respuesta
      if (jsonData.containsKey("projects")) { // Verifica si la respuesta contiene la clave "projects"
        final List<dynamic> projectsJson = jsonData["projects"]; // Obtiene la lista de proyectos en formato JSON
        final List<ShareProject> projects = projectsJson.map((json) => ShareProject.fromJson(json)).toList(); // Mapea los proyectos JSON a objetos ShareProject
        return projects; // Devuelve la lista de proyectos
      } else {
        throw Exception('Invalid JSON format'); // Formato JSON inválido si no se encuentra la clave "projects"
      }
    } else {
      throw Exception('Failed to load project list'); // Fallo al cargar la lista de proyectos
    }
  }


  Future<void> refreshProjects() async {
    futureShareProjects = fetchProjects(); // Actualiza el futuro de la lista de proyectos llamando a fetchProjects()
  }

// Esto es para obtener el ID y guardar un proyecto compartido
// final sharedProjectApiUrl = 'http://127.0.0.1:8000/user/project/detail/';
  TextEditingController idRandom = TextEditingController(); // Controlador de texto para el campo de ID aleatorio

  Future<ShareProject> shareProject(String idrandom) async {
    var box = await Hive.openBox(tokenBox); // Abre la caja de Hive (base de datos local)
    final token = box.get("token") as String?; // Obtiene el token almacenado en la base de datos local
    final response = await http.post(
      Uri.parse('http://127.0.0.1:8000/user/project/share/'), // URL para compartir un proyecto
      body: {'idrandom': idrandom}, // Cuerpo de la solicitud con el ID aleatorio
      headers: {'Authorization': 'Token $token'}, // Encabezados de la solicitud con el token de autorización
    );
    print(response.body);
    if (response.statusCode == 200) { // Código de estado 200 significa solicitud exitosa
      final json = jsonDecode(response.body); // Decodifica el JSON de la respuesta
      final project = ShareProject.fromJson(json); // Convierte el JSON en un objeto ShareProject
      setState(() {
        Shareprojects.add(project); // Agrega el proyecto a la lista de proyectos compartidos
      });
      print(project.name);
      return project; // Devuelve el proyecto compartido
    } else {
      final json = jsonDecode(response.body); // Decodifica el JSON de la respuesta
      final errorMessage = json['res']; // Obtiene el mensaje de error del JSON
      Future.delayed(Duration.zero, () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Error"),
              content: Text(errorMessage), // Muestra el mensaje de error en el cuadro de diálogo
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
      throw Exception("Failed to share project"); // Lanza una excepción indicando que ha fallado la compartición del proyecto
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
                                        controller: idRandom, // Controlador de texto para el campo de ID aleatorio
                                        onChanged: (value) {
                                          idRandom.text = value.trim(); // Actualiza el valor del controlador de texto eliminando espacios en blanco
                                        },
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Please input an idrandom'; // Valida que se ingrese un ID aleatorio
                                          }
                                          return null;
                                        },
                                        decoration: const InputDecoration(
                                          prefixIcon: Icon(Icons.code), // Icono de prefijo para el campo de texto
                                          border: OutlineInputBorder(), // Estilo de borde del campo de texto
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
                                    child: const Text('Cancel', style: TextStyle(color: Colors.black)), // Botón de cancelar para cerrar el cuadro de diálogo
                                  ),
                                  const Spacer(), // Un espacio flexible para separar los botones
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color.fromRGBO(0, 191, 174, 1), // Estilo de fondo del botón
                                    ),
                                    onPressed: () async {
                                      String idrandoms = idRandom.text; // Obtiene el valor del ID aleatorio del controlador de texto
                                      print(idrandoms);
                                      try {
                                        ShareProject sharedProject = await shareProject(idrandoms); // Comparte el proyecto llamando a la función shareProject
                                        //projects.add(sharedProject); // Agrega el proyecto compartido a una lista (comentado en este caso)
                                        print(sharedProject); // Imprime el proyecto compartido
                                      } catch (e) {
                                        print('Error compartiendo el proyecto: $e'); // Imprime un mensaje de error si ocurre una excepción durante la compartición del proyecto
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
                future: futureShareProjects, // Future que representa la carga de los proyectos compartidos
                builder: (context, snapshot) {
                  if (snapshot.hasData) { // Si los datos han sido obtenidos exitosamente
                    Shareprojects = snapshot.data!; // Asigna los proyectos compartidos obtenidos al List Shareprojects
                    return GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: MediaQuery.of(context).size.width > 1200 ? 5 : MediaQuery.of(context).size.width > 800 ? 4 : MediaQuery.of(context).size.width > 600 ? 3 : 2, // Define el número de columnas en función del tamaño de la pantalla
                        mainAxisSpacing: 16, // Espaciado principal entre los elementos
                        crossAxisSpacing: 16, // Espaciado en el eje cruzado entre los elementos
                        childAspectRatio: 1.0, // Relación de aspecto de los elementos
                      ),
                      itemCount: Shareprojects.length, // Número total de elementos en la cuadrícula
                      itemBuilder: (BuildContext context, int index) {
                        final project = Shareprojects[index]; // Proyecto compartido actual en el índice dado
                        return SizedBox(
                          height: 1200, // Altura fija del contenedor
                          child: Card(
                            color: const Color.fromRGBO(0, 191, 174, 1), // Color de fondo del Card
                            child: Padding(
                              padding: const EdgeInsets.all(0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(0),
                                    height: 100,
                                    decoration: BoxDecoration(
                                      border: Border.all(color: Colors.white), // Borde blanco alrededor del contenedor
                                      color: Colors.white, // Color de fondo del contenedor
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
                                        MaterialPageRoute(builder: (context) => const MyDevice()),
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
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      // Elementos adicionales en la parte inferior derecha del Card
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  } else if (snapshot.hasError) { // Si ha ocurrido un error al obtener los datos
                    return Text("${snapshot.error}"); // Muestra el mensaje de error
                  }
                  // Por defecto, muestra un indicador de carga
                  return const Center(child: CircularProgressIndicator());
                  },
                ),
              ),

            ]))
      ]),
    );
  }
}
