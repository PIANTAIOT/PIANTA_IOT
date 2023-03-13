import 'package:flutter/material.dart';
import 'package:pianta/Home/proyecto.dart';

class DeleteProject extends StatefulWidget {
  const DeleteProject({Key? key}) : super(key: key);

  @override
  State<DeleteProject> createState() => _DeleteProjectState();
}

class _DeleteProjectState extends State<DeleteProject> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: AlertDialog(
      title: const Text("Do you want to delete this project", textAlign: TextAlign.center,),
      content: const Text("Name project", textAlign: TextAlign.center,),
      actions: <Widget>[
        ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const Proyecto(),
              ),
            );
          },
          style: ElevatedButton.styleFrom(
            minimumSize: const Size(100, 30),
            backgroundColor: const Color.fromRGBO(242, 23, 23, 1),
          ),
          child: const Text(
              'Delete', textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 12,
              color: Colors.white,
            ),
          ),
        ),
      ],
    ),);
  }
}
