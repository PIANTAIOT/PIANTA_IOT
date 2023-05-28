
/*class MyCard extends StatelessWidget {
  const MyCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Card(
      child: ListTile(
        leading: Icon(Icons.person),
        title: Text('John Doe'),
        subtitle: Text('johndoe@example.com'),
        trailing: Icon(Icons.more_vert),
      ),
    );
  }
}
 */
class CardModel {
  String title;    // Título de la tarjeta
  String content;  // Contenido de la tarjeta

  // Constructor de la clase CardModel
  CardModel({required this.title, required this.content});
}
