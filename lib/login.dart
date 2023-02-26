import 'package:flutter/material.dart';
import 'package:pianta/forgot_password.dart';
import 'package:pianta/signup.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
    body: SafeArea(
     child: Center(
      child: SingleChildScrollView(
        child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'images/Logotipo_pianta.png',
                width: 300.0,
                height: 200.0,
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
                    Text('LOG IN',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 28,
                        ),
                        textAlign: TextAlign.center)
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
                    )
                  ],
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 0),
                  child: TextField(
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.email),
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(height: 20.0),
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
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 0),
                  child: TextField(
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.lock_open),
                      suffixIcon: Icon(Icons.visibility_off),
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(height: 25.0),
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const forgot_password(),
                        ),
                      );
                    },

                    child: Text(
                      'Forgot Password?',
                      style: TextStyle(
                          fontWeight: FontWeight.normal,
                          fontSize: 22,
                          color: Color.fromRGBO(122, 146, 233, 1)),
                    ), // El texto que se mostrará en el botón
                  )
                ]),
                const SizedBox(height: 25.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () {},
                      child: const Text(
                        'LOG IN',
                        style: TextStyle(
                          fontSize: 28,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size(350, 70),
                        backgroundColor: Color.fromRGBO(0, 191, 174, 1),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 25.0),
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SignUp(),
                        ),
                      );
                    },

                    child: Text(
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
    );
  }
}
