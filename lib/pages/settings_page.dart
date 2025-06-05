import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:twitterclon/component/mysettingstile.dart';
import 'package:twitterclon/helper/navigate_pages.dart';
import 'package:twitterclon/themes/theme_provider.dart';
/*
 Pagina de configuración de la aplicación.

  Esta página puede contener opciones como:
  - Dark mode
  - Usuarios bloqueados
  - Configuracion de tu cuenta
*/
class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      appBar: AppBar(
        centerTitle: true,
        title: Text('C O N F I G U R A C I O N'),
        foregroundColor: Theme.of(context).colorScheme.primary,
      ),
      
      body: Column(
        children: [
          MySettingsTile(
            title: 'Modo Oscuro', 
            action: 
            CupertinoSwitch(
              onChanged: (value) => Provider.of<ThemeProvider>(context, listen: false).toggleTheme(),
              value: Provider.of<ThemeProvider>(context, listen: false).isDarkMode,
              
            ),
            ),
          MySettingsTile(
            title: 'Usuarios bloqueados', 
            action: IconButton(
              onPressed: () => goToBlockedUsersPage(context),
              icon: Icon(
                Icons.arrow_forward,
                color: Theme.of(context).colorScheme.primary,
              ),
            )
          ),
          MySettingsTile(
            title: 'Configuración de tu cuenta', 
            action: IconButton(
              onPressed: () => goAccountSettingsPage(context), 
              icon: Icon(Icons.arrow_forward, 
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}