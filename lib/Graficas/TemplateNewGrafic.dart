import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pianta/Graficas/VitualPinDatastream.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TempCreateGrafics extends StatefulWidget {
  const TempCreateGrafics({Key? key}) : super(key: key);

  @override
  State<TempCreateGrafics> createState() => _TempCreateGraficsState();
}

class _TempCreateGraficsState extends State<TempCreateGrafics> {
  List<String> listaDeOpciones = <String>["Temperatura", "Humedad"];
  final TextEditingController titleController = TextEditingController();
  final _keyForm = GlobalKey<FormState>();

  void _savetitle(String title) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('title', title);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Card(
          key: _keyForm,
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
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
                                  icon: const Icon(Icons.exit_to_app))),
                        ),
                        const SizedBox(height: 16.0),
                        const Text(
                          'Gauge Settings',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20.0,
                          ),
                        ),
                        const SizedBox(height: 18.0),
                        const Text(
                          'TITLE (Optional)',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14.0, // Se ha cambiado el tamaño a 14.0
                          ),
                        ),
                        const SizedBox(height: 16.0),
                        TextFormField(
                          controller: titleController,
                          decoration: const InputDecoration(
                            hintText: 'Enter title',
                            border: OutlineInputBorder(),
                          ),
                          validator: (valor) {
                            if (valor!.isEmpty ||
                                !RegExp(r'^[a-z A-Z]+$').hasMatch(valor)) {
                              //allow upper and lower case alphabets and space
                              return "Please enter your title";
                            } else if (valor.trim().isEmpty ?? true) {
                              return 'your title must have digits';
                            } else {
                              return null;
                            }
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 50.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          flex: 3,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Datastream',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14.0,
                                ),
                              ),
                              DropdownButtonFormField(
                                items: listaDeOpciones.map((e) {
                                  // Ahora creamos "e" y contiene cada uno de los items de la lista.
                                  return DropdownMenuItem(
                                      child: Text(e), value: e);
                                }).toList(),
                                onChanged: (String? value) {},
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter the datastream';
                                  }
                                  return null;
                                },
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 16.0),
                        Flexible(
                            child: ElevatedButton(
                                onPressed: () {
                                    _savetitle(titleController.text);
                                    print(_savetitle);
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                VirtualPinDatastream()));
                                    print('Error title');
                                },
                                style: ElevatedButton.styleFrom(
                                  minimumSize: Size(90, 40),
                                  backgroundColor:
                                      Color.fromRGBO(0, 191, 174, 1),
                                ),
                                child: Text('+ Create Datastream')))
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
