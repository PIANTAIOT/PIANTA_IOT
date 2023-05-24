import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

//esto es un device
class NewDevice extends StatefulWidget {
  const NewDevice({Key? key}) : super(key: key);

  @override
  _NewDeviceState createState() => _NewDeviceState();
}

class _NewDeviceState extends State<NewDevice> {
  // Definición de claves y controladores necesarios
  final _formKey = GlobalKey<FormState>(); // Clave global para el formulario
  final _deviceNameController = TextEditingController(); // Controlador para el campo de nombre de dispositivo
  final _locationController = TextEditingController(); // Controlador para el campo de ubicación del dispositivo

  String? _selectedTemplate; // Plantilla seleccionada (puede ser nulo)
  List<dynamic> _templates = []; // Lista de plantillas (inicialmente vacía)
  List<dynamic> _devices = []; // Lista de dispositivos (inicialmente vacía)
  String? _deviceName; // Nombre del dispositivo (puede ser nulo)
  String? _location; // Ubicación del dispositivo (puede ser nulo)

  @override
  void initState() {
    super.initState();
    _getTemplates(); // Obtener las plantillas al iniciar el estado
  }

// Método asincrónico para obtener las plantillas
  Future<void> _getTemplates() async {
    final url = Uri.parse('http://127.0.0.1:8000/user/template/'); // URL de la API para obtener las plantillas
    final response = await http.get(url); // Realizar una solicitud GET a la URL

    if (response.statusCode == 200) {
      setState(() {
        _templates = json.decode(response.body); // Decodificar el cuerpo de la respuesta JSON y asignarlo a la lista de plantillas
      });
    } else {
      throw Exception('Failed to load templates'); // Si la solicitud no fue exitosa, lanzar una excepción
    }
  }

  @override
  // Liberar los recursos utilizados por los controladores al descartar el widget
  void dispose() {
    _deviceNameController.dispose(); // Liberar el controlador del nombre del dispositivo
    _locationController.dispose(); // Liberar el controlador de la ubicación del dispositivo
    super.dispose();
  }

// Obtener la lista de dispositivos desde la API
  Future<void> _getDevices() async {
    final url = Uri.parse('http://127.0.0.1:8000/user/devices/'); // URL de la API para obtener los dispositivos
    final response = await http.get(url); // Realizar una solicitud GET a la URL

    if (response.statusCode == 200) {
      setState(() {
        _devices = json.decode(response.body); // Decodificar el cuerpo de la respuesta JSON y asignarlo a la lista de dispositivos
      });
    } else {
      throw Exception('Failed to load devices'); // Si la solicitud no fue exitosa, lanzar una excepción
    }
  }

// Guardar el dispositivo actual
  void _saveDevice() async {
    if (_deviceNameController.text.isNotEmpty) { // Verificar que el campo de nombre de dispositivo no esté vacío
      final url = Uri.parse('http://127.0.0.1:8000/user/devices/'); // URL de la API para guardar el dispositivo

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
      });
// Verificar si el dispositivo se guardó exitosamente
      if (response.statusCode == 201) {
        setState(() {
          _deviceName = _deviceNameController.text; // Actualizar el nombre del dispositivo con el valor ingresado
          _location = _locationController.text; // Actualizar la ubicación del dispositivo con el valor ingresado
        });
        Navigator.of(context).pop(true); // Cerrar la pantalla actual y volver a la pantalla anterior

// Actualizar la lista de dispositivos después de guardar el dispositivo
        await _getDevices();
      } else {
// Mostrar un diálogo de error en caso de que no se pueda guardar el dispositivo
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
                  key: _formKey, // Clave única para identificar el formulario
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      const Text(
                        'New Device', // Título "New Device" en negrita con tamaño de fuente 18
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18.0,
                        ),
                      ),
                      const SizedBox(height: 12), // Espacio vertical de 12 píxeles
                      const Text(
                        'Create new device by filling in the form below', // Texto explicativo en color gris con tamaño de fuente 16
                        style: TextStyle(
                          fontSize: 16.0,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 12), // Espacio vertical de 12 píxeles
                      const Text(
                        'TEMPLATE', // Título "TEMPLATE" en negrita con tamaño de fuente 14
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14.0,
                        ),
                      ),
                      const SizedBox(height: 12), // Espacio vertical de 12 píxeles
                      DropdownButtonFormField<String>(
                        decoration: const InputDecoration(
                          labelText: 'Choose template', // Etiqueta para el campo de selección
                          border: OutlineInputBorder(), // Apariencia de un borde alrededor del campo
                        ),
                        value: _selectedTemplate, // Valor actualmente seleccionado en el campo de selección
                        items: _templates.map((template) => DropdownMenuItem<String>(
                          value: template['name'], // Valor del elemento de la lista desplegable
                          child: Text(template['name']), // Texto que se muestra para el elemento de la lista desplegable
                        )).toList(),
                        onChanged: (value) { // Función que se ejecuta cuando se cambia la selección en el campo de selección
                          setState(() {
                            _selectedTemplate = value; // Actualiza la variable _selectedTemplate con el valor seleccionado
                          });
                        },
                        validator: (value) { // Función de validación que se ejecuta al enviar el formulario
                          if (value == null || value.isEmpty) {
                            return 'Please select a device template'; // Mensaje de error si no se ha seleccionado un valor válido
                          }
                          return null; // Retorna null si el valor es válido
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
                        controller: _deviceNameController, // Controlador para el campo de texto
                        decoration: const InputDecoration(
                          labelText: 'Device Name', // Etiqueta para el campo de texto
                          border: OutlineInputBorder(), // Apariencia de un borde alrededor del campo
                        ),
                        validator: (value) { // Función de validación que se ejecuta al enviar el formulario
                          if (value == null || value.isEmpty) {
                            return 'Please enter a device name'; // Mensaje de error si el campo está vacío
                          }
                          return null; // Retorna null si el valor es válido
                        },
                      ),
                      const SizedBox(height: 12), // Espacio vertical de 12 píxeles
                      const Text(
                        'LOCATION', // Título "LOCATION" en negrita con tamaño de fuente 14
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14.0,
                        ),
                      ),
                      const SizedBox(height: 12), // Espacio vertical de 12 píxeles
                      TextFormField(
                        controller: _locationController, // Controlador para el campo de texto
                        decoration: const InputDecoration(
                          labelText: 'Location', // Etiqueta para el campo de texto
                          border: OutlineInputBorder(), // Apariencia de un borde alrededor del campo
                        ),
                        validator: (value) { // Función de validación que se ejecuta al enviar el formulario
                          if (value == null || value.isEmpty) {
                            return 'Please enter a location'; // Mensaje de error si el campo está vacío
                          }
                          return null; // Retorna null si el valor es válido
                        },
                      ),
                      const SizedBox(height: 12), // Espacio vertical de 12 píxeles

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



