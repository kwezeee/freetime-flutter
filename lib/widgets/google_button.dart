import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_button/sign_in_button.dart';

class GoogleSignInButton extends StatelessWidget {
  const GoogleSignInButton({super.key});

  Future<void> _handleGoogleSignIn(BuildContext context) async {
    try {
      final googleUser = await GoogleSignIn(scopes: ['email']).signIn();
      if (googleUser == null) return; // login annullato

      final googleAuth = await googleUser.authentication;
      final idToken = googleAuth.idToken;
      final accessToken = googleAuth.accessToken;
      // TODO: invia idToken/accessToken al tuo backend o a Firebase Auth

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ciao ${googleUser.displayName}!')),
      );
    } catch (error) {
      debugPrint('Errore Google Sign-In: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Login Google fallito')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: SignInButton(
        Buttons.google,               // ← minuscolo, come definito in enum Buttons :contentReference[oaicite:0]{index=0}
        text: 'Continue with Google',
        onPressed: () => _handleGoogleSignIn(context),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}
