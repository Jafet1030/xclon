/* 
  
  Post Model
  Esto es lo que todo post debe tener

*/

import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  final String id;
  final String uid;
  final String name;
  final String username;
  final String message;
  final Timestamp timestamp;
  final int likeCount;
  final List<String> likedBy;


  Post({
    required this.id,
    required this.uid,
    required this.name,
    required this.username,
    required this.message,
    required this.timestamp,
    required this.likeCount,
    required this.likedBy,
  });

  // Convertir de firebase a Post
  factory Post.fromDocument(DocumentSnapshot doc) {
    return Post(
      id: doc.id,
      uid: doc['uid'],
      name: doc['name'],
      username: doc['username'],
      message: doc['message'],
      timestamp: doc['timestamp'],
      likeCount: doc['likeCount'] ?? 0,
      likedBy: List<String>.from(doc['likedBy'] ?? []),
    );
  }

  // Convertir el post a un mapa para guardarlo en Firestore
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'username': username,
      'message': message,
      'timestamp': timestamp,
      'likeCount': likeCount,
      'likedBy': likedBy,
    };
  }
}