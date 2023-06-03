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
  var url = Uri.parse("$baseUrl/user/auth/loggeo/");
  var res = await http.post(url, body: body);

  print(res.body);
  print(res.statusCode);
  if (res.statusCode == 200) {
    Map json = jsonDecode(res.body);
    String token = json['key'];
    var box = await Hive.openBox(tokenBox);
    box.put("token", token);
    User? user = await getUser(token);
    return user;
  } else {
    Map json = jsonDecode(res.body);
    print(json);
    if (json.containsKey("email")) {
      return json["email"][0];
    }
    if (json.containsKey("password")) {
      return json["password"][0];
    }
    if (json.containsKey("non_field_errors")) {
      return json["non_field_errors"][0];
    }
  }
}

Future<User?> getUser(String token) async {
  //traemos los datos que guardamos de usuario
  var url = Uri.parse("$baseUrl/user/auth/user/");
  var res = await http.get(url, headers: {
    'Authorization': 'Token $token',
  });
  if (res.statusCode == 200) {
    var json = jsonDecode(res.body);
    User user = User.fromJson(json);
    user.token = token;
    return user;
  } else {
    return null;
  }
}
Future<String?> getUsername(String token) async {
  //llamamos especificamente el nombre de usuario registrado
  final user = await getUser(token);
  return user?.username;
}
Future<String?> getEmail(String token) async {
  //llamamos especificamente el email registrado del usuario
  final user = await getUser(token);
  return user?.email;
}
Future<String?> getLastLogin(String token) async {
  //llamamos especificamente la ultima vez que el usuario se a autenticado
  var url = Uri.parse("$baseUrl/user/auth/user/");
  var res = await http.get(url, headers: {
    'Authorization': 'Token ${token}',
  });
  if (res.statusCode == 200) {
    var json = jsonDecode(res.body);
    var lastLoginString = json['last_login'] as String?;
    if (lastLoginString != null) {
      return lastLoginString.toString();
    }
  }
  return null;
}
Future<void> logOut(String token) async {
  //llamamos la api de logout
  var url = Uri.parse("$baseUrl/user/auth/logout/");
  var res = await http.post(url, headers: {
    'Authorization': 'Token ${token}',
  });
  print(res.body);
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
