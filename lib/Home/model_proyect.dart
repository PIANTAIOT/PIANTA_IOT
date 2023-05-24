import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/adapters.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:pianta/Funciones/constantes.dart';
import 'package:pianta/MyDevices/My_Devices.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants.dart';
import 'new_project.dart';
import 'package:uuid/uuid.dart';
import 'package:pianta/Home/model_proyect.dart';
import 'package:hive_flutter/adapters.dart';

class Project {
  int id;
  // Variable que guarda el id aleatorio del proyecto
  final String idrandom;
  final String name;
  // final String location;
  final String description;

  Project({
    required this.id,
    required this.idrandom,
    required this.name,
    // required this.location,
    required this.description,
  })  : assert(id != null),
        assert(idrandom != null),
        assert(name != null),
  // assert(location != null),
        assert(description != null);

  // Factory method para crear una instancia de Project a partir de un mapa JSON
  factory Project.fromJson(Map<String, dynamic> json) {
    return Project(
      id: json['id'],
      idrandom: json['idrandom'],
      name: json['name'] ?? '',
      // location: json['location'] ?? '',
      description: json['description'] ?? '',
    );
  }
}

// Lista de proyectos creados, se instancia vacía inicialmente
List<Project> projects = [];

// Future que almacenará los proyectos en un punto de tiempo futuro
late Future<List<Project>> futureProjects;

// Método asincrónico para obtener la lista de proyectos desde una API
Future<List<Project>> fetchProjects() async {
  var box = await Hive.openBox(tokenBox);
  final token = box.get("token") as String?;
  final response = await http.get(
    Uri.parse('http://127.0.0.1:8000/user/project/'),
    headers: {'Authorization': 'Token $token'},
  );

  if (response.statusCode == 200) {
    final List<dynamic> jsonList = jsonDecode(response.body);
    // Convierte la lista de JSON a una lista de objetos Project utilizando el factory method
    final List<Project> projects = jsonList.map((json) => Project.fromJson(json)).toList();
    // Esto actualiza los proyectos para ver los cambios
    // await refreshProjects();
    return projects;
  } else {
    throw Exception('Failed to load project list');
  }
}

// Método asincrónico para actualizar los proyectos
Future<void> refreshProjects() async {
  futureProjects = fetchProjects();
}
