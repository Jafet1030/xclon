// ir a user page

import 'package:flutter/material.dart';
import 'package:twitterclon/models/post.dart';
import 'package:twitterclon/pages/account_settings_page.dart';
import 'package:twitterclon/pages/blocked_users_page.dart';
import 'package:twitterclon/pages/home_page.dart';
import 'package:twitterclon/pages/post_page.dart';
import 'package:twitterclon/pages/profile_page.dart';

void goUserPage(BuildContext context, String uid) {
  Navigator.push(
    context, 
    MaterialPageRoute(
      builder: (context) => ProfilePage(uid: uid)
    ),
  );
}

void goPostPage(BuildContext context, Post post) {

  Navigator.push(
    context, 
    MaterialPageRoute(
      builder: (context) => PostPage(post: post)
    ),
  );
}

void goToBlockedUsersPage(BuildContext context) {
  Navigator.push(
    context, 
    MaterialPageRoute(
      builder: (context) => BlockedUsersPage(),
    ),
  );
}

void goAccountSettingsPage(BuildContext context) {
  Navigator.push(
    context, 
    MaterialPageRoute(
      builder: (context) => AccountSettingsPage(),
    ),
  );
}

//ir a la pagina de inicio pero elimnara todas las rutas anteriores
void goHomePage(BuildContext context) {
  Navigator.pushAndRemoveUntil(
    context, 
    MaterialPageRoute(
      builder: (context) => const HomePage(),
    ),
    (route)=> route.isFirst, // Elimina todas las rutas anteriores
  );
}