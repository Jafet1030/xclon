/*

COMMENT MODEL
Este representa lo que todos los comentarios tienen que tener

*/
import 'package:cloud_firestore/cloud_firestore.dart';

class Comment {
  final String id;
  final String postId;
  final String uid;
  final String name;
  final String username;
  final String message;
  final DateTime timestamp;

  Comment({
    required this.id,
    required this.postId,
    required this.uid,
    required this.name,
    required this.username,
    required this.message,
    required this.timestamp,
  });

  // Crear un Comment desde un Mapa (Para usarlo en la app)
  factory Comment.fromDocument(DocumentSnapshot doc) {
    return Comment(
      id: doc.id,
      postId: doc['postId'],
      uid: doc['uid'],
      name: doc['name'],
      username: doc['username'],
      message: doc['message'],
      timestamp: (doc['timestamp'] as Timestamp).toDate(), // Conversión correcta
    );
  }

  // Convertir un Comment a un Mapa (Para guardarlo en firebase)
  Map<String, dynamic> toMap() {
    return {
      'postId': postId,
      'uid': uid,
      'name': name,
      'username': username,
      'message': message,
      'timestamp': Timestamp.fromDate(timestamp), // Conversión correcta
    };
  }


}