import 'package:flutter/material.dart';

/*
  Boton personalizado para la aplicacion.


  Se necesita lo siguiente:
  - Texto del boton
  - Funcion que se ejecuta al presionar el boton
*/

class MyButton extends StatelessWidget {
  final String text;
  final void Function()? onTap;
  const MyButton({super.key, this.onTap, required this.text});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap, 
      child: Container(
        padding: const EdgeInsets.all(25),

        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.secondary,
          borderRadius: BorderRadius.circular(12),
        ),

        child: Text(
          text, 
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16.0,
          ),
        ),
      ),

    );
  }
}