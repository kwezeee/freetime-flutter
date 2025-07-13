import 'package:dio/dio.dart';
import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/auth_provider.dart';
import '../utilities/app_theme.dart';
import '../widgets/continue_button.dart';
import '../widgets/homepage.dart';

class AuthPasswordScreen extends StatefulWidget {
  const AuthPasswordScreen({
    super.key,
    required this.email,
    required this.isLogin,
  });

  final String email;
  final bool isLogin;

  @override
  State<AuthPasswordScreen> createState() => _AuthPasswordScreenState();
}

class _AuthPasswordScreenState extends State<AuthPasswordScreen> {
  final _pwdCtrl = TextEditingController();
  bool _loading = false;

  bool get _enabled => _pwdCtrl.text.trim().length >= 6 && !_loading;

  @override
  void initState() {
    super.initState();
    _pwdCtrl.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _pwdCtrl.dispose();
    super.dispose();
  }

  // ------------------------------------------------------------
  // UI helper: vetro bianco 20 % con padding uniforme
  // ------------------------------------------------------------
  InputDecoration _glassDecoration({String? hint, Widget? prefixIcon}) {
    return InputDecoration(
      hintText: hint,
      prefixIcon: prefixIcon,
      filled: true,
      fillColor: Colors.white.withAlpha(20),
      border: InputBorder.none,
      contentPadding:
      const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    );
  }

  Future<void> _submit() async {
    if (!_enabled) return;
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
            (_) => false,
      );
    } on DioException catch (e) {
      final code = e.response?.statusCode;
      final msg = switch (code) {
        409 => 'E-mail already used',
        401 || 404 => 'Invalid credentials',
        _ => 'Error, try again',
      };
      _toast(msg);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  void _toast(String m) =>
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(m)));

  @override
  Widget build(BuildContext context) {
    final title = widget.isLogin ? 'Sign in' : 'Create account';

    return Scaffold(
      // 🔑 stesse impostazioni della LoginScreen
      backgroundColor: Colors.transparent,
      extendBodyBehindAppBar: true,

      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const BackButton(),
        title: Text(title),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // E-mail readonly (squircle vetro)
              ClipSmoothRect(
                radius: AppTheme.radius,
                child: TextFormField(
                  readOnly: true,
                  initialValue: widget.email,
                  decoration: _glassDecoration(
                    prefixIcon: const Icon(Icons.mail_outline, size: 20),
                  ),
                ),
              ),

              const SizedBox(height: 12),

              // Password (squircle vetro)
              ClipSmoothRect(
                radius: AppTheme.radius,
                child: TextFormField(
                  controller: _pwdCtrl,
                  obscureText: true,
                  autofillHints: [
                    widget.isLogin
                        ? AutofillHints.password
                        : AutofillHints.newPassword
                  ],
                  decoration: _glassDecoration(hint: 'Password'),
                ),
              ),

              const SizedBox(height: 16),

              // Pulsante primario
              ContinueButton(
                enabled: _enabled,
                onPressed: _enabled ? _submit : null,
                child: _loading
                    ? const SizedBox.square(
                  dimension: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
                    : Text(widget.isLogin ? 'Sign in' : 'Create'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
