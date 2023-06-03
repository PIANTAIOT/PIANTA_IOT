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
  String name;
  String location;
  String description;

  Projects({
    required this.name,
    required this.location,
    required this.description,
  });
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'location': location,
      'description': description,
    };
  }
}

class AddProjectScreen extends StatefulWidget {
  const AddProjectScreen({Key? key}) : super(key: key);

  @override
  _AddProjectScreenState createState() => _AddProjectScreenState();
}

class _AddProjectScreenState extends State<AddProjectScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _locationController = TextEditingController();
  final _descriptionController = TextEditingController();




  @override
  void dispose() {
    _nameController.dispose();
    _locationController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _addProject(Projects project) async {
    var box = await Hive.openBox(tokenBox);
    final token = box.get("token") as String?;
    final url = Uri.parse('http://127.0.0.1:8000/user/project/');
    final headers = {'Content-Type': 'application/json', 'Authorization': 'Token $token'};
    final body = json.encode(project.toMap());

    final response = await http.post(url, headers: headers, body: body);

    if (response.statusCode == 201) {
      Navigator.push(context, MaterialPageRoute(builder: (context) => Proyectos()));
      //Navigator.pop(context);
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
                          controller: _locationController,
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
                              return 'Please enter content';
                            }
                            return null;
                          },
                          controller: _descriptionController,
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
                              backgroundColor: const Color.fromRGBO(0, 191, 174, 1),
                            ),
                            onPressed: (){
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => Localization()));
                            },
                            icon: const Icon(Icons.location_on, color:Colors.white ,),
                            label: const Text('Location', style:TextStyle(fontSize: 12))
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
                            SizedBox(width: 12), // Agregar espacio horizontal
                            ElevatedButton(
                              onPressed: () async{

                                if (_formKey.currentState!.validate()) {
                                  final project = Projects(
                                    name: _nameController.text,
                                    location: _locationController.text,
                                    description: _descriptionController.text,
                                  );
                                  _addProject(project);
                                }
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
    )));
  }
}
