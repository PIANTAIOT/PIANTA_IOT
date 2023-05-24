import 'package:flutter/material.dart';
import 'package:pianta/Home/proyecto.dart';
import 'package:pianta/register/forgot_password.dart';
import 'package:pianta/register/signup.dart';
import '../api_login.dart';
import '../user_models.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  //contrasena
  bool _showPassword = false; // Indica si se debe mostrar la contraseña o no
  final _keyForm = GlobalKey<FormState>(); // Clave global para el estado del formulario

  TextEditingController emailController = TextEditingController(); // Controlador para el campo de texto del correo electrónico
  TextEditingController passwordController = TextEditingController(); // Controlador para el campo de texto de la contraseña

/*
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

 */
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
                          fit: BoxFit.cover,
                          width: 350,
                        ),
                      ],
                    ),
                    Container(
                      width: 410,
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
                              Text('LOG IN',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 28,
                                  ),
                                  textAlign: TextAlign.center)
                            ],
                          ),
                          //email usuario
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: const [
                              Text(
                                'EMAIL',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                            ],
                          ),
                          TextFormField(
                            controller: emailController, // Controlador para el campo de texto del correo electrónico
                            validator: (valor) {
                              String pattern =
                                  r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                              RegExp regExp = new RegExp(pattern);
                              if (valor!.length == 0) {
                                return 'Plase input your email'; // Mensaje de error si no se ingresa ningún correo electrónico
                              } else if (!regExp.hasMatch(valor)) {
                                return 'your email is not valid'; // Mensaje de error si el formato del correo electrónico no es válido
                              }
                              return null; // Validación exitosa
                            },
                            decoration: const InputDecoration(
                              prefixIcon: Icon(Icons.email), // Icono de correo electrónico en el campo de texto
                              border: OutlineInputBorder(), // Borde del campo de texto
                            ),
                          ),
                          const SizedBox(height: 20.0), // Espacio vertical entre los campos de texto

                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: const [
                              Text(
                                'PASSWORD',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              )
                            ],
                          ),
// Este TextFormField se utiliza para ingresar la contraseña del usuario
                          TextFormField(
                            // Validación de la contraseña
                            controller: passwordController, // Controlador para el campo de texto de la contraseña
                            validator: (valor) {
                              RegExp regex = RegExp(
                                  r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');
                              if (valor!.isEmpty) {
                                return 'A password is required to log in'; // Mensaje de error si no se ingresa ninguna contraseña
                              } else if (valor!.length < 8) {
                                return 'your password is too short it must have at least 8 characters'; // Mensaje de error si la contraseña es demasiado corta
                              } else if (valor?.trim()?.isEmpty ?? true) {
                                return 'your password must have digits'; // Mensaje de error si la contraseña no contiene dígitos
                              }
                              return null; // Validación exitosa
                            },
                            decoration: InputDecoration(
                              prefixIcon: Icon(Icons.lock), // Icono de candado en el campo de texto
                              border: OutlineInputBorder(), // Borde del campo de texto
                              suffixIcon: GestureDetector(
                                child: Icon(_showPassword == false
                                    ? Icons.visibility_off
                                    : Icons.visibility), // Icono de visibilidad de la contraseña
                                onTap: () {
                                  setState(() {
                                    _showPassword = !_showPassword; // Cambiar el estado para mostrar/ocultar la contraseña
                                  });
                                },
                              ),
                            ),
                            obscureText: _showPassword == false ? true : false, // Ocultar o mostrar la contraseña según el estado
                          ),

                          const SizedBox(height: 25.0), // Espacio vertical
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              TextButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                      const forgot_password(),
                                    ),
                                  );
                                },
                                child: const Text(
                                  'Forgot Password?', // Texto que se mostrará en el botón
                                  style: TextStyle(
                                    fontWeight: FontWeight.normal,
                                    fontSize: 22,
                                    color: Color.fromRGBO(122, 146, 233, 1), // Color del texto
                                  ),
                                ),
                              )
                            ],
                          ),
                          const SizedBox(height: 25.0), // Espacio vertical

                          //boton para iniciar proyecto
                          /*Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              if (_keyForm.currentState!.validate()) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const Home(),
                                  ),
                                );
                              } else {
                                print(
                                    'An error has occurred, check your email or password');
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              minimumSize: Size(350, 70),
                              backgroundColor: Color.fromRGBO(0, 191, 174, 1),
                            ),
                            child: const Text(
                              'LOG IN',
                              style: TextStyle(
                                fontSize: 20,
                              ),
                            ),
                          ),
                        ],
                      ),

                       */
                          ConstrainedBox(
                            constraints: const BoxConstraints(
                              minWidth: double.infinity,
                              minHeight: 70,
                            ),
                            child: ElevatedButton(
                              onPressed: () async {
                                var authRes = await userAuth(emailController.text, passwordController.text);
                                if (authRes.runtimeType == String && _keyForm.currentState!.validate()) {
                                  // Mostrar diálogo de error si no se puede iniciar sesión con las credenciales proporcionadas
                                  showDialog(
                                    context: context,
                                    builder: (_) => AlertDialog(
                                      title: Text('Error'),
                                      content: Text('Unable to log in with provided credentials'),
                                      actions: [
                                        TextButton(
                                          onPressed: () => Navigator.pop(context),
                                          child: Text('OK'),
                                        ),
                                      ],
                                    ),
                                  );
                                } else if (authRes.runtimeType == User) {
                                  User user = authRes;
                                  // Iniciar sesión exitosa, navegar a la pantalla de proyectos
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const Proyectos(),
                                    ),
                                  );
                                } else {
                                  print('An error has occurred, check your email or password'); // Mensaje de error en la consola
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color.fromRGBO(0, 191, 174, 1),
                              ),
                              child: const Text(
                                'LOG IN',
                                style: TextStyle(
                                  fontSize: 20,
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 25.0),

                          Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => const SignUp(),
                                      ),
                                    );
                                  },
                                  child: const Text(
                                    'Create new account',
                                    style: TextStyle(
                                        fontWeight: FontWeight.normal,
                                        fontSize: 22,
                                        color: Color.fromRGBO(122, 146, 233, 1)),
                                  ), // El texto que se mostrará en el botón
                                )
                              ]),
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
