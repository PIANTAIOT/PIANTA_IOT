import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:pianta/MyDevices/Dashboard.dart';
import 'package:http/http.dart' as http;
import '../Home/templates.dart';
import '../maps/maps.dart';

class VirtualPinDatastream extends StatefulWidget {
  const VirtualPinDatastream({Key? key}) : super(key: key);

  @override
  State<VirtualPinDatastream> createState() => _VirtualPinDatastreamState();
}

class _VirtualPinDatastreamState extends State<VirtualPinDatastream> {
  List<dynamic> templates = [];
  List<String> listaDePuertos = <String>["V1", "V2", "V3", "V4"];
  List<String> listaTipoDato = <String>["Float", "Integer", "String"];

  Future<dynamic> crearGrafico(String title, String name, String alias) async {
    final response = await http.post(
      Uri.parse('http://127.0.0.1:8000/user/graphics/'),
      body: {
        'titlegraphics': title,
        'namegraphics': name,
        'aliasgraphics': alias,
      },
    );

    if (response.statusCode == 201) {
      // El gráfico fue creado exitosamente
      return json.decode(response.body);
    } else {
      // El request falló
      throw Exception('Error al crear el gráfico');
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
              padding: const EdgeInsets.all(30.0),
              child: SizedBox(
                  width: 900,
                  height: 500,
                  child: Form(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
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
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [

                            const SizedBox(height: 16.0),

                            const Text(
                              'Virtual Pin Datastream',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20.0,
                              ),
                            ),
                            const SizedBox(height: 25.0),
                            Row(
                              children: [
                                Flexible(
                                    flex: 1,
                                    child: Column(
                                      children: [
                                        const Text(
                                          'NAME',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14.0,
                                          ),
                                        ),
                                        const SizedBox(height: 16.0),
                                        TextFormField(
                                          decoration: const InputDecoration(
                                            hintText: 'Enter title',
                                            border: OutlineInputBorder(),
                                          ),
                                        ),
                                      ],
                                    )
                                ),
                                const SizedBox(width: 16.0),
                                Flexible(
                                    flex: 1,
                                    child: Column(
                                      children: [
                                        const Text(
                                          'ALIAS',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14.0,
                                          ),
                                        ),
                                        const SizedBox(height: 16.0),
                                        TextFormField(
                                          decoration: const InputDecoration(
                                            hintText: 'Enter title',
                                            border: OutlineInputBorder(),
                                          ),
                                        ),
                                      ],
                                    )
                                ),
                              ],
                            ),
                            const SizedBox(width: 25.0),
                            Row(
                              children: [
                                Flexible(
                                    flex: 1,
                                    child: Column(
                                      children: [
                                        const SizedBox(height: 18.0),
                                        const Text(
                                          'PIN',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14.0,
                                          ),
                                        ),
                                        const SizedBox(height: 16.0),
                                        DropdownButtonFormField(
                                          items:listaDePuertos.map((e){
                                            // Ahora creamos "e" y contiene cada uno de los items de la lista.
                                            return DropdownMenuItem(
                                                child: Text(e),
                                                value: e
                                            );
                                          }).toList(),
                                          onChanged: (String? value) { },
                                        ),
                                      ],
                                    )
                                ),
                                const SizedBox(width: 16.0),
                                Flexible(
                                    flex: 1,
                                    child: Column(
                                      children: [
                                        const SizedBox(height: 18.0),
                                        const Text(
                                          'DATA TYPE',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14.0,
                                          ),
                                        ),
                                        const SizedBox(height: 16.0),
                                        DropdownButtonFormField(
                                          items:listaTipoDato.map((e){
                                            // Ahora creamos "e" y contiene cada uno de los items de la lista.
                                            return DropdownMenuItem(
                                                child: Text(e),
                                                value: e
                                            );
                                          }).toList(),
                                          onChanged: (String? value) { },
                                        ),
                                      ],
                                    )
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Flexible(
                                    flex: 1,
                                    child: Column(
                                      children: [
                                        const SizedBox(height: 30),
                                        const Text(
                                          'LOCATION',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14.0,
                                          ),
                                        ),
                                        const SizedBox(height: 12.0),
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
                                      ],
                                    )
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                SizedBox(width: 20),
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
                                SizedBox(width: 20),
                                ElevatedButton(
                                  onPressed: (){
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (context) => WebDashboard())
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    primary: Color.fromRGBO(0, 191, 174, 1),
                                  ),
                                  child: const Text(
                                    'Save',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                )
                              ],
                            )
                          ],
                        )
                      ],
                    ),
                  )
              ),
            ),
          ),
        )
    );
  }
}