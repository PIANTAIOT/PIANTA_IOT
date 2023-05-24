import 'package:flutter/material.dart';
import 'package:pianta/Home/settings.dart';
import 'package:pianta/Home/templates.dart';
import 'package:pianta/Home/proyecto.dart';
import 'package:flutter/services.dart';

var myDefaultBackground = Colors.white;

class Navigation extends StatefulWidget {
  const Navigation({Key? key, required this.title, required this.selectedIndex})
      : super(key: key);
  final String title;
  final int selectedIndex;

  @override
  _NavigationState createState() => _NavigationState();
}

class _NavigationState extends State<Navigation> {
  // variable int para instanciar la seleccion de las paginas a navegar
  int _selectedIndex = 0;
  List<IconData> icons = [    Icons.search,    Icons.more_horiz,    Icons.settings_outlined  ];
  List<Widget> pages = [
    Proyectos(),
    Templates(),
    Settings()
  ];


  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.selectedIndex;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: <Widget>[
          // Barra de navegación
          SizedBox(
            width: 100,
            child: Column(
              children: [
                Container(
                  width: 100,
                  height: 100,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/logo_P.jpeg'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(height: 20.0),
                Expanded(
                  child: ListView.builder(
                    itemCount: icons.length,
                    itemBuilder: (BuildContext context, int index) {
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedIndex = index;
                          });
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => pages[index]),
                          );
                        },
                        child: Container(
                          height: 100,
                          color: _selectedIndex == index
                              ? const Color.fromRGBO(0, 191, 174, 1)
                              : Colors.transparent,
                          child: Row(
                            children: [
                              const SizedBox(width: 20.0),
                              Icon(
                                icons[index],
                                size: 50.0,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}



