/* 
  PROFILE STATS

  Este se encargara de mostrar en el perfil

  - Numero de tweets
  - Numero de seguidores
  - Numero de seguidos
*/

import 'package:flutter/material.dart';

class MyProfileStats extends StatelessWidget {
  final int postCount;
  final int followersCount;
  final int followingCount;
  final void Function()? onTap;

  const MyProfileStats({super.key, required this.postCount, required this.followersCount, required this.followingCount, required this.onTap});

  @override
  Widget build(BuildContext context) {
    var textStyleForCount = TextStyle(
      color: Theme.of(context).colorScheme.inversePrimary,
      fontSize: 20,
    );
    var textStyleForText = TextStyle(
      color: Theme.of(context).colorScheme.primary,
    );

    return GestureDetector(
      onTap: onTap,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
      
          SizedBox(
            width: 100,
            child: Column(
              children: [Text(postCount.toString(),style: textStyleForCount,),Text('Tweets',style: textStyleForText,),],
            ),
          ),
      
          SizedBox(
            width: 100,
            child: Column(
              children: [Text(followersCount.toString(),style: textStyleForCount,),Text('Seguidores',style: textStyleForText,),],
            ),
          ),
      
          SizedBox(
            width: 100,
            child: Column(
              children: [Text(followingCount.toString(),style: textStyleForCount,),Text('Seguidos',style: textStyleForText,),],
            ),
          ),
      
        ],
      ),
    );
  }
}