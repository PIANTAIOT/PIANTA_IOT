import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:pianta/Home/settings.dart';
import 'package:pianta/register/forgot_password.dart';
import 'package:http/http.dart' as http;
import '../api_login.dart';
import '../constants.dart';

//clase creada para el alert de editar información
class EditInformation extends StatefulWidget {
  const EditInformation({Key? key}) : super(key: key);

  @override
  State<EditInformation> createState() => _EditInformationState();
}

class _EditInformationState extends State<EditInformation> {
  String? _username;
  String? _email;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();

  final _keyForm = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _loadUsernameAndLastLogin();
  }

  Future<void> _loadUsernameAndLastLogin() async {
    try {
      var box = await Hive.openBox(tokenBox);
      final token = box.get("token") as String?;
      final username = await getUsername(token!);
      final email = await getEmail(token);
      setState(() {
        _username = username;
        _email = email;
        emailController.text = email ?? '';
        usernameController.text = username ?? '';
      });
    } catch (e) {
      print('Failed to load username, email and last login: $e');
    }
  }

  Future<void> updateUserProfile(
      String username, String email, BuildContext context) async {
    final url = Uri.parse('http://127.0.0.1:8000/user/auth/user/edit/');
    final box = await Hive.openBox(tokenBox);
    final token = box.get('token') as String?;

    final response = await http.put(
      url,
      headers: {
        'Authorization': 'Token $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'username': usernameController.text,
        'email': emailController.text,
      }),
    );
    if (response.statusCode == 200) {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text('User'),
          content: Text('Edit user succesfull!'),
          actions: [
            TextButton(
              onPressed: () => Navigator.push(
                  context, MaterialPageRoute(builder: (context) => Settings())),
              child: Text('OK'),
            ),
          ],
        ),
      );
      return json.decode(response.body);

    } else if (response.statusCode == 400) {
      // mostrar diálogo de error
      print(response.body);
      final jsonResponse = json.decode(response.body) as Map<String, dynamic>;
      final errorMap = jsonResponse;
      final errorField = errorMap.keys.first;
      final errorMessage = errorMap[errorField][0] as String;
      final message = "$errorField: $errorMessage";
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text('Error'),
          content: Text(message ?? 'Failed to update user profile.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('OK'),
            ),
          ],
        ),
      );
      throw Exception('Failed to update user profile.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: Form(
      key: _keyForm,
      child: Card(
        elevation: 4.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: SizedBox(
            width: 350,
            height: 400,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16.0),
                  const Text(
                    'User Profile',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18.0,
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  Text(
                    'Name: ',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14.0,
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  TextFormField(
                    //initialValue: _username ?? '',
                    controller: usernameController,
                    validator: (valor) {
                      if (valor!.isEmpty ||
                          !RegExp(r'^[a-z A-Z]+$').hasMatch(valor)) {
                        //allow upper and lower case alphabets and space
                        return "Please enter your name";
                      } else if (valor?.trim()?.isEmpty ?? true) {
                        return 'your password must have digits';
                      } else {
                        return null;
                      }
                    },
                    keyboardType: TextInputType.text,
                    //initialValue: _username, // Agregamos el valor inicial aquí
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.person_2_outlined),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            width: 1, color: Colors.grey), //<-- SEE HERE
                      ),
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  const Text(
                    'Email :',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14.0, // Se ha cambiado el tamaño a 14.0
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  TextFormField(
                    //initialValue: _email ?? '',
                    controller: emailController,
                    validator: (valor) {
                      String pattern =
                          r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                      RegExp regExp = new RegExp(pattern);
                      if (valor!.length == 0) {
                        return 'Plase input your email';
                      } else if (!regExp.hasMatch(valor)) {
                        return 'your email is not valid';
                      }
                      return null;
                    },
                    keyboardType: TextInputType.text,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.email_outlined),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            width: 1, color: Colors.grey), //<-- SEE HERE
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                    Padding(
                      //margen de espacio para el boton
                      padding: const EdgeInsets.all(5.0),
                      //boton flotante para el created projectd
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            //accion que llevara a la card del projecto ya creado
                            MaterialPageRoute(
                                builder: (context) => const forgot_password()),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: const Color.fromRGBO(
                                0, 191, 174, 1) // Color de fondo del botón
                            ),
                        //texto que aparecera dentro del boton
                        child: const Text('Reset Password',
                            style: TextStyle(color: Colors.white)),
                      ),
                    )
                  ]),
                  Padding(
                    padding: const EdgeInsets.all(30),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          style: ElevatedButton.styleFrom(
                              minimumSize: const Size(90, 30),
                              backgroundColor:
                                  const Color.fromRGBO(255, 255, 255, 1)),
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
                          onPressed: () async {
                            if (_keyForm.currentState!.validate()) {
                              try {
                                await updateUserProfile(emailController.text,
                                    usernameController.text, context);
                                // ignore: use_build_context_synchronously
                                //Navigator.of(context).pop();
                              } catch (e) {
                                print('Failed to update user profile: $e');
                                // Mostrar mensaje de error aquí
                              }
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size(90, 30),
                            backgroundColor:
                                const Color.fromRGBO(0, 191, 174, 1),
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
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    )));
  }
}
//retorno de un alert
/*body: AlertDialog(
        //titulo inicial del alert
        title: Text('User Profile'),
        content: Column(
          //dimension de la card
          mainAxisSize: MainAxisSize.min,
          children:  [
             Row(
               mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text('NAME', textAlign: TextAlign.left)
                ]
            ),
                  //creacion campo de texto
                  const TextField(
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                    prefixIcon: Icon(Icons.person_2_outlined),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          width: 1, color: Colors.grey), //<-- SEE HERE
                    ),
                  ),
                ),
            const SizedBox(height: 20),
            //segundo subtitulo antes del campo de texto
            Row(
                children: const [
                  Padding(
                    padding: EdgeInsets.all(5),
                      child: Text('EMAIL', textAlign: TextAlign.left)
                  )
                ]
            ),
            //margen de espacio para el campo 2

                //creacion del segundo campo de texto
                const TextField(
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                  prefixIcon: Icon(Icons.email_outlined),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        width: 1, color: Colors.grey), //<-- SEE HERE
                  ),
                ),
              ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  //margen de espacio para el boton
                  padding: const EdgeInsets.all(5.0),
                  //boton flotante para el created projectd
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        //accion que llevara a la card del projecto ya creado
                        MaterialPageRoute(builder: (context) => const reset_passaword()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromRGBO(0, 191, 174, 1) // Color de fondo del botón
                    ),
                    //texto que aparecera dentro del boton
                    child: const Text('Reset Password', style: TextStyle(color:Colors.white)),
                  ),
                )
              ]
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
      ),*/
