/* 

Database Provider

Este se encarga de separar los datos de la base de datos de la logica de la aplicacion.

  -La clase de database service se encarga de interactuar con la base de datos de Firebase Firestore.
  -La clase de database provider se encarga de proporcionar los datos de la base de datos a la aplicacion.

Esto hara que el codigo sea mas limpio y facil de mantener.

*/
import 'package:flutter/foundation.dart';
import 'package:twitterclon/models/comment.dart';
import 'package:twitterclon/models/post.dart';
import 'package:twitterclon/models/user.dart';
import 'package:twitterclon/services/auth/auth_service.dart';
import 'package:twitterclon/services/database/database_service.dart';

class DatabaseProvider extends ChangeNotifier {
  
  final _db = DatabaseService(); // acceso al servicio de base de datos
  final _auth = AuthService(); // acceso al servicio de autenticacion


  // metodo para obtener el uid
  Future<UserProfile?> userProfile(String uid)=> _db.getUserFromFirebase(uid);


  // metodo para actualizar el perfil del usuario
  Future<void> updateBio(String uid, String bio) => _db.updateUserBioInFirebase(uid, bio: bio);


  // lista local de posts
  List<Post> _allPosts = [];
  List<Post> _followingPosts = [];

  // conseguir todos los posts
  List<Post> get allPosts => _allPosts; 
  List<Post> get followingPosts => _followingPosts;

  // metodo para postear los tweets
  Future<void> postMessage(String message) async {
    await _db.postMessageInFirebase(message);

    loadAllPosts(); // Recargar los posts después de publicar uno nuevo
  }

  // buscar todos los posts
  Future<void> loadAllPosts() async {
    final allPosts = await _db.getAllPostsFromFirebase();
    
    final blockedUsersIds = await _db.getBlockedUidsFromFirebase();
    // Filtrar los posts para excluir los de usuarios bloqueados
    _allPosts = allPosts.where((post) => !blockedUsersIds.contains(post.uid)).toList();

    loadFollowingPosts(); // Cargar los posts de los usuarios que sigo

    initializeLikeMap(); // Inicializar el mapa de likes después de cargar los posts

    notifyListeners(); // Actualizar la UI cuando se carguen los posts
  }

  // filtrar y retornar los posts por usuario
  List<Post> filterUserPosts(String uid) {
    return _allPosts.where((post) => post.uid == uid).toList();
  }

  // Cargar los posts de los usuarios que sigo

  Future<void> loadFollowingPosts() async {
    String currentUserId = _auth.getCurrentUserId();
    
    // Obtener los ids de los usuarios que sigo
    final followingUids = await _db.getFollowingUidsFromFirebase(currentUserId);

    // Filtrar los posts para incluir solo los de los usuarios que sigo
    _followingPosts = _allPosts.where((post) => followingUids.contains(post.uid)).toList();

    notifyListeners(); // Actualizar la UI cuando se carguen los posts de los seguidos
  }

  // eliminar un post
  Future<void> deletePost(String postId) async {
    await _db.deletePostFromFirebase(postId);
    await loadAllPosts(); // Recargar los posts después de eliminar uno
  }

  // mapa local para seguir la cuenta de likes de cada post
  Map<String, int> _likeCount = {
    // Por cada id de post, se guarda la cantidad de likes
    
  };

  // lista local para seguir los likes del usuario
  List<String> _likedPosts = [];

  //El usuario ha dado like a estos posts?
  bool isPostLikedByCurrentUser(String postId) => _likedPosts.contains(postId);

  // Obtener el contador de likes de un post
  int getLikeCount(String postId) => _likeCount[postId] ?? 0;  

  // inicializar un mapa de likes local
  void initializeLikeMap(){
    // Obtener uid actual
    final currentUserId = _auth.getCurrentUserId();

    // Limpiar los mapas y listas locales
    _likedPosts.clear();

    for(var post in _allPosts) {
      // Actualizar el mapa de contador de likes
      _likeCount[post.id] = post.likeCount; 
      
      // si el usuario actual ha dado like a este post
      if (post.likedBy.contains(currentUserId)) {
        // Agregar el post a la lista local de posts que el usuario ha dado like
        _likedPosts.add(post.id); 

      }
    }
  }

  // metodo para dar like a un post
  Future<void> toggleLike(String postId) async {
    //guardar el valor actual en caso de que falle
    final likedPostsOriginal = _likedPosts;
    final likeCountOriginal = _likeCount;

    // Likear y unlikear el post
    if(_likedPosts.contains(postId)){
      _likedPosts.remove(postId);
      _likeCount[postId] = (_likeCount[postId] ?? 0) - 1; // Decrementar el contador de likes
    } else {
      _likedPosts.add(postId);
      _likeCount[postId] = (_likeCount[postId] ?? 0) + 1; // Incrementar el contador de likes
    }

    notifyListeners(); // Actualizar la app localmente

    //ahora para actualizar en firebase
    try{
      await _db.toggleLikeinFirebase(postId);
    } catch (e) {
      // Si falla, revertir los cambios
      _likedPosts = likedPostsOriginal;
      _likeCount = likeCountOriginal;
      notifyListeners(); // Actualizar la app localmente
      print('Error al dar like al post: $e');
    }


  }




  // COMENTARIOS

  // Lista local de comentarios
  final Map<String, List<Comment>> _comments = {};


  // obtener comentarios localmente
  List<Comment> getComments(String postId)=>_comments[postId] ?? [];

  // cargar comentarios de firebase
  Future<void> loadComments(String postId) async {
    //Obtener todos los comentarios para este post
    final allComments = await _db.getCommentsFromFirebase(postId);
    
    // Guardar los comentarios en el mapa local
    _comments[postId] = allComments;
    notifyListeners(); // Actualizar la UI
  }

  Future<void> addComment (String postId, message) async {
    // Guardar el comentario en firebase
    await _db.addCommentinFirebase(postId, message);

    // Cargar los comentarios nuevamente
    await loadComments(postId);
  }

  // Eliminar un comentario

  Future<void> deleteComment(String postId, String commentId) async {
    // Eliminar el comentario de firebase
    await _db.deleteCommentFromFirebase(commentId);

    // Cargar los comentarios nuevamente
    await loadComments(postId);
    
  }


  // Lista local de usuarios bloqueados
  List<UserProfile> _blockedUsers = [];
  // Obtener usuarios bloqueados
  List<UserProfile> get blockedUsers => _blockedUsers;

  // Cargar usuarios bloqueados desde Firebase
  Future<void> loadBlockedUsers() async {
    final blockedUsersIds = await _db.getBlockedUidsFromFirebase();

    final blockedUserData = await Future.wait(
      blockedUsersIds.map((id) => _db.getUserFromFirebase(id))
    );
    // Retornar como una lista
    _blockedUsers = blockedUserData.whereType<UserProfile>().toList();
    
    notifyListeners(); // Actualizar la UI
  } 

  // Bloquear un usuario
  Future<void> blockUser(String userId) async {
    // Bloquear al usuario en Firebase
    await _db.blockUserInFirebase(userId);

    await loadBlockedUsers(); // Recargar la lista de usuarios bloqueados

    // Recargar la lista de usuarios bloqueados
    await loadAllPosts();

    notifyListeners(); // Actualizar la UI
  }

  // Desbloquear un usuario
  Future<void> unblockUser(String blockedUserId) async {
    // Desbloquear al usuario en Firebase
    await _db.unblockUserInFirebase(blockedUserId);

    await loadBlockedUsers(); // Recargar la lista de usuarios bloqueados

    // Recargar la lista de usuarios bloqueados
    await loadAllPosts();

    notifyListeners(); // Actualizar la UI
  }

  // Reportar un usuario o post
  Future<void> reportUser(String postId, userId) async {
    // Reportar al usuario en Firebase
    await _db.reportUserInFirebase(postId, userId);

  }


  /* 
  FOLLOW
  
  Todo esta con uids

  Cada id de usuario tiene una lista de
  - seguidores uid
  - seguidos uid
  */

  //mapa local
  final Map<String, List<String>> _followers = {};
  final Map<String, List<String>> _following = {};
  final Map<String, int> _followersCount = {};
  final Map<String, int> _followingCount = {};

  // obtener cuenta de seguidores y seguidos
  int getFollowersCount(String uid) => _followersCount[uid] ?? 0;
  int getFollowingCount(String uid) => _followingCount[uid] ?? 0;

  // cargar seguidores y seguidos 
  Future<void> loadUserFollowers(String uid) async {
    final listOfFollowersUids = await _db.getFollowerUidsFromFirebase(uid);

    // Actualizar el mapa local de seguidores
    _followers[uid] = listOfFollowersUids;
    _followersCount[uid] = listOfFollowersUids.length;

    notifyListeners(); // Actualizar la UI
  }

  Future<void> loadUserFollowing(String uid) async {
    final listOfFollowingUids = await _db.getFollowingUidsFromFirebase(uid);

    // Actualizar el mapa local de seguidos
    _following[uid] = listOfFollowingUids;
    _followingCount[uid] = listOfFollowingUids.length;

    notifyListeners(); // Actualizar la UI
  }

  // Seguir a un usuario
  Future<void> followUser(String targetUserId) async {

    final currentUserId = _auth.getCurrentUserId();

    _following.putIfAbsent(currentUserId, () => []);
    _followers.putIfAbsent(targetUserId, () => []);

    if (!_followers[targetUserId]!.contains(currentUserId)) {
      
      _followers[targetUserId]?.add(currentUserId);
      _followersCount[targetUserId] = (_followersCount[targetUserId] ?? 0) + 1;

      _following[currentUserId]?.add(targetUserId);
      _followingCount[currentUserId] = (_followingCount[currentUserId] ?? 0) + 1;


    }
    notifyListeners(); // Actualizar la UI

    try {
      // Guardar los cambios en Firebase
      await _db.followUserInFirebase(targetUserId);

      await loadUserFollowers(targetUserId); // Recargar seguidores

      await loadUserFollowing(currentUserId); // Recargar seguidos

      await loadFollowingPosts(); 
    
    } catch (e) {
      // Si falla, revertir los cambios locales
      _followers[targetUserId]?.remove(currentUserId);
      _followersCount[targetUserId] = (_followersCount[targetUserId] ?? 0) - 1;

      _following[currentUserId]?.remove(targetUserId);
      _followingCount[currentUserId] = (_followingCount[currentUserId] ?? 0) - 1;

      notifyListeners(); // Actualizar la UI
    }

    
  }

  // Dejar de seguir a un usuario
  Future<void> unfollowUser(String targetUserId) async {

    final currentUserId = _auth.getCurrentUserId();

    _following.putIfAbsent(currentUserId, () => []);
    _followers.putIfAbsent(targetUserId, () => []);

    if (_followers[targetUserId]!.contains(currentUserId)) {
      
      _followers[targetUserId]?.remove(currentUserId);
      _followersCount[targetUserId] = (_followersCount[targetUserId] ?? 1) - 1;

      _following[currentUserId]?.remove(targetUserId);
      _followingCount[currentUserId] = (_followingCount[currentUserId] ?? 1) - 1;

    }
    notifyListeners(); // Actualizar la UI

    try {
      // Guardar los cambios en Firebase
      await _db.unfollowUserInFirebase(targetUserId);

      await loadUserFollowers(currentUserId); // Recargar seguidores

      await loadUserFollowing(currentUserId); // Recargar seguidos

      await loadFollowingPosts(); 
    
    } catch (e) {
      // Si falla, revertir los cambios locales
      _followers[targetUserId]?.add(currentUserId);
      _followersCount[targetUserId] = (_followersCount[targetUserId] ?? 0) + 1;

      _following[currentUserId]?.add(targetUserId);
      _followingCount[currentUserId] = (_followingCount[currentUserId] ?? 0) + 1;

      notifyListeners(); // Actualizar la UI
    }

    
  }


  // El usuario actual esta siguiendo a este usuario?
  bool isFollowing(String uid) {
    final currentUserId = _auth.getCurrentUserId();
    return _followers[uid]?.contains(currentUserId) ?? false;
  }


  final Map<String, List<UserProfile>> _followersProfile = {};
  final Map<String, List<UserProfile>> _followingProfile = {};
  // Obtener la lista de seguidores de un usuario
  List<UserProfile>? getListFollowersProfile(String uid) => _followersProfile[uid] ?? [];
  // Obtener la lista de seguidos de un usuario
  List<UserProfile> getListFollowingProfile(String uid) => _followingProfile[uid] ?? [];

  // Cargar los perfiles de los seguidores
  Future<void> loadUserFollowersProfile(String uid) async {
    try {
      final followersIds = await _db.getFollowerUidsFromFirebase(uid);

      List<UserProfile> followerProfiles = [];

      for(String followerId in followersIds) {
        UserProfile? followerProfile = await _db.getUserFromFirebase(followerId);
        
        if (followerProfile != null) {
          followerProfiles.add(followerProfile);
        }

      }
      _followersProfile[uid] = followerProfiles;
      notifyListeners(); // Actualizar la UI

    } catch (e) {
      print('Error al cargar los perfiles de seguidores: $e');
    }
  }

  // Cargar los perfiles de los seguidos
  Future<void> loadUserFollowingProfile(String uid) async {
    try {
      final followingIds = await _db.getFollowingUidsFromFirebase(uid);

      List<UserProfile> followingProfiles = [];

      for(String followingId in followingIds) {
        UserProfile? followingProfile = await _db.getUserFromFirebase(followingId);
        
        if (followingProfile != null) {
          followingProfiles.add(followingProfile);
        }

      }
      _followingProfile[uid] = followingProfiles;
      notifyListeners(); // Actualizar la UI

    } catch (e) {
      print('Error al cargar los perfiles de seguidos: $e');
    }
  }

  // Buscar usuarios

  //Lista local de busqueda
  List<UserProfile> _searchResults = [];
  // Obtener resultados de busqueda
  List<UserProfile> get searchResults => _searchResults;
  // metodo para buscar usuarios
  Future<void> searchUsers(String searchTerm) async {
    try{
      // Buscar usuarios en Firebase
      final results = await _db.searchUsersInFirebase(searchTerm);

      _searchResults = results;

      notifyListeners(); // Actualizar la UI

    } catch (e) {
      print('Error al buscar usuarios: $e');
      
    }
  }


}