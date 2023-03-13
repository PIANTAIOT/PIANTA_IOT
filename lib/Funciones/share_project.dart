import 'package:flutter/material.dart';
import 'package:pianta/Home/proyecto.dart';

class ShareProject extends StatefulWidget {
  const ShareProject({Key? key}) : super(key: key);

  @override
  State<ShareProject> createState() => _ShareProjectState();
}

class _ShareProjectState extends State<ShareProject> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("SHARE CREATED PROJECT", textAlign: TextAlign.center,),
    content: const Text("#########", textAlign: TextAlign.center,),
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
            backgroundColor: const Color.fromRGBO(0, 191, 174, 1),
          ),
          child: const Text(
            'Save',textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 12,
              color: Colors.white,
            ),
          ),
        ),

      ],
    );
  }
}
