import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Potresti voler mantenere lo sfondo trasparente se il tuo design lo richiede
      // backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: const Text('Profilo'),
        // backgroundColor: Colors.transparent, // Esempio se vuoi un'appBar trasparente
        // elevation: 0, // Rimuove l'ombra dell'AppBar se trasparente
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const CircleAvatar(
              radius: 50,
              // Potresti caricare un'immagine del profilo qui
              // backgroundImage: NetworkImage('URL_DELLA_TUA_IMMAGINE'),
              child: Icon(Icons.person, size: 50),
            ),
            const SizedBox(height: 20),
            const Text(
              'Nome Utente',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
              'email@esempio.com',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                // Azione per modificare il profilo
              },
              child: const Text('Modifica Profilo'),
            ),
            ElevatedButton(
              onPressed: () {
                // Azione per il logout
              },
              child: const Text('Logout'),
            ),
          ],
        ),
      ),
    );
  }
}
