import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:twitterclon/pages/home_page.dart';
import 'package:twitterclon/services/auth/login_or_register.dart';
/*

AuthGate 

Es un widget que se encarga de verificar si el usuario esta autenticado o no.


Si el usuario esta autenticado, se redirige a la pantalla de inicio.
Si el usuario no esta autenticado, se redirige a la pantalla de inicio de sesion o registro.
*/

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(), 
        builder: (context, snapshot) {
          // Si el snapshot tiene datos, significa que el usuario esta autenticado
          if (snapshot.hasData) {
            return const HomePage();
          } 
          // Si el snapshot no tiene datos, significa que el usuario no esta autenticado
          else {
            return const LoginOrRegister();
          }
        },
      ),
    );
  }
}
