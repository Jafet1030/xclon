import 'package:flutter/material.dart';

/* Drawer Tile 

  Es para crear un tile en el drawer, 
  que es un widget que se usa para mostrar 
  una lista de opciones en el drawer. 


 Se ocupa un
  Titulo (Home)
  Icono (Icons.home)
  Funcion (Ir a la pagina de inicio)
*/

class MyDrawerTile extends StatelessWidget {
  final String title;
  final IconData icon;
  final void Function()? onTap;
  
  const MyDrawerTile({super.key, required this.title, required this.icon, this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        title,
        style: TextStyle(
          color: Theme.of(context).colorScheme.primary,
          fontSize: 18.0,
        ),
      ),
      leading: Icon(
        icon,
        color: Theme.of(context).colorScheme.primary,
      ),
      onTap: onTap,
    );
  }
}