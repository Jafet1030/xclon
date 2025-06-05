/*
  Post Page
  Esta pagina muestra
  -Post individuales
  -Comentarios en el post
 
*/

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:twitterclon/component/mycommenttile.dart';
import 'package:twitterclon/component/myposttile.dart';
import 'package:twitterclon/helper/navigate_pages.dart';
import 'package:twitterclon/models/post.dart';
import 'package:twitterclon/services/database/database_provider.dart';

class PostPage extends StatefulWidget {
  final Post post;
  const PostPage({super.key, required this.post});

  @override
  State<PostPage> createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  late final listeningProvider = Provider.of<DatabaseProvider>(context); 
  late final databaseProvider = Provider.of<DatabaseProvider>(context, listen: false);


  
  @override
  Widget build(BuildContext context) {

    final allComments = listeningProvider.getComments(widget.post.id);

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,

      appBar: AppBar(
        foregroundColor: Theme.of(context).colorScheme.primary,
      ),

      body: ListView(
        children: [
          MyPostTile(
            post: widget.post, 
            onPostTap: (){}, 
            onUserTap: ()=>goUserPage(context, widget.post.uid)),

          allComments.isEmpty
          ?
          Center(
            child: Text("No hay comentarios"),
          )
          : // Si existen comentarios, mostrarlos
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: allComments.length,
            itemBuilder: (context, index) {
              // obtener cada comentario 
              final comment = allComments[index];

              // mostrar el comentario personalizado
              return MyCommentTile(
                comment: comment, 
                onUserTap: ()=> goUserPage(context, comment.uid) );
            },
          )
        
        ],
      ),

    );
  }
}