import 'dart:js';
import 'package:flutter/material.dart';
import 'package:pianta/Home/template.dart';

var myDefaultBackground = Colors.white;

var myAppBar = AppBar(
  title: const Center(child: Text(' C O M P A N N Y'),),
  actions: const [
  //imagen
  ],
);
int _selectedIndex = 0;
var myDrawer = NavigationRail(
  //este campo permite la seleccion de cada item y a donde conllevara
  selectedIndex: _selectedIndex,
  minWidth: 100,
  elevation: 5,
  //se llama la clase logo, la cual esta ne la linea 113 donde contiene el logo
  leading: const logo(),
  //se genera el indicador, cuando se pase el cursor y se de click se cambia de color
  useIndicator: true,
  //se asigna el color al que cambiara
  indicatorColor: const Color.fromRGBO(0, 191, 174, 1),
  //anotacion que permitira ir a las paginas seleccionadas en la barra cuando se hace click
  onDestinationSelected: (int index) {

  },
  //se crean los item de la barra
  destinations: const <NavigationRailDestination>[
    //primer item
    NavigationRailDestination(
        icon: Icon(Icons.search, color:Colors.black, size: 50),
        label: Text('Projects'),

    ),
    //segundo item
    NavigationRailDestination(
      icon: Icon(Icons.more_horiz, color: Colors.black, size: 50),
      label: Text('Templates'),

    ),
    //tercer item
    NavigationRailDestination(
      icon: Icon(Icons.settings_outlined, color: Colors.black, size: 50),
      label: Text('Settings'),
    ),
  ],
);
//clase creada unicamente para poder visualizar y llamar el logo a la parte superior de los items
class logo extends StatelessWidget {
  const logo ({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      //child que contiene la imagen
      child: Image.asset('assets/logo_P.jpeg', width: 80),
    );
  }
}


