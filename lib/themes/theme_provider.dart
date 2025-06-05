import 'package:flutter/material.dart';
import 'package:twitterclon/themes/dark_mode.dart';
import 'package:twitterclon/themes/light_mode.dart';


/* THEME PROVIDER 
 Esto es para ayudar a cambiar el tema de la aplicacion
 entre claro y oscuro.
 */

class ThemeProvider with ChangeNotifier {
  ThemeData _themeData=lightMode;

  ThemeData get themeData => _themeData;

  bool get isDarkMode => _themeData== darkMode;
  
  // Poner el tema actual
  // en el tema que se le pase como parametro
  set themeData(ThemeData themeData) {
    _themeData = _themeData;
    // Notificar a los listeners que el tema ha cambiado
    // Esto es necesario para que la aplicacion sepa que el tema ha cambiado
    notifyListeners();
  }
  
  
  void toggleTheme() {
    if (_themeData.brightness == Brightness.dark) {
      _themeData = lightMode;
    } else {
      _themeData = darkMode;
    }
    notifyListeners();
  }
}