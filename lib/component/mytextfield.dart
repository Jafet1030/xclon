import 'package:flutter/material.dart';

/* 
TextField personalizado
Este widget es un TextField personalizado que se puede utilizar en cualquier parte de la aplicacion.


Para usarlo ocupas:
 - Controlador del texto
 - HintText
 - Texto de contraseña
*/
class MyTextField extends StatelessWidget {
  final TextEditingController controller;
  final bool obscureText;
  final String hintText;
  
  const MyTextField({super.key, required this.controller, required this.obscureText, required this.hintText});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.tertiary,
          ),
          borderRadius: BorderRadius.circular(12.0),
        ),

        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.primary,
          ),
          borderRadius: BorderRadius.circular(12.0),
        ),

        fillColor: Theme.of(context).colorScheme.secondary,
        filled: true,
        hintText: hintText,
        hintStyle: TextStyle(
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }
}