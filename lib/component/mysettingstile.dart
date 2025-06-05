import 'package:flutter/material.dart';

/* 
  Configuración de la tile de ajustes 

  Es un simple tile que se usa para mostrar en la pagina de configuracion
  
  Para usarlo se ocupa:
  - Titulo
  - Accion

*/

class MySettingsTile extends StatelessWidget {
  final String title;
  final Widget action;

  const MySettingsTile({super.key, required this.title, required this.action});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondary,
        borderRadius: BorderRadius.circular(12.0),
      ),

      margin: const EdgeInsets.only(left: 25.0, right: 25.0 , top: 10.0),
      padding: const EdgeInsets.all(25.0),


      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          action,
        ],
      ),
    );
  }
}
