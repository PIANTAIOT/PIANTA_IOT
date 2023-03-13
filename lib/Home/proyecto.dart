import 'package:flutter/material.dart';
import 'package:pianta/Funciones/constantes.dart';
import 'package:pianta/Funciones/delete_project.dart';
import 'package:pianta/Funciones/share_project.dart';
import 'package:pianta/Home/new_project.dart';
import 'package:pianta/Home/project_created.dart';



class Proyecto extends StatefulWidget {
  const Proyecto({super.key});

  @override
  State<Proyecto> createState() => _ProyectoState();
}

class _ProyectoState extends State<Proyecto> {
  var pruebaText = 'Project Name';


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Row(children: [
        myDrawer,

        Padding(
          padding: const EdgeInsets.all(0),
          child: Column(//4 cajas en la parte superior
              children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Projects',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 40,
                    ),
                    textAlign: TextAlign.center),
                const SizedBox(
                  width: 250, // Espacio de 16 píxeles entre los botones
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ProjectCreated(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                      minimumSize: const Size(90, 30),
                      backgroundColor: const Color.fromRGBO(255, 255, 255, 1)),

                  child: const Text(
                    'Project Created',

                    style: TextStyle(
                        fontWeight: FontWeight.normal,
                        fontSize: 20,
                        color: Color.fromRGBO(16, 16, 16, 1)),
                  ), // El texto que se mostrará en el botón
                ),
                const SizedBox(
                  width: 12, // Espacio de 16 píxeles entre los botones
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const NewProject(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(

                    minimumSize: const Size(90, 30),
                    backgroundColor: const Color.fromRGBO(0, 191, 174, 1),

                  ),
                  child: const Text(
                    '+New Project',
                    style: TextStyle(
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
            Row(mainAxisAlignment: MainAxisAlignment.end, children: const [
              Divider(
                height: 100,
                color: Colors.green,
                thickness: 1,
                indent: 10,
                endIndent: 10,
              ),
            ]),
            Center(
              child: Card(
                  elevation: 4.0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(0),
                  ),
                  child: SizedBox(
                    width: 170,
                    height: 230,
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(children: [
                        IconButton(
                          icon: const Icon(
                            Icons.account_circle_outlined,
                            size: 20,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const ShareProject(),
                              ),
                            );
                          },
                        ),
                        const SizedBox(
                          height: 90, // Espacio de 16 píxeles entre los botones
                        ),
                        Container(
                          padding: const EdgeInsets.all(0),
                          width: 120,
                          height: 20,
                          color: const Color.fromRGBO(0, 191, 174, 1),
                          alignment: Alignment.centerLeft,
                          child: Text(
                            pruebaText,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.delete, size: 20),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const DeleteProject(),
                                  ),
                                );
                              },
                            ),
                            const SizedBox(
                              width:
                                  4, // Espacio de 16 píxeles entre los botones
                            ),
                            IconButton(
                              icon: const Icon(Icons.share, size: 20),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const ShareProject(),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ]),
                    ),
                  )),
            )

          ]),
        ),
      ]),



    );

  }

}


