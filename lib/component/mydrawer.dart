import 'package:flutter/material.dart';
import 'package:twitterclon/component/mydrawertile.dart';
import 'package:twitterclon/pages/profile_page.dart';
import 'package:twitterclon/pages/search_page.dart';
import 'package:twitterclon/pages/settings_page.dart';
import 'package:twitterclon/services/auth/auth_service.dart';

/* Drawer es la barra lateral de la aplicacion
   que se muestra al hacer swipe desde el borde izquierdo de la pantalla.
   En este caso, se usa para mostrar el menu de la aplicacion.

   Contiene 5 opciones:
    - Home: Muestra la pagina de inicio.
    - Perfil: Muestra el perfil del usuario.
    - Buscar: Muestra la pagina de busqueda.
    - Configuracion: Muestra la pagina de configuracion.
    - Cerrar sesion: Cierra la sesion del usuario.
*/
class MyDrawer extends StatelessWidget {
  MyDrawer({super.key});

  // acceder a auth service
  final _auth = AuthService();

  // metodo para cerrar sesion
  void logout(){
    _auth.logout();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.surface,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: Column(
            children: [
              // appLogo
              Padding(
                padding: EdgeInsets.symmetric(vertical: 50.0),
                child: Icon(Icons.person, size: 72.0, color: Theme.of(context).colorScheme.primary),
              ),

              Divider(
                color: Theme.of(context).colorScheme.secondary,
              ),

              const SizedBox(height: 10,),
          
              MyDrawerTile(
                title: 'Inicio',
                icon: Icons.home,
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              MyDrawerTile(
                title: 'Perfil',
                icon: Icons.person,
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(context, MaterialPageRoute(builder: (context) => ProfilePage(uid: _auth.getCurrentUserId(),),
                  ));
                  
                },
              ),
              MyDrawerTile(
                title: 'Buscar',
                icon: Icons.search,
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(context, MaterialPageRoute(builder: (context) => SearchPage(),));

                },
              ),
              MyDrawerTile(
                title: 'Configuracion',
                icon: Icons.settings,
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(context, MaterialPageRoute(builder: (context) => SettingsPage(),
                  ));
                },
              ),
              const Spacer(),
              MyDrawerTile(
                title: 'Cerrar sesion',
                icon: Icons.logout,
                onTap: logout,
              ),
          
            ],
          ),
        )
      ),
    );
  }
}