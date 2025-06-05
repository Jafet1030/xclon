import 'package:flutter/material.dart';
/*
  Circulo de carga personalizado

*/

void showLoadingCircle(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => AlertDialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      content: Center(
        child: CircularProgressIndicator(),
      ),
    ),
  );
}

void hideLoadingCircle(BuildContext context) {
  Navigator.pop(context);
}