import 'package:flutter/material.dart';
import 'package:pianta/register/create_password.dart';
import 'package:pianta/register/login.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
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
                    Text('LOG IN',
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
                      'Welcome! Fill in your email address and we will',
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
                      'send an account activation link.',
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
                          builder: (context) => const create_password(),
                        ),
                      );
                      },
                      child: const Text('Sign Up',style:TextStyle(fontSize: 28,), ),
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
                          builder: (context) => const Login(),
                        ),
                      );
                    },

                    child: Text(
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
    )
    )
    ),
    );
  }
}