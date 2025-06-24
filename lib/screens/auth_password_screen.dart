import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/auth_provider.dart';
import '../widgets/continue_button.dart';

class AuthPasswordScreen extends StatefulWidget {
  final String email;
  final bool isLogin; // true = login, false = registrazione

  const AuthPasswordScreen({
    super.key,
    required this.email,
    required this.isLogin,
  });

  @override
  State<AuthPasswordScreen> createState() => _AuthPasswordScreenState();
}

class _AuthPasswordScreenState extends State<AuthPasswordScreen> {
  final _pwdCtrl = TextEditingController();
  bool _enabled = false;
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _pwdCtrl.addListener(() => setState(() => _enabled = _pwdCtrl.text.length >= 6));
  }

  @override
  void dispose() {
    _pwdCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    setState(() => _loading = true);
    final auth = context.read<AuthProvider>();
    try {
      if (widget.isLogin) {
        await auth.login(widget.email, _pwdCtrl.text.trim());
      } else {
        await auth.register(widget.email, _pwdCtrl.text.trim());
      }
      if (!mounted) return;
      Navigator.of(context).pushReplacementNamed('/home'); // o HomePage()
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Credenziali non valide')),
      );
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final title = widget.isLogin ? 'Sign in' : 'Create account';
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(title, style: Theme.of(context).textTheme.headlineMedium),
              const SizedBox(height: 24),
              TextField(
                controller: _pwdCtrl,
                obscureText: true,
                decoration: InputDecoration(
                  hintText: 'Password',
                  filled: true,
                  fillColor: Colors.white.withAlpha(20),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                ),
              ),
              const SizedBox(height: 16),
              ContinueButton(
                enabled: _enabled && !_loading,
                onPressed: _enabled ? _submit : null,
                child: _loading
                    ? const SizedBox.square(
                  dimension: 18,
                  child: CircularProgressIndicator(strokeWidth: 2, valueColor: AlwaysStoppedAnimation(Colors.white)),
                )
                    : Text(widget.isLogin ? 'Login' : 'Create'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
