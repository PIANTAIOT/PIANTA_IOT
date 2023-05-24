import 'dart:convert';
import 'package:hive_flutter/adapters.dart';
import 'package:http/http.dart' as http;
import 'package:pianta/user_models.dart';
import 'constants.dart';

const baseUrl = "http://127.0.0.1:8000";
//definimos la base de nuestro proyecto, localmente
Future<dynamic> userAuth(String email, String password) async {
  //user auth valida los datos ingresados en el backend y realizamos un post para enviar los datos
  Map body = {
    // "username": "",
    "email": email,
    "password": password,
  };
  var url = Uri.parse("$baseUrl/user/auth/loggeo/"); // Define la URL a la que se realizará la solicitud de inicio de sesión
  var res = await http.post(url, body: body); // Realiza una solicitud POST a la URL con el cuerpo especificado

  print(res.body); // Imprime el cuerpo de la respuesta recibida
  print(res.statusCode); // Imprime el código de estado de la respuesta

  if (res.statusCode == 200) { // Verifica si el código de estado de la respuesta es 200 (éxito)
    Map json = jsonDecode(res.body); // Decodifica el cuerpo de la respuesta en un mapa JSON
    String token = json['key']; // Obtiene el token de autenticación del mapa JSON

    var box = await Hive.openBox(tokenBox); // Abre una caja (box) en Hive para almacenar datos
    box.put("token", token); // Almacena el token en la caja

    User? user = await getUser(token); // Obtiene un objeto User a partir del token
    return user; // Retorna el objeto User
  } else { // Si el código de estado de la respuesta no es 200
    Map json = jsonDecode(res.body); // Decodifica el cuerpo de la respuesta en un mapa JSON
    print(json); // Imprime el mapa JSON

    if (json.containsKey("email")) { // Verifica si el mapa JSON contiene la clave "email"
      return json["email"][0]; // Retorna el primer error de email del mapa JSON
    }
    if (json.containsKey("password")) { // Verifica si el mapa JSON contiene la clave "password"
      return json["password"][0]; // Retorna el primer error de password del mapa JSON
    }
    if (json.containsKey("non_field_errors")) { // Verifica si el mapa JSON contiene la clave "non_field_errors"
      return json["non_field_errors"][0]; // Retorna el primer error de non_field_errors del mapa JSON
    }
  }
}

Future<User?> getUser(String token) async {
  // Traemos los datos del usuario almacenados
  var url = Uri.parse("$baseUrl/user/auth/user/"); // Define la URL a la que se realizará la solicitud
  var res = await http.get(url, headers: {
    'Authorization': 'Token $token', // Agrega el token de autorización en los encabezados de la solicitud
  });

  if (res.statusCode == 200) { // Verifica si el código de estado de la respuesta es 200 (éxito)
    var json = jsonDecode(res.body); // Decodifica el cuerpo de la respuesta en un mapa JSON
    User user = User.fromJson(json); // Crea un objeto User a partir del mapa JSON
    user.token = token; // Asigna el token al objeto User
    return user; // Retorna el objeto User
  } else { // Si el código de estado de la respuesta no es 200
    return null; // Retorna null
  }
}

Future<String?> getUsername(String token) async {
  // Llamamos específicamente al nombre de usuario registrado
  final user = await getUser(token); // Obtiene el objeto User a partir del token
  return user?.username; // Retorna el nombre de usuario del objeto User, si existe
}

Future<String?> getEmail(String token) async {
  // Llamamos específicamente al email registrado del usuario
  final user = await getUser(token); // Obtiene el objeto User a partir del token
  return user?.email; // Retorna el email del objeto User, si existe
}

Future<String?> getLastLogin(String token) async {
  // Llamamos específicamente la última vez que el usuario se autenticó
  var url = Uri.parse("$baseUrl/user/auth/user/"); // Define la URL a la que se realizará la solicitud
  var res = await http.get(url, headers: {
    'Authorization': 'Token ${token}', // Agrega el token de autorización en los encabezados de la solicitud
  });

  if (res.statusCode == 200) { // Verifica si el código de estado de la respuesta es 200 (éxito)
    var json = jsonDecode(res.body); // Decodifica el cuerpo de la respuesta en un mapa JSON
    var lastLoginString = json['last_login'] as String?; // Obtiene la última vez que el usuario se autenticó como una cadena

    if (lastLoginString != null) { // Verifica si la cadena no es nula
      return lastLoginString.toString(); // Retorna la cadena de la última vez que el usuario se autenticó
    }
  }

  return null; // Retorna null si no se puede obtener la última vez que el usuario se autenticó
}

Future<void> logOut(String token) async {
  // Llamamos a la API de logout
  var url = Uri.parse("$baseUrl/user/auth/logout/"); // Define la URL a la que se realizará la solicitud
  var res = await http.post(url, headers: {
    'Authorization': 'Token ${token}', // Agrega el token de autorización en los encabezados de la solicitud
  });

  print(res.body); // Imprime el cuerpo de la respuesta recibida
}



/*
Future<String> getUsername() async {
  final token = await getUser(token); // función para obtener el token de autenticación
  final response = await http.get(Uri.parse('http://127.0.0.1:8000/user/auth/user/'),
      headers: {'Authorization': 'Token $token'});

  if (response.statusCode == 200) {
    final json = jsonDecode(response.body);
    return json['username'];
  } else {
    throw Exception('Failed to load username');
  }
}
*/




//registar

/*
Future<dynamic> register(
    String email,
    String nickname,
    String password,
    String confirm_password,
    ) async {
  Map<String, dynamic> data = {
    "email": email,
    "password1": password,
    "password2": confirm_password,
    "nickname": nickname,
  };

  var url = Uri.parse("$baseUrl/user/auth/registration/");
  var res = await http.post(url, body: data);

// {
//     "key": "6d03435fe7d0356e7fbac5f4c35af8a63157548b"
// }

  if (res.statusCode == 200 || res.statusCode == 201) {
    Map json = jsonDecode(res.body);

    if (json.containsKey("key")) {
      String token = json["key"];
      var box = await Hive.openBox(tokenBox);
      box.put("token", token);
      var a = await getUser(token);
      if (a != null) {
        User user = a;
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
}
*/
