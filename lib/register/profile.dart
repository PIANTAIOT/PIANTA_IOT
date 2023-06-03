import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:pianta/register/create_password.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'login.dart';

class profile extends StatefulWidget {
  const profile({Key? key}) : super(key: key);

  @override
  State<profile> createState() => _profileState();
}

class _profileState extends State<profile> {
  final _keyForm = GlobalKey<FormState>();
  TextEditingController usernames = TextEditingController();

  void _saveUsername(String username) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('username', username);
  }
  Future<void> _checkEmailExists(String username, String email) async {


    final response = await http.post(
      Uri.parse('http://127.0.0.1:8000/user/auth/RegisterView/'),
      body: {
        'email': email,
        'username': username,
      },
    );
    if (response.statusCode == 409) {
      // El username ya está registrado
      final jsonResponse = jsonDecode(response.body);
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text('Error'),
          content: Text('The user is already registered'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('OK'),
            ),
          ],
        ),
      );
    } else if (response.statusCode == 400) {
      final jsonResponse = jsonDecode(response.body);
      if (jsonResponse['username'] != null) {
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: Text('Error'),
            content: Text(jsonResponse['username'][0]),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('OK'),
              ),
            ],
          ),
        );
      }
    } else {
      // El username no está registrado
      _saveUsername(username);
      createUser(context);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const Login(),
        ),
      );

    };
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
          child: Form(
            key: _keyForm,
            child: Center(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'images/Logotipo_pianta.png',
                          width: 350,
                        ),
                      ],
                    ),
                    Container(
                      width: 450,
                      height: 500,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.black26,
                          width: 2.0,
                        ),
                      ),
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Text('Profile',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 28,
                                  ),
                                  textAlign: TextAlign.center)
                            ],
                          ),
                          const SizedBox(height: 20.0),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Flexible(
                                flex: 1,
                                child: Text(
                                  'Fill in information your personal data',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 22,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              SizedBox(height: 10),
                            ],
                          ),

                          const SizedBox(height: 30.0),
                          //se pone el nombre de ususario a registar
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: const [
                              Text(
                                'FIRST NAME',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              )
                            ],
                          ),
                          //se poner el nombre de ususario
                          TextFormField(
                            controller: usernames,
                            validator: (valor) {
                              if (valor!.isEmpty ||
                                  !RegExp(r'^[a-z A-Z]+$').hasMatch(valor)) {
                                //allow upper and lower case alphabets and space
                                return "Please enter your name";
                              } else if( valor?.trim()?.isEmpty ?? true){
                                return 'your password must have digits';
                              } else{
                                return null;
                              }

                            },
                            decoration:
                            const InputDecoration(border: OutlineInputBorder()),
                          ),
                          const SizedBox(height: 25.0),
                          const SizedBox(height: 25.0),
                          const SizedBox(height: 25.0),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                        const create_password(),
                                      ),
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    primary: Colors.white,
                                    onPrimary:
                                    const Color.fromRGBO(122, 146, 233, 1),
                                  ),
                                  child: const Text(
                                    'Back to password creation',
                                    style: TextStyle(
                                      fontSize: 18,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: () async {
                                    if (_keyForm.currentState!.validate()) {
                                      final prefs = await SharedPreferences.getInstance();
                                      final storedEmail = prefs.getString('email');
                                      _checkEmailExists(usernames.text, storedEmail!);

/*
                                  final prefs = await SharedPreferences.getInstance();
                                  final storedEmail = prefs.getString('email');
                                  final storedUsername = prefs.getString('username');
                                  final storedPassword = prefs.getString('password');

*/
                                      //User? user = await createUser(context, storedPassword!, storedUsername!, storedEmail!);


                                      // Si el usuario se creó correctamente, navegar a la pantalla Home
                                      /*
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => const Login(),
                                      ),
                                    );

                                   */
                                    } else {
                                      print('Error creating user');
                                    }

                                  },
                                  style: ElevatedButton.styleFrom(
                                    primary: const Color.fromRGBO(0, 191, 174, 1),
                                  ),
                                  child: const Text(
                                    'Done',
                                    style: TextStyle(
                                      fontSize: 28,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 25.0),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}
@override
void createUser(BuildContext context) async {
  final prefs = await SharedPreferences.getInstance();
  final storedEmail = prefs.getString('email');
  final storedPassword = prefs.getString('password');
  final storedUsername = prefs.getString('username');
  try {
    final response = await http.post(
      Uri.parse('http://127.0.0.1:8000/user/auth/RegisterView/'),
      body: {
        'email': storedEmail,
        'username': storedUsername,
        'password': storedPassword,
      },
    );
    //response.statusCode == 200 ||
    if ( response.statusCode == 201) {
      // Navegar a la pantalla Home
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Login()),
      );
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('User created successfully')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred while creating the user')),
      );
    }
  } catch (e) {
    print(e);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error: ${e.toString()}')),
    );
  }
  await prefs.remove('email');
  await prefs.remove('password');
  await prefs.remove('username');
  Navigator.pop(context);
}
/*
@override
Future<User?> createUser(BuildContext context, String email, String username, String password) async {
  final prefs = await SharedPreferences.getInstance();
  final storedEmail = prefs.getString('email');
  final storedPassword = prefs.getString('password');
  final storedUsername = prefs.getString('username');
  if (storedEmail == null || storedPassword == null || storedUsername == null) {
    // Alguno de los valores es nulo, manejar el caso adecuadamente
    return null;
  }
  Map<String, dynamic> data = {
    'email': storedEmail,
    'username': storedUsername,
    'password': storedPassword,
  };

  var url = Uri.parse("http://127.0.0.1:8000/user/auth/RegisterView/");
  var res = await http.post(url, body: data);
  if (res.statusCode == 201) {
    Map json = jsonDecode(res.body);

    if (json.containsKey("key")) {
      String token = json["key"];
      var box = await Hive.openBox(tokenBox);
      box.put("token", token);
      var a = await getUser(token);
      if (a != null) {
        User user = a;
        // Navegar a la pantalla Home
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const Home(),
          ),
        );
        return user;
      } else {
        return null;
      }
    }
  } else if (res.statusCode == 400) {
    Map json = jsonDecode(res.body);
    if (json.containsKey("email")) {
      return json["email"][0];
    } else if (json.containsKey("password")) {
      return json["password"][0];
    }
  } else {
    print(res.body);
    print(res.statusCode);
    return null;
  }
  await prefs.remove('email');
  await prefs.remove('password');
  await prefs.remove('username');
  return null;
}
*/

/*
void createUser(BuildContext context) async {
  final prefs = await SharedPreferences.getInstance();
  final storedEmail = prefs.getString('email');
  final storedPassword = prefs.getString('password');
  final storedUsername = prefs.getString('username');
  try {
    final response = await http.post(
      Uri.parse('http://127.0.0.1:8000/user/auth/RegisterView/'),
      body: {
        'email': storedEmail,
        'username': storedUsername,
        'password': storedPassword,
      },
    );
    //response.statusCode == 200 ||
    if ( response.statusCode == 201) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Usuario creado exitosamente.')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Hubo un error al crear el usuario.')),
      );
    }
  } catch (e) {
    print(e);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error: ${e.toString()}')),
    );
  }
  await prefs.remove('email');
  await prefs.remove('password');
  await prefs.remove('username');
  Navigator.pop(context);
}
 */


/*
  try {
    final response = await http.post(
      Uri.parse('http://127.0.0.1:8000/user/auth/UserCreateAPIView/'),
      body: {
        'email': email,
        'username': username,
        'password': password,
      },
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Usuario creado exitosamente.')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Hubo un error al crear el usuario.')),
      );
    }
  } catch (e) {
    print(e);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error: ${e.toString()}')),
    );
  }
  */
