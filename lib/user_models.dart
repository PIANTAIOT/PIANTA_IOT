import 'package:flutter/cupertino.dart';
/*
class UserRegister {
  late String email;
  late String username;
  late String password;
  UserRegister({required this.email, required this.username, required this.password});
}

class UserProvider with ChangeNotifier {
  late  UserRegister _userRegister = UserRegister(email: '', username: '', password: '');
  UserRegister get user => _userRegister;

  set email(String value) {
    _userRegister.email = value;
    notifyListeners();
  }

  set username(String value) {
    _userRegister.username = value;
    notifyListeners();
  }

  set password(String value) {
    _userRegister.password = value;
    notifyListeners();
  }

  void resetUser() {
    _userRegister = UserRegister(email: '', username: '', password: '');
    notifyListeners();
  }
}
*/
//clase usuario, los datos enviados por los guarda aca para mostrarlos en la aplicacion
class User {
  int? id; // Identificación del usuario (puede ser nula)
  String? token; // Token de autenticación del usuario (puede ser nulo)
  String? username; // Nombre de usuario del usuario (puede ser nulo)
  String? email; // Dirección de correo electrónico del usuario (puede ser nula)
  //first_name, last_name; // (Estos campos están comentados y no se utilizan en el código actual)

  User({
    this.email,
    this.id,
    this.username,
  });

  //{"pk":2,"username":"","email":"example1@gmail.com","first_name":"First","last_name":"Last"}
  factory User.fromJson(json) {
    print(json); // Imprime el objeto JSON recibido
    return User(
      email: json["email"], // Asigna el valor del campo "email" del objeto JSON a la propiedad "email" de la instancia de "User"
      //first_name: json["first_name"], // Estos campos están comentados y no se utilizan en el código actual
      id: json["pk"], // Asigna el valor del campo "pk" del objeto JSON a la propiedad "id" de la instancia de "User"
      //last_name: json["last_name"], // Estos campos están comentados y no se utilizan en el código actual
      username: json["username"], // Asigna el valor del campo "username" del objeto JSON a la propiedad "username" de la instancia de "User"
    );
  }
}

