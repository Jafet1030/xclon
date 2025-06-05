import 'package:firebase_auth/firebase_auth.dart';
import 'package:twitterclon/services/database/database_service.dart';

/* 
  Autenticacion servicio
  Este servicio maneja toda la autenticacion en firebase

  - Registro de usuario
  - Inicio de sesion
  - Cierre de sesion
  - Eliminacion de usuario

*/


class AuthService{
  // Instancia de FirebaseAuth
  final _auth = FirebaseAuth.instance;
  // Obtener el usuario actual
  User? getCurrentUser() => _auth.currentUser;
  String getCurrentUserId() => _auth.currentUser!.uid;


  // Inicio de sesion con correo y contrasena
  Future<UserCredential> loginEmailPassword(String email, String password) async {
    // intentar iniciar sesion con correo y contrasena
    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email, 
        password: password
        );

      return userCredential;
    } 
    
    // Si ocurre un error, lanzar una excepcion
    on FirebaseAuthException catch (e) {
      throw Exception(e.code);
    }
  }

  // Registro de usuario con correo y contrasena
  Future<UserCredential> registerEmailPassword(String email, password) async {
    // intentar registrar usuario con correo y contrasena
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email, 
        password: password
        );

      return userCredential;
    } 
    
    // Si ocurre un error, lanzar una excepcion
    on FirebaseAuthException catch (e) {
      throw Exception(e.code);
    }
  }


  // Cierre de sesion
  Future<void> logout() async {
    await _auth.signOut();
  }


  // Eliminacion de usuario
  Future<void> deleteAccount() async {
    User? user = getCurrentUser();
    if (user != null) {
      await DatabaseService().deleteUserInfoFromFirebase(user.uid); // Eliminar datos del usuario
      await user.delete();
    }
  }


}