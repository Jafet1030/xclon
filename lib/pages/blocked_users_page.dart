/* 

  Blocked Users Page
  Esta pagina muestra una lista de usuarios bloqueados.

  -Puedes desbloquear a un usuario.

*/

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:twitterclon/services/database/database_provider.dart';

class BlockedUsersPage extends StatefulWidget {
  const BlockedUsersPage({super.key});

  @override
  State<BlockedUsersPage> createState() => _BlockedUsersPageState();
}

class _BlockedUsersPageState extends State<BlockedUsersPage> {

  late final listeningProvider = Provider.of<DatabaseProvider>(context);
  late final databaseProvider = Provider.of<DatabaseProvider>(context, listen: false);

  // AL Iniciar
  @override
  void initState() {
    super.initState();
    // Cargar los usuarios bloqueados al iniciar la página
    loadBlockedUsers();
  }

  Future<void> loadBlockedUsers() async {
    // Cargar los usuarios bloqueados desde Firebase
    await databaseProvider.loadBlockedUsers();
  }

  // Mostrar un cuadro de diálogo para desbloquear al usuario
  void _showUnblockConfirmationBox(String userId) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text('Desbloquear Usuario'),
          content: Text('¿Estás seguro de que quieres desbloquear a este usuario?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
              child: Text('Cancelar'),
            ),
            TextButton(
              onPressed: () async{
                await databaseProvider.unblockUser(userId);
                Navigator.of(dialogContext).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Usuario desbloqueado.'),
                    duration: Duration(milliseconds: 1100),
                  ),
                );
              },
              child: Text('Desbloquear'),
            ),
          ],
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {

    final blockedUsers = listeningProvider.blockedUsers;


    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Usuarios Bloqueados'),
        foregroundColor: Theme.of(context).colorScheme.primary,
      ),

      body: blockedUsers.isEmpty 
      ? const Center(
        child: Text('No hay usuarios bloqueados..',),
      )
      : ListView.builder(
        itemCount: blockedUsers.length,
        itemBuilder: (context, index) {
          final user = blockedUsers[index];
          return ListTile(
            title: Text(user.username),
            subtitle: Text('@' + user.username),
            trailing: IconButton(
              icon: Icon(Icons.block),
              onPressed: () => _showUnblockConfirmationBox(user.uid),
            ),
          );
        },

      )


    );
  }
}