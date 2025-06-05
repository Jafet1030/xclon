/*
  FOLLOW BUTTON

  Este es un boton que permite seguir o dejar de seguir a un usuario.

  Ocuparas:
  - Una funcion (toggleFollow) que cambie el estado de seguimiento del usuario.
  - Esta siguiendo (isFollowing) para saber si el usuario esta siguiendo al otro.
*/

import 'package:flutter/material.dart';

class MyFollowButton extends StatelessWidget {
  final void Function()? OnPressed;
  final bool isFollowing;
  
  const MyFollowButton({super.key, required this.OnPressed, required this.isFollowing});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(25.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12.0),
        child: MaterialButton(
          padding: const EdgeInsets.all(25.0),
          onPressed: OnPressed,

          color:isFollowing?Theme.of(context).colorScheme.primary : Colors.blue,

          child: Text(
            isFollowing?"Dejar de seguir":"Seguir", 
            style: TextStyle(
              color: Theme.of(context).colorScheme.tertiary,
              fontWeight: FontWeight.bold,
            ),
          
        ),
      ),
      )
    );
  }
}