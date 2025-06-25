import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/auth_provider.dart';
import '../widgets/continue_button.dart';
import '../widgets/homepage.dart';

class AuthPasswordScreen extends StatefulWidget {
  final String email;
  final bool isLogin;
  const AuthPasswordScreen({super.key, required this.email, required this.isLogin});

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
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const HomePage()),
            (route) => false,
      );
    } on DioException catch (e) {
      late final String msg;
      switch (e.response?.statusCode) {
        case 409:
          msg = 'E‑mail già in uso';
          break;
        case 401:
        case 404:
          msg = 'Credenziali non valide';
          break;
        default:
          msg = 'Errore, riprova';
      }
      _toast(msg);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  void _toast(String m) =>
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(m)));

  @override
  Widget build(BuildContext context) {
    final title = widget.isLogin ? 'Accedi' : 'Crea account';
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
              Text(title, style: Theme.of(context).textTheme.headlineMedium),
              const SizedBox(height: 24),
              // e‑mail (readonly) so the user always sees what was typed
              TextField(
                readOnly: true,
                controller: TextEditingController(text: widget.email),
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.mail_outline, size: 20),
                  filled: true,
                  fillColor: Colors.white.withAlpha(20),
                  border:  SquircleBorder(side: BorderSide.none),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _pwdCtrl,
                obscureText: true,
                decoration: InputDecoration(
                  hintText: 'Password',
                  filled: true,
                  fillColor: Colors.white.withAlpha(20),
                  border:  SquircleBorder(side: BorderSide.none),
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
                    : Text(widget.isLogin ? 'Accedi' : 'Crea'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

//--------------------------------------------------
// Helper: Figma squircle shape
//--------------------------------------------------
class SquircleBorder extends OutlineInputBorder {
   SquircleBorder({BorderSide side = BorderSide.none})
      : super(borderRadius: BorderRadius.all(Radius.circular(28)), borderSide: side);
}

