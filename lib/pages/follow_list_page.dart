/*

FOLLOW LIST PAGE

Esta es una pagina que muestra la lista de seguidores o seguidos de un usuario.

*/

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:twitterclon/component/myusertile.dart';
import 'package:twitterclon/models/user.dart';
import 'package:twitterclon/services/database/database_provider.dart';

class FollowListPage extends StatefulWidget {

  final String uid;
  const FollowListPage({super.key, required this.uid});

  @override
  State<FollowListPage> createState() => _FollowListPageState();
}

class _FollowListPageState extends State<FollowListPage> {
  
  late final listeningProvider = Provider.of<DatabaseProvider>(context);
  late final databaseProvider = Provider.of<DatabaseProvider>(context, listen: false);

  // Al iniciar 
  @override
  void initState() {
    super.initState();
    // Cargar la informacion de seguidores y seguidos
    loadFollowerList();
    loadFollowingList();
  }

  Future<void> loadFollowerList() async {
    await databaseProvider.loadUserFollowersProfile(widget.uid);
  }

  Future<void> loadFollowingList() async {
    await databaseProvider.loadUserFollowingProfile(widget.uid);
  }



  @override
  Widget build(BuildContext context) {

    final followers = listeningProvider.getListFollowersProfile(widget.uid);
    final following = listeningProvider.getListFollowingProfile(widget.uid);

    return DefaultTabController(
      length: 2, 
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,

        appBar: AppBar(
          foregroundColor: Theme.of(context).colorScheme.primary,

          bottom: TabBar(
            dividerColor: Colors.transparent,
            labelColor: Theme.of(context).colorScheme.inversePrimary,
            unselectedLabelColor: Theme.of(context).colorScheme.primary,
            indicatorColor: Theme.of(context).colorScheme.primary,
            tabs: const [
              Tab(text: 'Seguidores'),
              Tab(text: 'Seguidos'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildUserList(followers!,'No tienes seguidores aún..',),
            _buildUserList(following,'No sigues a nadie aún..'),
              
              
          ],
        ),
      ),
      
      );
  }

  Widget _buildUserList(List<UserProfile> userList,String emptyMessage) {

    return userList.isEmpty
        ? Center(child: Text(emptyMessage))
        : ListView.builder(
            itemCount: userList.length,
            itemBuilder: (context, index) {
              final user = userList[index];
              return MyUserTile(user: user);
            },
          );
  }
}