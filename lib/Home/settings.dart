import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:pianta/register/login.dart';
import 'package:pianta/Funciones/edit_setting.dart';
import 'package:pianta/Funciones/constantes.dart';
import '../api_login.dart';
import '../constants.dart';

//clase creada para la pantalla de configuracion
class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  State<Settings> createState() => _SettingsState();
}



class _SettingsState extends State<Settings> {
  String? _username;
  String? _email;
  String? _lastLogin;

  @override
  void initState() {
    super.initState();
    _loadUsernameAndLastLogin(); // Cargar el nombre de usuario y el último inicio de sesión al iniciar el estado
  }

  Future<void> _loadUsernameAndLastLogin() async {
    try {
      var box = await Hive.openBox(tokenBox); // Abrir la caja de Hive
      final token = box.get("token") as String?; // Obtener el token almacenado en la caja
      final username = await getUsername(token!); // Obtener el nombre de usuario utilizando el token
      final lastLogin = await getLastLogin(token); // Obtener el último inicio de sesión utilizando el token
      final email = await getEmail(token); // Obtener el correo electrónico utilizando el token
      setState(() {
        _username = username; // Actualizar el nombre de usuario en el estado
        _email = email; // Actualizar el correo electrónico en el estado
        _lastLogin = lastLogin != null ? DateTime.parse(lastLogin).toString() : null; // Actualizar el último inicio de sesión en el estado
      });
    } catch (e) {
      print('Failed to load username, email and last login: $e'); // Mostrar un mensaje de error si falla la carga de nombre de usuario, correo electrónico y último inicio de sesión
    }
  }

  Future<void> _logout() async {
    try {
      var box = await Hive.openBox(tokenBox); // Abrir la caja de Hive
      final token = box.get("token") as String?; // Obtener el token almacenado en la caja
      await logOut(token!); // Realizar el cierre de sesión utilizando el token
      box.close(); // Cerrar la caja de Hive
    } catch (e) {
      print('Failed to logout: $e'); // Mostrar un mensaje de error si falla el cierre de sesión
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Row(
            children: [
              const SizedBox(
                width: 100,
                child: Navigation(title: 'nav', selectedIndex: 2 /* Fundamental SelectIndex para que funcione el selector*/),
              ),
              Expanded(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Padding(
                              padding: EdgeInsets.all(16.0),
                              // Texto al inicio de la página que muestra el nombre de usuario
                              child: Text(
                                _username ?? '', // Mostrar el nombre de usuario almacenado en el estado, si está disponible
                                textAlign: TextAlign.center,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
                              ),
                            ),
                            // Icono que funciona como botón y permite abrir un diálogo
                            InkWell(
                              child: Icon(Icons.list, size: 50), // Icono deseado
                              onTap: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      content: Container(
                                        width: MediaQuery.of(context).size.width * 0.3,
                                        height: MediaQuery.of(context).size.height * 0.8,
                                        child: Column(
                                          children: [
                                            Expanded(child: EditInformation()), // Contenido del diálogo
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                );
                              },
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.all(19.0),
                          // Botón para cerrar sesión
                          child: ElevatedButton(
                            onPressed: () async {
                              await _logout(); // Realizar el cierre de sesión
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => Login()), // Navegar a la pantalla de inicio de sesión después de cerrar sesión
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              primary: Colors.white, // Color de fondo del botón
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Icon(Icons.logout, color: Colors.black),
                                SizedBox(width: 5),
                                Text('Log Out', style: TextStyle(color: Colors.black)),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  const Divider(
                    color: Colors.black26, //color of divider
                    height: 2, //height spacing of divider
                    thickness: 1, //thickness of divier line
                    indent: 15, //spacing at the start of divider
                    endIndent: 0, //spacing at the end of divider
                  ),
                  Row(
                    //mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Column(
                          children: [
                            Container(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'EMAIL : ',
                                    textAlign: TextAlign.left,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
                                  ),
                                  Text(
                                    _email ?? '',
                                    style: TextStyle( fontSize: 30),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          children: [
                            Container(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'LAST LOGIN : ',
                                    textAlign: TextAlign.left,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
                                  ),
                                  Text(
                                    _lastLogin ?? '',
                                    style: TextStyle( fontSize: 30),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            )
          ]
        )
    );
  }
}

