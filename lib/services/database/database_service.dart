/*

Servicio de la base de datos
Este servicio se encarga de interactuar con la base de datos de Firebase Firestore.

  - Perfil del usuario
  - Postear mensajes
  - Likes
  - Comentarios
  - Cosas de la cuenta (reportar, bloquear, eliminar cuenta)
  - Seguir / Dejar de seguir
  - Buscar usuarios

*/

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:twitterclon/models/comment.dart';
import 'package:twitterclon/models/post.dart';
import 'package:twitterclon/models/user.dart';
import 'package:twitterclon/services/auth/auth_service.dart';


class DatabaseService {
  final _db = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;


  /*
  Perfil del usuario
  */

  // Guardar informacion del usuario
  Future<void> saveUserInfoInFirebase({required String name,required String email}) async {
    
    // Obtener el uid actual
    String uid = _auth.currentUser!.uid;

    // Extraer username del email
    String username = email.split('@')[0];

    // Crear un perfil de usuario
    UserProfile user = UserProfile(
      uid: uid,
      name: name,
      email: email,
      username: username,
      bio: '',
    );

    // Convertir el perfil a un mapa para guardarlo en Firestore
    final userMap = user.toMap();

    //Guardar el perfil en Firestore
    await _db.collection('Users').doc(uid).set(userMap);

  }


  // Obtener el perfil del usuario
  Future<UserProfile?> getUserFromFirebase(String uid) async {
    try {
      // Obtener el documento del usuario desde Firestore
      DocumentSnapshot userDoc = await _db.collection('Users').doc(uid).get();
      // Convertir el documento a un perfil de usuario
      return UserProfile.fromDocument(userDoc);
      
    } catch (e) {
      print('Error al obtener el perfil del usuario: $e');
      return null;
    }
  }

  Future<void> updateUserBioInFirebase(String uid, {String? name, String? bio}) async {
    String uid = AuthService().getCurrentUserId();

    try{
      await _db.collection('Users').doc(uid).update({'bio': bio});
      }
    catch (e) {
      print('Error al actualizar el perfil del usuario: $e');
    }
  }

  // Eliminar cuenta de usuario
  Future<void> deleteUserInfoFromFirebase(String uid) async{

    WriteBatch batch = _db.batch();

    // Eliminar el usuario de la coleccion Users
    DocumentReference userDoc = _db.collection("Users").doc(uid);
    batch.delete(userDoc);

    // Eliminar los posts del usuario
    QuerySnapshot userPosts = 
      await _db.collection("Posts").where("uid", isEqualTo: uid).get();

    for (var post in userPosts.docs) {
      batch.delete(post.reference);
    }

    // Eliminar los comentarios del usuario
    QuerySnapshot userComments = 
      await _db.collection("Comments").where("uid", isEqualTo: uid).get();

    for (var comment in userComments.docs) {
      batch.delete(comment.reference);
    }

    // Eliminar los likes del usuario
    QuerySnapshot allPosts = await _db.collection("Posts").get();

    for(QueryDocumentSnapshot post in allPosts.docs) {

      Map<String,dynamic> postData = post.data() as Map<String, dynamic>;
      var likedBy = postData['likedBy'] as List<dynamic>? ?? [];

      if (likedBy.contains(uid)) {
        batch.update(post.reference, {
          'likedBy': FieldValue.arrayRemove([uid]),
          'likeCount': FieldValue.increment(-1),
        });
      }
    }

    await batch.commit();

  }
  // Postear un tweet
  Future<void> postMessageInFirebase(String message) async {
    // Intentar postear un mensaje
    try{
      String uid = _auth.currentUser!.uid;

      UserProfile? user = await getUserFromFirebase(uid);

      Post newPost = Post(
        id: '', //firebase lo generara automaticamente
        uid: uid,
        name: user!.name,
        username: user.username,
        message: message,
        timestamp: Timestamp.now(),
        likeCount: 0,
        likedBy: [],
      );

      Map<String, dynamic> newPostMap = newPost.toMap();

      await _db.collection('Posts').add(newPostMap);

    }catch (e) {
      print('Error al publicar el mensaje: $e');
    }
  }

  // Obtener todos los posts
  Future<List<Post>> getAllPostsFromFirebase() async {
    try {
      QuerySnapshot snapshot = await _db.collection('Posts').orderBy('timestamp', descending: true).get();
      return snapshot.docs.map((doc) => Post.fromDocument(doc)).toList();
    } catch (e) {
      print('Error al obtener los posts: $e');
      return [];
    }
  }
  
  //Borrar un post
  Future<void> deletePostFromFirebase(String postId) async {
    try {
      await _db.collection('Posts').doc(postId).delete();
    } catch (e) {
      print('Error al eliminar el post: $e');
    }
  }
  
  /*
  Likes
  */

  //Likear un post
  Future<void> toggleLikeinFirebase(String postId) async {    
    try {
      String uid = _auth.currentUser!.uid;
      DocumentReference postDoc = _db.collection('Posts').doc(postId);

      await _db.runTransaction((transaction) async {

        // Obtener los datos del post
        DocumentSnapshot postSnapshot = await transaction.get(postDoc);

        // Obtener los usuarios que le dieron like al post
        List<String> likedBy = List<String>.from(postSnapshot['likedBy'] ?? []);

        //Obtener el contador de likes
        int currentLikeCount = postSnapshot['likeCount'] ?? 0;

        // Si el usuario no le ha dado like al post, agregarlo
        if (!likedBy.contains(uid)) {

          //Agregar el usuario a la lista de likes
          likedBy.add(uid);
          currentLikeCount++;

        } else {
          // Si el usuario ya le dio like, quitarlo
          likedBy.remove(uid);
          currentLikeCount--;
        }
        // Actualizar en firebase
        transaction.update(postDoc, {
          //Numero de likes
          'likeCount': currentLikeCount,
          //Usuarios que le dieron like
          'likedBy': likedBy,
        });


      },);

    } catch (e) {
      print('Error al dar like al post: $e');
    }
  }



  /*
  Comentarios
  */

  // Postear un comentario
  Future<void> addCommentinFirebase(String postId, String message) async {
    try {
      // Obtener el usuario actual
      String uid = _auth.currentUser!.uid;
      UserProfile? user = await getUserFromFirebase(uid);      

      // crear un comentario
      Comment newComment = Comment(
        id: '', // Firebase lo generará automáticamente
        postId: postId,
        uid: uid,
        name: user!.name,
        username: user.username,
        message: message,
        timestamp: DateTime.now(),
      );

      // convertir el comentario a un mapa
      Map<String, dynamic> newCommentMap = newComment.toMap();
      // Guardar el comentario en Firestore
      await _db.collection('Comments').add(newCommentMap);


    } catch (e) {
      print('Error al agregar el comentario: $e');
    }
  }
  
  // Eliminar un comentario
  Future<void> deleteCommentFromFirebase(String commentId) async {
    try {
      await _db.collection('Comments').doc(commentId).delete();
    } catch (e) {
      print('Error al eliminar el comentario: $e');
    }
  }
  
  
  // Buscar comentarios de un post
  Future<List<Comment>> getCommentsFromFirebase(String postId) async {
    try {
      // Obtener comentarios de un post
      QuerySnapshot snapshot = await _db
        .collection('Comments')
        .where('postId', isEqualTo: postId)
        .get();
      
      return snapshot.docs.map((doc) => Comment.fromDocument(doc)).toList();
    } catch (e) {
      print('Error al obtener los comentarios: $e');
      return [];
    }
  }

  /*
  Cosas de la cuenta
  */
  // Reportar un usuario

  Future<void> reportUserInFirebase(String postId, userId) async {
    final currentUserId = _auth.currentUser!.uid;

    final report = {
      'reportedBy': currentUserId,
      'postId': postId,
      'userId': userId,
      'timestamp': FieldValue.serverTimestamp(),
    };

    await _db.collection('Reports').add(report);
  }

  // Bloquear un usuario

  Future<void> blockUserInFirebase(String userId) async {
    final currentUserId = _auth.currentUser!.uid;

    await _db
    .collection('Users')
    .doc(currentUserId)
    .collection("BlockedUsers")
    .doc(userId)
    .set({});
  }

  // Desbloquear un usuario

  Future<void> unblockUserInFirebase(String userId) async {
    final currentUserId = _auth.currentUser!.uid;

    await _db
    .collection('Users')
    .doc(currentUserId)
    .collection("BlockedUsers")
    .doc(userId)
    .delete();
  }

  // Obtener usuarios bloqueados
  Future<List<String>> getBlockedUidsFromFirebase() async {
    final currentUserId = _auth.currentUser!.uid;

    final snapshot = await _db
      .collection('Users')
      .doc(currentUserId)
      .collection("BlockedUsers")
      .get();

      //retorna una lista de los ids de los usuarios bloqueados
    return snapshot.docs.map((doc) => doc.id).toList();
  }


  //SEGUIR / DEJAR DE SEGUIR
  Future<void> followUserInFirebase(String uid) async {
    final currentUserId = _auth.currentUser!.uid;

    // Agregar el usuario a la lista de seguidos
    await _db
      .collection('Users')
      .doc(currentUserId)
      .collection("Following")
      .doc(uid)
      .set({});

    // Agregar el usuario actual a la lista de seguidores 
    await _db
      .collection('Users')
      .doc(uid)
      .collection("Followers")
      .doc(currentUserId)
      .set({});
  }

  Future<void> unfollowUserInFirebase(String uid) async {
    final currentUserId = _auth.currentUser!.uid;

    // Eliminar el usuario de la lista de seguidos
    await _db
      .collection('Users')
      .doc(currentUserId)
      .collection("Following")
      .doc(uid)
      .delete();

    // Eliminar el usuario actual de la lista de seguidores
    await _db
      .collection('Users')
      .doc(uid)
      .collection("Followers")
      .doc(currentUserId)
      .delete();
  }


  // Obtener los usuarios que sigue
  Future<List<String>> getFollowerUidsFromFirebase(String uid) async {

    final snapshot = await _db
      .collection('Users')
      .doc(uid)
      .collection("Followers")
      .get();

    // Retorna una lista de los ids de los usuarios que sigo
    return snapshot.docs.map((doc) => doc.id).toList();
  }

  // Obtener los seguidores de un usuario
  Future<List<String>> getFollowingUidsFromFirebase(String uid) async {
    final snapshot = await _db
      .collection('Users')
      .doc(uid)
      .collection("Following")
      .get();

    // Retorna una lista de los ids de los seguidores
    return snapshot.docs.map((doc) => doc.id).toList();
  }


  // Buscar usuarios por nombre
  Future<List<UserProfile>> searchUsersInFirebase(String searchTerm) async {
    try {
      QuerySnapshot snapshot = await _db
        .collection('Users')
        .where('username', isGreaterThanOrEqualTo: searchTerm)
        .where('username', isLessThanOrEqualTo: '$searchTerm\uf8ff')
        .get();

      return snapshot.docs.map((doc) => UserProfile.fromDocument(doc)).toList();
    } catch (e) {
      return [];
    }
  }
}