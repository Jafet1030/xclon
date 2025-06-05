import 'package:flutter/material.dart';
import 'package:twitterclon/component/mybutton.dart';
import 'package:twitterclon/component/myloadingcircle.dart';
import 'package:twitterclon/component/mytextfield.dart';
import 'package:twitterclon/services/auth/auth_service.dart';
import 'package:twitterclon/services/database/database_service.dart';

/* 
REGISTER PAGE

Aqui ocuparemos los siguientes datos para el registro:
- Nombre de usuario
- Correo electronico
- Contraseña
- Confirmacion de contraseña
*/

class RegisterPage extends StatefulWidget {
  final void Function()? onTap;
  const RegisterPage({super.key, this.onTap});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {

  final _auth = AuthService(); // acceso al servicio de autenticacion
  final _db = DatabaseService(); // acceso al servicio de base de datos


  final TextEditingController namecontroller = TextEditingController();
  final TextEditingController emailcontroller = TextEditingController();
  final TextEditingController pwcontroller = TextEditingController();
  final TextEditingController confirmPwController = TextEditingController();


  // metodo para iniciar sesion
  void register() async {
    // contraseñas coinciden?
    if (pwcontroller.text == confirmPwController.text) {
      showLoadingCircle(context);
       
      // intentar registrar al usuario con correo y contraseña
      try {
        if(mounted) hideLoadingCircle(context);
        // llamar al metodo de registro del servicio de autenticacion
        await _auth.registerEmailPassword(emailcontroller.text, pwcontroller.text);
        
        

        // si el registro es exitoso, crear el perfil del usuario y guardarlo en la base de datos 
        await _db.saveUserInfoInFirebase(
          name: namecontroller.text,
          email: emailcontroller.text,
        );

        // quitar el mensaje de carga

        
      } catch (e) {
        
        // quitar el mensaje de carga
        if(mounted) hideLoadingCircle(context);
        
        // si ocurre un error, mostrar un mensaje
        if (mounted) {
          showDialog(context: context, builder: (context) => AlertDialog(
            title: Text(e.toString()),
          )
          );
        }
      }
    }else {
      // si las contraseñas no coinciden, mostrar un mensaje
      if (mounted) {
        showDialog(context: context, builder: (context) => AlertDialog(
          title: const Text("Las contraseñas no coinciden"),
        ));
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
              const SizedBox(height: 25.0),
        
              // appLogo
              Icon(Icons.lock_open_rounded, size: 72.0, color: Theme.of(context).colorScheme.primary),
        
              const SizedBox(height: 35.0),
              Text("Crea una cuenta nueva",
                style: TextStyle(
                  fontSize: 16.0,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              // login button
        
              const SizedBox(height: 20.0),
              MyTextField(controller: namecontroller, obscureText: false, hintText: "Ingresa tu nombre de usuario"),
              const SizedBox(height: 10.0),
              MyTextField(controller: emailcontroller, obscureText: false, hintText: "Ingresa tu correo electrónico"),
              const SizedBox(height: 10.0),

              MyTextField(controller: pwcontroller, obscureText: true, hintText: "Ingresa tu contraseña"),
              const SizedBox(height: 10.0),
              MyTextField(controller: confirmPwController, obscureText: true, hintText: "Confirma tu contraseña"),
              


              const SizedBox(height: 20.0),

              MyButton(text: "Registrarse", onTap: register,
              ),

              const SizedBox(height: 25.0),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Ya tienes una cuenta?", style: TextStyle(color: Theme.of(context).colorScheme.primary),),
                  const SizedBox(width: 5.0),
                  GestureDetector(
                    onTap: widget.onTap,
                    child: Text("Inicia sesión",
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