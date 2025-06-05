import 'package:flutter/material.dart';
import 'package:twitterclon/pages/login_page.dart';
import 'package:twitterclon/pages/register_page.dart';

/* 
  LoginOrRegister Page
  Esta pagina es la que decide si mostrar el login o el registro
*/

class LoginOrRegister extends StatefulWidget {
  const LoginOrRegister({super.key});

  @override
  State<LoginOrRegister> createState() => _LoginOrRegisterState();
}

class _LoginOrRegisterState extends State<LoginOrRegister> {
  
  bool showLoginPage = true;
  void togglePage() {
    setState(() {
      showLoginPage = !showLoginPage;
    });
  }


  @override
  Widget build(BuildContext context) {
    if(showLoginPage) {
      return LoginPage(
        onTap: togglePage,
      );
    }else {
      return RegisterPage(
        onTap: togglePage,
      );
    }
  }
}