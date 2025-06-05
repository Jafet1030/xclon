import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:twitterclon/component/myusertile.dart';
import 'package:twitterclon/services/database/database_provider.dart';

// Esta es la pagina de busqueda
// Permite buscar usuarios en la base de datos


class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {

  final _seachController = TextEditingController();

  @override
  Widget build(BuildContext context) {

    //Provider
    final databaseProvider = Provider.of<DatabaseProvider>(context, listen: false);
    final listeningProvider = Provider.of<DatabaseProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _seachController,
          decoration: InputDecoration(
            hintText: "Buscar usuarios..",
            hintStyle: TextStyle(
              color: Theme.of(context).colorScheme.primary,
            ),
            border: InputBorder.none,
          ),
          onChanged: (value) {
            if (value.isNotEmpty) {
              databaseProvider.searchUsers(value);
            } else {
              databaseProvider.searchUsers("");
            }
          },	

        ),

      ),
      backgroundColor: Theme.of(context).colorScheme.surface,


      body: listeningProvider.searchResults.isEmpty
          ? Center(
              child: Text(
                "No se encontraron resultados",
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            )
          : ListView.builder(
              itemCount: listeningProvider.searchResults.length,
              itemBuilder: (context, index) {
                final user = listeningProvider.searchResults[index];
                return MyUserTile(user: user);
              },
            ),
    
    );
  }
}