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
  int? id;
  String? token;
  String? username;
  String? email; //first_name, last_name;

  User({
    this.email,
    // this.first_name,
    //this.last_name,
    this.id,
    this.username,
  });

//{"pk":2,"username":"","email":"example1@gmail.com","first_name":"First","last_name":"Last"}
  factory User.fromJson(json) {
    print(json);
    return User(
      email: json["email"],
      //first_name: json["first_name"],
      id: json["pk"],
      //last_name: json["last_name"],
      username: json["username"],
    );
  }
}
