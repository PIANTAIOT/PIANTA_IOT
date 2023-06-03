class ProjectTemplate {
  int id;
  final String name;
  final String sensor;
  final String red;
  final String descripcion;
  ProjectTemplate({
    required this.id,
    required this.name,
    required this.red,
    required this.sensor,
    required this.descripcion,
  });

  factory ProjectTemplate.fromJson(Map<String, dynamic> json) {
    return ProjectTemplate(
      id: json['id'],
      name: json['name'],
      red: json['red'],
      sensor: json['sensor'],
      descripcion: json['descripcion'],
    );
  }
}

List<ProjectTemplate> templateprojects = [];