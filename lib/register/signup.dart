import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:pianta/register/create_newpassword.dart';
import 'package:pianta/register/login.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {

  late Dio dio;

  @override
  void initState() {
    super.initState();

    // Configuración de la instancia Dio
    BaseOptions options = BaseOptions(
      baseUrl: 'http://127.0.0.1:8000/',
      connectTimeout: 5000,
      receiveTimeout: 5000,
    );
    dio = Dio(options);

    // Configuración de la gestión de cookies
    var cookieJar = CookieJar();
    dio.interceptors.add(CookieManager(cookieJar));
  }

  @override
  void dispose() {
    dio.close();
    super.dispose();
  }

  final TextEditingController emailController = TextEditingController();

  final cookieJar = CookieJar();
  final client = http.Client();

  final _keyForm = GlobalKey<FormState>();



  Future<void> sendRegistrationEmail(String email) async {
    try {
      // Obtener el token CSRF de la cookie
      String token = await _getCsrfToken();

      String url = "http://127.0.0.1:8000/user/auth/send-registration-email/";


// Incluir el valor de la cookie CSRF en los encabezados de la solicitud
      dio.options.headers['X-CSRFToken'] = token;

      var response = await dio.post(url, data: {'email': email});

      if (response.statusCode == 200 ) {
        print('Email sent successfully');
      } else {
        print('Failed to send email: ${response.statusCode}');
      }
    } catch (e) {
      print('Failed to send email: $e');
    }
  }

  Future<String> _getCsrfToken() async {
    List<Cookie> cookies = (await (dio.interceptors
        .firstWhere((interceptor) => interceptor is CookieManager)
    as CookieManager)
        .cookieJar
        .loadForRequest(Uri.parse('${dio.options.baseUrl}/'))) as List<Cookie>;
    return cookies.isNotEmpty ? cookies.first.value : '';
  }

/*
  String _getCsrfToken() {
    List<Cookie> cookies = dio.interceptors
        .whereType<CookieManager>()
        .first
        .cookieJar
        .loadForRequest(Uri.parse('${dio.options.baseUrl}/')); // agrega una barra diagonal al final de la URL
    return cookies.isNotEmpty ? cookies.first.value : '';
  }
*/
  final TextEditingController codeController = TextEditingController();
  Future<void> validateRegistrationToken(
      BuildContext context, String token) async {
    final url = Uri.parse('http://127.0.0.1:8000/user/auth/validate_token/');
    final headers = {'Content-Type': 'application/json'};
    final body = jsonEncode({'token': token});
    try {
      final response = await http.post(url, headers: headers, body: body);
      final data = jsonDecode(response.body);
      if (response.statusCode == 200 && data['success']) {
        Navigator.of(context).pop();
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => create_password1(),
          ),
        );
      } else if (response.statusCode == 200 && !data['success']) {
        final message = data['message'];
        if (message == 'the token has expired') {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Expired code'),
                content: Text(
                    'The verification code has expired. Please try again by pressing the "Sign up" button'),
                actions: <Widget>[
                  TextButton(
                    child: Text('OK'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            },
          );
        } else {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Invalid code'),
                content: Text('Try again'),
                actions: <Widget>[
                  TextButton(
                    child: Text('OK'),
                    onPressed: () {
                      Navigator.of(context).pop();
                      //_showTokenDialog(context);
                    },
                  ),
                ],
              );
            },
          );
        }
      } else {
        throw Exception('Failed to validate registration token');
      }
    } catch (e) {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${e.toString()}'),
        ),
      );
    }
  }

  void _showTokenDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
              'Enter the verification code that we sent to your email'),
          content: TextField(
            controller: codeController,
            decoration: const InputDecoration(
              hintText: 'Enter the code',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () async {
                final String token = codeController.text.trim();
                if (token.isNotEmpty) {
                  //Navigator.of(context).pop();
                  await validateRegistrationToken(context, token);
                } else {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title:
                        Text('Please enter the verification code'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(
                                  context, true); // Cerrar el diálogo actual
                              //_showTokenDialog(context); // Volver a abrir el diálogo
                            },
                            child: Text('Ok'),
                          ),
                        ],
                      );
                    },
                  );
                }
              },
              child: const Text('Validate'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Cerrar el diálogo actual
              },
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  void _saveEmail(String email) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('email', email);
  }
/*
  Future<void> _submitForm() async {
    final email = _emailController.text.trim();
    //final otp = _otpController.text.trim();
/*
    try {
      await sendOtp(email);
      // muestra un mensaje de éxito
    } catch (e) {
      // muestra un mensaje de error
    }
*/
    // Envía el correo electrónico y el código OTP al servidor para la autenticación
  }
*/
  //TextEditingController comfirmPassword = TextEditingController();
  Future<void> _checkEmailExists(String email) async {
    final response = await http.post(
      Uri.parse('http://127.0.0.1:8000/user/auth/RegisterView/'),
      body: {
        'email': email,
      },
    );
    if (response.statusCode == 409) {
      // El correo ya está registrado
      final jsonResponse = jsonDecode(response.body);
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text('Error'),
          content: Text('The email is already registered'),
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
      if (jsonResponse['email'] != null) {
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: Text('Error'),
            content: Text(jsonResponse['email'][0]),
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
      // El correo no está registrado
      sendRegistrationEmail(email);
      _showTokenDialog(context);
      _saveEmail(email);
    }
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
                          width: 450.0,
                          height: 500.0,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.black26,
                              width: 2.0,
                            ),
                          ),
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            // ignore: prefer_const_literals_to_create_immutables
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  Text('LOG IN',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 38,
                                      ),
                                      textAlign: TextAlign.center)
                                ],
                              ),
                              const SizedBox(height: 20.0),
                              //creacion un nuevo contraseña
                              Wrap(
                                alignment: WrapAlignment.center,
                                children: const [
                                  Flexible(
                                    flex: 1,
                                    child: Text(
                                      'Welcome! Fill in your email address and we will',
                                      style: TextStyle(
                                        fontWeight: FontWeight.normal,
                                        fontSize: 19,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 10),
                              Wrap(
                                alignment: WrapAlignment.center,
                                children: const [
                                  Flexible(
                                    flex: 1,
                                    child: Text(
                                      'send an account activation link.',
                                      style: TextStyle(
                                        fontWeight: FontWeight.normal,
                                        fontSize: 19,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 20.0),
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
                                controller: emailController,
                                validator: (valor) {
                                  String pattern =
                                      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                                  RegExp regExp = RegExp(pattern);
                                  if (valor!.length == 0) {
                                    return 'Plase input your email';
                                  } else if (!regExp.hasMatch(valor)) {
                                    return 'your email is not valid';
                                  }
                                  return null;
                                },
                                decoration: const InputDecoration(
                                  prefixIcon: Icon(Icons.email),
                                  border: OutlineInputBorder(),
                                ),
                              ),
                              const SizedBox(height: 20.0),

                              const SizedBox(height: 25.0),
                              ConstrainedBox(
                                constraints: const BoxConstraints(
                                  minWidth: double.infinity,
                                  minHeight: 50,
                                ),
                                child: ElevatedButton(
                                  onPressed: () {
                                    if (_keyForm.currentState!.validate()) {
                                      _checkEmailExists(emailController.text);
/*
                              sendRegistrationEmail(emailController.text);
                              _showTokenDialog(context);
                              _saveEmail(emailController.text);

 */
                                      /*Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const create_password1(),
                                ),
                              );*/
                                    } else {
                                      print(
                                          'An error has occurred, check your email or password');
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Color.fromRGBO(0, 191, 174, 1),
                                  ),
                                  child: const Text(
                                    'Sign up',
                                    style: TextStyle(
                                      fontSize: 28,
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
                                            builder: (context) => const Login(),
                                          ),
                                        );
                                      },

                                      child: const Text(
                                        'Back to Login?',
                                        style: TextStyle(
                                            fontWeight: FontWeight.normal,
                                            fontSize: 22,
                                            color: Color.fromRGBO(122, 146, 233, 1)),
                                      ), // El texto que se mostrará en el botón
                                    )
                                  ])
                            ],
                          ),
                        )
                      ],
                    ),
                  ))),
        ));
  }
}


