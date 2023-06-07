import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../constants.dart';

//esto es un device
class NewDevice extends StatefulWidget {
  const NewDevice({Key? key}) : super(key: key);
//Propiedad de Girardot
  @override
  _NewDeviceState createState() => _NewDeviceState();
}

class _NewDeviceState extends State<NewDevice> {
  final _formKey = GlobalKey<FormState>();
  final _deviceNameController = TextEditingController();
  final _locationController = TextEditingController();
  String? _selectedTemplate;
  List<dynamic> _templates = [];
  List<dynamic> _devices = [];
  String? _deviceName;
  String? _location;

  @override
  void initState() {
    super.initState();
    _getTemplates();

  }


  Future<void> _getTemplates() async {
    var box = await Hive.openBox(tokenBox);
    final token = box.get("token") as String?;

    final url = Uri.parse('http://127.0.0.1:8000/user/template/');
    final response = await http.get(url,headers:  {'Authorization': 'Token $token'},);

    if (response.statusCode == 200) {
      setState(() {
        _templates = json.decode(response.body);
      });
    } else {
      throw Exception('Failed to load templates');
    }
  }

  @override
  void dispose() {
    _deviceNameController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  Future<void> _getDevices() async {
    var box = await Hive.openBox(tokenBox);
    final token = box.get("token") as String?;
    final url = Uri.parse('http://127.0.0.1:8000/user/devices/');
    final response = await http.get(url, headers: {'Authorization': 'Token $token'},);

    if (response.statusCode == 200) {
      setState(() {
        _devices = json.decode(response.body);
      });
    } else {
      throw Exception('Failed to load devices');
    }
  }

  void _saveDevice() async {
    var box = await Hive.openBox(tokenBox);
    final token = box.get("token") as String?;
    if (_deviceNameController.text.isNotEmpty) {
      final url = Uri.parse('http://127.0.0.1:8000/user/devices/');

      String? templateId;

      if (_selectedTemplate != null) {
        // Busca el template seleccionado en la lista de templates para obtener su ID
        final selectedTemplate = _templates.firstWhere((template) => template['name'] == _selectedTemplate);
        templateId = selectedTemplate['id'].toString();
      }

      final response = await http.post(url, body: {
        'name': _deviceNameController.text,
        'template': templateId, // Incluye el ID del template seleccionado en el body
        'location': _locationController.text,
      }, headers:{'Authorization': 'Token $token'}, );

      if (response.statusCode == 201) {
        setState(() {
          _deviceName = _deviceNameController.text;
          _location = _locationController.text;
        });
        Navigator.of(context).pop(true);

        // Actualiza la lista de dispositivos después de guardar el dispositivo
        await _getDevices();
      } else {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Error'),
              content: const Text('Failed to save device'),
              actions: <Widget>[
                TextButton(
                  child: const Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      }
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
              padding: const EdgeInsets.all(10),
              child: SizedBox(
                width: 900,
                height: 500,
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      const Text(
                        'New Device',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18.0,
                        ),
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'Create new device by filling in the form below',
                        style: TextStyle(
                          fontSize: 16.0,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'TEMPLATE',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14.0, // Se ha cambiado el tamaño a 14.0
                        ),
                      ),
                      const SizedBox(height: 12),
                      DropdownButtonFormField<String>(
                        decoration: const InputDecoration(
                          labelText: 'Choose template',
                          border: OutlineInputBorder(),
                        ),
                        value: _selectedTemplate,
                        items: _templates
                            .map((template) => DropdownMenuItem<String>(
                          value: template['name'],
                          child: Text(template['name']),
                        ))
                            .toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedTemplate = value;
                          });
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please select a device template';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'DEVICE NAME',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14.0, // Se ha cambiado el tamaño a 14.0
                        ),
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _deviceNameController,
                        decoration: const InputDecoration(
                          labelText: 'Device Name',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a device name';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'LOCATION',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14.0, // Se ha cambiado el tamaño a 14.0
                        ),
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _locationController,
                        decoration: const InputDecoration(
                          labelText: 'Location',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a location';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 12),
                      /*ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _saveDevice();
                      }
                    },
                    child: const Text('Save'),
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
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color.fromRGBO(0, 191, 174, 1),
                            ),
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                _saveDevice();
                              }
                            },
                            child: const Text('Save'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ));
  }
}



