import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:twitterclon/component/mybiobox.dart';
import 'package:twitterclon/component/myfollowbotton.dart';
import 'package:twitterclon/component/myinputalertbox.dart';
import 'package:twitterclon/component/myposttile.dart';
import 'package:twitterclon/component/myprofilestats.dart';
import 'package:twitterclon/helper/navigate_pages.dart';
import 'package:twitterclon/models/user.dart';
import 'package:twitterclon/pages/follow_list_page.dart';
import 'package:twitterclon/services/auth/auth_service.dart';
import 'package:twitterclon/services/database/database_provider.dart';
/* 

  Profile Page
  Esta es la pagina de perfil del usuario
  Muestra la informacion del usuario y permite editarla.
  Tambien permite cambiar la foto de perfil y la biografia.
*/


class ProfilePage extends StatefulWidget {
  final String uid; 

  const ProfilePage({super.key, required this.uid});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {

  late final listeningProvider = Provider.of<DatabaseProvider>(context);
  late final databaseProvider= Provider.of<DatabaseProvider>(context, listen: false);

  UserProfile? user;
  String getCurrentUserId=AuthService().getCurrentUserId();

  final bioTextController = TextEditingController();


  bool _isLoading = true;

  bool _isFollowing = false;
  

  @override
  void initState() {
    super.initState();
    // Cargar la informacion del usuario al iniciar la pagina
    loadUser();
  }

  Future<void> loadUser() async {
    user = await databaseProvider.userProfile(widget.uid);

    //cargar seguidores y seguidos
    await databaseProvider.loadUserFollowers(widget.uid);
    await databaseProvider.loadUserFollowing(widget.uid);


    _isFollowing = databaseProvider.isFollowing(widget.uid);

    setState(() {
      _isLoading = false;
    });
    
  }

  // metodo para editar la biografia del usuario
  void _showEditBioBox() {
    showDialog(
      context: context,
      builder: (context) => MyInputAlertBox(
        textController: bioTextController, 
        hintText: "Editar biografia",
        onPressed: saveBio, 
        onPressedText: "Guardar",
        )
    );
  }

  // metodo para actualizar la biografia del usuario
  Future<void> saveBio() async {
    setState(() {
      _isLoading = true;
    });
    await databaseProvider.updateBio(widget.uid, bioTextController.text);

    await loadUser(); // recargar la informacion del usuario
    
    setState(() {
      _isLoading = false;
    });
  }


  // Seguir / Dejar de seguir
  Future<void> toggleFollow() async {

    if (_isFollowing) {
      showDialog(
        context: context, 
        builder: (context) => AlertDialog(
          title: const Text("Dejar de seguir"),
          content: const Text("¿Estás seguro de que quieres dejar de seguir a este usuario?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              }, 
              child: const Text("Cancelar")
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();

                await databaseProvider.unfollowUser(widget.uid);
                
              }, 
              child: const Text("Dejar de seguir")
            ),
          ],
        )
      );
    } else {
      await databaseProvider.followUser(widget.uid);
    }


    setState(() {
      _isFollowing = !_isFollowing;
    });
  }



  @override
  Widget build(BuildContext context) {

    final allUserPosts = listeningProvider.filterUserPosts(widget.uid);
    
    final followersCount = listeningProvider.getFollowersCount(widget.uid);
    final followingCount = listeningProvider.getFollowingCount(widget.uid);

    _isFollowing=listeningProvider.isFollowing(widget.uid);

    return Scaffold(
      
      appBar: AppBar(
        title: Text(_isLoading ? '' : user!.name),
        foregroundColor: Theme.of(context).colorScheme.primary,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => goHomePage(context),
        ),
      ),
      

      body: ListView(
        children: [
          //manejo del username
          Center(
            child: Text(
              _isLoading ? '' : '@${user!.username}',
              style: TextStyle(color: Theme.of(context).colorScheme.primary),
            ),
          ),
      
          const SizedBox(height: 25,),
      
          // foto de perfil
      
          Center(
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.secondary,
                borderRadius: BorderRadius.circular(25),
              ),
              padding: const EdgeInsets.all(25),
              child: Icon(
                Icons.person, 
                size: 72.0, 
                color: Theme.of(context).colorScheme.primary
                ),
            ),
          ),
          
          const SizedBox(height: 25,),

          MyProfileStats(
            postCount: allUserPosts.length, 
            followersCount: followersCount, 
            followingCount: followingCount,
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => 
              FollowListPage(uid: widget.uid ,)
            )),
            ),

          const SizedBox(height: 10,),
      
          //estadisticas del perfil (tweets, seguidores, seguidos)
          if(user != null && user!.uid != getCurrentUserId)
            MyFollowButton(
              OnPressed: toggleFollow,
              isFollowing: _isFollowing,
            ),

          

      
          // editar bio 
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Bio",
                  style: 
                  TextStyle(color: Theme.of(context).colorScheme.primary),
                ),

                if(user!= null && user!.uid == getCurrentUserId)
                GestureDetector(
                  onTap: _showEditBioBox,
                  child: Icon(Icons.settings, 
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ],
            ),
          ),
      
          const SizedBox(height: 10,),
      
          // biografia
          MyBioBox(
            text: _isLoading ? '' : (user!.bio ?? ''),
          ),

          Padding(
            padding: const EdgeInsets.only(left: 25, top: 25.0),
            child: Text("Posts",
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                
              ),
            ),
          ),
      
          // lista de tweets del usuario
      
          allUserPosts.isEmpty
          ? 
          const Center(child: Text("No hay tweets para mostrar."),)
          :
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: allUserPosts.length,
            itemBuilder: (context, index) {
              final post = allUserPosts[index];
              return MyPostTile(
                post: post,
                onUserTap: (){},
                onPostTap: () => goPostPage(context, post),
                );
            }
          ),
      
        ],
      
      )

    );
  }

}