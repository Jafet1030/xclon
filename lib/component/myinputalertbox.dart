/* 

Input Alert Box
Esta es la caja de alerta que se muestra cuando se requiere una entrada del usuario.

Para usarlo solo ocuparas:

  - Un controlador de texto
  - Un hint text
  - Una funcion
  - Texto del boton de aceptar

*/

import 'package:flutter/material.dart';

class MyInputAlertBox extends StatelessWidget {
  final TextEditingController textController;
  final String hintText;
  final void Function()? onPressed;
  final String onPressedText;

  const MyInputAlertBox({super.key, required this.textController, required this.hintText, required this.onPressed, required this.onPressedText});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
      backgroundColor: Theme.of(context).colorScheme.surface,

      content: TextField(
        controller: textController,
        maxLength: 140,
        maxLines: 3,

        decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Theme.of(context).colorScheme.tertiary),
          ),

          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Theme.of(context).colorScheme.primary),
          ),

          hintText: hintText,
          hintStyle: TextStyle(
            color: Theme.of(context).colorScheme.primary,
          ),

          //Color dentro del campo de texto
          fillColor: Theme.of(context).colorScheme.secondary,
          filled: true,

          counterStyle: TextStyle(
            color: Theme.of(context).colorScheme.primary,
          ),

        ),
      ),

      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
            textController.clear();
          },
          child: Text("Cancelar",),
        ),
        TextButton(
          onPressed: (){
            Navigator.pop(context);
            onPressed!();
            textController.clear();

          }, 
          child: Text(onPressedText)
          )

      ],

    );
  }
}