import 'package:flutter/material.dart';
/* 

  User Bio Box
  Esta es la caja con texto que muestra la biografia del usuario.

  Para usarlo solo ocuparas:
  - Texto

*/


class MyBioBox extends StatelessWidget {
  final String text;
  const MyBioBox({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 25),
      padding: const EdgeInsets.all(25),

      
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondary,
        borderRadius: BorderRadius.circular(8),
      ),

      child: Text(
        text.isNotEmpty ? text : 'No hay biografia',
        style: TextStyle(
          color: Theme.of(context).colorScheme.inversePrimary,
        ),
      ),



    );
  }
}