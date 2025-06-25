import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dio/dio.dart';

import '../repositories/auth_repository.dart';
import '../utilities/divider.dart';
import '../widgets/email_input.dart';
import '../widgets/continue_button.dart';
import '../widgets/google_button.dart';
import 'auth_password_screen.dart';

//--------------------------------------------------
// LoginScreen → asks only for e‑mail, decides login vs sign‑up
//--------------------------------------------------
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  bool _enabled = false;
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _emailController.addListener(() =>
        setState(() => _enabled = _emailController.text.trim().isNotEmpty));
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _continue() async {
    final email = _emailController.text.trim();
    // semplice validazione lato client (RFC 5322 semplificata)
    final emailRegex = RegExp(
        r'^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$'
    );
    if (!emailRegex.hasMatch(email)) {
      _toast('E‑mail non valida');
      return;
    }

    setState(() => _loading = true);
    try {
      final exists = await context.read<AuthRepository>().checkEmail(email);
      if (!mounted) return;
      Navigator.of(context).push(MaterialPageRoute(
        builder: (_) => AuthPasswordScreen(email: email, isLogin: exists),
      ));
    } on DioException {
      _toast('Errore di rete, riprova');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  void _toast(String m) =>
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(m)));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: const BackButton(color: Colors.white),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              EmailInputField(controller: _emailController),
              const SizedBox(height: 16),
              ContinueButton(
                enabled: _enabled && !_loading,
                onPressed: _enabled ? _continue : null,
                child: _loading
                    ? const SizedBox.square(
                  dimension: 18,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation(Colors.white),
                  ),
                )
                    : const Text('Continua'),
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