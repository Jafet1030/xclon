/*
  POST TILE
  Este widget se encarga de mostrar un post en la pantalla principal de la aplicacion.

  Para usarlo se debe tener:
  - El post que se va a mostrar
  - Una funcion para ver el post completo
  - Una funcion para irse al perfil del usuario que hizo el post

*/

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:twitterclon/component/myinputalertbox.dart';
import 'package:twitterclon/helper/time_formatter.dart';
import 'package:twitterclon/models/post.dart';
import 'package:twitterclon/services/auth/auth_service.dart';
import 'package:twitterclon/services/database/database_provider.dart';

class MyPostTile extends StatefulWidget {

  final Post post;
  
  final void Function()? onPostTap; // Funcion para ver el post completo
  final void Function()? onUserTap; // Funcion para ir al perfil del usuario que hizo el post
  

  const MyPostTile({super.key, required this.post,required this.onPostTap,required this.onUserTap});

  @override
  State<MyPostTile> createState() => _MyPostTileState();
}

class _MyPostTileState extends State<MyPostTile> {
  // provider
  late final listeningProvider = Provider.of<DatabaseProvider>(context);
  late final databaseProvider=Provider.of<DatabaseProvider>(context, listen: false);


  @override
  void initState() {
    super.initState();
    // Cargar los comentarios del post al iniciar el widget
    _loadComments();
  }

  //likes
  void _toggleLikePost()async{
    try {
      await databaseProvider.toggleLike(widget.post.id);
    }catch (e) {
      print('Error al dar like al post: $e');
    }
  }

  final _commentController = TextEditingController();

  // abrir el cuadro de texto para comentar
  void _openNewCommentBox() {
    showDialog(
      context: context, 
      builder: (context) => MyInputAlertBox(
        textController: _commentController, 
        hintText: "Escribe un comentario...", 
        onPressed: ()async{
          await _addComment();
        }, 
        onPressedText: "Publicar",));
  }
  // usuario ha dado click en publicar comentario
  Future<void> _addComment() async {
    if (_commentController.text.trim().isEmpty) return;
    try {
      await databaseProvider.addComment(
        widget.post.id,
        _commentController.text.trim(),
      );
      _commentController.clear(); // Limpiar el campo de texto
    } catch (e) {
      print('Error al agregar comentario: $e');
    }
  }
  // cargar comentarios del post
  Future<void> _loadComments() async{
    await databaseProvider.loadComments(widget.post.id);
  }


/*
  MOSTRAR OPCIONES

  Caso 1: Si el post es del usuario actual
  - Eliminar
  - Cancelar
  Caso 2: Si el post no es del usuario actual
  - Reportar
  - Bloquear
  - Cancelar

*/





  void _showOptions() {

    // checar si el usuario es el dueño del post
    String currentUserId = AuthService().getCurrentUserId();
    final bool isOwnPost = widget.post.uid == currentUserId;
    
    showModalBottomSheet(
      context: context, 
      builder: (context){
        return SafeArea(
          child: Wrap(
            children: [

              if (isOwnPost) // SI el post es del usuario actual
              // Boton de eliminar
              ListTile(
                leading: const Icon(Icons.delete),
                title: const Text('Eliminar'),
                onTap: () async{
                    Navigator.pop(context); // Cerrar las opciones

                    await databaseProvider.deletePost(widget.post.id); // Eliminar el post
                  },
              )

              else...[
                
                //Boton de reportar
                ListTile(
                  leading: const Icon(Icons.flag),
                  title: const Text('Reportar'),
                  onTap: () {
                    Navigator.pop(context); // Cerrar las opciones

                    // Reportar al usuario
                    _reportPostConfirmationBox();

                  },
                ),
                
                // Boton de bloquear
                ListTile(
                  leading: const Icon(Icons.block),
                  title: const Text('Bloquear'),
                  onTap: () {
                    Navigator.pop(context); // Cerrar las opciones

                    // Bloquear al usuario
                    _blockUserConfirmationBox();

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

  //  Confirmacion de reportar post
  void _reportPostConfirmationBox() {
    showDialog(
      context: context, 
      builder: (dialogContext) => AlertDialog(
        title: const Text('Reportar Post'),
        content: const Text('¿Estás seguro de que quieres reportar este post?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(dialogContext); // Cerrar el dialogo
            }, 
            child: const Text('Cancelar')),
          TextButton(
            onPressed: () async {
              await databaseProvider.reportUser(widget.post.id, widget.post.uid);
              Navigator.pop(dialogContext); // Cerrar el dialogo

              if (!mounted) return; 
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Publicación reportada."),
                  duration: Duration(milliseconds: 1100),)
                
              );

            }, 
            child: const Text('Reportar')),
        ],
      )
    );
  }

void _blockUserConfirmationBox() {
    showDialog(
      context: context, 
      builder: (dialogContext) => AlertDialog(
        title: const Text('Bloquear Usuario'),
        content: const Text('¿Estás seguro de que quieres bloquear este usuario?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(dialogContext); // Cerrar el dialogo
            }, 
            child: const Text('Cancelar')),
          TextButton(
            onPressed: () async {
              await databaseProvider.blockUser(widget.post.uid);
              Navigator.pop(dialogContext); // Cerrar el dialogo

              if (!mounted) return; 
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Usuario bloqueado."),
                  duration: Duration(milliseconds: 1100),
                  )
              );

            }, 
            child: const Text('Bloquear')),
        ],
      )
    );
  }


  @override
  Widget build(BuildContext context) {

    // El usuario ha dado like a este post?
    bool likedByCurrentUser = listeningProvider.isPostLikedByCurrentUser(widget.post.id);

    // Contador de likes
    int likeCount = listeningProvider.getLikeCount(widget.post.id);

    int commentCount= listeningProvider.getComments(widget.post.id).length;

    return GestureDetector(
      onTap: widget.onPostTap, // Llamar a la funcion cuando se toque el tile
      child: Container(
        margin: const EdgeInsets.symmetric( horizontal: 25, vertical: 5,),
      
        padding: const EdgeInsets.all(20),
      
        decoration: BoxDecoration(
          // Color de fondo del tile
          color: Theme.of(context).colorScheme.secondary,
          // Bordes redondeados
          borderRadius: BorderRadius.circular(10),
          // Sombra para darle un efecto de elevacion
          
        ),
      
        child: Column(
      
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
      
            GestureDetector(
              onTap: widget.onUserTap,
              child: Row(
                children: [
                  // Foto de perfil
                  Icon(Icons.person, color: Theme.of(context).colorScheme.primary,),
              
                  const SizedBox(width: 10),
                  //Nombre del usuario
                  Text(widget.post.name,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
              
                  const SizedBox(width: 5),
              
                  // Username del usuario
                  Text('@${widget.post.username}',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),

                  const Spacer(),


                  GestureDetector(
                    onTap: _showOptions,
                    child: Icon(Icons.more_horiz, 
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ],
              ),
            ),
      
            const SizedBox(height: 15),
      
            //message
            Text(widget.post.message,
              style: TextStyle(
                color: Theme.of(context).colorScheme.inversePrimary,
              ),
            ),

            const SizedBox(height: 15),

            //boton de like y comentarios
            Row(
              children: [


                // Seccion de likes
                SizedBox(
                  width: 60,
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: _toggleLikePost,
                        child: likedByCurrentUser 
                        ? 
                        Icon(Icons.favorite, 
                        color: Colors.red,)
                        :
                        Icon(Icons.favorite_border, 
                        color: Theme.of(context).colorScheme.primary,)
                      ),
                  
                      const SizedBox(width: 5),
                  
                      //like count
                      Text(likeCount != 0 ? likeCount.toString() : '',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                ),

                // Seccion de Commentarios

                Row(
                  children: [
                  GestureDetector(
                    onTap: _openNewCommentBox,
                    child: Icon(Icons.comment, 
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                
                  const SizedBox(width: 5),
                
                  // Contador de Comentarios 
                  Text(commentCount != 0 ? commentCount.toString() : '',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),

                  

                ],
              ),

              const Spacer(),

              //Fecha de publicacion
              Text(formatTimestamp(widget.post.timestamp),
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              ],
            )

          ],
        ),
      
      ),
    );
  }
}