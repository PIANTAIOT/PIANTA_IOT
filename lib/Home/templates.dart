/*import 'package:flutter/material.dart';
import 'package:pianta/Home/create_templete.dart';
//clase creada para la pantalla donde aparecen los templates
class Templates extends StatefulWidget {
  const Templates({Key? key}) : super(key: key);
  @override
  State<Templates> createState() => _TemplatesState();
}
class _TemplatesState extends State<Templates> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: [
        //Modulo 1° Texto inicial
        //se tomara una fila para poder ubicarlo
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            //texto inicial de la pagina
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Templates',
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(19.0),
              //boton
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    //accion que permitira al dar click retornar al login
                    MaterialPageRoute(builder: (context) => CreateTemplate()),
                  );
                },
                style: ElevatedButton.styleFrom(
                    primary: const Color.fromRGBO(
                        0, 191, 174, 1) // Color de fondo del botón
                    ),
                //texto que aparecera en el boton
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    SizedBox(width: 5),
                    Text('+New Template'),
                  ],
                ),
              ),
            ),
          ],
        ), //fin modulo 1°
        //Modulo 2° linea divisoria
        //linea divisoria para separar titulo y botones iniciales de las card de los templates
        const Divider(
          color: Colors.black26, //color of divider
          height: 2, //height spacing of divider
          thickness: 1, //thickness of divier line
          indent: 15, //spacing at the start of divider
          endIndent: 0, //spacing at the end of divider
        ), //fin modulo 2°
        //Modulo 3° card para templates creados
        Row(mainAxisAlignment: MainAxisAlignment.start, children: [
          Padding(
            padding: const EdgeInsets.all(19.0),
            child: SizedBox(
              width: 260,
              height: 300,
              child: Card(
                child: Column(
                  children: [
                    Expanded(
                      child: Container(
                        width: 260,
                        height: 350,
                        color: Colors.white, // color de la primera mitad
                      ),
                    ),
                    Expanded(
                      child: Container(
                          width: 260,
                          height: 1,
                          color: const Color.fromRGBO(0, 191, 174, 1),
                          child: const ListTile(
                              title: Text('Template Name',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: 30)),
                              subtitle: Text('Connected device',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize:
                                          20))) // color de la segunda mitad
                          ),
                    )
                  ],
                ),
              ),
            ),
          )
        ]),
      ],
    ));
  }
}
*/
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:pianta/Home/template_model.dart';
import 'package:pianta/MyDevices/Dashboard.dart';
import '../Funciones/constantes.dart';
import '../Graficas/TemplateNewGrafic.dart';
import 'create_templete.dart';

//el Project es lo que esta en la api

class Templates extends StatefulWidget {
  const Templates({Key? key}) : super(key: key);

  @override
  State<Templates> createState() => _TemplatesState();
}

class _TemplatesState extends State<Templates> {
  late final VoidCallback onDelete; // Callback que se ejecuta cuando se elimina algo (función sin retorno y sin parámetros)
  final project = templateprojects = []; // Variable "project" que inicialmente es una lista vacía
  late Future<List<ProjectTemplate>> futureProjects; // Futuro que devuelve una lista de objetos de tipo ProjectTemplate (se inicializará más adelante)
  final projectListKey = GlobalKey<_TemplatesState>(); // Llave global para acceder al estado de la lista de proyectos
  late String idrandomValue; // Variable "idrandomValue" de tipo String que se inicializará más adelante

  @override
  void initState() {
    super.initState();
    futureProjects = fetchProjects(); // Inicialización del futuro llamando a la función fetchProjects()
    idrandomValue = "1"; // Inicialización de la variable "idrandomValue" con el valor "1"
  }

// Esto es para mostrar la tarjeta (card)
  Future<List<ProjectTemplate>> fetchProjects() async {
    final response = await http.get(Uri.parse('http://127.0.0.1:8000/user/template/')); // Realizar una solicitud GET a la URL especificada
    if (response.statusCode == 200) { // Si la respuesta es exitosa
      final List<dynamic> jsonList = jsonDecode(response.body); // Decodificar la respuesta JSON en una lista dinámica
      final List<ProjectTemplate> projects = jsonList.map((json) => ProjectTemplate.fromJson(json)).toList(); // Mapear cada objeto JSON a un objeto de tipo ProjectTemplate y crear una lista de ellos
      // Esto refresca el proyecto para ver los cambios
      // await refreshProjects(); // Llamar a la función refreshProjects (comentada, no está siendo utilizada)
      return projects; // Devolver la lista de proyectos
    } else {
      throw Exception('Failed to load project list'); // Si la respuesta no es exitosa, lanzar una excepción indicando que no se pudo cargar la lista de proyectos
    }
  }

  Future<void> refreshProjects() async {
    setState(() {
      futureProjects = fetchProjects(); // Actualizar el futuro de los proyectos llamando a la función fetchProjects()
    });
  }

  //esto es para meter el id para el guardar un proyecto

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: projectListKey,
        body: Row(children: [
          const SizedBox(
            width: 100,
            child: Navigation(
                title: 'nav',
                selectedIndex:
                1 /* Fundamental SelectIndex para que funcione el selector*/),
          ),
          Expanded(
              child: Column(children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(10),
                      child: Text(
                        'Template',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 30,
                            color: Colors.black),
                      ),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 5),
                          backgroundColor: const Color.fromRGBO(0, 191, 174, 1),
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
                                  height:
                                  MediaQuery.of(context).size.height * 0.9,
                                  child: Column(
                                    children: [
                                      Expanded(child: CreateTemplate()),
                                    ],
                                  )),
                            );
                          },
                        );
                      },
                      child: Text(
                        "+New Template",
                        style: TextStyle(
                          fontSize: 15,
                        ),
                      ),
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
                  child: FutureBuilder<List<ProjectTemplate>>(
                    future: futureProjects, // Futuro que se espera completar
                    builder: (context, snapshot) { // Función de generación del widget basado en el estado del futuro
                      if (snapshot.hasData) { // Si el futuro tiene datos
                        final projects = snapshot.data!; // Obtener los datos del futuro
                        return GridView.builder(
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: MediaQuery.of(context).size.width > 1200
                                ? 5
                                : MediaQuery.of(context).size.width > 800
                                ? 4
                                : MediaQuery.of(context).size.width > 600
                                ? 3
                                : 2, // Número de elementos por fila en la cuadrícula basado en el ancho de la pantalla
                            mainAxisSpacing: 16,
                            crossAxisSpacing: 16,
                            childAspectRatio: 1.0,
                          ),
                          itemCount: projects.length, // Número total de elementos en la cuadrícula
                          itemBuilder: (BuildContext context, int index) {
                            final project = projects[index]; // Obtener el proyecto en el índice actual
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
                                        height: 130,
                                        decoration: new BoxDecoration(
                                          border: new Border.all(color: Colors.white),
                                          color: Colors.white,
                                        ),
                                      ),
                                      ListTile(
                                        title: Text(
                                          project.name, // Mostrar el nombre del proyecto
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20,
                                          ),
                                          textAlign: TextAlign.left,
                                        ),
                                        trailing: IconButton(
                                          icon: const Icon(Icons.delete, color: Colors.black),
                                          onPressed: () async {
                                            showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                  title: const Text('Delete template'),
                                                  content: const Text(
                                                      'Are you sure you want to delete this template?'),
                                                  actions: <Widget>[
                                                    Row(
                                                      mainAxisAlignment: MainAxisAlignment.end,
                                                      children: [
                                                        TextButton(
                                                          style: ButtonStyle(
                                                            backgroundColor:
                                                            MaterialStateProperty.all<Color>(
                                                              Colors.red,
                                                            ),
                                                          ),
                                                          onPressed: () async {
                                                            final response = await http.delete(
                                                                Uri.parse(
                                                                    'http://127.0.0.1:8000/user/template/${project.id}/'));
                                                            if (response.statusCode == 204) {
                                                              // El proyecto se eliminó correctamente
                                                            } else {
                                                              // Mostrar un mensaje de error si no se pudo eliminar el proyecto
                                                            }
                                                            await refreshProjects();
                                                            Navigator.of(context).pop();
                                                          },
                                                          child: const Text(
                                                            'Delete',
                                                            style: TextStyle(
                                                              color: Colors.white,
                                                              fontWeight: FontWeight.bold,
                                                            ),
                                                          ),
                                                        ),
                                                        Spacer(),
                                                        TextButton(
                                                          style: ButtonStyle(
                                                            backgroundColor:
                                                            MaterialStateProperty.all<Color>(
                                                              const Color.fromRGBO(0, 191, 174, 1),
                                                            ),
                                                          ),
                                                          onPressed: () {
                                                            Navigator.of(context).pop();
                                                          },
                                                          child: const Text(
                                                            'Cancel',
                                                            style: TextStyle(
                                                              fontWeight: FontWeight.bold,
                                                              fontSize: 12,
                                                              color: Colors.white,
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                );
                                              },
                                            );
                                          },
                                        ),
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  Dashboard(project: project), // Navegar a la pantalla Dashboard con el proyecto seleccionado
                                            ),
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      } else if (snapshot.hasError) { // Si hay un error en el futuro
                        return Text("${snapshot.error}"); // Mostrar el mensaje de error
                      }
                      // Por defecto, mostrar un indicador de carga
                      return Center(child: CircularProgressIndicator());
                    },
                  ),
                )
              ]))
        ]));
  }
}

class Dashboard extends StatelessWidget {
  final ProjectTemplate project;

  const Dashboard({Key? key, required this.project}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          const SizedBox(
            width: 100,
            child: Navigation(
              title: 'nav',
              selectedIndex:
              1 /* Fundamental SelectIndex para que funcione el selector*/,
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
                            project.name,
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
                  //color of divider
                  height: 2,
                  //height spacing of divider
                  thickness: 1,
                  //thickness of divier line
                  indent: 15,
                  //spacing at the start of divider
                  endIndent: 0, //spacing at the end of divider
                ),
                Container(
                  padding: const EdgeInsets.all(20),
                  margin: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.grey,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Name:',
                              style: const TextStyle(fontSize: 24),
                            ),
                            Text(
                              '${project.name}',
                              style: const TextStyle(fontSize: 24),
                            ),
                            const SizedBox(height: 20),
                            const Text(
                              'Hardware:',
                              style: TextStyle(fontSize: 24),
                            ),
                            Text('${project.sensor} ',
                                style: const TextStyle(fontSize: 24)),
                            const SizedBox(height: 20),
                            Text(
                              'Template id:',
                              style: const TextStyle(fontSize: 24),
                            ),
                            Text(
                              '${project.id}',
                              style: const TextStyle(fontSize: 24),
                            ),
                            const SizedBox(height: 20),
                            const Text(
                              'Descriptions:',
                              style: TextStyle(fontSize: 24),
                            ),
                            Text(
                              '${project.descripcion}',
                              style: const TextStyle(fontSize: 24),
                            ),
                            const SizedBox(height: 20),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            const Text(
                              'Connection Type:',
                              style: TextStyle(fontSize: 24),
                            ),
                            Text(
                              '${project.red}',
                              style: const TextStyle(fontSize: 24),
                            ),
                            const SizedBox(height: 20),
                          ],
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}