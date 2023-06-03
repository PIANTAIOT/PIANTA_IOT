import 'package:flutter/material.dart';
import 'package:pianta/register/mensaje.dart';
import 'login.dart';

class reset_passaword extends StatefulWidget {
  const reset_passaword({Key? key}) : super(key: key);

  @override
  State<reset_passaword> createState() => _reset_passawordState();
}
class _reset_passawordState extends State<reset_passaword> {
  final _keyForm = GlobalKey<FormState>();
  bool _showPassword = false;

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
                              Text('Create Password',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 28,
                                  ),
                                  textAlign: TextAlign.center)
                            ],
                          ),
                          const SizedBox(height: 20.0),
                          Wrap(
                            alignment: WrapAlignment.center,
                            children: const [
                              Flexible(
                                flex: 1,
                                child: Text(
                                  'Create a password which is hard to guess.',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 22,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 50.0),
                          //se pone el nombre de ususario a registar
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
                          //se ponber el nombre de ususario
                          TextFormField(
                            //validacion email
                            validator: (valor) {
                              RegExp regex = RegExp(
                                  r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');
                              if (valor!.isEmpty) {
                                return 'A password is required to log in';
                              } else if (valor!.length < 8) {
                                return 'your password is too short it must have at least 8 characters';
                              }else if( valor?.trim()?.isEmpty ?? true){
                                return 'your password must have digits';
                              }
                              return null;
                            },

                            decoration: InputDecoration(
                                prefixIcon: Icon(Icons.lock),
                                border: OutlineInputBorder(),
                                suffixIcon: GestureDetector(
                                  child: Icon(_showPassword == false
                                      ? Icons.visibility_off
                                      : Icons.visibility),
                                  onTap: () {
                                    setState(() {
                                      _showPassword = !_showPassword;
                                    });
                                  },
                                )),
                            obscureText: _showPassword == false ? true : false,
                          ),
                          const SizedBox(height: 10.0),
                          Row(
                            children: const [
                              Text('-Make it at least 8 symbols long'),
                            ],
                          ),
                          const SizedBox(height: 10.0),
                          Row(
                            children: const [
                              Text('Other tips:',
                                  textAlign: TextAlign.center
                              ),
                            ],
                          ),
                          const SizedBox(height: 10.0),
                          Row(
                            children: const [
                              Text('-Use uncommon words'),
                            ],
                          ),
                          const SizedBox(height: 10.0),
                          Row(
                            children: const [
                              Text('-Use non-standard uPPercaSing'),
                            ],
                          ),
                          const SizedBox(height: 10.0),
                          Row(
                            children: const [
                              Text('-Use creative spelling'),
                            ],
                          ),
                          const SizedBox(height: 10.0),
                          Row(
                            children: const [
                              Text('-Use non-obvi0u number & symbo1')
                            ],
                          ),

                          const SizedBox(height: 10.0),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const Login(),
                                    ),
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                    minimumSize: Size(150, 50),
                                    backgroundColor:
                                    Color.fromRGBO(255, 255, 255, 1)),
                                child: const Text(
                                  'Login in',
                                  style: TextStyle(
                                      fontSize: 18,
                                      color: Color.fromRGBO(122, 146, 233, 1)),
                                ),
                              ),
                              const SizedBox(
                                width:
                                25, // Espacio de 16 píxeles entre los botones
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  if (_keyForm.currentState!.validate()) {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => const mensaje(),
                                      ),
                                    );
                                  } else {
                                    print(
                                        'An error has occurred, check your email or password');
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  minimumSize: Size(150, 50),
                                  backgroundColor: Color.fromRGBO(0, 191, 174, 1),
                                ),
                                child: const Text(
                                  'NEXT',
                                  style: TextStyle(
                                    fontSize: 18,
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
