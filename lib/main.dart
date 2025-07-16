import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tempo_libero/provider/auth_provider.dart';
import 'package:tempo_libero/widgets/homepage.dart';

import 'repositories/auth_repository.dart';
import 'screens/login_screen.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        // Repo: logica di rete / token
        Provider<AuthRepository>(create: (_) => AuthRepository()),
        // State-manager (facoltativo ma consigliato)
        ChangeNotifierProvider(create: (_) => AuthProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BoatConnect',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.blue,
      ),
      builder: (context, child) {
        return Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/background.jpg'),
              fit: BoxFit.cover,
            ),
          ),
          child: child,
        );
      },
      //home: const LoginScreen(),
      home: const HomePage(),
    );
  }
}
