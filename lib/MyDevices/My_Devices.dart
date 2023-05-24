import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pianta/Home/templates.dart';
import 'package:pianta/MyDevices/DeviceGrafics.dart';
import 'dart:convert';
import 'package:pianta/MyDevices/New_Devices.dart';
import 'package:pianta/Funciones/constantes.dart';

class Devices {
  final int id; // ID único del dispositivo
  final String name; // Nombre del dispositivo
  final String location; // Ubicación del dispositivo

  Devices({required this.id, required this.name, required this.location});

  // Constructor de fábrica para crear una instancia de Devices a partir de un mapa JSON
  factory Devices.fromJson(Map<String, dynamic> json) {
    return Devices(
      id: json['id'], // Asigna el valor del campo 'id' del JSON al campo 'id' del objeto Devices
      name: json['name'], // Asigna el valor del campo 'name' del JSON al campo 'name' del objeto Devices
      location: json['location'], // Asigna el valor del campo 'location' del JSON al campo 'location' del objeto Devices
    );
  }
}

class MyDevice extends StatefulWidget {
  const MyDevice({Key? key}) : super(key: key);

  @override
  State<MyDevice> createState() => _MyDeviceState();
}

class _MyDeviceState extends State<MyDevice> {
  List<Devices> _devices = []; // Lista de dispositivos

  @override
  void initState() {
    super.initState();
    _getDevices(); // Obtiene la lista de dispositivos al inicializar el estado
  }

  void _deleteDevice(int id) async {
    bool confirm = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm the Deletion'),
          content: const Text('Are you sure you want to delete this device?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );

    if (confirm == true) {
      // Realiza una solicitud HTTP DELETE para eliminar el dispositivo con el ID proporcionado
      final response = await http.delete(Uri.parse('http://127.0.0.1:8000/user/devices/$id/'));

      if (response.statusCode == 200) {
        setState(() {
          _devices.removeWhere((device) => device.id == id); // Elimina el dispositivo de la lista si el ID coincide
        });
        print('Device deleted successfully');
      } else {
        throw Exception('Failed to delete device');
      }
    }
  }


  Future<void> _getDevices() async {
    final response = await http.get(Uri.parse('http://127.0.0.1:8000/user/devices/')); // Realiza una solicitud HTTP GET para obtener la lista de dispositivos
    if (response.statusCode == 200) {
      final List<dynamic> jsonList = jsonDecode(response.body);
      final List<Devices> devices = jsonList.map((json) => Devices.fromJson(json)).toList(); // Convierte la lista de JSON en una lista de objetos Devices
      setState(() {
        _devices = devices; // Actualiza la lista de dispositivos en el estado del widget
      });
      print('Devices list updated successfully');
    } else {
      throw Exception('Failed to load devices');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          const SizedBox(
            width: 100,
            child: Navigation(title: 'nav', selectedIndex: 0 /* Fundamental SelectIndex para que funcione el selector */),
          ),
          Expanded(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Padding(
                        padding: EdgeInsets.all(10),
                        child: Text(
                          'My Devices',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 30,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                              primary: const Color.fromRGBO(0, 191, 174, 1),
                            ),
                            onPressed: () async {
                              final url = Uri.parse('http://127.0.0.1:8000/user/template/');
                              final response = await http.get(url);

                              if (response.statusCode == 200 && json.decode(response.body).isNotEmpty) {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      content: Container(
                                        width: MediaQuery.of(context).size.width * 0.7,
                                        height: MediaQuery.of(context).size.height * 0.9,
                                        child: Column(
                                          children: const [
                                            Expanded(child: NewDevice()),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ).then((value) => _getDevices());
                              } else {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: const Text('Create a template first'),
                                      content: const Text('Please create a template before adding a device.'),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(builder: (context) => const Templates()),
                                            );
                                          },
                                          child: const Text('OK'),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              }
                            },
                            child: const Text(
                              '+New Device',
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                          const SizedBox(
                            width: 10,
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
                    child: ListView.builder(
                      itemCount: _devices.length,
                      itemBuilder: (context, index) {
                        final device = _devices[index];
                        return SizedBox(
                          width: MediaQuery.of(context).size.width / 2,
                          child: Card(
                            child: ListTile(
                              title: Text(device.name), // Mostrar el nombre del dispositivo en el título
                              subtitle: Text(device.location), // Mostrar la ubicación del dispositivo en el subtítulo
                              trailing: IconButton(
                                icon: const Icon(Icons.delete), // Mostrar un ícono de eliminación
                                onPressed: () {
                                  _deleteDevice(device.id); // Llamar a la función _deleteDevice() al presionar el ícono de eliminación
                                },
                              ),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => DeviceGrafics()), // Navegar a la página de gráficos del dispositivo al hacer clic en el ListTile
                                );
                              },
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              )
          )// segundo widget
        ],
      ),

    );
  }
}

