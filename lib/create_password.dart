import 'package:flutter/material.dart';
import 'package:pianta/profile.dart';

import 'login.dart';

class create_password extends StatefulWidget {
  const create_password({Key? key}) : super(key: key);

  @override
  State<create_password> createState() => _create_passwordState();
}

class _create_passwordState extends State<create_password> {
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
                    Text('Create Password',
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
                    Text('Create a password which is hard to guess.',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 22,
                        ),
                        textAlign: TextAlign.center)
                  ],
                ),
                const SizedBox(height: 30.0),
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: const [
                    Text(
                      'CONFIRM PASSWORD',
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
                const SizedBox(height: 25.0),
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
                      child: const Text(
                        'LOG IN',
                        style: TextStyle(
                            fontSize: 28,
                            color: Color.fromRGBO(122, 146, 233, 1)),
                      ),
                      style: ElevatedButton.styleFrom(
                          minimumSize: Size(200, 50),
                          backgroundColor: Color.fromRGBO(255, 255, 255, 1)),
                    ),
                    SizedBox(
                      width: 25, // Espacio de 16 píxeles entre los botones
                    ),
                    ElevatedButton(
                      onPressed: () {
                       Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const profile(),
                        ),
                      );
                      },
                      child: const Text(
                        'Next',
                        style: TextStyle(
                          fontSize: 28,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size(200, 50),
                        backgroundColor: Color.fromRGBO(0, 191, 174, 1),
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
    );
  }
}
