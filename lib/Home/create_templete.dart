import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:pianta/Home/template_model.dart';
import 'package:pianta/Home/templates.dart';

import '../constants.dart';

class CreateTemplate extends StatefulWidget {
  const CreateTemplate({Key? key}) : super(key: key);

  @override
  State<CreateTemplate> createState() => _CreateTemplateState();
}

class _CreateTemplateState extends State<CreateTemplate> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _sensorController = TextEditingController();
  final _descriptionController = TextEditingController();

  String? _selectedSensorOption; // added this line
  String? _selectedRedOption;

  List<String> _sensorOptions = ["ESP32", "SP23", "Option"];
  List<String> _redOptions = ["WiFi", "Ethernet", "USB"];
  late Future<List<ProjectTemplate>> futureProjects;

  @override
  void initState() {
    super.initState();
    futureProjects = fetchProjects();
  }

  Future<List<ProjectTemplate>> fetchProjects() async {
    var box = await Hive.openBox(tokenBox);
    final token = box.get("token") as String?;
    final response =
    await http.get(Uri.parse('http://127.0.0.1:8000/user/template/'),
      headers: {'Authorization': 'Token $token'},
    );
    if (response.statusCode == 200) {
      final List<dynamic> jsonList = jsonDecode(response.body);
      final List<ProjectTemplate> projects = jsonList.map((json) => ProjectTemplate.fromJson(json)).toList();
      //esto refresca el proyecto para ver los cambios
      //await refreshProjects();
      return projects;
    } else {
      throw Exception('Failed to load project list');
    }
  }

  Future<void> refreshProjects() async {
    setState(() {
      futureProjects = fetchProjects();
    });
  }

  Future<void> guardarSeleccion(List<String> opcionesSeleccionadas) async {
    var box = await Hive.openBox(tokenBox);
    final token = box.get("token") as String?;

    var url = Uri.parse('http://127.0.0.1:8000/user/template/');

    var data = {'opciones': opcionesSeleccionadas};

    var body = jsonEncode(data);

    var response = await http
        .post(url, body: body, headers: {'Content-Type': 'application/json', 'Authorization': 'Token $token'});

    if (response.statusCode == 200) {
      print('Datos guardados en la API');
      await refreshProjects();
    } else {
      print('Error al guardar datos en la API');
    }
  }

  Future<void> _addProject() async {
    var box = await Hive.openBox(tokenBox);
    final token = box.get("token") as String?;
    final url = Uri.parse('http://127.0.0.1:8000/user/template/');
    final headers = {'Content-Type': 'application/json', 'Authorization': 'Token $token'};
    final project = Project(
      name: _nameController.text,
      descripcion: _descriptionController.text,
      sensor:
      _selectedSensorOption!, // convertir el valor seleccionado en una lista
      red: _selectedRedOption!,
    );
    final body = json.encode(project.toMap());

    final response = await http.post(url, headers: headers, body: body);

    if (response.statusCode == 201) {
      await refreshProjects();
      Navigator.pop(context);

    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error adding project'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _sensorController.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Card(
          elevation: 4.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(0),
          ),
          child: Padding(
            padding: const EdgeInsets.all(30.0),
            child: SizedBox(
              width: 900,
              height: 500,
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 16.0),
                        const Text(
                          'Create New Template',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20.0,
                          ),
                        ),
                        const SizedBox(height: 16.0),
                        const Text(
                          'Name',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14.0, // Se ha cambiado el tamaño a 14.0
                          ),
                        ),
                        const SizedBox(height: 16.0),
                        TextFormField(
                          controller: _nameController,
                          decoration: const InputDecoration(
                            hintText: 'Enter the Project Name',
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your name';
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 16.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          flex: 1,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'HARDWARE',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 10.0,
                                ),
                              ),
                              DropdownButtonFormField<String>(
                                value: _selectedSensorOption,
                                onChanged: (String? newValue) {
                                  setState(() {
                                    _selectedSensorOption = newValue;
                                  });
                                },
                                items: _sensorOptions
                                    .map<DropdownMenuItem<String>>(
                                        (String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(value),
                                      );
                                    }).toList(),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 16.0),
                        Flexible(
                          flex: 1,
                          child: DropdownButtonFormField<String>(
                            value: _selectedRedOption,
                            onChanged: (String? newValue) {
                              setState(() {
                                _selectedRedOption = newValue;
                              });
                            },
                            decoration: const InputDecoration(
                              labelText: 'WIFI',
                            ),
                            items: _redOptions
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16.0),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'DESCRIPTION',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16.0,
                          ),
                        ),
                        const SizedBox(height: 16.0),
                        TextFormField(
                          controller: _descriptionController,
                          decoration: const InputDecoration(
                            hintText: 'Enter the project description',
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a description for the project';
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 16.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ElevatedButton(
                          onPressed: () async {
                            Navigator.of(context).pop();
                          },
                          style: ElevatedButton.styleFrom(
                            primary: Colors.white,
                          ),
                          child: const Text(
                            'Cancel',
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                        SizedBox(width: 16), // Agregar espacio horizontal
                        ElevatedButton(
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              await _addProject();
                            }
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => Templates()),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            primary: Color.fromRGBO(0, 191, 174, 1),
                          ),
                          child: const Text(
                            'DONE',
                            style: TextStyle(color: Colors.white),
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
    );
  }
}

class Project {
  final String name;
  final String descripcion;
  final String sensor;
  final String red;

  Project(
      {required this.name,
        required this.descripcion,
        required this.sensor,
        required this.red});

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'descripcion': descripcion,
      'sensor': sensor,
      'red': red,
    };
  }
}