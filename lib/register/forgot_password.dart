import 'package:flutter/material.dart';
import 'package:pianta/register/create_password.dart';
import 'package:pianta/register/login.dart';
import 'package:pianta/register/profile.dart';
import 'package:pianta/register/reset_password.dart';

class forgot_password extends StatefulWidget {
  const forgot_password({Key? key}) : super(key: key);

  @override
  State<forgot_password> createState() => _forgot_passwordState();
}

class _forgot_passwordState extends State<forgot_password> {
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
                      Text('Forgot Password?',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 38,
                          ),
                          textAlign: TextAlign.center)
                    ],
                  ),
                  const SizedBox(height: 20.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Text(
                        'It happens sometimes, no worries. We will send ',
                        style: TextStyle(
                          fontWeight: FontWeight.normal,
                          fontSize: 19,
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Text(
                        'you an email with the link to reset password',
                        style: TextStyle(
                          fontWeight: FontWeight.normal,
                          fontSize: 19,
                        ),
                      )
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
                          fontSize: 23,
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
                  const SizedBox(height: 25.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const reset_passaword(),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          minimumSize: Size(350, 70),
                          backgroundColor: Color.fromRGBO(0, 191, 174, 1),
                        ),
                        child: const Text(
                          'Submit',
                          style: TextStyle(
                            fontSize: 28,
                          ),
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
                            builder: (context) => const Login(),
                          ),
                        );
                      },

                      child: const Text(
                        'Back to Login',
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
    );
  }
}
