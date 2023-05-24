import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:pianta/Home/proyecto.dart';
import 'package:pianta/api_login.dart';
import 'package:pianta/constants.dart';
import 'package:pianta/user_models.dart';
import 'register/login.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
//import 'package:flutter_riverpod/flutter_riverpod.dart' as riverpod;
//import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  runApp(
    const MyApp(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp();
//Realizamos validacion de token y retornamos siempre el login cuando inicia la aplicacion
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      /*
       routes: {
         // rutas existentes...
         '/reset_password_confirm/:uidb64/:token': (),
         // '/password_reset_complete': (context) => const mensaje(),
       },
       */

      debugShowCheckedModeBanner: false, // Desactiva el banner de modo depuración en la interfaz
      home: FutureBuilder<Box>( // Construye una interfaz basada en el estado futuro de un objeto "Box"
        future: Hive.openBox(tokenBox), // Abre un objeto "Box" de Hive en el futuro
        builder: (context, snapshot) { // Función de generador que construye la interfaz según el estado del futuro
          if (snapshot.hasData) { // Verifica si el futuro tiene datos
            var box = snapshot.data; // Obtiene el objeto "Box" de los datos del futuro
            var token = box!.get("token"); // Obtiene el valor del token del objeto "Box"
            if (token != null) { // Verifica si el token no es nulo
              return FutureBuilder<User?>( // Construye una interfaz basada en el estado futuro de un objeto "User"
                future: getUser(token), // Obtiene un objeto "User" a partir del token en el futuro
                builder: (context, snapshot) { // Función de generador que construye la interfaz según el estado del futuro
                  if (snapshot.hasData) { // Verifica si el futuro tiene datos
                    if (snapshot.data != null) { // Verifica si el objeto "User" no es nulo
                      User user = snapshot.data!; // Obtiene el objeto "User" de los datos del futuro
                      user.token = token; // Asigna el token al objeto "User"
                      //context.read<UserCubit>().emit(user); // Emite el objeto "User" al "UserCubit" (gestor de estado)
                      return const Proyectos(); // Retorna la pantalla de Proyectos
                    } else {
                      return const Login(); // Retorna la pantalla de inicio de sesión
                    }
                  } else {
                    return const Login(); // Retorna la pantalla de inicio de sesión
                  }
                },
              );
            } else {
              return const Login(); // Retorna la pantalla de inicio de sesión
            }
          } else if (snapshot.hasError) { // Verifica si el futuro tiene un error
            return const Login(); // Retorna la pantalla de inicio de sesión
          } else {
            return const Login(); // Retorna la pantalla de inicio de sesión
          }
        },
      ),
    );
  }
}
