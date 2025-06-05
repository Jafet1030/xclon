import 'package:flutter/material.dart';
import 'package:twitterclon/component/mybutton.dart';
import 'package:twitterclon/component/myloadingcircle.dart';
import 'package:twitterclon/component/mytextfield.dart';
import 'package:twitterclon/services/auth/auth_service.dart';

/* Login page
   Esta es la pagina de inicio de sesion
*/


class LoginPage extends StatefulWidget {
  final void Function()? onTap; 
  const LoginPage({super.key, this.onTap});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // acceso al servicio de autenticacion
  final _auth = AuthService();

  // controladores de los campos de texto
  final TextEditingController emailcontroller = TextEditingController();
  final TextEditingController pwcontroller = TextEditingController();


  // metodo para iniciar sesion
  void login() async {
    // mostrar un mensaje de carga mientras se intenta iniciar sesion
    showLoadingCircle(context);

    //intentar iniciar sesion con correo y contrasena
    try {
      // llamar al metodo de inicio de sesion del servicio de autenticacion
      await _auth.loginEmailPassword(emailcontroller.text, pwcontroller.text);
      

      // quitar el mensaje de carga
      if(mounted) hideLoadingCircle(context);
    } catch (e) {
      
      // quitar el mensaje de carga
      if(mounted) hideLoadingCircle(context);

      // si ocurre un error, mostrar un mensaje
      if (mounted) {
        showDialog(
          context: context, 
          builder: (context) => AlertDialog(
            title: Text(e.toString()),
          )
        );
      }

    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,

      body: SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 50.0),
        
              // appLogo
              Icon(Icons.lock_open_rounded, size: 72.0, color: Theme.of(context).colorScheme.primary),
        
              const SizedBox(height: 50.0),
              Text("Bienvenido de vuelta",
                style: TextStyle(
                  fontSize: 16.0,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              // login button
        
              const SizedBox(height: 25.0),
        
              MyTextField(controller: emailcontroller, obscureText: false, hintText: "Ingresa tu correo electrónico"),
              
              const SizedBox(height: 10.0),
              MyTextField(controller: pwcontroller, obscureText: true, hintText: "Ingresa tu contraseña"),
              
              const SizedBox(height: 10.0),

              Align(
                alignment: Alignment.centerRight,
                child: Text(
                  "¿Olvidaste tu contraseña?",
                  style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
                )
              ),


              const SizedBox(height: 25.0),

              MyButton(
                text: "Iniciar sesión", 
                onTap: login,
              ),

              const SizedBox(height: 50.0),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("¿No tienes una cuenta?", style: TextStyle(color: Theme.of(context).colorScheme.primary),),
                  const SizedBox(width: 5.0),
                  GestureDetector(
                    onTap: widget.onTap,
                    child: Text("Regístrate",
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),

            ],
          ),
        ),
      ),
      ),
    );
  }
}