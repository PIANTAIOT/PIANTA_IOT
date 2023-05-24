/*import 'package:flutter/material.dart';
import 'package:pianta/Home/proyecto.dart';
import 'package:pianta/Home/Home.dart';
import 'package:pianta/Home/templates.dart';
import 'package:pianta/maps/maps.dart';

class NewProject extends StatefulWidget {
  const NewProject({Key? key}) : super(key: key);

  @override
  State<NewProject> createState() => _NewProjectState();
}

// ignore: camel_case_types
class _NewProjectState extends State<NewProject> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
        child: SingleChildScrollView(
               child: Card(
                  elevation: 8.0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0), 
                  ),
                  child: SizedBox(
                    width: 900,
                    height: 450,
                    child: Padding(
                      padding: EdgeInsets.all(20.0),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: const [
                              Text('Create New Project',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 28,
                                  ),
                                  textAlign: TextAlign.left)
                            ],
                          ),
                          const SizedBox(height: 20.0),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: const [
                              Text(
                                'NAME',
                                style: TextStyle(
                                  fontWeight: FontWeight.normal,
                                  fontSize: 15,
                                ),
                              )
                            ],
                          ),
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 2),
                            child: TextField(
                              keyboardType: TextInputType.text,
                              decoration: InputDecoration(
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      width: 1, color: Colors.grey), //<-- SEE HERE
                                ),
                              ),
                              ),
                            ),
                          const SizedBox(height: 20.0),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: const [
                              Text(
                                'DESCRIPTION',
                                style: TextStyle(
                                  fontWeight: FontWeight.normal,
                                  fontSize: 15,
                                ),
                              )
                            ],
                          ),
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 2),
                            child: TextField(
                              keyboardType: TextInputType.text,
                              decoration: InputDecoration(
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      width: 1, color: Colors.grey), //<-- SEE HERE
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20.0),
                          Row(

                            mainAxisAlignment: MainAxisAlignment.start,
                            children: const [
                              Text(
                                'LOCATION',
                                style: TextStyle(
                                  fontWeight: FontWeight.normal,
                                  fontSize: 15,
                                ),
                              )
                            ],
                          ),
                          const SizedBox(height: 8.0),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [

                              ElevatedButton.icon(
                                  style: ElevatedButton.styleFrom(
                                    minimumSize: Size(70, 20),
                                    backgroundColor: const Color.fromRGBO(0, 191, 174, 1),
                                  ),
                                onPressed: () {

                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>  MapSample(),
                                    ),
                                  );

                                },
                                icon: const Icon(Icons.location_on, color:Colors.white ,),
                                label: const Text('Location', style:TextStyle(fontSize: 12,),)
                              ),

                            ],
                          ),
                          const SizedBox(height: 35.0),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const Home(),
                                    ),
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                    minimumSize: Size(90, 30),
                                    backgroundColor: Color.fromRGBO(255, 255, 255, 1)),
                                child: const Text(
                                  'Cancel',
                                  style: TextStyle(
                                      fontSize: 12,
                                      color: Color.fromRGBO(16, 16, 16, 1)),
                                ),
                              ),
                              const SizedBox(
                                width: 25, // Espacio de 16 píxeles entre los botones
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const Home(),
                                    ),
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  minimumSize: Size(90, 30),
                                  backgroundColor: Color.fromRGBO(0, 191, 174, 1),
                                ),
                                child: const Text(
                                  'Done',
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
                  )
                )
        ),
        ),
      ),
    );
  }
}
*/
/*
import 'package:flutter/material.dart';

class NewCardScreen extends StatefulWidget {
  @override
  _NewCardScreenState createState() => _NewCardScreenState();
}

class _NewCardScreenState extends State<NewCardScreen> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Nueva Tarjeta'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: 'Título',
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _contentController,sqdasdsa
              decoration: InputDecoration(
                labelText: 'Contenido',
              ),
              maxLines: 10,
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // TODO: Guardar la tarjeta
              },
              child: Text('Guardar Tarjeta'),
            ),
          ],
        ),
      ),
    );
  }
}
 */

/*import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';


class CardModel {
  String title;
  String content;
  DateTime createdAt;

  CardModel({
    required this.title,
    required this.content,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'content': content,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory CardModel.fromJson(Map<String, dynamic> json) {
    return CardModel(
      title: json['title'],
      content: json['content'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<CardModel> _cards = [];

  @override
  void initState() {
    super.initState();
    _cargarCartas();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cartas'),
      ),
      body: ListView.builder(
        itemCount: _cards.length,
        itemBuilder: (context, index) {
          final card = _cards[index];
          return Card(
            child: ListTile(
              title: Text(card.title),
              subtitle: Text(card.content),
              trailing: Text(card.createdAt.toString()),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final newCard = await Navigator.push<CardModel>(
            context,
            MaterialPageRoute(builder: (context) => NewCardPage()),
          );
          if (newCard != null) {
            setState(() {
              _cards.add(newCard);
            });
            _guardarCartas();
          }
        },
        child: Icon(Icons.add),
      ),
    );
  }

  Future<void> _cargarCartas() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/cards.json');
      final content = await file.readAsString();
      final List<dynamic> jsonList = jsonDecode(content);
      final List<CardModel> cards =
          jsonList.map((json) => CardModel.fromJson(json)).toList();
      setState(() {
        _cards = cards;
      });
    } catch (e) {
      print('Error al cargar las cartas: $e');
    }
  }

  Future<void> _guardarCartas() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/cards.json');
      final List<dynamic> jsonList =
          _cards.map((card) => card.toJson()).toList();
      final jsonString = jsonEncode(jsonList);
      await file.writeAsString(jsonString);
    } catch (e) {
      print('Error al guardar las cartas: $e');
    }
  }
}

class NewCardPage extends StatefulWidget {
  @override
  _NewCardPageState createState() => _NewCardPageState();
}

class _NewCardPageState extends State<NewCardPage> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Nueva carta'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                hintText: 'Título',
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _contentController,
              decoration: InputDecoration(
                hintText: 'Contenido',
              ),
              maxLines: null,
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                final title = _titleController.text;
                final content = _contentController.text;
                if (title.isNotEmpty && content.isNotEmpty) {
                  final newCard = CardModel(
                    title: title,
                    content: content,
                    createdAt: DateTime.now(),
                  );
                  Navigator.pop(context, newCard);
                }
              },
              child: Text('Guardar'),
            ),
          ],
        ),
      ),
    );
  }
}
 */
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:http/http.dart' as http;
import 'package:pianta/Home/model_proyect.dart';
import 'package:pianta/Home/proyecto.dart';
import 'package:pianta/maps/maps.dart';

import '../constants.dart';

class Projects {
  String name; // Variable para almacenar el nombre del proyecto
  String location; // Variable para almacenar la ubicación del proyecto
  String description; // Variable para almacenar la descripción del proyecto

  Projects({
    required this.name, // Parámetro obligatorio para el nombre del proyecto
    required this.location, // Parámetro obligatorio para la ubicación del proyecto
    required this.description, // Parámetro obligatorio para la descripción del proyecto
  });

  Map<String, dynamic> toMap() {
    // Método que convierte el objeto Projects en un mapa (diccionario)
    return {
      'name': name, // Agrega el nombre del proyecto al mapa
      'location': location, // Agrega la ubicación del proyecto al mapa
      'description': description, // Agrega la descripción del proyecto al mapa
    };
  }
}

class AddProjectScreen extends StatefulWidget {
  const AddProjectScreen({Key? key}) : super(key: key);

  @override
  _AddProjectScreenState createState() => _AddProjectScreenState();
}

class _AddProjectScreenState extends State<AddProjectScreen> {
  final _formKey = GlobalKey<FormState>(); // Clave global para el formulario
  final _nameController = TextEditingController(); // Controlador para el campo de texto del nombre
  final _locationController = TextEditingController(); // Controlador para el campo de texto de la ubicación
  final _descriptionController = TextEditingController(); // Controlador para el campo de texto de la descripción

  @override
  void dispose() {
    _nameController.dispose(); // Limpia el controlador del nombre cuando se destruye el estado
    _locationController.dispose(); // Limpia el controlador de la ubicación cuando se destruye el estado
    _descriptionController.dispose(); // Limpia el controlador de la descripción cuando se destruye el estado
    super.dispose();
  }

  Future<void> _addProject(Projects project) async {
    var box = await Hive.openBox(tokenBox); // Abre una caja en Hive (un almacén de datos local)
    final token = box.get("token") as String?; // Obtiene el token de autenticación de la caja
    final url = Uri.parse('http://127.0.0.1:8000/user/project/'); // URL del servidor donde se enviará la solicitud de agregar un proyecto
    final headers = {
      'Content-Type': 'application/json', // Encabezados de la solicitud HTTP que indican que el cuerpo está en formato JSON
      'Authorization': 'Token $token' // Encabezado de autorización que incluye el token
    };
    final body = json.encode(project.toMap()); // Convierte el objeto Projects en una cadena JSON

    final response = await http.post(url, headers: headers, body: body); // Realiza una solicitud POST al servidor con la URL, los encabezados y el cuerpo

    if (response.statusCode == 201) {
      Navigator.push(context, MaterialPageRoute(builder: (context) => Proyectos()));
      // Si la respuesta del servidor es exitosa (código 201), navega a la pantalla "Proyectos"
      // Navigator.pop(context); // Opcional: regresar a la pantalla anterior después de agregar el proyecto
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error adding project'), // Muestra un mensaje de error en un Snackbar si la respuesta no es exitosa
          backgroundColor: Colors.red, // Establece el color de fondo del Snackbar a rojo
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: Card(
              elevation: 4.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: SizedBox(
                  width: 900,
                  height: 500,
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Create New Project',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20.0,
                          ),
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'Name',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextFormField(
                          maxLines: null,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.fromLTRB(12, 16, 12, 16),
                            hintStyle: TextStyle(
                              fontSize: 16,
                              color: Colors.grey,
                            ),
                          ),
                          textAlign: TextAlign.left,
                          textAlignVertical: TextAlignVertical.top,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter content';
                            }
                            return null;
                          },
                          controller: _nameController,
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'Location',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                    TextFormField(
                      maxLines: null,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(), // Establece un borde alrededor del campo de texto
                        contentPadding: EdgeInsets.fromLTRB(12, 16, 12, 16), // Establece el relleno interno del campo de texto
                        hintStyle: TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                      textAlign: TextAlign.left,
                      textAlignVertical: TextAlignVertical.top,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter content'; // Valida si el campo de texto está vacío
                        }
                        return null;
                      },
                      controller: _locationController, // Asocia el controlador de texto "_locationController" al campo de texto
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Description',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextFormField(
                      maxLines: null,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.fromLTRB(12, 16, 12, 16),
                        hintStyle: TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                      textAlign: TextAlign.left,
                      textAlignVertical: TextAlignVertical.top,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter content'; // Valida si el campo de texto está vacío
                        }
                        return null;
                      },
                      controller: _descriptionController, // Asocia el controlador de texto "_descriptionController" al campo de texto
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Location',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 12),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size(70, 20),
                        backgroundColor: const Color.fromRGBO(0, 191, 174, 1), // Establece el color de fondo del botón
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => Localization()), // Navega a la pantalla "Localization" al hacer clic en el botón
                        );
                      },
                      icon: const Icon(Icons.location_on, color: Colors.white),
                      label: const Text('Location', style: TextStyle(fontSize: 12)), // Texto y estilo del botón
                    ),


                        /*ElevatedButton(
                                      onPressed: () {
                                        if (_formKey.currentState!.validate()) {
                                          final project = Project(
                                            name: _nameController.text,
                                            location: _locationController.text,
                                            description: _descriptionController.text,
                                          );
                                          _addProject(project);
                                        }
                                      },
                                      child: const Text('Agregar proyecto'),
                                    ),
                                     */
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            ElevatedButton(
                              onPressed: () async {
                                Navigator.of(context).pop(); // Cerrar la pantalla actual al hacer clic en el botón
                              },
                              style: ElevatedButton.styleFrom(
                                primary: Colors.white, // Establece el color de fondo del botón a blanco
                              ),
                              child: const Text(
                                'Cancel',
                                style: TextStyle(color: Colors.black), // Establece el color del texto del botón a negro
                              ),
                            ),
                            SizedBox(width: 12), // Agregar espacio horizontal
                            ElevatedButton(
                              onPressed: () async {
                                if (_formKey.currentState!.validate()) { // Valida el formulario antes de agregar el proyecto
                                  final project = Projects(
                                    name: _nameController.text, // Obtiene el texto ingresado en el campo de nombre
                                    location: _locationController.text, // Obtiene el texto ingresado en el campo de ubicación
                                    description: _descriptionController.text, // Obtiene el texto ingresado en el campo de descripción
                                  );
                                  _addProject(project); // Agrega el proyecto utilizando el método "_addProject"
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                primary: Color.fromRGBO(0, 191, 174, 1), // Establece el color de fondo del botón a verde azulado
                              ),
                              child: const Text(
                                'DONE',
                                style: TextStyle(color: Colors.white), // Establece el color del texto del botón a blanco
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
    )));
  }
}
