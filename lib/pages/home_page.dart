import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:twitterclon/component/mydrawer.dart';
import 'package:twitterclon/component/myinputalertbox.dart';
import 'package:twitterclon/component/myposttile.dart';
import 'package:twitterclon/helper/navigate_pages.dart';
import 'package:twitterclon/models/post.dart';
import 'package:twitterclon/services/database/database_provider.dart';

/*

  Home Page
  Esta es la pagina principal de la aplicacion
  Muestra todos los posts

  Se dividira en dos partes:
  - Para ti
  - Siguiendo

*/
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  late final listeningProvider = Provider.of<DatabaseProvider>(context);
  late final databaseProvider = Provider.of<DatabaseProvider>(context, listen: false);


  final _messageController = TextEditingController();

  //al iniciar la pagina, cargar todos los posts
  @override
  void initState() {
    super.initState();
    loadAllPosts();
    
  }

  // metodo para cargar todos los posts
  Future<void> loadAllPosts() async {
    await databaseProvider.loadAllPosts();
  }

  void _openPostMessageBox(){
    showDialog(
      context: context, 
      builder: (context)=> MyInputAlertBox(
        textController: _messageController, 
        hintText: "En que piensas?", 
        onPressed: ()async{
          await postMessage(_messageController.text);
        }, 
        onPressedText: "Publicar",
      ),
    );
  }

  Future<void> postMessage(String message) async {
    await databaseProvider.postMessage(message);
  }


  @override
  Widget build(BuildContext context) {
    final databaseProvider = Provider.of<DatabaseProvider>(context);


    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        drawer: MyDrawer(),
      
        appBar: AppBar(
          centerTitle: true,
          title: const Text("I N I C I O"),
          foregroundColor: Theme.of(context).colorScheme.primary,
          bottom: TabBar(
            dividerColor: Colors.transparent,
            labelColor: Theme.of(context).colorScheme.inversePrimary,
            unselectedLabelColor: Theme.of(context).colorScheme.primary,
            indicatorColor: Theme.of(context).colorScheme.primary,
            tabs: const [
              Tab(text: "Para ti"),
              Tab(text: "Siguiendo"),
            ],
          ),
        ),
      
        floatingActionButton: FloatingActionButton(
          onPressed: _openPostMessageBox,
          backgroundColor: Theme.of(context).colorScheme.primary,
          child: const Icon(Icons.add),
      
        ),
      
        body: TabBarView(
          children: [
            // Para ti
            _buildPostList(databaseProvider.allPosts),
            // Siguiendo
            _buildPostList(databaseProvider.followingPosts),
          ],
        ),
      ),
    );
  }

  Widget _buildPostList(List<Post> posts){
    return posts.isEmpty 
    ? 
    
    const Center(child: Text("Nada que ver.."),) 
    
    : 
    
    ListView.builder(
      itemCount: posts.length,
      itemBuilder: (context, index) {
        final post = posts[index];
        return MyPostTile(
          post: post, 
          onPostTap: () => goPostPage(context, post),
          onUserTap: () => goUserPage(context, post.uid)
        );

      },

    );
  }
}