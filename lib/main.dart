import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:pianta/Home/proyecto.dart';
import 'package:pianta/api_login.dart';
import 'package:pianta/constants.dart';
import 'package:pianta/user_models.dart';
import 'register/login.dart';  

//import 'package:flutter_bloc/flutter_bloc.dart';
//import 'package:flutter_riverpod/flutter_riverpod.dart';
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

                    
      debugShowCheckedModeBanner: false,
      home: FutureBuilder<Box>(
        future: Hive.openBox(tokenBox),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            var box = snapshot.data;
            var token = box!.get("token");
            if (token != null) {
              return FutureBuilder<User?>(
                future: getUser(token),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    if (snapshot.data != null) {
                      User user = snapshot.data!;
                      user.token = token;
                      //context.read<UserCubit>().emit(user);
                      return const Proyectos();
                    } else {
                      return const Login();
                    }
                  } else {
                    return const Login();
                  }
                },
              );
            } else {
              return const Login();
            }
          } else if (snapshot.hasError) {
            return const Login();
          } else {
            return const Login();
          }
        },
      ),
    );
  }
}
