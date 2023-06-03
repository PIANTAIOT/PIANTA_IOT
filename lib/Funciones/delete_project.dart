import 'package:flutter/material.dart';

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
        title: const Text(
          "Do you want to delete this project",
          textAlign: TextAlign.center,
        ),
        content: const Text(
          "Name project",
          textAlign: TextAlign.center,
        ),
        actions: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(100, 30),
                  backgroundColor: const Color.fromRGBO(242, 23, 23, 1),
                ),
                child: const Text(
                  'Delete',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                    color: Colors.white,
                  ),
                ),
              ),
              Spacer(),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(100, 30),
                  backgroundColor: const Color.fromRGBO(0, 191, 174, 1),
                ),
                child: const Text(
                  'Cancel',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

