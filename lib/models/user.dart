/* 

  Perfil del usuario
  Lo que todos los usuarios deben tener en su perfil:
  
  - ID de usuario
  - Nombre de usuario
  - Correo electronico
  - Username
  - Foto de perfil
  - Biografia

*/

import 'package:cloud_firestore/cloud_firestore.dart';

class UserProfile {
  final String uid;
  final String name; 
  final String email; 
  final String username; 
  final String? bio; 

  UserProfile({
    required this.uid,
    required this.name,
    required this.email,
    required this.username,
    required this.bio,
  });

  // Metodo para convertir el mapa al perfil (firebase -> app ) para usarlo en la app

  factory UserProfile.fromDocument(DocumentSnapshot doc) {
    return UserProfile(
      uid: doc['uid'],
      name: doc['name'],
      email: doc['email'],
      username: doc['username'],
      bio: doc['bio'],
    );
  }

  // Metodo para convertir el perfil a un mapa (app -> firebase)
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'username': username,
      'bio': bio,
    };
  }
}