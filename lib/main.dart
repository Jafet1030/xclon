import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:twitterclon/firebase_options.dart';
import 'package:twitterclon/services/auth/auth_gate.dart';
import 'package:twitterclon/services/database/database_provider.dart';
import 'package:twitterclon/themes/theme_provider.dart';

void main() async {
  // Firebase setup 
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Correr la aplicacion
  runApp(
    MultiProvider(providers: [
      ChangeNotifierProvider(create: (context) => ThemeProvider()),
      ChangeNotifierProvider(create: (context) => DatabaseProvider()),
    ],
      child: MyApp(),
    ),
  );
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => const AuthGate(),
      },
      theme: Provider.of<ThemeProvider>(context).themeData,
    );
  }
}