import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../repositories/auth_repository.dart';
import '../utilities/divider.dart';
import '../widgets/email_input.dart';
import '../widgets/continue_button.dart';
import '../widgets/google_button.dart';
import 'auth_password_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  bool _isButtonEnabled = false;
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _emailController.addListener(() {
      setState(() => _isButtonEnabled = _emailController.text.isNotEmpty);
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _handleContinue() async {
    final email = _emailController.text.trim();

    // semplice validazione lato client
    final emailRegex = RegExp(r'^[\w-.]+@([\w-]+\.)+[a-zA-Z]{2,}$');
    if (!emailRegex.hasMatch(email)) {
      _shakeAndToast('Email non valida');
      return;
    }

    setState(() => _loading = true);
    try {
      final exists = await context.read<AuthRepository>().checkEmail(email);
      setState(() => _loading = false);

      final route = MaterialPageRoute(
        builder: (_) => AuthPasswordScreen(
          email: email,
          isLogin: exists,   // traue ⇒ login, false ⇒ registrazione
        ),
      );


      if (!mounted) return;
      Navigator.of(context).push(route);
    } on DioException catch (e) {
      debugPrint('Network error: ${e.message}');
      _shakeAndToast('Impossibile contattare il server');
    }
  }

  void _shakeAndToast(String message) {
    // puoi sostituire con una vera animation "shake"
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              EmailInputField(controller: _emailController),
              const SizedBox(height: 16),
              ContinueButton(
                enabled: _isButtonEnabled && !_loading,
                onPressed: _isButtonEnabled ? _handleContinue : null,
                child: _loading
                    ? const SizedBox.square(
                  dimension: 18,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation(Colors.white),
                  ),
                )
                    : const Text('Continue'),
              ),
              const SizedBox(height: 24),
              const OrDivider(),
              const SizedBox(height: 16),
              const GoogleSignInButton(),
            ],
          ),
        ),
      ),
    );
  }
}
