/* 
  ACCOUNT SETTINGS PAGE

  Esta pagina tendra varias opciones de configuracion de la cuenta, como:
  -Eliminar cuenta
*/

import 'package:flutter/material.dart';
import 'package:twitterclon/services/auth/auth_service.dart';

class AccountSettingsPage extends StatefulWidget {
  const AccountSettingsPage({super.key});

  @override
  State<AccountSettingsPage> createState() => _AccountSettingsPageState();
}

class _AccountSettingsPageState extends State<AccountSettingsPage> {


  // Confirmar la eliminación de la cuenta
  void confirmDeletion(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Eliminar Cuenta'),
          content: Text('¿Estás seguro de que quieres eliminar tu cuenta? Esta acción no se puede deshacer.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancelar'),
            ),
            TextButton(
              onPressed: () async{

                await AuthService().deleteAccount();


                Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);              
              },
              child: Text('Eliminar'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {


    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,

      appBar: AppBar(
        centerTitle: true,
        title: Text('Configuración de Cuenta'),
        foregroundColor: Theme.of(context).colorScheme.primary,
      ),


      body: Column(
        children: [
          GestureDetector(
            onTap: () => confirmDeletion(context),
            child: Container(
              padding: const EdgeInsets.all(25.0),
              margin: const EdgeInsets.all(25),
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: const Center(
                child:Text(
                    'Eliminar Cuenta',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,

                    ),
                  ),
              ),
            ), 
          ), 
        ],
      ),
    );
  }
}