/* 

COMMENT TILE
Este widget se encarga de mostrar un comentario en la pantalla principal de la aplicacion.
Para usarlo se debe tener:
- El comentario que se va a mostrar
- Una funcion para ver el perfil del usuario que hizo el comentario

*/

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:twitterclon/models/comment.dart';
import 'package:twitterclon/services/auth/auth_service.dart';
import 'package:twitterclon/services/database/database_provider.dart';

class MyCommentTile extends StatelessWidget {
  final Comment comment;
  final void Function()? onUserTap;

  const MyCommentTile({super.key, required this.comment, required this.onUserTap});

  void _showOptions(BuildContext context) {

    // checar si el usuario es el dueño del post
    String currentUserId = AuthService().getCurrentUserId();
    final bool isOwnComment = comment.uid == currentUserId;
    
    showModalBottomSheet(
      context: context, 
      builder: (context){
        return SafeArea(
          child: Wrap(
            children: [

              if (isOwnComment) // SI el post es del usuario actual
              // Boton de eliminar
              ListTile(
                leading: const Icon(Icons.delete),
                title: const Text('Eliminar'),
                onTap: () async{
                    Navigator.pop(context); // Cerrar las opciones

                    await Provider.of<DatabaseProvider>(context, listen: false).deleteComment(comment.postId, comment.id); // Eliminar el post

                  },
              )

              else...[
                
                //Boton de reportar
                ListTile(
                  leading: const Icon(Icons.flag),
                  title: const Text('Reportar'),
                  onTap: () {
                    Navigator.pop(context); // Cerrar las opciones

                  },
                ),
                
                // Boton de bloquear
                ListTile(
                  leading: const Icon(Icons.block),
                  title: const Text('Bloquear'),
                  onTap: () {
                    Navigator.pop(context); // Cerrar las opciones

                  },
                ),
              ],

              // Boton de cancelar
              ListTile(
                leading: const Icon(Icons.cancel),
                title: const Text('Cancelar'),
                onTap: () {
                    Navigator.pop(context); // Cerrar las opciones
                  },
              )
            ],
          ),
        );
      }

      );
  }


  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.symmetric( horizontal: 25, vertical: 5,),
      
        padding: const EdgeInsets.all(20),
      
        decoration: BoxDecoration(
          // Color de fondo del tile
          color: Theme.of(context).colorScheme.tertiary,
          // Bordes redondeados
          borderRadius: BorderRadius.circular(10),
          // Sombra para darle un efecto de elevacion
          
        ),
      
        child: Column(
      
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
      
            GestureDetector(
              onTap: onUserTap,
              child: Row(
                children: [
                  // Foto de perfil
                  Icon(Icons.person, color: Theme.of(context).colorScheme.primary,),
              
                  const SizedBox(width: 10),
                  //Nombre del usuario
                  Text(comment.name,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
              
                  const SizedBox(width: 5),
              
                  // Username del usuario
                  Text('@${comment.username}',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),

                  const Spacer(),


                  GestureDetector(
                    onTap: ()=> _showOptions(context),
                    child: Icon(Icons.more_horiz, 
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ],
              ),
            ),
      
            const SizedBox(height: 15),
      
            //message
            Text(comment.message,
              style: TextStyle(
                color: Theme.of(context).colorScheme.inversePrimary,
              ),
            ),

            
          ],
        ),
      
      );
      
  }
}