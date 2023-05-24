class ProjectTemplate {
  int id; // Identificador del proyecto (entero)
  final String name; // Nombre del proyecto (cadena de texto)
  final String sensor; // Tipo de sensor (cadena de texto)
  final String red; // Red asociada (cadena de texto)
  final String descripcion; // Descripción del proyecto (cadena de texto)

  ProjectTemplate({
    required this.id,
    required this.name,
    required this.red,
    required this.sensor,
    required this.descripcion,
  });

  factory ProjectTemplate.fromJson(Map<String, dynamic> json) {
    return ProjectTemplate(
      id: json['id'], // Asigna el valor del campo 'id' del JSON al atributo 'id' de la clase
      name: json['name'], // Asigna el valor del campo 'name' del JSON al atributo 'name' de la clase
      red: json['red'], // Asigna el valor del campo 'red' del JSON al atributo 'red' de la clase
      sensor: json['sensor'], // Asigna el valor del campo 'sensor' del JSON al atributo 'sensor' de la clase
      descripcion: json['descripcion'], // Asigna el valor del campo 'descripcion' del JSON al atributo 'descripcion' de la clase
    );
  }
}

List<ProjectTemplate> templateprojects = []; // Lista vacía para almacenar proyectos de tipo ProjectTemplate
